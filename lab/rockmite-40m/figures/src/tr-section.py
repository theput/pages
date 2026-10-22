#!/usr/bin/env python3
"""The T/R section on its own: series C, clamp diodes, series L (the crystal).
Figure for lab/rockmite-40m/tr-switching.md. Run by assets/mims/render-figures.py.
"""
from mims import Page

p = Page(26, 10, seed=20, jitter=1.0)


def diode_pair(x, y, depth=3):
    p.junction((x - 1, y))
    p.junction((x + 1, y))
    p.wire([(x - 1, y), (x - 1, y + 1)])
    p.wire([(x + 1, y), (x + 1, y + 1)])
    p.diode((x - 1, y + 1), (x - 1, y + depth))
    p.diode((x + 1, y + depth), (x + 1, y + 1))
    p.wire([(x - 1, y + depth), (x - 1, y + depth + 1), (x + 1, y + depth + 1), (x + 1, y + depth)])
    p.junction((x, y + depth + 1))
    p.ground((x, y + depth + 1))


Y = 4
p.antenna((3, Y))
p.wire([(3, Y), (6, Y)])
p.junction((6, Y))
p.capacitor((6, Y), (8, Y))
p.text((7, Y - 0.8), "X_C ~ 500Ω", 11, anchor="middle")
p.wire([(8, Y), (14, Y)])
diode_pair(11, Y)
p.inductor((14, Y), (17, Y))
p.text((15.5, Y - 0.8), "X_L ~ 500Ω", 11, anchor="middle")
p.wire([(17, Y), (19, Y)])
p.terminal((19, Y), label="TO SA612", side="right", size=10)

p.save("tr-section.svg", crop=True, paper=False)
