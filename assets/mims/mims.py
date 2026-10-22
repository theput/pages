#!/usr/bin/env python3
"""
mims.py - draw Forrest-Mims-style notebook schematics as SVG.

Hand-lettered block capitals (a built-in stroke font, no font files needed),
quad-ruled paper, hand-drawn schematic symbols with a little waver.
Everything is placed on a grid: 1 unit = one square of the paper = 20 px.

Usage (see bottom of file for a demo):

    from mims import Page
    p = Page(30, 20, seed=7)              # 30 x 20 squares
    p.heading((1, 1.2), "RC LOW PASS")
    a = p.terminal((2, 4), label="V_{IN}", side="left")
    p.resistor((2, 4), (6, 4), "R1", "10K")
    p.junction((6, 4))
    p.capacitor((6, 4), (6, 7), "C1", ".01 µF")
    p.ground((6, 7))
    p.wire([(6, 4), (9, 4)])
    p.arrow((9, 4), 0, label="V_{OUT}")
    p.save("rc.svg")              # full page
    p.save("rc-fig.svg", crop=True)   # just the figure, grid behind it

All coordinates are in grid units. Text sizes are in px (cap height).
"""
import math
import random

UNIT = 20            # px per grid square
INK = "#1c1c1c"
PAPER = "#fbfaf4"
GRID = "#b4d2e6"

