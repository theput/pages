#!/usr/bin/env python3
"""
build_font.py - turn mims.py's stroke glyphs into a real webfont (MimsHand).

Each glyph's polylines get a little waver (same spirit as the renderer), are
stroked to a felt-tip width with round caps, unioned, and written as TrueType
outlines.  Lowercase letters map to the capital forms except the unit letters
m k p n h z, exactly like the renderer.  Output: MimsHand.ttf + MimsHand.woff2.
"""
import math
import random
import sys

from fontTools.fontBuilder import FontBuilder
from fontTools.pens.ttGlyphPen import TTGlyphPen
from shapely.geometry import LineString, Polygon
from shapely.ops import unary_union

sys.path.insert(0, ".")
from mims import GLYPHS, WIDTHS  # noqa: E402

UPM = 1000
S = 118.0            # font units per glyph unit (cap height 6 -> 708)
PEN = 0.95 * S / 2   # half the felt-tip width
rnd = random.Random(7)


def wobble(stroke, amp=0.10, step=0.6):
    """Subdivide and add a gentle low-frequency waver (glyph units)."""
    out = []
    for i in range(len(stroke) - 1):
        (x1, y1), (x2, y2) = stroke[i], stroke[i + 1]
        dx, dy = x2 - x1, y2 - y1
        L = math.hypot(dx, dy) or 1e-6
        nx, ny = -dy / L, dx / L
        n = max(1, int(L / step))
        ph, fr = rnd.uniform(0, 6.28), rnd.uniform(0.5, 1.2)
        for k in range(n + (1 if i == len(stroke) - 2 else 0)):
            t = k / n
            off = 0 if k in (0, n) else amp * (0.7 * math.sin(2 * math.pi * fr * t + ph) + 0.3 * rnd.uniform(-1, 1))
            out.append((x1 + dx * t + nx * off, y1 + dy * t + ny * off))
    return out


def glyph_outline(strokes):
    """Union of stroked polylines, in font units."""
    polys = []
    tilt = rnd.uniform(-0.02, 0.04)
    for st in strokes:
        pts = [((x + y * tilt) * S + rnd.uniform(-3, 3), y * S + rnd.uniform(-3, 3)) for x, y in wobble(st)]
        if len(pts) < 2:
            continue
        polys.append(LineString(pts).buffer(PEN, cap_style=1, join_style=1, resolution=6))
    return unary_union(polys) if polys else None


def draw(pen, geom):
    geoms = list(geom.geoms) if hasattr(geom, "geoms") else [geom]
    for g in geoms:
        if not isinstance(g, Polygon):
            continue
        for ring, outer in [(g.exterior, True)] + [(h, False) for h in g.interiors]:
            coords = list(ring.coords)[:-1]
            # TrueType: outer contours clockwise, holes counter-clockwise
            cw = Polygon(coords).exterior.is_ccw is False
            if cw != outer:
                coords.reverse()
            pen.moveTo((round(coords[0][0]), round(coords[0][1])))
            for x, y in coords[1:]:
                pen.lineTo((round(x), round(y)))
            pen.closePath()


def build():
    names, glyphs, widths, cmap = [".notdef"[:0] or ".notdef", "space"], {}, {}, {}
    # .notdef and space
    pen = TTGlyphPen(None); glyphs[".notdef"] = pen.glyph(); widths[".notdef"] = int(4 * S)
    pen = TTGlyphPen(None); glyphs["space"] = pen.glyph(); widths["space"] = int((WIDTHS[" "] + 1.4) * S)
    cmap[ord(" ")] = "space"; cmap[0xA0] = "space"

    done = {}
    UNIT = "mkpn"           # lowercase forms used only as unit prefixes after a digit
    for ch, strokes in GLYPHS.items():
        if ch in (" ",):
            continue
        if ch in "mkpnhz":
            if ch not in UNIT:
                continue
            name = f"{ch}.unit"
        else:
            name = f"uni{ord(ch):04X}"
        if name in done:
            continue
        done[name] = True
        geom = glyph_outline(strokes)
        pen = TTGlyphPen(None)
        if geom is not None and not geom.is_empty:
            draw(pen, geom)
        glyphs[name] = pen.glyph()
        widths[name] = int((WIDTHS.get(ch.upper(), 4) + 1.4) * S)
        names.append(name)
        if ch not in "mkpnhz":
            cmap[ord(ch)] = name

    # lowercase -> capital forms (the unit forms are swapped in by the calt feature)
    for c in "abcdefghijklmnopqrstuvwxyz":
        if ord(c) not in cmap:
            cmap[ord(c)] = cmap[ord(c.upper())]
    # a few aliases
    cmap[0x2212] = cmap[ord("-")]      # minus
    cmap[0x2013] = cmap[ord("-")]      # en dash
    cmap[0x2014] = cmap[ord("-")]      # em dash
    cmap[0x2019] = cmap[ord("'")]      # right single quote
    cmap[0x2018] = cmap[ord("'")]
    cmap[0x201C] = cmap[ord("'")]
    cmap[0x201D] = cmap[ord("'")]
    cmap[0x00D7] = cmap[ord("×")]
    cmap[0x2026] = cmap[ord(".")]      # ellipsis (crude)

    fb = FontBuilder(UPM, isTTF=True)
    fb.setupGlyphOrder(names)
    fb.setupCharacterMap(cmap)
    fb.setupGlyf(glyphs)
    metrics = {n: (widths[n], glyphs[n].xMin if hasattr(glyphs[n], "xMin") else 0) for n in names}
    fb.setupHorizontalMetrics(metrics)
    fb.setupHorizontalHeader(ascent=int(7.2 * S), descent=-int(2.6 * S))
    fb.setupNameTable({"familyName": "MimsHand", "styleName": "Regular",
                       "fullName": "MimsHand Regular", "psName": "MimsHand-Regular",
                       "version": "Version 1.0",
                       "description": "Hand-lettered block capitals in the Forrest Mims notebook style, built from mims.py."})
    fb.setupOS2(sTypoAscender=int(7.2 * S), sTypoDescender=-int(2.6 * S), sTypoLineGap=0,
                usWinAscent=int(7.6 * S), usWinDescent=int(2.8 * S),
                sCapHeight=int(6 * S), sxHeight=int(4 * S))
    fb.setupPost()
    # contextual alternates: a lowercase m/k/p/n right after a digit (or digit + space)
    # becomes the unit form, so "325 mW" and "10k" read as units while "RockMite" stays caps.
    from fontTools.feaLib.builder import addOpenTypeFeaturesFromString
    digits = " ".join(f"uni{ord(d):04X}" for d in "0123456789")
    fea = "@D = [%s];\n" % digits
    fea += "feature calt {\n"
    for c in UNIT:
        cap = cmap[ord(c.upper())]
        # part numbers (2N2222, 1N4148, 2k2 is fine) keep the capital: no unit form before a digit
        fea += f"  ignore sub @D {cap}' @D;\n  ignore sub @D space {cap}' @D;\n"
        fea += f"  sub @D space {cap}' by {c}.unit;\n  sub @D {cap}' by {c}.unit;\n"
    fea += "} calt;\n"
    addOpenTypeFeaturesFromString(fb.font, fea)
    fb.save("MimsHand.ttf")
    f = fb.font
    f.flavor = "woff2"
    f.save("MimsHand.woff2")
    print(len(names), "glyphs")


if __name__ == "__main__":
    build()
