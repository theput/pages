#!/usr/bin/env python3
"""Mims-style page for the coupon-10-frontend test board: both circuits with values and socket positions."""
import os
from mims import Page

p = Page(37, 33, seed=11, jitter=1.2)
p.heading((1, 1.3), "COUPON-10: ROCKMITE RX FRONT END TEST BOARD", size=15)
p.text((1, 2.4), "TWO CIRCUITS, ONE 100 × 70 BLANK. PARTS IN [ ] PLUG INTO SOCKET PIN PAIRS.", 10)

def chain(y, tag, title, jin, jout, series, tpa, mid_part, alt_part, node_b, tpb, shunt, rload, rs, rp, clamp):
    p.text((1, y - 4.9), title, 12)
    p._path([p.px((1, y - 4.6)), p.px((1 + p.text_width(title, 12) / p.u, y - 4.6))], width=1.4)
    # input
    p.terminal((2, y))
    p.text((2, y + 0.85), jin[0], 10, anchor="middle"); p.text((2, y + 1.6), jin[1], 10, anchor="middle")
    p.wire([(2, y), (4, y)])
    p.capacitor((4, y), (7, y), *series[:2], side="above")
    p.text((5.5, y + 1.05), series[2], 10, anchor="middle")
    p.wire([(7, y), (11, y)]); p.junction((8, y))
    # test point A
    p.wire([(8, y), (8, y - 1.5)]); p.terminal((8, y - 1.5), label=tpa, side="above")
    if clamp:
        p.wire([(8, y), (8, y + 1)]); p.diode((8, y + 1), (8, y + 4), None, None)
        p.junction((10, y)); p.wire([(10, y), (10, y + 1)]); p.diode((10, y + 4), (10, y + 1), None, None)
        p.text((9, y + 6.5), "D1 D2 1N4148", 10, anchor="middle")
        p.wire([(8, y + 4), (8, y + 5), (10, y + 5), (10, y + 4)]); p.junction((9, y + 5)); p.ground((9, y + 5))
    # inductive element + alternate above
    p.junction((11, y)); p.junction((14, y))
    mid_part(11, 14, y)
    p.wire([(11, y), (11, y - 3)]); p.wire([(14, y), (14, y - 3)])
    alt_part(11, 14, y - 3)
    p.wire([(14, y), (18, y)]); p.junction((15, y))
    # test point B
    p.wire([(15, y), (15, y - 1.5)]); p.terminal((15, y - 1.5), label=tpb, side="above")
    # shunt C and load
    p.wire([(15, y), (15, y + 1)]); p.capacitor((15, y + 1), (15, y + 4), None, None)
    p.text((14.2, y + 2.0), shunt[0], 10, anchor="end"); p.text((14.2, y + 2.7), shunt[1], 10, anchor="end"); p.text((14.2, y + 3.4), shunt[2], 10, anchor="end")
    p.junction((18, y)); p.wire([(18, y), (18, y + 1)]); p.resistor((18, y + 1), (18, y + 4), None, None)
    p.text((18.8, y + 2.0), rload[0], 10); p.text((18.8, y + 2.7), rload[1], 10); p.text((19.3, y + 6.5), rload[2], 10, anchor="middle")
    p.wire([(15, y + 4), (15, y + 5), (18, y + 5), (18, y + 4)]); p.junction((16.5, y + 5)); p.ground((16.5, y + 5))
    # probe divider
    p.resistor((18, y), (21, y), *rs, side="above")
    p.wire([(21, y), (24.5, y)]); p.junction((22, y))
    p.wire([(22, y), (22, y + 1)]); p.resistor((22, y + 1), (22, y + 4), None, None)
    p.text((22.8, y + 2.0), rp[0], 10); p.text((22.8, y + 2.7), rp[1], 10)
    p.wire([(22, y + 4), (22, y + 5)]); p.ground((22, y + 5))
    p.arrow((24.5, y), 0, label=jout)

def xtal(ref, val):
    return lambda a, b, y: p.crystal((a, y), (b, y), ref, val, side="below")
def coil(ref, val):
    return lambda a, b, y: p.inductor((a, y), (b, y), ref, val, side="below")
def xtal_above(ref, val):
    return lambda a, b, y: p.crystal((a, y), (b, y), ref, val, side="above")

# ---------------- A
chain(9, "A", "A: ROCKMITE RX INPUT, ANTENNA TO SA602 PIN 1",
      jin=("J1", "SMA IN"), jout="J2 OUT",
      series=("C1", "47p", "[J5 1-2]"), tpa="TP1 DIO",
      mid_part=xtal("Y1", "7.030 MHz"), alt_part=xtal_above("Y1B", "2ND XTAL (OPT)"),
      node_b="LOAD", tpb="TP2 LOAD",
      shunt=("C2", "47p", "[J5 3-4]"), rload=("RL", "1.5k", "[J6 1-2]"),
      rs=("R1", "10k"), rp=("R2", "51"), clamp=True)

# ---------------- B
chain(22, "B", "B: THE L-MATCH ALONE, KNOWN COIL IN PLACE OF THE XTAL",
      jin=("J3", "SMA IN"), jout="J4 OUT",
      series=("C3", "110p*", "[J7 1-2]"), tpa="TP4 MID",
      mid_part=coil("L1", "10 µH 78F"), alt_part=xtal_above("Y2", "XTAL INSTEAD OF L1"),
      node_b="LOADB", tpb="TP5 LOADB",
      shunt=("C4", "82p", "[J7 3-4]"), rload=("RL", "1.5k", "[J8 1-2]"),
      rs=("R3", "10k"), rp=("R4", "51"), clamp=False)

# ---------------- annotation column
p.note((29.5, 4.5), [
    "SOLDERED:",
    "J1-J4 SMA",
    "J5-J8 SIP-4 SKT",
    "D1 D2 1N4148",
    "Y1 7.030 MHz",
    "L1 78F CHOKE",
    "R1 R3 10k",
    "R2 R4 51",
    "TP1-TP6 PINS",
    "H1-H4 M3, GND",
    "",
    "PLUG-INS:",
    "C1 C2 C3 C4",
    "RL ×2 (1.5k)",
    "SKT PIN 1 =",
    "SQUARE PAD",
    "",
    "PROBE: 10k/51",
    "FLAT LINE -47 dB",
    "ON THE VNA (S21",
    "REF = V/2). MATCH",
    "PEAK ~ -39 dB.",
    "",
    "TP3 TP6 = GND",
], size=10, lead=0.8)

# ---------------- footer
p.text((1, 29.7), "RUN B FIRST: RESISTORS ONLY = -47 dB FLAT. THEN L+C: HUMP NEAR 7 MHz, ~-39 dB.", 10)
p.text((1, 30.5), "THEN XTAL / A: 7.02-7.06 MHz, 401 PTS. PEAK ~500 Hz WIDE JUST ABOVE F_S. C2 MOVES IT 9 Hz/pF.", 10)
p.text((1, 31.4), "* MEASURED 10-27: C3 122p→6.89, 100p→7.12, 82p→7.39 MHz. 110p (100+10) PUTS IT ON 7.03.", 9)
p.text((1, 32.3), "L&J 10-27-26", 10)
p.page_number(1)
out = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../coupon-10-frontend.svg"))
p.save(out); print("wrote", out)
