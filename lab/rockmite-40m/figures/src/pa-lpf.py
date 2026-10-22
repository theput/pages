#!/usr/bin/env python3
"""RockMite 40m PA + low-pass filter — figure for lab/rockmite-40m/pa-lpf.md.
Run from the figures/ directory (render-figures.py does this):  python3 src/pa-lpf.py
"""
from mims import Page

p = Page(30, 18, seed=11)

Y = 10          # Q3 base row
T = 7           # filter row

p.terminal((2, Y), label="FROM Q2", side="below")
p.wire([(2, Y), (3, Y)])
p.capacitor((3, Y), (5, Y), "C1", ".01", side="above")
p.wire([(5, Y), (6, Y)])
p.junction((6, Y))
p.resistor((6, Y), (6, Y + 3), "R1", "10K", side="left")
p.ground((6, Y + 3))

q = p.npn((7, Y), ref="Q3", val="2N2222A")
p.wire([q["E"], (q["E"][0], Y + 3)])
p.ground((q["E"][0], Y + 3))
p.wire([q["C"], (q["C"][0], T)])
p.junction((q["C"][0], T))
p.inductor((q["C"][0], T), (q["C"][0], T - 2.5), "RFC1", "100 µH", side="left")
p.terminal((q["C"][0], T - 3), label="+12V (KEYED)", side="above")

p.wire([(q["C"][0], T), (9, T)])
p.capacitor((9, T), (11, T), "C2", ".01", side="above")
p.wire([(11, T), (12, T)])

for x, ref, val in ((12, "C3", "470p"), (17, "C4", "820p"), (22, "C5", "470p")):
    p.junction((x, T))
    p.capacitor((x, T), (x, T + 3), ref, val, side="right")
    p.ground((x, T + 3))
p.inductor((12, T), (17, T), "L1", "1.1 µH")
p.inductor((17, T), (22, T), "L2", "1.1 µH")
p.wire([(22, T), (24, T)])
p.antenna((24, T))
p.text((24, T - 2.4), "ANT 50Ω", 11, anchor="middle")

p.save("pa-lpf.svg", crop=True, paper=False)
