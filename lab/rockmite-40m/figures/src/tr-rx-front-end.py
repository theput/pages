#!/usr/bin/env python3
"""RockMite receive front end: coupling cap, clamp diodes, crystal, shunt cap, SA612 pin 2.
Figure for lab/rockmite-40m/tr-switching.md. Run by assets/mims/render-figures.py.
Source: Bill's notebook page of 2026-10-20 (Constellation making/rockmite-40m/photos/notebook/).
"""
from mims import Page

p = Page(30, 12, seed=20, jitter=1.0)


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
p.terminal((2, Y), label="ANT/LPF", side="below", size=9)
p.wire([(2, Y), (4, Y)])
p.capacitor((4, Y), (6, Y))
p.text((5, Y - 0.8), "X_C ~ 482Ω", 11, anchor="middle")
p.text((5.2, Y + 1.1), "47 pF", 10, anchor="middle")
p.wire([(6, Y), (12, Y)])
diode_pair(8, Y)
p.crystal((12, Y), (14, Y))
p.inductor((12.2, Y - 1.8), (13.8, Y - 1.8), loops=3)      # "looks inductive"
p.text((14.4, Y - 1.6), "ABOVE F_S: INDUCTIVE", 10)
p.wire([(14, Y), (24, Y)])
p.junction((16, Y))
p.capacitor((16, Y), (16, Y + 3))
p.ground((16, Y + 3))
p.junction((20, Y))
p.resistor((20, Y), (20, Y + 3), "R_{IN}", "~1.5K", side="right")
p.ground((20, Y + 3))
p.text((23.6, Y - 0.4), "2", 10, anchor="end")
p.box((24, Y - 1.5), 3.5, 3, label="SA612", size=12)

p.save("tr-rx-front-end.svg", crop=True, paper=False)
