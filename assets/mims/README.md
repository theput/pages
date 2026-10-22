# Mims-style lab notes

The notebook look for `pages/`: cream quad paper, hand-lettered block caps, figures drawn on the same grid as the page, a right-hand annotation column, page number bottom right.

## Writing a note

A note is a Markdown file anywhere under `lab/` with this front matter:

```
---
layout: notebook
title: PA + low pass filter
project: RockMite 40m
date: 2026-10-21
page: 1
---
```

`lab/index.md` lists every note that has a `project`, newest first. Optional: `summary` (meta description), `previous_note` / `next_note` (paths, for the nav at the bottom), `callsign`.

Things the layout understands:

- A paragraph followed by `{: .margin}` goes in the annotation column. Put it right *before* the paragraph or figure it annotates, and it sits beside it. On phones it falls inline with a bar on the left.

- `![caption](figures/name.svg)` drops a figure in at its natural size. Figures are rendered with `paper=False` so the page's own grid shows through and lines up.

- A line starting with `\*` followed by `{: .foot}` is the page footnote.

- Headings are underlined like Mims'. `**bold**` underlines (the hand has no bold). Tables and blockquotes get hand-drawn borders.

- Everything is set in caps by the font. Unit prefixes stay lowercase after a digit: `325 mW`, `10k`, `470p`, `100 nF`.

## Figures

Each figure is a small Python script that draws with `mims.py`:

```
lab/<project>/figures/src/<name>.py   -> writes  lab/<project>/figures/<name>.svg
```

The script ends with `p.save("<name>.svg", crop=True, paper=False)`. Regenerate all of them with

```
python3 assets/mims/render-figures.py
```

`push.sh` runs that before committing, so the SVGs in the repo always match their scripts. To draw a new figure, ask Claude for a Mims-style figure (the `mims-diagrams` skill) and drop the script it writes into `figures/src/`.

## Font

`MimsHand.woff2` is built from the same stroke glyphs the renderer uses, so page lettering and figure lettering are one hand. Rebuild it after changing glyphs in `mims.py`:

```
pip install fonttools shapely brotli
cd assets/mims && python3 build_font.py
```

## Files

- `mims.py` — the renderer (canonical copy lives in Constellation `engineering/mims-style/`; this is its published mirror — copy it over when it changes)
- `mims.css` — the paper
- `../../_layouts/notebook.html` — the page
- `MimsHand.ttf` / `MimsHand.woff2` — the hand
- `build_font.py`, `render-figures.py` — tooling
