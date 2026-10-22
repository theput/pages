#!/usr/bin/env python3
"""Transmit: PA, choke and low-pass, with the coupling cap now across the LPF output.
Figure for lab/rockmite-40m/tr-switching.md. Run by assets/mims/render-figures.py.
"""
from mims import Page

p = Page(26, 12, seed=20, jitter=1.0)

T = 5
q = p.npn((4, T + 2), ref="PA")
cx = q["C"][0]
p.wire([q["C"], (cx, T)])
p.junction((cx, T))
p.inductor((cx, T), (cx, T - 2.5), "RFC", None, side="right")
p.wire([(cx, T), (7, T)])
p.junction((7, T))
p.capacitor((7, T), (7, T + 3))
p.ground((7, T + 3))
p.inductor((7, T), (11, T))
p.junction((11, T))
p.capacitor((11, T), (11, T + 3))
p.ground((11, T + 3))
p.text((10, T + 1.9), "(", 16, anchor="middle")
p.text((13, T + 1.9), "+", 13, anchor="middle")
p.wire([(11, T), (18, T)])
p.junction((15, T))
p.capacitor((15, T), (15, T + 3))
p.ground((15, T + 3))
p.text((16.6, T + 1.9), ")", 16, anchor="middle")
p.arrow((18, T), 0, label="ANTENNA")
p.text((10.4, T + 4.9), "TYP 100'S pF", 11, anchor="middle")
p.text((17.4, T + 4.9), "TYP 10'S pF", 11, anchor="middle")

p.save("tr-tx-lpf.svg", crop=True, paper=False)
