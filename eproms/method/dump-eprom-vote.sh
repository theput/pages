#!/usr/bin/env bash
#
# dump-eprom-vote.sh -- read an aging EPROM N times and reconcile the reads
# byte by byte, instead of just failing when two passes disagree.
#
# Usage:
#   ./dump-eprom-vote.sh <name> [profile] [nreads] [base-address-hex]
#
# Examples:
#   ./dump-eprom-vote.sh int_F8                             # 5 reads, M2716@DIP24
#   ./dump-eprom-vote.sh int_F8 "M2716@DIP24" 5 F800        # annotate as $F800..
#   ./dump-eprom-vote.sh mostek_F0 "M2716@DIP24" 7 F000     # stubborn chip
#
# WHY VOTING, AND WHY IT IS NOT SYMMETRIC
#
# A UV EPROM erases to 1. Programming injects charge onto a floating gate to
# make a 0. Over decades that charge leaks away, so the ONLY natural failure
# direction is 0 -> 1. A cell cannot spontaneously become "more programmed."
#
# Therefore, if any read of a bit returns 0, that bit was almost certainly
# programmed -- a spurious 0 would require charge to appear from nowhere.
# The reverse is the expected decay signature. This asymmetry gives us two
# different reconstructions, and the gap between them is the honest error bar:
#
#   <name>.bin          MAJORITY  -- per-bit majority across N reads.
#                                    Conservative. What most reads saw.
#   <name>.sticky0.bin  STICKY-0  -- bitwise AND of all reads: every bit that
#                                    read 0 even once is held at 0.
#                                    Physics-preferred reconstruction.
#
# If the two files are identical, every read agreed and you are done -- the
# dump is clean and both files are the answer. Where they differ, the script
# lists the exact bytes so you can adjudicate them by disassembly, by a
# checksum against a known-good image, or by more reads.
#
# Caveat worth knowing: sticky-0 is the right bet for CHARGE DECAY, but a
# spurious 0 can also come from a bus glitch or a dirty pin, and sticky-0
# will happily believe it. That is exactly why both images are written rather
# than one. Raise N on any chip that produces disagreements.
#
# Every read is kept as <name>_rN.bin until you delete them.

set -euo pipefail

DEFAULT_PROFILE="M2716@DIP24"
DEFAULT_READS=5

