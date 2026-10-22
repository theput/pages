# Milling a PCB on a Makera Carvera

*How a desktop CNC, a hand-rolled CAM tool, and three deliberately boring boards
produced a working through-hole amplifier — and the four things that nearly went
wrong without saying a word.*

This is a build diary, not a tutorial. It covers one real board end to end:
**dcrx-10-micamp**, a single-stage op-amp microphone preamp for a
direct-conversion receiver. It was the first PCB I designed, milled, and brought
up successfully.

The reusable parts — the CAM tool and the design rules — are published alongside
this page:

- [`claudecam.py`](claudecam.py) — Gerber + Excellon → Carvera G-code. MIT licensed.
- [`carvera-pcb-SKILL.md`](carvera-pcb-SKILL.md) — the workflow and house rules
  as a Claude skill.

**The single most useful thing here**, if you read nothing else: on a milled
board, **copper clearance has a ceiling, not just a floor**. More space between
your traces is *worse*. [Jump to that section.](#clearance-has-a-ceiling)

---

## The board

A microphone-level preamp sitting after the product detector in a direct-conversion
receiver. One NE5532 gain stage, single 12 V supply, band-limited to speech.

| | |
|---|---|
| Gain | ~50 dB passband peak |
| Passband | 255 Hz – 3.46 kHz (−3 dB) |
| Input | 51 Ω broadband termination off a diode double-balanced mixer |
| Output | ~150 Ω source, mic level (nominal −40 dBu) into a USB audio interface |
| Noise | ~5.2 nV/√Hz input-referred → MDS ≈ −119 dBm |
| Supply | single 12 V, 6 V virtual ground buffered by the spare op-amp half |
| Board | 100 × 70 mm, single-sided, through-hole, bare copper |

Nothing exotic. That was the point — the board existed to prove the *process*,
and a design whose behaviour I could predict to a fraction of a dB was the only
way to know whether the process had worked.

<!-- PHOTO: as-cut board -->

---

## Earn each rung: one new variable per board

The temptation with a new machine is to go straight at the thing you actually
want. Resisting that is most of why this worked.

| Rung | Board | New variable |
|---|---|---|
| 1 | Makera's built-in example | machine, ATC, probing, hold-down |
| 2 | Calibration coupon | **our own design → our own G-code** |
| 3 | **dcrx-10-micamp** | **drilling + through-hole parts** |
| 4 | *(deferred)* | finer isolation / SMD pads |
| 5 | *(deferred)* | double-sided with flip alignment |

Rung 1 proved the machine was trustworthy for a known-good job, which meant every
subsequent failure was on my side of the toolchain — a much smaller search space.
Rung 2 introduced exactly one unknown: our G-code. Rung 3 added holes.

Three rungs took us from a factory example to a functioning board. Skipping to
rung 3 directly would have meant debugging the machine, the CAM, and the design
simultaneously, with silent failures in all three.

---

## Why we wrote our own CAM

MakeraCAM, the vendor tool, failed two ways on this machine. Both failures were
silent.

**It silently discards open geometry.** I added a layer containing a single line
and re-exported. The G-code changed by one *comment* line and produced zero
motion. No warning, no error — the output just quietly didn't contain the thing
I'd asked for.

**It refuses overlapping shapes:** *"the shapes intersect and cannot generate
contour path!"* Gerber is an additive paint model, so **all** real PCB artwork
overlaps. Traces overlap pads. Pour strokes overlap each other. This isn't an
edge case; it's every board anyone has ever drawn.

**It has no isolation-routing operation at all.** You hand-profile shapes with a
generic 2D contour.

What caught both problems was the same move: diff the actual output against an
expected count. That move is the whole design principle of the replacement.

### How claudecam works

```
KiCad → Gerber + Excellon → claudecam → .nc → Carvera Controller
```

1. **gerbonara** parses the Gerber. Every Gerber construct — aperture macros,
   obrounds, region fills, arcs, clear polarity — reduces to five render
   primitives, so full-spec coverage comes free. This matters: an earlier
   hand-rolled parser handled circles and rectangles only, and would have
   silently skipped obround pads, zones, and curved traces. Same failure mode as
   the tool we were replacing.
2. Each primitive becomes a **Shapely** polygon; `unary_union` merges them into
   disjoint copper polygons — the nets. Clear-polarity objects are subtracted.
3. **Isolation pass N is the boundary of `copper.buffer(r + N·stepover)`.**
   That's the entire algorithm. Cutting that boundary curve *is* isolation
   routing. Exterior and interior rings are both cut — they're all copper /
   no-copper boundaries.
4. **Drilling** from Excellon: straight plunge when the hole equals the bit,
   helical interpolation when it's bigger, **hard error when it's smaller**.
5. **Outline** last, if there is one.

Three lines of geometry replaced a GUI. The offset-and-cut-the-boundary framing
is the part worth stealing — once isolation routing is "the boundary of a
buffered polygon," the whole operation is one Shapely call and there's nothing
left to get subtly wrong.

**Under-declaring the tool is deliberate.** The bit cuts ~0.23 mm; declaring
0.20 mm puts the path 0.10 mm off each copper edge, so every pass eats ~15 µm
into its own copper. That's the safe direction — nothing left uncut. Declaring
the true width would leave a copper whisker at every boundary.

---

## Every failure was silent

This is the theme, and it's why the tool asserts its own invariants rather than
trusting anything.

Not one of the problems this project hit announced itself. No exception, no error
dialog, no red X. In every case the tooling reported success and produced
plausible-looking output that was wrong.

**MakeraCAM dropping geometry** — reported success, emitted a file, moved no
tool.

**KiCad's netlister silently dropping four connections.** The "finished"
schematic was electrically broken — two capacitors, a resistor, and the feedback
resistor were unconnected — and *nothing showed as floating on screen*. Junction
dots were present. The cause: **KiCad does not connect a wire that ends on the
interior of another wire. The through-wire must be split at the tap**, junction
dot or not. Reproduced in isolation with `kicad-cli export netlist`; splitting
the riser fixed it with or without a junction dot.

Worse, my own schematic verifier was wrong *the same way the GUI looked* — it
treated any pin-on-a-wire as connected. It agreed with the picture instead of
with the netlister. Rebuilt to union only at shared endpoints, plus an explicit
mid-segment-tap check, it now agrees with `kicad-cli`.

> **Rule adopted:** connectivity is confirmed by a real netlist export or an
> explicit mid-tap check. Never by appearance.

**DRC passing a stranded ground pad.** A ground pour fragmented into two islands
— a signal trace severed the copper path — and one capacitor's GND pad sat on the
orphan island. **DRC passed.** Its connectivity reasons about net *labels*, not
physical copper continuity, so both fragments still read "GND" and the pad marked
as connected. No ratsnest, no error. KiCad's "remove islands" doesn't help
either: the fragment contains a pad, so it's kept.

Same blind spot as the mid-tap bug — logical connection ✓, physical connection ✗.

> **Rule adopted:** on a single-sided milled board the pour *will* fragment
> around traces. Never let the pour be a GND pad's only path — route an explicit
> GND trace to every GND pad and treat the pour as shielding and fill. Stopgap
> detection: unfill the zones and read the ratsnest; pour-only connections light
> up.

**A tool-slot swap that voided a run.** Isolation ran with the blunt corn bit
instead of the pointed V-bit. The machine did exactly what it was told. Now the
rule is to name a tool by **slot + physical bit**, never by number, and to verify
that slot 2 holds the bit that visibly tapers to a point before any isolation cut.

### What we do instead of trusting

claudecam refuses to write a file that fails its own invariants:

- `T` and `M06` on the same line — split lines make the Carvera lose the height map
- no `G02`/`G03` — arcs are flattened upstream, so their presence means a bug
- deepest Z within board thickness
- every Excellon hole covered by a machining entry
- hole smaller than the bit → hard error, never a silent skip

And it predicts shorts before you cut. Two nets closer than 2× the offset have
physically nowhere to put a groove, so the offset regions merge and no cut gets
placed between them:

```
pass 1 @ offset 0.100 mm: 51 regions, 112 loops   <-- SOME NETS MERGE: no groove between them
WARNING: 2 net(s) merge at pass 1 -- those pairs will NOT be isolated.
```

That's a shorted board, readable *before* the spindle turns.

**And we read the entire `.nc` before every cut.** Not by eyeballing 16,569
lines — by classifying every line against an allowed grammar and requiring **zero
unrecognised**. On this board that confirmed no `G02`/`G03`, `T`+`M06` unsplit,
deepest Z −1.5 under the drill tool only, and no stray profile pass. It takes
seconds and it's mechanical rather than heroic. The preview is not the file.

---

## Clearance has a ceiling {#clearance-has-a-ceiling}

This is the genuinely counterintuitive result, and it cost a board's worth of
whiskers to learn.

On a fabbed board, clearance has a floor and more is always safer. **On a milled
board there is a ceiling too, and it's about 0.40 mm.**

Isolation routing cuts **two** grooves at every copper-to-copper boundary. The
CAM offsets each net outward by the tool radius and cuts that loop — so the trace
contributes one groove and the pour contributes another. Whether those merge into
one clean trench or leave **a rib of floating copper standing between them** is
pure arithmetic:

```
kerf = tip + 2·depth·tan(half-angle)     0.2 mm tip, 30°, at 0.065 mm  →  0.235 mm
rib  = gap − 2·r − kerf                  r = tool_dia/2 = 0.10 mm
```

| Design gap | Result at 0.065 mm depth |
|---|---|
| ≤ 0.40 mm | **merged — one trench, at any depth** |
| 0.40–0.435 mm | merged, but only at nominal depth |
| **0.50 mm** | **two grooves + a 66 µm floating whisker** |
| 0.70–0.74 mm | two grooves + a 165–365 µm rib |

At ≤ 0.40 mm the two groove centrelines sit 0.2 mm apart — exactly the bit's tip
width — so they merge at *any* cutting depth. That's the robust number, because
it doesn't depend on hitting your depth target.

This board was laid out at 0.50 mm zone clearance. Every pour-facing trace came
out flanked by two grooves with a 66 µm copper whisker running between them the
whole way round. The one net that happened to be at 0.40 mm came out as a single
clean trench.

The whiskers are electrically harmless — isolated on both sides, floating. But
they lift, shed as debris, and **wick solder and bridge** when you're working on
an unmasked board. De-whisker before soldering.

> **Set KiCad zone clearance to 0.40 mm maximum and keep a 0.30 mm floor.** More
> clearance is not safer here. It's worse.

For gaps the layout forces on you — trace-to-trace spacing you don't control —
the CAM-side lever is extra passes. Each additional pass widens the cleared band
from each side by the stepover, so the fully-cleared gap goes roughly
**0.435 mm (1 pass) → 0.615 (2) → 0.795 (3)** at the default 0.45 stepover. It
costs cutting time.

### The related one: `--edge-margin`

A pour that runs out to the artwork edge produces one isolation loop that merely
traces the stock perimeter. It isolates the pour from bare FR4 — from nothing —
and it drives the collet within a millimetre of the hold-down clamps.

`--edge-margin 3` drops any isolation loop that never reaches more than 3 mm in
from the artwork bounding box. Exactly one loop qualified here. Nearest toolpath
to the stock edge went from 0.40 mm to 1.60 mm. Side benefit: the outer frame
stays continuous with the pour instead of becoming a floating ring.

Every dropped loop is printed with its bounding box and length, so you can check
that only the one you meant qualified.

---

## Cutting it

| | |
|---|---|
| Stock | 100 × 70 mm copper-clad, 1.5 mm — **stock size = board size** |
| Isolation | slot 2, 1/8" 30° 0.2 mm-tip V-bit, −0.065 mm, 1 pass |
| Drill / slots | slot 3, 0.8 mm corn bit, to −1.5 mm, 0.2 mm stepdown |
| Spindle / feed | 12,000 rpm / 300 mm·min⁻¹ |
| Job | 17 isolation loops, 16 engrave loops, 46 holes, 5 routed slots |
| Size | 16,569 lines, 89 plunges, ~2,079 mm of cutting |

Because the stock *is* the board, there's no outline cut and no breakaway tabs —
the stock's own edges become the board edges, and it's pried off the fixture
after. Work origin is the squared stock corner, so machine origin *is* artwork
origin and no offset goes into the G-code.

**Copper goes on the side you can solder.** A single-sided board milled
copper-up must be routed on the *bottom* copper layer, so part bodies don't sit
over the pads you need to reach with an iron — and then mirrored at CAM time,
since the blank is flipped copper-up in the machine. KiCad's plot-mirror only
flips Gerbers, not the Excellon, so the mirror has to be applied downstream where
copper, drill, slots and engraving all flip together. It's baked into the `.nc`;
nothing gets flipped again in Controller.

Two things I'd have gotten wrong without a checklist: **all 46 holes were larger
than the 0.8 mm bit**, so every one is helically interpolated rather than
plunged; and a control run of the *old* command reproduced the previous `.nc`
byte-for-byte before `--edge-margin` was introduced, which is how I know the new
flag was the only variable.

Outcome: ran to completion. All 13 copper nets isolated as 13 regions with no
merge warning, holes and slots clean, engraved text legible in the pour.

---

## Bring-up: does it do what the sim said?

This is the part that makes the whole exercise worth it.

**Predicted 50.96 dB. Measured 50.9 dB.**

That's the payoff for a board whose only job was to be predictable. A milled
board with no plating, no mask, hand-soldered onto bare copper, landed within
0.06 dB of the model.

<!-- PHOTO: Bode sweep -->

There was one discrepancy worth reporting, because the wrong conclusion was
sitting right there. **The first sweep read about 1 dB low.** The obvious
explanation on a hand-built board is component tolerance — 1% resistors, an
electrolytic that's whatever it feels like today — and I could have written that
down, shrugged, and been wrong.

It wasn't tolerance. It was **output compression**: the analyzer was driving the
stage hard enough that the output was starting to clip, which shows up as
uniformly reduced gain rather than as obvious distortion in a magnitude sweep.
Driving through a **470 Ω pad** and re-measuring brought the reading to 50.9 dB.

The tell was that the error was flat across the passband. A tolerance error in a
gain-setting resistor would be flat too — which is exactly why it was
convincing — but so is compression, and only one of those goes away when you
back off the drive level. Attenuate and re-measure costs a minute and settles it.

A 1 dB error you can explain is worth more than a 0.1 dB error you can't.

---

## What's published here

| File | What it is |
|---|---|
| [`claudecam.py`](claudecam.py) | The CAM tool. Gerber + Excellon → Carvera G-code. **MIT licensed** — see the header. |
| [`carvera-pcb-SKILL.md`](carvera-pcb-SKILL.md) | Design rules, tool map, feeds and speeds, KiCad export settings, pre-cut checklist. |

**Adapt the paths.** The skill file refers to directories in my own notes vault
(`engineering/carvera/`, `making/dc-rx-audio-amp/`, and similar). Those paths
won't exist for you — repoint them at wherever your board folders and machine
notes live. The design rules, the arithmetic, and the checklist are the portable
parts.

**Adapt the tool numbers too.** The slot map (slot 2 = V-bit, slot 3 = corn bit)
and the feeds are specific to one machine's ATC loadout. The *practice* of naming
a tool by slot and physical bit rather than by number is the transferable bit.

### Deliberate limits

claudecam is single-sided only. No double-sided flip and registration, no solder
mask, no silkscreen, no travel optimisation beyond nearest-neighbour. That
narrowness is on purpose — it's what keeps the tool small enough to fully verify.
For anything past that, use a mature CAM tool; CopperCAM produced Makera's own
PCB example and is known to cut correctly on this machine.

For this style of board — connector-heavy, hand-soldered, bare copper — **solder
mask would be a bigger win than finer pitch.** That's the next rung.

---

## The short version

- **One new variable per board.** Three boring rungs beat one ambitious board.
- **Every failure was silent.** Vendor CAM, KiCad's netlister, DRC, and a tool
  swap all reported success while being wrong. Assert your invariants; diff
  output against expected counts.
- **Connectivity is confirmed by a netlist export, never by appearance.**
- **Clearance has a ceiling (~0.40 mm), not just a floor.** Two grooves per
  boundary; too much gap leaves floating whiskers.
- **Read the whole `.nc`** — by grammar-classifying every line, not by eyeballing.
- **Attenuate and re-measure** before blaming tolerance.
