# How to read a forty-year-old EPROM and know you got it right

The reusable part of this project. Everything here was learned the hard way over
one long session reading two Apple II ROM sets, and most of it applies to any
aging EPROM, not just these.

**Hardware:** XGecu TL866II Plus driven by `minipro` on a Mac.
Note its 18V Vpp ceiling — it *reads* vintage NMOS 2716/2732 fine (reading needs
only 5V) but cannot *write* them, since those need 21–25V. It can program CMOS
parts like the 27C32 at 12.5V.

---

## The core problem

A single read of an old EPROM gives you no way to know whether you got the truth.
Charge leaks off floating gates over decades, contacts oxidize, and the failure is
silent — you get 2048 plausible-looking bytes either way.

The obvious fix is to read twice and compare. That is where we started, and it is
not enough.

## Lesson 1 — agreement is not correctness

One chip was logged **CLEAN**: five passes, byte-for-byte identical. It was
**100% `$FF`** — the chip was not making contact and the programmer was reading
its own idle bus. Five passes agreed perfectly on nothing at all.

Repeated reads detect only *random* error. A chip that is dead, dirty, or absent
returns the same wrong answer every time and sails through any vote.

So the script now runs plausibility checks on the result, independent of
agreement:

- **>90% `$FF`** — an empty socket reads all-FF on this programmer, so the chip is
  either blank or not connected
- **fewer than 32 distinct byte values** — real firmware has ~200
- **no 6502 opcode structure** — almost no JSR/JMP/RTS/LDA/STA/BNE bytes

None of that is sufficient. **The only real defence is a second chip holding the
same block.** Two of ours did, and the byte-identical match between two
manufacturers is the single most valuable fact in the whole project.

## Lesson 2 — verify the toolchain with a programmed chip, never a blank one

Our original toolchain check was "a blank chip read as all `$FF`, so seating,
profile and cable are good."

An **empty socket also reads all `$FF`**. So did a dead chip. So would a broken
cable. That test could not distinguish any of them and proved nothing.

The only valid check is a **programmed** chip that disassembles into sensible
code.

## Lesson 3 — the obvious rule for reconstructing decayed cells is wrong half the time

A UV EPROM erases to 1; programming stores charge to make a 0. Charge only leaks
away. So decay flips **0 → 1**, never the reverse, and the physics says: if a bit
ever reads 0, it was programmed. Prefer the zero. Hold every zero you ever saw.

That reasoning is sound, and it was wrong on two of the three chips where it
mattered.

A **stuck-low output driver flips 1 → 0**. On such a chip, holding every observed
zero locks in false zeros permanently. We watched it happen in plain English —
one chip's bit 3 was dropping, and the Integer BASIC error table read:

| as read | should be |
|---|---|
| `TGO LGNG` | `TOO LONG` |
| `BAD BRAFC@` | `BAD BRANCH` |
| `RETYPE LIFE` | `RETYPE LINE` |

Every error bit 3, every one in the 1 → 0 direction. Held-zero reconstruction
would have cemented all of it.

On another chip, majority vote picked `JSR $DD6A` where held-zero picked
`JSR $5D6A` — a call into RAM, impossible for a ROM. Majority was right.

**There is no universal rule.** Diagnose the direction per chip, then choose:

| failure mode | flips | correct reconstruction |
|---|---|---|
| charge decay | 0 → 1 | hold zeros (AND of all passes) |
| stuck-low driver / weak contact | 1 → 0 | hold ones, or majority |

The way you tell is ground truth — English text in the ROM, or an address that
must land in ROM rather than RAM. **The disassembler is a verification
instrument**, not just a way to read the code.

## Lesson 4 — cleaning works, and it is measurable

The chip that read 100% `$FF` came back **byte-perfect** after its pins were
cleaned, matching an independently-read chip from another set exactly.

- Use **DeoxIT on a lint-free polyester wipe**. Never a cotton swab — it sheds
  fibres into the ZIF socket, which is worse than the oxide.
- Apply to the wipe, not the chip. Pinch-drag each pin row through it, finish
  with a dry section.
