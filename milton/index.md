# Milton the Radio — build diary

A running log of the Milton radio build: design decisions, wiring, parts, and
schematics.

## Overview

*(One or two lines on what Milton is and what you're going for — the kind of
radio, the goal, the vibe.)*

## Schematics

Diagrams live in [`schematics/`](schematics/). Embed one with a relative path so
it travels with the page:

![Milton signal chain — block diagram](schematics/block-diagram.png)

*Above: a placeholder block diagram, here just to show how an image renders.
Replace it with the real schematic when it's drawn.*

## Build checklist

Two ways to do checklists on a page.

**1. Markdown task list** — simplest, but the boxes are *static* (they display as
checked/unchecked but you can't click them on a rendered page):

- [x] Idea captured
- [ ] Parts ordered
- [ ] First light

**2. Operable checklist** — clickable, and your ticks are remembered in *this
browser* (via localStorage). This is the pattern a QR-code inventory page would
use: scan the label, open the page, check items, state persists.

<ul style="list-style:none;padding-left:0;line-height:2" id="milton-checklist">
  <li><label><input type="checkbox" data-key="antenna"> Antenna wire cut &amp; mounted</label></li>
  <li><label><input type="checkbox" data-key="coil"> Tuning coil wound (~60 turns)</label></li>
  <li><label><input type="checkbox" data-key="diode"> Germanium detector diode installed</label></li>
  <li><label><input type="checkbox" data-key="earphone"> High-Z earphone wired</label></li>
  <li><label><input type="checkbox" data-key="firstsignal"> First signal received</label></li>
</ul>
<button type="button" id="milton-reset" style="font-size:0.85em;padding:4px 10px;cursor:pointer">Reset checklist</button>
<script>
(function () {
  var scope = 'milton';
  var boxes = document.querySelectorAll('#milton-checklist input[type=checkbox]');
  boxes.forEach(function (b) {
    var k = 'ck:' + scope + ':' + b.getAttribute('data-key');
    try { if (localStorage.getItem(k) === '1') b.checked = true; } catch (e) {}
    b.addEventListener('change', function () {
      try { localStorage.setItem(k, b.checked ? '1' : '0'); } catch (e) {}
    });
  });
  var reset = document.getElementById('milton-reset');
  if (reset) reset.addEventListener('click', function () {
    boxes.forEach(function (b) {
      b.checked = false;
      try { localStorage.removeItem('ck:' + scope + ':' + b.getAttribute('data-key')); } catch (e) {}
    });
  });
})();
</script>

*(Persistence is per-browser/per-device — fine for a personal build or inventory
checklist. A shared, multi-device source of truth would need a backend, which is
deliberately out of scope for "as simple as possible.")*

## Build log

### Entry 1 — *date*

*(What you did, what worked, what didn't. Add a new dated entry per session.)*

## Parts

*(Running list of components — value, source, notes.)*

## References

External links render as normal markdown links and open in the browser:

- [ARRL Technical Information Service — reference (PDF)](https://www.arrl.org/files/file/Technology/tis/info/pdf/0003037.pdf)
