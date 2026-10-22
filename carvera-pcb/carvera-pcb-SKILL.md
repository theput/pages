# `carvera-pcb` — Claude skill

Companion to [*Milling a PCB on a Makera Carvera*](./). This is the skill file
reproduced in full, so a teammate can adapt it rather than rebuild it.

> **Adapt before you use it.**
>
> It is reproduced as written, so it still says "Bill" and still refers to
> directories in a private notes vault — `engineering/carvera/`,
> `making/dc-rx-audio-amp/`, `engineering/kicad/`, and per-board folders under
> `boards/NNN-name/`. **Those paths will not exist for you.** Repoint them at
> wherever your own board folders, machine notes, and CAM tool live, or delete
> the references outright.
>
> The **ATC slot map and the feeds/speeds are specific to one machine's
> loadout** — verify them against yours before cutting anything.
>
> The portable parts are the design rules (especially the clearance *ceiling*),
> the board-complexity ladder, the pre-cut checklist, and the habit of naming a
> tool by slot plus physical bit rather than by number.
>
> The CAM tool it drives, [`claudecam.py`](claudecam.py), is published alongside
> under the MIT license. This skill file carries no separate license — treat it
> as notes to adapt freely.

## Skill front matter

To install this as a Claude skill, recreate `SKILL.md` with this YAML header
followed by everything below it:

```yaml
---
name: carvera-pcb
description: >-
  Design and mill a single-sided, through-hole PCB on Bill's Makera Carvera, from KiCad to
  cut copper. Use when Bill is designing a board to mill, generating or reviewing Carvera
  G-code, running claudecam, or asking "will this mill on the Carvera?" / "check my board
  against the design rules" / "make the gcode for this board". Encodes the design rules,
  ATC tool map, factory-proven feeds/speeds, KiCad Gerber export settings, the claudecam CLI,
  and the pre-cut checklist — all derived from the 001/002 bring-up. NOT for double-sided,
  SMD, solder-mask, or silkscreen work (deferred rungs) — say so and stop.
---
```

---


# Carvera PCB — design → mill (single-sided, through-hole)

Bill mills his own PCBs on a **Makera Carvera** desktop CNC. This skill is the durable workflow
and the house rules learned during bring-up (boards 001–002). The authoritative source files
live in `engineering/carvera/` — read them when you need depth:
`machine-notes.md` (tool map, geometry, Stage A results), `cam-toolchain.md` (KiCad export,
design rules, sources), `factory-gcode-reference.md` (verified G-code conventions),
`claudecam/README.md` (the CLI), and per-board dirs under `boards/NNN-name/`.

## The pipeline

```
KiCad → Gerber + Excellon → claudecam → .nc → Carvera Controller
```

Design and cut from the same machine — the Carvera is reachable over the network. Keep the `.nc`
in the **version-controlled board folder** either way, so there's always a record of which file
cut the board.

> Earlier revisions of this skill described a Mac-design / Windows-cut split, back when the
> Carvera would only enumerate over USB on Windows. That's obsolete as of 2026-08-14.

## Board complexity ladder — earn each rung, one new variable per board

1. Built-in example, no mask — proves machine/ATC/probing/hold-down. **(001 done.)**
2. Own design → own G-code. **(002 calibration coupon.)**
3. Drilling + through-hole parts — real functional board. **(003 — dcrx-10-micamp op-amp AF amp, cut 2026-08-14. ✅)**
4. Finer isolation / SMD pads. 5. Double-sided with flip alignment (the hard one).

Don't introduce two new variables in one board. Single-sided + through-hole is the default;
push past it only deliberately.

## Design rules — set these in KiCad before laying out

| Rule | Value | Note |
|---|---|---|
| Min track width | **0.20 mm** | Go wider wherever you can — there is no cost. |
| Clearance | **0.30–0.40 mm** (floor 0.25) | Has a **ceiling as well as a floor** — see below. Tool 2 cuts ~0.23 mm wide at nominal depth, so 0.20 mm is the marginal edge, not a rule. |
| Min hole | **0.80 mm** | Hard floor — Tool 3 *is* a 0.8 mm bit. 0.6 mm is impossible. |
| Min pad / via | **1.1 mm** | 0.8 mm hole + annular ring. |
| Origin | drill/place file origin, bottom-left | Keeps Gerber + Excellon registered. |

### Clearance has a CEILING too — 0.40 mm (learned on dcrx-10-micamp, 2026-08-14)

Isolation routing cuts **two** grooves at every copper-to-copper boundary — claudecam offsets each
net outward by r and cuts that loop, so the trace contributes one and the pour contributes another.
Whether they merge into a single clean trench or leave a **rib of floating copper standing between
them** is pure arithmetic:

```
kerf  = tip + 2·depth·tan(half-angle)     30° 0.2 mm tip @ 0.065 mm  ->  0.235 mm
rib   = gap − 2·r − kerf                  r = tool_dia/2 = 0.10 mm
```

| Design gap | Result at 0.065 mm depth |
|---|---|
| ≤ 0.40 mm | **merged — one trench, at ANY depth** (centrelines are 0.2 mm apart = the tip width) |
| 0.40–0.435 mm | merged, but only at nominal depth |
| **0.50 mm** | **two grooves + a 66 µm copper whisker** |
| 0.70–0.74 mm | two grooves + a 165–365 µm rib |

So **more clearance is not safer here — it's worse.** dcrx-10-micamp was laid out with 0.50 mm zone
clearance and every pour-facing trace came out flanked by two grooves with a fragile whisker between;
its one 0.40 mm net came out as a single clean trench. Whiskers are floating copper (isolated on both
sides, so electrically harmless) but they lift, become debris, and bridge when soldering.

**Set KiCad zone clearance to 0.40 mm max, and keep the 0.30 mm floor.** Zone min width stays
~0.3–0.4 mm so KiCad won't try webs it can't mill.

Gaps you *can't* control — trace-to-trace spacing forced by the layout — are inherent to isolation
routing. The CAM-side lever is `--passes`: each extra pass widens the cleared band from each side by
the stepover, so the **fully-cleared gap** goes ≈ **0.435 mm (1 pass) → 0.615 mm (2) → 0.795 mm (3)**
at the default 0.45 stepover. Use it when a board has to carry wide gaps; it costs cutting time.

**Copper goes on the side you can solder.** Milled boards have no plated-through holes, so every
joint needs iron access on the copper side; route a backup track where a part body blocks a pad.