# ---------------------------------------------------------------- stroke font
# Each glyph: list of strokes; each stroke a list of (x, y) in a 4-wide,
# 6-tall box, y up, baseline at 0.  Widths default to 4.
_O = [[(1, 0), (0, 1), (0, 5), (1, 6), (3, 6), (4, 5), (4, 1), (3, 0), (1, 0)]]
_P = [[(0, 0), (0, 6), (3, 6), (4, 5), (4, 3.6), (3, 2.8), (0, 2.8)]]
GLYPHS = {
    "A": [[(0, 0), (2, 6), (4, 0)], [(0.7, 2.1), (3.3, 2.1)]],
    "B": [[(0, 0), (0, 6), (3, 6), (4, 5), (4, 3.6), (3, 3.1), (0, 3.1)],
          [(3, 3.1), (4, 2.5), (4, 1), (3, 0), (0, 0)]],
    "C": [[(4, 5), (3, 6), (1, 6), (0, 5), (0, 1), (1, 0), (3, 0), (4, 1)]],
    "D": [[(0, 0), (0, 6), (2.5, 6), (4, 4.5), (4, 1.5), (2.5, 0), (0, 0)]],
    "E": [[(4, 6), (0, 6), (0, 0), (4, 0)], [(0, 3.1), (2.6, 3.1)]],
    "F": [[(4, 6), (0, 6), (0, 0)], [(0, 3.1), (2.6, 3.1)]],
    "G": [[(4, 5), (3, 6), (1, 6), (0, 5), (0, 1), (1, 0), (3, 0), (4, 1), (4, 2.8), (2.4, 2.8)]],
    "H": [[(0, 0), (0, 6)], [(4, 0), (4, 6)], [(0, 3), (4, 3)]],
    "I": [[(0.5, 6), (3.5, 6)], [(2, 6), (2, 0)], [(0.5, 0), (3.5, 0)]],
    "J": [[(4, 6), (4, 1), (3, 0), (1, 0), (0, 1)]],
    "K": [[(0, 0), (0, 6)], [(4, 6), (0, 2.2)], [(1.5, 3.4), (4, 0)]],
    "L": [[(0, 6), (0, 0), (4, 0)]],
    "M": [[(0, 0), (0, 6), (2, 2.6), (4, 6), (4, 0)]],
    "N": [[(0, 0), (0, 6), (4, 0), (4, 6)]],
    "O": _O,
    "P": _P,
    "Q": _O + [[(2.4, 1.6), (4.4, -0.5)]],
    "R": _P + [[(2, 2.8), (4, 0)]],
    "S": [[(4, 5), (3, 6), (1, 6), (0, 5), (0, 4.1), (1, 3.2), (3, 3.2), (4, 2.2),
           (4, 1), (3, 0), (1, 0), (0, 1)]],
    "T": [[(0, 6), (4, 6)], [(2, 6), (2, 0)]],
    "U": [[(0, 6), (0, 1), (1, 0), (3, 0), (4, 1), (4, 6)]],
    "V": [[(0, 6), (2, 0), (4, 6)]],
    "W": [[(0, 6), (1, 0), (2, 3.6), (3, 0), (4, 6)]],
    "X": [[(0, 0), (4, 6)], [(0, 6), (4, 0)]],
    "Y": [[(0, 6), (2, 3.2), (4, 6)], [(2, 3.2), (2, 0)]],
    "Z": [[(0, 6), (4, 6), (0, 0), (4, 0)]],
    "0": _O,
    "1": [[(0.8, 4.8), (2, 6), (2, 0)], [(0.8, 0), (3.2, 0)]],
    "2": [[(0, 5), (1, 6), (3, 6), (4, 5), (4, 3.9), (0, 0), (4, 0)]],
    "3": [[(0, 6), (4, 6), (2, 3.5), (3, 3.5), (4, 2.5), (4, 1), (3, 0), (1, 0), (0, 1)]],
    "4": [[(3, 0), (3, 6), (0, 2), (4, 2)]],
    "5": [[(4, 6), (0, 6), (0, 3.4), (3, 3.6), (4, 2.6), (4, 1), (3, 0), (1, 0), (0, 1)]],
    "6": [[(3.5, 6), (1.6, 6), (0, 4), (0, 1), (1, 0), (3, 0), (4, 1), (4, 2.5), (3, 3.5), (1, 3.5), (0, 2.5)]],
    "7": [[(0, 6), (4, 6), (1.5, 0)]],
    "8": [[(1, 3.2), (0, 4.2), (0, 5), (1, 6), (3, 6), (4, 5), (4, 4.2), (3, 3.2), (1, 3.2),
           (0, 2.2), (0, 1), (1, 0), (3, 0), (4, 1), (4, 2.2), (3, 3.2)]],
    "9": [[(4, 3.5), (3, 2.5), (1, 2.5), (0, 3.5), (0, 5), (1, 6), (3, 6), (4, 5), (4, 2), (2.4, 0), (0.5, 0)]],
    "+": [[(2, 1), (2, 5)], [(0, 3), (4, 3)]],
    "-": [[(0.4, 3), (3.6, 3)]],
    "=": [[(0.4, 2), (3.6, 2)], [(0.4, 4), (3.6, 4)]],
    "×": [[(0.6, 1.2), (3.4, 4.8)], [(0.6, 4.8), (3.4, 1.2)]],
    "/": [[(0.5, 0), (3.5, 6)]],
    "\\": [[(0.5, 6), (3.5, 0)]],
    "<": [[(3.5, 5), (0.5, 3), (3.5, 1)]],
    ">": [[(0.5, 5), (3.5, 3), (0.5, 1)]],
    ".": [[(0.8, 0), (1.2, 0), (1.2, 0.5), (0.8, 0.5), (0.8, 0)]],
    ",": [[(1.2, 0.5), (0.7, -0.8)]],
    ":": [[(0.8, 1), (1.2, 1), (1.2, 1.5), (0.8, 1.5), (0.8, 1)],
          [(0.8, 4), (1.2, 4), (1.2, 4.5), (0.8, 4.5), (0.8, 4)]],
    "(": [[(2.6, 6.6), (1.2, 5), (0.8, 3), (1.2, 1), (2.6, -0.6)]],
    ")": [[(0.4, 6.6), (1.8, 5), (2.2, 3), (1.8, 1), (0.4, -0.6)]],
    "'": [[(1.3, 6), (1, 4.6)]],
    "!": [[(2, 6), (2, 1.6)], [(1.8, 0), (2.2, 0), (2.2, 0.5), (1.8, 0.5), (1.8, 0)]],
    "?": [[(0, 5), (1, 6), (3, 6), (4, 5), (4, 4), (2, 2.6), (2, 1.6)],
          [(1.8, 0), (2.2, 0), (2.2, 0.5), (1.8, 0.5), (1.8, 0)]],
    "~": [[(0, 2.6), (1, 3.6), (2, 3.6), (3, 2.6), (4, 3.6)]],
    "°": [[(1.5, 6), (1, 5.5), (1, 4.8), (1.5, 4.3), (2.5, 4.3), (3, 4.8), (3, 5.5), (2.5, 6), (1.5, 6)]],
    "Ω": [[(0, 0), (1.2, 0), (0.6, 0.8), (0, 2), (0, 5), (1, 6), (3, 6), (4, 5), (4, 2), (3.4, 0.8), (2.8, 0), (4, 0)]],
    "µ": [[(0, -2), (0, 4)], [(0, 1), (1, 0), (3, 0), (4, 1), (4, 4)]],
    "π": [[(0, 4), (4, 4)], [(1, 4), (1, 0)], [(3, 4), (3, 0)]],
    "%": [[(0.5, 0), (3.5, 6)], [(0.5, 6), (1, 6), (1, 5), (0.5, 5), (0.5, 6)], [(3, 1), (3.5, 1), (3.5, 0), (3, 0), (3, 1)]],
    "&": [[(4, 0), (1, 3.5), (1, 5.2), (1.8, 6), (2.6, 5.2), (2.6, 4.4), (0, 1.6), (0, 0.8), (0.8, 0), (2.2, 0), (4, 2.2)]],
    "#": [[(1.2, 0), (1.8, 6)], [(2.6, 0), (3.2, 6)], [(0.2, 2), (4.2, 2)], [(0.4, 4), (4.4, 4)]],
    "[": [[(2.6, 6.4), (1, 6.4), (1, -0.4), (2.6, -0.4)]],
    "]": [[(0.4, 6.4), (2, 6.4), (2, -0.4), (0.4, -0.4)]],
    "*": [[(2, 1.5), (2, 4.5)], [(0.7, 2.2), (3.3, 3.8)], [(0.7, 3.8), (3.3, 2.2)]],
    "√": [[(0, 2.5), (1, 0), (2, 6), (4, 6)]],
}
# lowercase set for units (m, k, p, n, h, z) - everything else is lettered in caps
GLYPHS.update({
    "m": [[(0, 0), (0, 4)], [(0, 3), (1, 4), (1.7, 4), (2, 3), (2, 0)], [(2, 3), (2.8, 4), (3.4, 4), (4, 3), (4, 0)]],
    "k": [[(0, 0), (0, 6)], [(3.2, 4), (0, 1.5)], [(1.2, 2.4), (3.4, 0)]],
    "p": [[(0, -2), (0, 4)], [(0, 3), (1, 4), (2.6, 4), (3.6, 3), (3.6, 1), (2.6, 0), (1, 0), (0, 1)]],
    "n": [[(0, 0), (0, 4)], [(0, 3), (1, 4), (2.6, 4), (3.6, 3), (3.6, 0)]],
    "h": [[(0, 0), (0, 6)], [(0, 3), (1, 4), (2.6, 4), (3.6, 3), (3.6, 0)]],
    "z": [[(0, 4), (3.6, 4), (0, 0), (3.6, 0)]],
})
GLYPHS["μ"] = GLYPHS["µ"]
GLYPHS["Ω"] = GLYPHS["Ω"]
WIDTHS = {".": 2, ",": 2, ":": 2, "(": 3, ")": 3, "'": 2, " ": 3, "!": 4, "[": 3, "]": 3, "°": 4}