if [[ $# -lt 1 || "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    awk 'NR>1 && /^#/ {sub(/^# ?/,""); print; next} NR>1 {exit}' "$0"
    exit 1
fi

name="$1"
profile="${2:-$DEFAULT_PROFILE}"
nreads="${3:-$DEFAULT_READS}"
base="${4:-0}"

command -v minipro >/dev/null 2>&1 || {
    echo "error: minipro not found. brew install minipro" >&2; exit 1; }
command -v python3 >/dev/null 2>&1 || {
    echo "error: python3 not found (install Xcode command line tools)" >&2; exit 1; }

if [[ -e "${name}.bin" ]]; then
    echo "error: ${name}.bin already exists -- refusing to overwrite." >&2
    echo "       Move it aside or choose another name." >&2
    exit 1
fi

if [[ "$nreads" -lt 3 || $(( nreads % 2 )) -eq 0 ]]; then
    echo "error: nreads must be an odd number >= 3 (got ${nreads})." >&2
    echo "       An even count can tie on a per-bit majority vote." >&2
    exit 1
fi

echo "Reading '${name}' as ${profile}, ${nreads} passes."
echo "Leave the chip seated. Do not touch the ZIF lever between passes."
echo

files=()
for ((i=1; i<=nreads; i++)); do
    f="${name}_r${i}.bin"
    printf '  pass %d of %d ... ' "$i" "$nreads"
    if ! minipro -p "$profile" -r "$f" >/dev/null 2>&1; then
        echo "FAILED"
        echo "error: read ${i} errored out. Check seating and profile." >&2
        echo "       Partial reads kept: ${files[*]:-none}" >&2
        exit 1
    fi
    echo "ok"
    files+=("$f")
done
echo

python3 - "$name" "$base" "$profile" "${files[@]}" << 'PYEOF'
import sys, hashlib

name, base_s, profile = sys.argv[1], sys.argv[2], sys.argv[3]
base = int(base_s, 16) if base_s not in ("0", "") else 0
paths = sys.argv[4:]
reads = [open(p, 'rb').read() for p in paths]
n = len(reads)

sizes = {len(r) for r in reads}
if len(sizes) != 1:
    sys.exit(f"error: reads differ in SIZE {sizes} -- wrong profile or bad contact")
size = sizes.pop()

majority, sticky0 = bytearray(size), bytearray(size)
disputed = []
half = n // 2

for off in range(size):
    vals = [r[off] for r in reads]
    if len(set(vals)) == 1:
        majority[off] = sticky0[off] = vals[0]
        continue
    m = s = 0
    for bit in range(8):
        mask = 1 << bit
        ones = sum(1 for v in vals if v & mask)
        if ones > half:
            m |= mask
        if ones == n:          # never read 0 -> genuinely erased
            s |= mask
    majority[off], sticky0[off] = m, s
    disputed.append((off, vals, m, s))

open(f"{name}.bin", 'wb').write(majority)
open(f"{name}.sticky0.bin", 'wb').write(sticky0)

def sha(b): return hashlib.sha256(b).hexdigest()
maj_sha, st_sha = sha(bytes(majority)), sha(bytes(sticky0))

# ---- PLAUSIBILITY CHECKS -------------------------------------------------
# Agreement across passes only detects RANDOM error. A chip that is not
# contacting at all, or is internally dead, returns the SAME wrong answer
# every pass and sails through the vote as "CLEAN". These catch that.
pct_ff = 100.0 * majority.count(0xFF) / size
distinct = len(set(majority))
suspect = []
if pct_ff > 90:
    suspect.append(f"{pct_ff:.1f}% of bytes are 0xFF -- an EMPTY SOCKET reads all-FF. "
                   "Either this chip is blank/erased, or it is not making contact "
                   "and you are reading the programmer's own bus.")
if distinct < 32:
    suspect.append(f"only {distinct} distinct byte values in 2K -- real firmware has "
                   "~200. Suspect dead output drivers or a wrong device profile.")
code_ops = sum(majority.count(b) for b in (0x20, 0x4C, 0x60, 0xA5, 0x85, 0xD0))
if distinct >= 32 and code_ops < size // 100:
    suspect.append(f"almost no 6502 opcode structure ({code_ops} JSR/JMP/RTS/LDA/STA/BNE "
                   "bytes) -- may not be 6502 code, or may be corrupt.")

def addr(off): return f"${base + off:04X}" if base else f"+0x{off:03X}"

print(f"  {size} bytes, {n} passes")
print(f"  majority sha256 {maj_sha}")
print(f"  sticky-0 sha256 {st_sha}")
print()

if suspect:
    print("  " + "!"*66)
    print("  !! PASSES AGREED, BUT THE IMAGE LOOKS WRONG:")
    for s in suspect:
        print(f"  !!   - {s}")
    print("  !! Repeated reads cannot detect a SYSTEMATIC error. Reseat, clean the")
    print("  !! pins, and re-read; compare against another chip holding the same")
    print("  !! block before trusting this.")
    print("  " + "!"*66)
    print()

if not disputed:
    print(f"  CLEAN -- all {n} reads identical, byte for byte.")
    if not suspect:
        print(f"  {name}.bin is trustworthy. (sticky0 file is a duplicate.)")
else:
    split = [d for d in disputed if d[2] != d[3]]
    print(f"  {len(disputed)} unstable byte(s) of {size}:")
    print()
    print(f"  {'addr':>8}  {'reads':<28} {'major':>5} {'stky0':>5}  note")
    print(f"  {'-'*8}  {'-'*28} {'-'*5} {'-'*5}  {'-'*30}")
    for off, vals, m, s in disputed[:64]:
        vs = ' '.join(f"{v:02X}" for v in vals)
        note = "DISAGREE - adjudicate" if m != s else "vote unanimous-ish"
        drift = m ^ s
        if drift:
            note += f" (bit{'/'.join(str(b) for b in range(8) if drift >> b & 1)})"
        print(f"  {addr(off):>8}  {vs:<28} {f'{m:02X}':>5} {f'{s:02X}':>5}  {note}")
    if len(disputed) > 64:
        print(f"  ... and {len(disputed)-64} more")
    print()
    if split:
        print(f"  *** {len(split)} byte(s) where MAJORITY and STICKY-0 disagree.")
        print(f"      These are decayed cells: most reads say 1, at least one says 0.")
        print(f"      Physics favours sticky-0 (charge only leaks 0->1).")
        print(f"      Verify by disassembling both, or checksum vs a known image.")
    else:
        print(f"  Both reconstructions agree; the instability was self-cancelling.")
    print()
    if len(disputed) > size // 20:
        print(f"  NOTE: >5% of bytes unstable -- suspect seating, dirty pins or")
        print(f"        the wrong device profile before trusting any of this.")

with open("dump-log.txt", 'a') as f:
    import datetime
    ts = datetime.datetime.now(datetime.timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')
    tag = "CLEAN" if not disputed else f"{len(disputed)}-unstable"
    f.write(f"{ts}  {name}.bin  {size} bytes  {profile}  "
            f"{n}x-vote  {tag}  {maj_sha}\n")
PYEOF

echo
echo "  individual reads kept: ${files[*]}"
echo "  logged to dump-log.txt"