**Ground pour: use Solid pad connections, not thermal reliefs** (KiCad zone → Pad connections →
*Solid*). Thermal spokes are fussy on milled copper — a hemmed-in pad forms only one spoke and trips
KiCad's min-spoke-count DRC (hit on dcrx-10-micamp's C6) — and solid also *mills cleaner* (no thin
spokes for the V-bit to isolate) and grounds better. There's no wave-solder heat-sink reason for
thermals on a hand-soldered board; a normal iron solders solid-to-pour fine on 35 µm copper. Set zone
clearance in the **0.30–0.40 mm** band (see the clearance ceiling above — **not** 0.50) and zone min
width ~**0.3–0.4 mm** so KiCad won't try thin webs it can't mill (it'll simply leave un-fillable gaps, e.g. between DIP pins, open — expected). The pour
pairs perfectly with claudecam's isolation-only routing: it cuts a moat around each non-GND
trace/pad and leaves the rest of the copper, so a pour means *less* milling, not more.

**Don't rely on the pour as a GND pad's only path.** On a single layer the pour *will* fragment
into islands wherever a trace crosses it — and **DRC won't catch a GND pad stranded on an orphan
island** (its connectivity reasons about net *labels*, not copper continuity, so both fragments read
"GND" and the pad shows connected — no ratsnest, no error; found on dcrx-10-micamp's C6). KiCad
"remove islands" doesn't help — a fragment with a pad is kept. So **route an explicit GND trace to
every GND pad** and treat the pour as shielding/fill, not the ground network (this is also why the
modular-radio plan uses a deliberate star ground). Stopgap detection: unfill zones and read the
ratsnest — pour-only connections light up; re-fill and confirm the copper actually bridges them.

**Don't route between DIP/IC pads.** 1.8 mm pads on 2.54 mm pitch leave a 0.74 mm copper gap; at the
0.30 mm clearance rule a threaded trace would be 0.14 mm — under the 0.20 mm floor. Route out to the
sides; if a crossing is unavoidable, use a top-side wire jumper (through-hole board, links are free).

Until board **002 Stage B** (geometry coupon) is cut, treat clearance ≥ **0.30 mm** as the floor —
Stage A is done (copper ≈ 1 oz / 35 µm) but the trace/clearance rule isn't empirically pinned yet.

**Footprint check (design step).** Before committing a footprint to a milled board, run
`engineering/kicad/verify_footprints.py <lib.pretty>` — flags SMD copper pads, holes < 0.80 mm,
pads < 1.10 mm, pad-to-pad clearance < 0.30 mm, and thin annular rings (< 0.15 mm). KiCad's own
DRC won't catch a milling-hostile footprint; this does. (All Constellation_Carvera + Constellation_Custom
footprints pass as of 2026-08-13.)

## Tooling — ATC slot map (PCB work uses slots 2 and 3 only)

Always name a tool by **slot + physical bit**, never just "Tool N" (the kit's markings differ
from the manual's numbering).

| Slot | Bit | Role |
|---|---|---|
| **2** | 1/8" 30°, **0.2 mm tip V-bit** ("Engraving Bit 30° × 0.2 mm") | copper **isolation** |
| **3** | **0.8 mm corn bit** ("Corn Bit 0.8 mm") | copper clearing, **drilling**, board **cutout** |

> ⚠️ **Before any isolation cut, verify slot 2 holds the POINTED V-bit.** A 002 run was voided
> because 2 and 3 were swapped — isolation ran with the blunt corn bit. The V-bit is the only bit
> that tapers to a sharp point. Re-probe tool length whenever a bit changes in a slot.

## Feeds & speeds — FACTORY-PROVEN (from board 001's example G-code)

| Operation | Tool | Spindle | Feed | Depth |
|---|---|---|---|---|
| Isolation | 2 (0.2 mm V) | 12,000 | 300 curves / 500 straights, plunge 300 | **−0.065 mm** working (Stage A), constant Z, **no V-carve** |
| Drilling | 3 (0.8 mm corn) | 12,000 | plunge 300 | one plunge to −1.6, no pecking |
| Cutout / interpolated holes | 3 | 12,000 | 200–400 | 0.2 mm stepdown, ~8 passes to −1.6 |

Header conventions (verified): `G21 G40 G54` / `G80 G90 G94` · `T2 M06` **on one line** ·
`M03 S12000` · `M07` … `M09 M05 M02` · approach `Z2`, clear `Z3`. Isolation depth is the whole
game — too shallow leaves copper connected, too deep widens the kerf. That's why auto-leveling
is mandatory.

## KiCad Gerber export

`File → Fabrication Outputs → Gerbers (.gbr)` → into the board's `cam/` subdir. Include the copper
layer + `Edge.Cuts`. **Check "Use drill/place file origin."** Then generate **Excellon** drill
files from the same dialog.

## claudecam — the CLI engine (KiCad artwork → Carvera G-code, no CAM GUI)

Lives at `engineering/carvera/claudecam/`. Built because MakeraCAM **silently** discards open
geometry and refuses overlapping Gerber artwork. claudecam parses Gerber (gerbonara) → Shapely
polygons → isolation = boundary of `copper.buffer(r + N·stepover)`; drills from Excellon
(plunge if hole == bit, helical interpolation if bigger, hard error if smaller); outline last.

```bash
python3 claudecam.py \
  --copper 003-F_Cu.gbr --outline 003-Edge_Cuts.gbr --drill 003.drl \
  --iso-depth 0.065 --board-thick 1.5 \
  --origin 2,2 --tabs 4 --tab-width 2.5 --tab-height 0.4 \
  -o 003.nc
```

Key options: `--tool-dia` (declared, default 0.20 — deliberately undersized so nothing is left
uncut), `--passes`, `--stepover`, `--iso-tool`/`--drill-tool`/`--drill-dia`, `--stepdown`,
`--feed`/`--plunge`/`--spindle`, `--tabs` (breakaway tabs as a CLI option, not baked into artwork),
`--mirror x|y` (bottom-copper board milled copper-up — mirrors copper + engrave + **drill** together,
since KiCad's plot-mirror won't touch the Excellon), `--engrave LAYER.gbr` + `--engrave-depth`
(a mark/logo on User.1, cut with the same T2 bit, riding the same mirror/origin).

**`--edge-margin N`** skips any isolation loop lying entirely within N mm of the artwork bounding
box. Use it (3 mm is fine) on any board with a **pour that reaches the stock edge**: that pour
produces a loop which merely traces the perimeter — it isolates the pour from bare FR4, buys
nothing, and drives the collet next to the hold-down clamps. Dropping it also leaves the outer frame
continuous with the pour instead of a floating ring. Every dropped loop is printed with its bbox and
length; check that only the one you meant qualified.

**When the stock IS the board** (no `--outline`, no `--tabs`, stock cut to size and squared against
a fence): the artwork origin is the stock corner, so pass **no `--origin`** — machine origin *is*
artwork origin, set XY zero at Anchor 1. Verify with Controller's margin/frame trace before cutting;
predict the four edge clearances from the `.nc`'s XY extents and check the frame matches.

claudecam self-checks before it writes: `T`+`M06` same line (height-map bug), no `G02`/`G03`
(arcs flattened), deepest Z within board thickness, every Excellon hole covered, hole < bit → hard
error. It **warns when two nets are closer than 2× offset** ("nets merge — will NOT be isolated"),
so you read a shorted-board prediction *before* cutting. Single-sided only by design — for
double-sided/mask, use a mature tool (CopperCAM cut Makera's own example).

## Pre-cut checklist — every failure this project has hit was SILENT

- [ ] **Footprints milling-clean** — `verify_footprints.py` PASS on every library the board uses
      (no SMD pads, hole ≥ 0.8, pad ≥ 1.1, clearance ≥ 0.3).
- [ ] **Read the entire `.nc`** before sending. Both bring-up failures ran silently. Don't eyeball
      16,000 lines — **classify every line against the allowed grammar** (`%`, comments,
      `G21 G40 G54`, `G80 G90 G94`, `T# M06`, `M03 S#`, `M07/M09/M05/M02`, `G00 X..Y..`, `G00 Z..`,
      `G01 F# Z..`, `G01 F# X..Y..`) and require **zero unrecognised**. Then check XY extents,
      deepest Z per tool, and the section map. The preview is not the file.
- [ ] **Regenerate a control run** when changing a CAM flag: re-run the *old* command first and
      confirm it reproduces the existing `.nc` byte-for-byte, so the new flag is the only variable.
- [ ] **Diff the CAM output against expected** (segment/hole counts) — claudecam asserts this; if
      you used MakeraCAM, do it by hand (its 2D Contour drops open geometry with zero warning).
- [ ] **No perimeter moat** — if the pour reaches the stock edge, run `--edge-margin 3`.
- [ ] **`T…` and `M06` on the same line** — split lines make the Carvera lose the height map.
- [ ] **Slot 2 = pointed V-bit, slot 3 = corn bit.** Re-probe tool length after any bit swap.
- [ ] **Auto-level 5×5** in Carvera Controller (min; 15 pts better). Reuse the map for every
      later op on the same board and **disable re-probing** — re-probing mid-board loses registration.
- [ ] **Sacrificial backing** (scrap FR4 / thin MDF) — drilling and cutout go fully through onto
      the aluminium bed.
- [ ] **Boundary/outline cut first as a canary** where practical — confirms it's cutting before the
      sensitive fine work.
- [ ] Solder side reachable for every joint; debris plan (fine sand → brush → isopropanol).

## Soldering the finished board (bare copper, no mask) — Bill's settings

**Sn63/Pb37 leaded, iron at 640 °F / 338 °C, hit it quick.** Hot-and-fast is deliberate, not
sloppy: with no plating and no mask the copper is held to the FR4 by adhesive alone, so *dwell*
is what lifts a pad, not peak temperature. 2–3 s on a normal pad. If a joint isn't taking, pull
off, re-flux, and go back — never sit on it.

- **Clean and flux first.** Bare unplated copper oxidizes and won't wet, however hot the iron is.
  Fine abrasive → isopropanol → flux; tinning the pads before placing parts is worth it.
- **Pour-tied GND pads need tip MASS, not more heat.** Solid pad connections weld every GND pad to
  the whole pour (thousands of mm² of 35 µm copper). Use a chisel/bevel tip, not a fine conical;
  4–5 s is fine there. Raise temperature only ~20 °F if you must.
- **Knock the isolation whiskers off before soldering** — any gap over ~0.435 mm leaves a floating
  copper rib that wicks solder and bridges. Sand → brush → isopropanol.
- **All joints are on the copper side** — no plated-through holes to carry solder through.

## Board folder convention (set 2026-08-10, refined)

A board is **self-contained**: one folder holds the KiCad design (`kicad/`), the milling
artifacts (`cam/`: Gerbers, Excellon, `.nc`, previews), photos, and a markdown design record —
**milling artifacts stay with the board**, never split into a separate CAM area.

**Where that folder lives:**
- **Real project boards** live **with their project** (self-contained), using the Carvera as
  shared tooling — e.g. `making/dc-rx-audio-amp/` (design in `kicad/`, artifacts in `cam/`).
- `engineering/carvera/boards/NNN-short-name/` is only for **bring-up / coupon / example** boards
  (001 LED, 002 calibration coupon, kicad tests).

Either way, log every cut (successes AND failures — failures carry the most information) in the
shared `engineering/carvera/build-log.md` (machine history), plus the project's own build notes.

## Scope guard

This skill is single-sided, through-hole only. If asked for double-sided flip/registration,
solder mask, silkscreen, laser, or fine SMD pitch: name it as a later ladder rung, don't
improvise it here, and point at a mature CAM tool.