def _text_runs(s):
    """Split 'V_{IN}' / 'R_1' / 'V^2' into (text, mode) runs; mode is 0, 'sub' or 'sup'."""
    runs, i, buf = [], 0, ""
    while i < len(s):
        c = s[i]
        if c in "_^" and i + 1 < len(s):
            if buf:
                runs.append((buf, 0))
                buf = ""
            mode = "sub" if c == "_" else "sup"
            if s[i + 1] == "{":
                j = s.find("}", i + 2)
                j = len(s) if j < 0 else j
                runs.append((s[i + 2:j], mode))
                i = j + 1
            else:
                runs.append((s[i + 1], mode))
                i += 2
            continue
        buf += c
        i += 1
    if buf:
        runs.append((buf, 0))
    return runs


def _glyph(ch):
    return GLYPHS.get(ch) or GLYPHS.get(ch.upper())


class Page:
    def __init__(self, w=30, h=40, seed=1, jitter=1.3, unit=UNIT):
        self.w, self.h, self.u = w, h, unit
        self.rnd = random.Random(seed)
        self.jit = jitter
        self.els = []
        self.bbox = [1e9, 1e9, -1e9, -1e9]

    # ------------------------------------------------------------ helpers
    def px(self, p):
        x, y = p
        return (x * self.u, y * self.u)

    def _track(self, pts):
        for x, y in pts:
            b = self.bbox
            b[0], b[1] = min(b[0], x), min(b[1], y)
            b[2], b[3] = max(b[2], x), max(b[3], y)

    def _wob(self, pts, amp=0.55, step=7.0, close=False):
        """Hand-drawn polyline: subdivide segments and add low-frequency waver."""
        out = []
        pts = list(pts) + ([pts[0]] if close else [])
        r = self.rnd
        j = self.jit
        for i in range(len(pts) - 1):
            (x1, y1), (x2, y2) = pts[i], pts[i + 1]
            dx, dy = x2 - x1, y2 - y1
            L = math.hypot(dx, dy) or 1e-6
            nx, ny = -dy / L, dx / L
            n = max(1, int(L / step))
            ph, fr = r.uniform(0, 6.28), r.uniform(0.5, 1.3)
            ph2, fr2 = r.uniform(0, 6.28), r.uniform(1.6, 3.2)
            bow = r.uniform(-1, 1) * amp * j * min(1.0, L / 80.0)   # long lines bow a little
            for k in range(n + (1 if i == len(pts) - 2 else 0)):
                t = k / n
                if k == 0 or k == n:
                    off = r.uniform(-0.45, 0.45) * j * min(1.0, L / 15.0)
                else:
                    off = amp * j * (0.55 * math.sin(2 * math.pi * fr * t + ph)
                                     + 0.25 * math.sin(2 * math.pi * fr2 * t + ph2)
                                     + 0.3 * r.uniform(-1, 1)) + bow * math.sin(math.pi * t)
                out.append((x1 + dx * t + nx * off, y1 + dy * t + ny * off))
        return out

    def _path(self, pts, width=2.0, fill="none", close=False, amp=0.55, color=INK):
        pts = [tuple(p) for p in pts]
        self._track(pts)
        w = self._wob(pts, amp=amp, close=close)
        width = width * self.rnd.uniform(0.88, 1.12)
        d = "M" + " L".join(f"{x:.1f},{y:.1f}" for x, y in w) + (" Z" if close else "")
        self.els.append(f'<path d="{d}" fill="{fill}" stroke="{color}" stroke-width="{width:.2f}" '
                        f'stroke-linecap="round" stroke-linejoin="round"/>')

    def _circle_pts(self, c, r, n=28, start=0.0, sweep=2 * math.pi):
        cx, cy = c
        return [(cx + r * math.cos(start + sweep * k / n), cy + r * math.sin(start + sweep * k / n))
                for k in range(n + 1)]

    # --------------------------------------------------------------- text
    def text_width(self, s, size=11):
        k = size / 6.0
        w = 0.0
        for run, mode in _text_runs(s):
            kk = k * (0.7 if mode else 1)
            for ch in run:
                w += (WIDTHS.get(ch.upper(), 4) + 1.4) * kk
        return w

    def text(self, p, s, size=11, anchor="start", width=None):
        """Hand-lettered block caps. p = (x, y) in grid units, y is the baseline."""
        x0, y0 = self.px(p)
        tw = self.text_width(s, size)
        if anchor == "middle":
            x0 -= tw / 2
        elif anchor == "end":
            x0 -= tw
        k = size / 6.0
        sw = width or max(1.4, size / 6.5)
        x = x0
        r = self.rnd
        slope = r.uniform(-0.012, 0.012) * self.jit      # the whole line drifts up or down a little
        lean = r.uniform(-0.03, 0.05) * self.jit         # and leans a little, consistently
        for run, mode in _text_runs(s):
            kk = k * (0.7 if mode else 1)
            base = y0 + (size * 0.28 if mode == "sub" else -size * 0.45 if mode == "sup" else 0)
            for ch in run:
                g = _glyph(ch)
                adv = (WIDTHS.get(ch.upper(), 4) + 1.4) * kk
                if g:
                    # each letter gets its own size, slant and baseline - that is the hand
                    ks = kk * r.uniform(0.92, 1.08)
                    dx, dy = r.uniform(-0.4, 0.4) * self.jit, r.uniform(-0.7, 0.7) * self.jit
                    tilt = lean + r.uniform(-0.05, 0.05) * self.jit
                    by = base + dy + (x - x0) * slope
                    for stroke in g:
                        pts = [(x + dx + gx * ks + (gy * ks) * tilt, by - gy * ks) for gx, gy in stroke]
                        self._path(pts, width=sw, amp=0.5)
                x += adv * r.uniform(0.97, 1.03)
        return tw / self.u

    def heading(self, p, s, size=16):
        """Underlined title, like Mims' section heads."""
        tw = self.text(p, s, size=size)
        x, y = p
        self._path([self.px((x - 0.05, y + size / self.u * 0.3)),
                    self.px((x + tw + 0.1, y + size / self.u * 0.3))], width=1.6)
        return tw

    def fraction(self, p, num, den, size=11):
        """num over den, centred at p (p is the fraction bar)."""
        x, y = self.px(p)
        wn, wd = self.text_width(num, size), self.text_width(den, size)
        w = max(wn, wd) + 6
        self.text((p[0], p[1] - (size * 0.35) / self.u), num, size, anchor="middle")
        self.text((p[0], p[1] + (size * 1.25) / self.u), den, size, anchor="middle")
        self._path([(x - w / 2, y), (x + w / 2, y)], width=1.6)
        return w / self.u

    def note(self, p, lines, size=11, lead=0.8):
        """A column of annotation lines (list of strings), top-left at p."""
        x, y = p
        for i, ln in enumerate(lines):
            self.text((x, y + i * lead), ln, size)

    # -------------------------------------------------------------- wires
    def wire(self, pts, width=2.0):
        """Polyline; each leg is its own pen stroke and corners overshoot a hair."""
        P = [self.px(p) for p in pts]
        r = self.rnd
        for i in range(len(P) - 1):
            (x1, y1), (x2, y2) = P[i], P[i + 1]
            L = math.hypot(x2 - x1, y2 - y1) or 1e-6
            ux, uy = (x2 - x1) / L, (y2 - y1) / L
            o0 = r.uniform(0, 2.2) * self.jit if i > 0 else 0
            o1 = r.uniform(0, 2.2) * self.jit if i < len(P) - 2 else 0
            self._path([(x1 - ux * o0, y1 - uy * o0), (x2 + ux * o1, y2 + uy * o1)], width=width)

    def junction(self, p, r=2.8):
        c = self.px(p)
        self._track([c])
        self.els.append(f'<circle cx="{c[0]:.1f}" cy="{c[1]:.1f}" r="{r}" fill="{INK}"/>')

    def terminal(self, p, label=None, side="left", size=11, r=3.5):
        """Open-circle input terminal. Label goes on `side`."""
        c = self.px(p)
        self._path(self._circle_pts(c, r, n=18), width=1.8, fill=PAPER, close=True, amp=0.08)
        if label:
            x, y = p
            if side == "left":
                self.text((x - 0.5, y + 0.25), label, size, anchor="end")
            elif side == "right":
                self.text((x + 0.5, y + 0.25), label, size)
            elif side == "above":
                self.text((x, y - 0.45), label, size, anchor="middle")
            else:
                self.text((x, y + 0.85), label, size, anchor="middle")

    def arrow(self, p, angle=0, label=None, size=11, length=0.0):
        """Filled arrowhead at p pointing along `angle` (deg, 0 = right, 90 = down).
        `length` adds a lead-in wire before the head."""
        a = math.radians(angle)
        ux, uy = math.cos(a), math.sin(a)
        tip = self.px(p)
        if length:
            tail = (tip[0] - ux * length * self.u, tip[1] - uy * length * self.u)
            self._path([tail, tip], width=2.0)
        h, b = 9.0, 3.6
        base = (tip[0] - ux * h, tip[1] - uy * h)
        pts = [tip, (base[0] - uy * b, base[1] + ux * b), (base[0] + uy * b, base[1] - ux * b)]
        self._path(pts, width=1.2, fill=INK, close=True, amp=0.15)
        if label:
            x, y = p
            if angle == 0:
                self.text((x + 0.4, y + 0.25), label, size)
            elif angle == 180:
                self.text((x - 0.4, y + 0.25), label, size, anchor="end")
            elif angle == 90:
                self.text((x, y + 0.9), label, size, anchor="middle")
            else:
                self.text((x, y - 0.5), label, size, anchor="middle")

    def ground(self, p, down=True):
        """Ground symbol hanging below p (or above if down=False)."""
        x, y = self.px(p)
        s = 1 if down else -1
        self._path([(x, y), (x, y + s * 8)], width=2.0)
        for i, hw in enumerate((9, 6, 2.5)):
            yy = y + s * (8 + i * 4.5)
            self._path([(x - hw, yy), (x + hw, yy)], width=2.0)

    def antenna(self, p, h=1.5, w=1.0):
        """Antenna symbol rising from p."""
        x, y = self.px(p)
        top = (x, y - h * self.u)
        self._path([(x, y), top], width=2.0)
        self._path([(x - w * self.u / 2, top[1] - 0.45 * self.u), top, (x + w * self.u / 2, top[1] - 0.45 * self.u)], width=2.0)
        self._path([(x - w * self.u / 2, top[1] - 0.45 * self.u), (x + w * self.u / 2, top[1] - 0.45 * self.u)], width=2.0)

    def box(self, p, w, h, label=None, size=11, lines=None):
        """Plain rectangle (IC, module, black box). p = top-left in grid units."""
        x, y = self.px(p)
        W, H = w * self.u, h * self.u
        self._path([(x, y), (x + W, y), (x + W, y + H), (x, y + H)], width=2.0, close=True)
        if label:
            self.text((p[0] + w / 2, p[1] + h / 2 + 0.25), label, size, anchor="middle")
        if lines:
            for i, ln in enumerate(lines):
                self.text((p[0] + w / 2, p[1] + 0.9 + i * 0.75), ln, size, anchor="middle")

    # -------------------------------------------------- two-terminal parts
    def _two_term(self, a, b, body, blen, lead_w=2.0):
        """Draw leads from a to b with a body of length blen (px) in the middle.
        body(t_to_xy) receives a function mapping local (t, s) -> page px."""
        ax, ay = self.px(a)
        bx, by = self.px(b)
        L = math.hypot(bx - ax, by - ay)
        ux, uy = (bx - ax) / L, (by - ay) / L
        nx, ny = -uy, ux

        def M(t, s):
            return (ax + ux * t + nx * s, ay + uy * t + ny * s)
        t0, t1 = L / 2 - blen / 2, L / 2 + blen / 2
        self._path([(ax, ay), M(t0, 0)], width=lead_w)
        self._path([M(t1, 0), (bx, by)], width=lead_w)
        body(M, t0, t1)
        return M, t0, t1, L

    def _label2(self, a, b, ref, val, size, side):
        """Place ref/value beside a two-terminal part."""
        ax, ay = a
        bx, by = b
        mx, my = (ax + bx) / 2, (ay + by) / 2
        horiz = abs(bx - ax) >= abs(by - ay)
        s = 1 if side == "below" or side == "right" else -1
        if horiz:
            if s < 0:   # above
                if ref:
                    self.text((mx, my - 0.75), ref + (" " + val if val else ""), size, anchor="middle")
            else:
                if ref:
                    self.text((mx, my + 1.05), ref + (" " + val if val else ""), size, anchor="middle")
        else:
            if s > 0:   # right
                if ref:
                    self.text((mx + 0.8, my + (0.25 if not val else -0.1)), ref, size)
                if val:
                    self.text((mx + 0.8, my + 0.75), val, size)
            else:
                if ref:
                    self.text((mx - 0.8, my + (0.25 if not val else -0.1)), ref, size, anchor="end")
                if val:
                    self.text((mx - 0.8, my + 0.75), val, size, anchor="end")

    def resistor(self, a, b, ref=None, val=None, side="above", size=11):
        def body(M, t0, t1):
            n, amp = 6, 0.3 * self.u
            pts = [M(t0, 0)]
            for k in range(n):
                pts.append(M(t0 + (t1 - t0) * (2 * k + 1) / (2 * n), amp if k % 2 == 0 else -amp))
            pts.append(M(t1, 0))
            self._path(pts, width=2.0, amp=0.35)
        self._two_term(a, b, body, 2.0 * self.u)
        self._label2(a, b, ref, val, size, side)

    def pot(self, a, b, wiper_dir=90, ref=None, val=None, side="above", size=11):
        """Potentiometer: resistor plus a wiper arrow from the side. Returns wiper point (grid)."""
        self.resistor(a, b, ref, val, side, size)
        ax, ay = self.px(a)
        bx, by = self.px(b)
        mx, my = (ax + bx) / 2, (ay + by) / 2
        r = math.radians(wiper_dir)
        tip = (mx + math.cos(r) * 0.32 * self.u, my + math.sin(r) * 0.32 * self.u)
        tail = (mx + math.cos(r) * 1.0 * self.u, my + math.sin(r) * 1.0 * self.u)
        self._path([tail, tip], width=2.0)
        self.arrow((tip[0] / self.u, tip[1] / self.u), (wiper_dir + 180) % 360)
        return (tail[0] / self.u, tail[1] / self.u)

    def capacitor(self, a, b, ref=None, val=None, side="right", polar=False, plus="a", size=11):
        """plus='a' puts the + (straight plate) at end a; the curved plate is the other end."""
        def body(M, t0, t1):
            h = 0.42 * self.u
            # straight plate at t0, curved (or straight) at t1
            if polar and plus == "b":
                self._curved_plate(M, t0, h, -1)
                self._path([M(t1, -h), M(t1, h)], width=2.2, amp=0.2)
            elif polar:
                self._path([M(t0, -h), M(t0, h)], width=2.2, amp=0.2)
                self._curved_plate(M, t1, h, +1)
            else:
                self._path([M(t0, -h), M(t0, h)], width=2.2, amp=0.2)
                self._path([M(t1, -h), M(t1, h)], width=2.2, amp=0.2)
            if polar:
                # a little + sign beside the straight plate
                tp = t0 - 6 if plus == "a" else t1 + 6
                sgn = -1 if plus == "a" else 1
                self._path([M(tp + sgn * 1, -h - 2), M(tp + sgn * 1, -h - 8)], width=1.4, amp=0.1)
                self._path([M(tp + sgn * 1 - 3, -h - 5), M(tp + sgn * 1 + 3, -h - 5)], width=1.4, amp=0.1)
        self._two_term(a, b, body, 0.28 * self.u)
        self._label2(a, b, ref, val, size, side)

    def _curved_plate(self, M, t, h, dirn):
        pts = []
        for k in range(11):
            s = -h + 2 * h * k / 10
            bulge = dirn * 4.0 * (1 - (s / h) ** 2)
            pts.append(M(t + bulge, s))
        self._path(pts, width=2.2, amp=0.2)

    def inductor(self, a, b, ref=None, val=None, side="above", loops=4, size=11):
        def body(M, t0, t1):
            seg = (t1 - t0) / loops
            pts = []
            for i in range(loops):
                cx = t0 + seg * (i + 0.5)
                for k in range(9):
                    ang = math.pi - math.pi * k / 8
                    pts.append(M(cx + (seg / 2) * math.cos(ang), -(seg / 2) * math.sin(ang) * 1.1))
            self._path(pts, width=2.0, amp=0.35)
        self._two_term(a, b, body, 2.0 * self.u)
        self._label2(a, b, ref, val, size, side)

    def diode(self, a, b, ref=None, val=None, side="above", kind="", size=11):
        """Anode at a, cathode at b. kind='zener' adds the bent bar, 'led' adds arrows."""
        def body(M, t0, t1):
            h = 0.38 * self.u
            self._path([M(t0, -h), M(t1, 0), M(t0, h)], width=2.0, fill=INK, close=True, amp=0.15)
            if kind == "zener":
                self._path([M(t1 + 4, -h - 3), M(t1, -h), M(t1, h), M(t1 - 4, h + 3)], width=2.2, amp=0.15)
            else:
                self._path([M(t1, -h), M(t1, h)], width=2.2, amp=0.15)
            if kind == "led":
                for off in (-4, 3):
                    p0, p1 = M(t0 + 6 + off, -h - 3), M(t0 + 12 + off, -h - 11)
                    self._path([p0, p1], width=1.4)
                    self.arrow((p1[0] / self.u, p1[1] / self.u), -55)
        self._two_term(a, b, body, 0.8 * self.u)
        self._label2(a, b, ref, val, size, side)

    def crystal(self, a, b, ref=None, val=None, side="above", size=11):
        def body(M, t0, t1):
            h = 0.4 * self.u
            g = 0.22 * self.u
            self._path([M(t0, -h), M(t0, h)], width=2.2, amp=0.2)
            self._path([M(t1, -h), M(t1, h)], width=2.2, amp=0.2)
            self._path([M(t0 + g, -h * 0.8), M(t1 - g, -h * 0.8), M(t1 - g, h * 0.8), M(t0 + g, h * 0.8)],
                       width=2.0, close=True, amp=0.2)
        self._two_term(a, b, body, 0.9 * self.u)
        self._label2(a, b, ref, val, size, side)

    def battery(self, a, b, ref=None, val=None, side="left", cells=2, size=11):
        """Long plate (+) at end a."""
        def body(M, t0, t1):
            n = cells * 2
            step = (t1 - t0) / (n - 1)
            for i in range(n):
                h = (0.5 if i % 2 == 0 else 0.25) * self.u
                self._path([M(t0 + i * step, -h), M(t0 + i * step, h)], width=2.2 if i % 2 == 0 else 2.8, amp=0.15)
            self._path([M(t0 - 7, -0.5 * self.u - 2), M(t0 - 7, -0.5 * self.u - 8)], width=1.4, amp=0.1)
            self._path([M(t0 - 10, -0.5 * self.u - 5), M(t0 - 4, -0.5 * self.u - 5)], width=1.4, amp=0.1)
        self._two_term(a, b, body, (cells * 2 - 1) * 0.3 * self.u)
        self._label2(a, b, ref, val, size, side)

    def switch(self, a, b, ref=None, val=None, side="above", size=11):
        """SPST, drawn open."""
        def body(M, t0, t1):
            self.junction((M(t0, 0)[0] / self.u, M(t0, 0)[1] / self.u), r=2.4)
            self.junction((M(t1, 0)[0] / self.u, M(t1, 0)[1] / self.u), r=2.4)
            self._path([M(t0, 0), M(t1 - 2, -0.5 * self.u)], width=2.0)
        self._two_term(a, b, body, 1.2 * self.u)
        self._label2(a, b, ref, val, size, side)

    def key(self, a, b, size=11):
        """Telegraph key: a switch with the word KEY."""
        self.switch(a, b, "KEY", None, "above", size)

    # ------------------------------------------------------------ transistor
    def npn(self, c, facing="right", ref=None, val=None, size=11, pnp=False):
        """Bipolar transistor centred at c. Returns dict of pin points (grid units) B, C, E."""
        cx, cy = self.px(c)
        f = 1 if facing == "right" else -1
        r = 0.72 * self.u
        self._path(self._circle_pts((cx, cy), r, n=30), width=2.0, close=True, amp=0.6)
        bx = cx - f * 0.22 * self.u
        self._path([(bx, cy - 0.42 * self.u), (bx, cy + 0.42 * self.u)], width=2.6, amp=0.2)
        B = (cx - f * 1.0 * self.u, cy)
        self._path([B, (bx, cy)], width=2.0)
        ex = cx + f * 0.35 * self.u
        C = (ex, cy - 1.2 * self.u)
        E = (ex, cy + 1.2 * self.u)
        self._path([(bx, cy - 0.2 * self.u), (ex, cy - 0.62 * self.u), C], width=2.0)
        self._path([(bx, cy + 0.2 * self.u), (ex, cy + 0.62 * self.u), E], width=2.0)
        # emitter arrow
        if pnp:
            tip = (bx + f * 0.08 * self.u, cy + 0.27 * self.u)
            ang = math.degrees(math.atan2((bx - ex), (cy + 0.2 * self.u) - (cy + 0.62 * self.u)))
            self.arrow((tip[0] / self.u, tip[1] / self.u), math.degrees(math.atan2(0.2 - 0.62, (bx - ex) / self.u)))
        else:
            tip = (ex - f * 0.05 * self.u, cy + 0.58 * self.u)
            self.arrow((tip[0] / self.u, tip[1] / self.u), math.degrees(math.atan2(0.62 - 0.2, (ex - bx) / self.u)))
        if ref:
            self.text((c[0] + f * 1.0, c[1] + 0.25), ref, size, anchor="start" if f > 0 else "end")
        if val:
            self.text((c[0] + f * 1.0, c[1] + 1.0), val, size, anchor="start" if f > 0 else "end")
        g = self.u
        return {"B": (B[0] / g, B[1] / g), "C": (C[0] / g, C[1] / g), "E": (E[0] / g, E[1] / g)}

    def pnp(self, c, facing="right", ref=None, val=None, size=11):
        return self.npn(c, facing, ref, val, size, pnp=True)

    def fet(self, c, facing="right", ref=None, val=None, size=11):
        """N-channel MOSFET (IRF510 style), simplified. Returns G, D, S."""
        cx, cy = self.px(c)
        f = 1 if facing == "right" else -1
        r = 0.72 * self.u
        self._path(self._circle_pts((cx, cy), r, n=30), width=2.0, close=True, amp=0.6)
        gx = cx - f * 0.3 * self.u
        self._path([(gx, cy - 0.4 * self.u), (gx, cy + 0.4 * self.u)], width=2.0, amp=0.15)
        chx = cx - f * 0.1 * self.u
        for dy in (-0.35, 0, 0.35):
            self._path([(chx, cy + dy * self.u - 0.1 * self.u), (chx, cy + dy * self.u + 0.1 * self.u)], width=2.8, amp=0.1)
        G = (cx - f * 1.0 * self.u, cy)
        self._path([G, (gx, cy)], width=2.0)
        ex = cx + f * 0.35 * self.u
        D = (ex, cy - 1.2 * self.u)
        S = (ex, cy + 1.2 * self.u)
        self._path([(chx, cy - 0.35 * self.u), (ex, cy - 0.35 * self.u), D], width=2.0)
        self._path([(chx, cy + 0.35 * self.u), (ex, cy + 0.35 * self.u), S], width=2.0)
        self._path([(chx, cy), (ex, cy), (ex, cy + 0.35 * self.u)], width=2.0)
        self.arrow(((chx + f * 0.12 * self.u) / self.u, cy / self.u), 180 if f > 0 else 0)
        if ref:
            self.text((c[0] + f * 1.0, c[1] + 0.25), ref, size, anchor="start" if f > 0 else "end")
        if val:
            self.text((c[0] + f * 1.0, c[1] + 1.0), val, size, anchor="start" if f > 0 else "end")
        g = self.u
        return {"G": (G[0] / g, G[1] / g), "D": (D[0] / g, D[1] / g), "S": (S[0] / g, S[1] / g)}

    def opamp(self, c, facing="right", ref=None, size=11):
        """Op-amp triangle centred at c, inputs on the flat side. Returns P (+), N (-), O."""
        cx, cy = self.px(c)
        f = 1 if facing == "right" else -1
        w, h = 1.4 * self.u, 1.6 * self.u
        self._path([(cx - f * w / 2, cy - h / 2), (cx + f * w / 2, cy), (cx - f * w / 2, cy + h / 2)],
                   width=2.0, close=True, amp=0.3)
        P = (cx - f * 1.2 * self.u, cy + 0.4 * self.u)
        N = (cx - f * 1.2 * self.u, cy - 0.4 * self.u)
        O = (cx + f * 1.2 * self.u, cy)
        self._path([P, (cx - f * w / 2, P[1])], width=2.0)
        self._path([N, (cx - f * w / 2, N[1])], width=2.0)
        self._path([(cx + f * w / 2, cy), O], width=2.0)
        self.text(((cx - f * w / 2 + f * 9) / self.u, (cy + 0.4 * self.u + 4) / self.u), "+", 9, anchor="middle")
        self.text(((cx - f * w / 2 + f * 9) / self.u, (cy - 0.4 * self.u + 4) / self.u), "-", 9, anchor="middle")
        if ref:
            self.text((c[0], c[1] - 1.0), ref, size, anchor="middle")
        g = self.u
        return {"P": (P[0] / g, P[1] / g), "N": (N[0] / g, N[1] / g), "O": (O[0] / g, O[1] / g)}

    # ------------------------------------------------------------- output
    def page_number(self, n, size=16):
        self.text((self.w - 1.2, self.h - 1.0), str(n), size, anchor="end")

    def svg(self, crop=False, margin=1.0, paper=True):
        """paper=False leaves out the cream background and grid, for figures that sit
        on a web page that already draws the paper (the grid lines up if the image is
        placed on a 20 px multiple)."""
        if crop:
            x0 = math.floor(self.bbox[0] / self.u - margin) * self.u
            y0 = math.floor(self.bbox[1] / self.u - margin) * self.u
            x1 = math.ceil(self.bbox[2] / self.u + margin) * self.u
            y1 = math.ceil(self.bbox[3] / self.u + margin) * self.u
        else:
            x0, y0, x1, y1 = 0, 0, self.w * self.u, self.h * self.u
        W, H = x1 - x0, y1 - y0
        grid = []
        for gx in range(int(x0), int(x1) + 1, self.u):
            grid.append(f"M{gx},{y0} V{y1}")
        for gy in range(int(y0), int(y1) + 1, self.u):
            grid.append(f"M{x0},{gy} H{x1}")
        bg = ""
        if paper:
            bg = (f'<rect x="{x0}" y="{y0}" width="{W}" height="{H}" fill="{PAPER}"/>\n'
                  f'<path d="{" ".join(grid)}" stroke="{GRID}" stroke-width="0.8" opacity="0.75" fill="none"/>\n')
        return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="{x0} {y0} {W} {H}" width="{W}" height="{H}">\n'
                + bg + "\n".join(self.els) + "\n</svg>\n")

    def save(self, path, crop=False, margin=1.0, paper=True):
        with open(path, "w") as f:
            f.write(self.svg(crop, margin, paper))
        return path


if __name__ == "__main__":
    p = Page(30, 16, seed=3)
    p.heading((1, 1.2), "VOLTAGE DIVIDER")
    p.battery((3, 5), (3, 8), None, None)
    p.text((2.2, 6.8), "V_{IN}", 12, anchor="end")
    p.wire([(3, 5), (3, 3), (8, 3), (8, 4)])
    p.resistor((8, 4), (8, 7), "R1", None, side="right")
    p.junction((8, 7))
    p.resistor((8, 7), (8, 10), "R2", None, side="right")
    p.wire([(8, 10), (8, 11), (3, 11), (3, 8)])
    p.wire([(8, 7), (11, 7)])
    p.arrow((11, 7), 0, label="+ V_{OUT}")
    p.wire([(8, 11), (11, 11)])
    p.arrow((11, 11), 0)
    p.text((13, 8.0), "V_{OUT} = V_{IN} ×", 12)
    p.fraction((21.5, 7.6), "R2", "R1 + R2", 12)
    p.text((1, 13.5), "R1 AND R2 CAN BE A POTENTIOMETER.", 11)
    p.page_number(5)
    p.save("demo.svg")
    print("wrote demo.svg")