- **Reseat 5–10 times first.** A ZIF socket wipes the pins on every insertion.
  Free, no residue, often sufficient.
- Never spray at a windowed part — solvent wicks under the lid seal and lifts the
  label protecting the window.

**But cleaning is not a universal fix.** On a chip with internal damage it made
things marginally *worse* (160 → 167 unstable bytes). Measure before and after.
If the unstable count does not drop, oxide was not the problem.

## Lesson 5 — label the file from the physical chip, at the moment you read it

The single most expensive mistake of the session: a dump named for one
manufacturer that actually came from the other. Reasoning from it produced a
confident, completely wrong conclusion about what both sets contained, and it
survived several rounds of analysis before the physical chips contradicted it.

Convention: `<manufacturer>_<sticker>.bin`, always. Never a bare sticker name —
this lot contains three chips labelled F8 and two labelled F0.

## Lesson 6 — diagnose which *bit* is failing

Per-bit statistics tell you immediately what kind of failure you have. Healthy
6502 code sits in a 35–65% "1" rate on every bit:

| chip | D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |
|---|---|---|---|---|---|---|---|---|
| healthy | 64.2 | 47.2 | 55.0 | 34.9 | 26.8 | 49.1 | 41.7 | 50.1 |
| **dead** | 67.1 | **0.2** | **0.0** | **1.1** | **0.0** | 26.0 | **0.1** | **0.0** |

Six planes pinned at zero, no opcode structure, and — critically — an empty
socket on this programmer floats to `$FF`, so those pins were connected and being
actively driven low. Internal die failure, not contact. That chip was never going
to be recovered, and knowing it early saves hours.

If instability concentrates in **one bit across several chips**, suspect the
socket or the programmer's data line. If it follows the chip, it is the chip.

---

## The tools

### `dump-eprom-vote.sh`

```bash
./dump-eprom-vote.sh <name> [profile] [nreads] [base-address-hex]
./dump-eprom-vote.sh mostek_E0 "M2716@DIP24" 5 E000
```

Reads N times (default 5, must be odd), writes both reconstructions —
`<name>.bin` (per-bit majority) and `<name>.sticky0.bin` (held zeros) — plus a
table of every unstable byte showing what each pass saw and where the two
reconstructions disagree. Individual passes are kept. Runs the plausibility
checks from Lesson 1.

[**Download dump-eprom-vote.sh**](dump-eprom-vote.sh)

### `a2dis.py`

Apple II–aware 6502 disassembler. Annotates `$C0xx` soft switches, monitor entry
points and monitor zero page; renders high-bit ASCII as `.ASC` directives instead
of garbage instructions; emits the `$FFFA`–`$FFFF` vector table as data; and flags
every line containing an unstably-read byte.

```bash
python3 a2dis.py rom.bin F800 F800 FFFF
```

[**Download a2dis.py**](a2dis.py)

## Reading text out of Apple II ROMs

Apple II stores characters with **bit 7 set** — `A` is `$C1`, not `$41` — so a hex
editor's ASCII column shows nothing but dots and the ROM looks textless.

```bash
python3 -c "import sys;d=open(sys.argv[1],'rb').read();\
s=''.join(chr(b&0x7f) if 32<=(b&0x7f)<127 else chr(10) for b in d);\
print(chr(10).join(l for l in s.split(chr(10)) if len(l)>4))" rom.bin
```

Terminator conventions differ by BASIC: Integer BASIC sets bit 7 on every
character and **clears** it on the last; Applesoft uses plain ASCII and **sets**
bit 7 on the last.

## A checklist

1. Read a **known-programmed** chip first to validate the chain. Never a blank.
2. Read every chip **5×**, odd count.
3. Run the plausibility checks — %FF, distinct values, opcode structure.
4. Look at **which bit** is unstable before touching anything.
5. Clean only what fails, and **measure** before and after.
6. Adjudicate disputed bytes by **disassembly**, not by rule.
7. **Cross-check against a second chip** wherever one exists.
8. Name files from the physical chip, immediately.
9. Boot the result in an emulator before calling it done.

Step 9 is the one still outstanding on this project.

---

*[← All recovered EPROMs](../)*
