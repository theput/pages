# Published pages

Everything currently published from `pages/`. Each entry links to its live URL
once GitHub Pages is enabled.

## Projects

- **[Milton the Radio](milton/)** — build diary and schematics for the Milton
  radio project.
- **[Milling a PCB on a Makera Carvera](carvera-pcb/)** — build diary of the
  first board designed, milled, and brought up on the Carvera: why we wrote our
  own CAM tool, why every failure was silent, and why copper clearance has a
  *ceiling*. Includes [`claudecam.py`](carvera-pcb/claudecam.py) (MIT) and the
  [`carvera-pcb` skill file](carvera-pcb/carvera-pcb-SKILL.md).

## Lab notes

- **[Lab notes](lab/)** — build notes and experiment journals as notebook
  pages: quad paper, hand lettering, figures on the grid. First page:
  [RockMite 40m — PA + low pass filter](lab/rockmite-40m/pa-lpf). Board pages
  (what a board label points to): [rockmite-10](lab/rockmite-40m/rockmite-10),
  [coupon-10](lab/rockmite-40m/coupon-10).

## Inventory

- **[Parts](parts/)** — full parts list (the single URL all labels point to for
  now).
- **[Sealed IC blister packs](parts/sealed-blister-packs/)** — the sealed-pack bin, generated from the surplus-IC inventory.
- **[Op-amps & analog chips](parts/op-amps-analog/)** — the working op-amp/analog IC bin.
- **[Transistors](parts/transistors/)** — the discrete transistor bin (5 function buckets + CA3018 array).

## Preservation

- **[Recovered EPROMs](eproms/)** — firmware read off surplus 1970s–80s EPROMs.
  Two complete Apple II ROM sets so far: [Integer BASIC](eproms/apple2-integer/)
  (Woz, with SWEET16 and the Mini-Assembler) and
  [Applesoft](eproms/apple2-applesoft/) (Microsoft). Includes
  [how they were read](eproms/method/) and verified.

---

*To add a page: copy `_template/` to a new folder, write its `index.md`, and add
a line here. See [README.md](README.md) for the full workflow.*
