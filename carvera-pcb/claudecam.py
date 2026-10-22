#!/usr/bin/env python3
"""
claudecam — Gerber/Excellon -> Carvera G-code for single-sided PCB isolation milling.

MIT License

Copyright (c) 2026 Bill Putnam

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

    KiCad  ->  Gerber + Excellon  ->  [ this ]  ->  .nc  ->  Carvera Controller

WHY THIS EXISTS
  MakeraCAM, tested 2026-08-09:
    * silently DISCARDS open geometry (proved on Stage A: adding a layer changed the
      G-code by one comment line and produced zero motion)
    * REFUSES overlapping shapes -- "the shapes intersect and cannot generate
      contour path!" -- but Gerber is an additive paint model, so ALL real PCB
      artwork overlaps
    * has no isolation-routing operation at all; you hand-profile shapes
  Both failures were SILENT. What caught them was diffing output against an
  expected count. This tool is built so that check is intrinsic, not heroic:
  it asserts what it produced and refuses to emit a file that fails its own
  invariants.

HOW IT WORKS
  1. gerbonara parses the Gerber. Every Gerber construct -- aperture macros,
     obrounds, regions, arcs, polarity -- reduces to five render primitives
     (Line, Arc, Circle, Rectangle, ArcPoly), so full-spec coverage comes free.
     Do NOT hand-roll a Gerber parser; that was the gap in merge_gerber.py.
  2. Each primitive becomes a Shapely polygon; unary_union merges them into
     disjoint copper polygons -- the nets.
  3. Isolation pass N = boundary of copper.buffer(r + N*stepover). Cutting a
     boundary curve is exactly what isolation routing is.
  4. Excellon -> plunge if hole == tool diameter, else helical interpolation.
  5. Outline -> board edge buffered outward by r, stepped down in Z.
  6. G-code emitted with the conventions verified from Makera's own working PCB
     example (see factory-gcode-reference.md): G21 G40 G54 / G80 G90 G94,
     "T2 M06" on ONE line (split across two loses the height map), M03 S12000,
     M07/M09, approach Z2, clear Z3.

DELIBERATE LIMITS -- keep it narrow or it becomes a burden
  Single-sided only. No double-sided flip/registration, no solder mask, no
  silkscreen, no travel optimisation beyond nearest-neighbour. If a board needs
  those, use a mature tool; this is for coupons and simple single-layer boards.
"""
import argparse, math, sys
from shapely.geometry import LineString, Point, box, Polygon, MultiPolygon
from shapely.ops import unary_union
from shapely import affinity

ARC_SEGS = 32          # arc flattening
BUF_SEGS = 24          # buffer smoothness

# ----------------------------------------------------------- gerber -> shapely
def prim_to_poly(p):
    """One gerbonara render primitive -> one Shapely polygon (or None)."""
    t = type(p).__name__
    if t == 'Line':
        if (p.x1, p.y1) == (p.x2, p.y2):
            return Point(p.x1, p.y1).buffer(p.width/2, quad_segs=BUF_SEGS)
        return LineString([(p.x1,p.y1),(p.x2,p.y2)]).buffer(
            p.width/2, cap_style=1, quad_segs=BUF_SEGS)
    if t == 'Circle':
        return Point(p.x, p.y).buffer(p.r, quad_segs=BUF_SEGS)
    if t == 'Rectangle':
        b = box(p.x - p.w/2, p.y - p.h/2, p.x + p.w/2, p.y + p.h/2)
        return affinity.rotate(b, p.rotation, origin=(p.x, p.y), use_radians=False) \
               if getattr(p, 'rotation', 0) else b
    if t == 'Arc':
        pts = _arc_pts(p.x1,p.y1,p.x2,p.y2,p.cx,p.cy,p.clockwise)
        return LineString(pts).buffer(p.width/2, cap_style=1, quad_segs=BUF_SEGS)
    if t == 'ArcPoly':
        pts = []
        for (pt, centre) in zip(p.outline, list(p.arc_centers)+[None]*len(p.outline)):
            pts.append((pt[0], pt[1]))
        poly = Polygon(pts)
        return poly if poly.is_valid else poly.buffer(0)
    raise NotImplementedError("unhandled Gerber primitive %r -- refusing to "
                              "silently drop geometry" % t)

def _arc_pts(x1,y1,x2,y2,cx,cy,cw):
    r  = math.hypot(x1-cx, y1-cy)
    a1 = math.atan2(y1-cy, x1-cx); a2 = math.atan2(y2-cy, x2-cx)
    if cw and a2 > a1: a2 -= 2*math.pi
    if not cw and a2 < a1: a2 += 2*math.pi
    return [(cx+r*math.cos(a1+(a2-a1)*i/ARC_SEGS),
             cy+r*math.sin(a1+(a2-a1)*i/ARC_SEGS)) for i in range(ARC_SEGS+1)]

def load_copper(path):
    from gerbonara import GerberFile
    gf = GerberFile.open(path)
    dark, clear = [], []
    n = 0
    for obj in gf.objects:
        for p in obj.to_primitives(unit='mm'):
            poly = prim_to_poly(p); n += 1
            if poly is None or poly.is_empty: continue
            (dark if getattr(p,'polarity_dark',True) else clear).append(poly)
    cu = unary_union(dark)
    if clear:                                   # %LPC*% clear polarity
        cu = cu.difference(unary_union(clear))
    return cu, n

def load_holes(path):
    """Return (round_holes, slots).
      round_holes = [(x, y, dia)]           -- Excellon plunge points (Flash)
      slots       = [(x1, y1, x2, y2, wid)] -- routed/obround pads (Line); KiCad emits
                     oval pads (RCA/phono/etc.) as a tool moving along a line, i.e. a
                     slot of width == tool dia. Milled boards need these ROUTED, not
                     plunged -- so they get their own toolpath below."""
    from gerbonara import ExcellonFile
    ef = ExcellonFile.open(path)
    holes, slots = [], []
    for o in ef.objects:
        d = getattr(getattr(o, 'aperture', None), 'diameter', None)
        if d is None: continue
        if hasattr(o, 'x1') and getattr(o, 'x1', None) is not None:   # Line -> slot
            slots.append((o.x1, o.y1, o.x2, o.y2, d))
        elif getattr(o, 'x', None) is not None:                        # Flash -> hole
            holes.append((o.x, o.y, d))
    return holes, slots

def polys(g):
    if g.is_empty: return []
    return list(g.geoms) if isinstance(g, MultiPolygon) else [g]

def rings(g):
    """Every closed boundary of a (multi)polygon: exteriors and interiors alike.
    Both are copper/no-copper boundaries, so both get cut."""
    out = []
    for p in polys(g):
        out.append(list(p.exterior.coords))
        for i in p.interiors: out.append(list(i.coords))
    return out

# ------------------------------------------------------------------- g-code ---
class GCode:
    """Conventions copied from Makera's PCB-NO-UV-MASK.nc -- see
    factory-gcode-reference.md. Deviating from these is how you lose a board."""
    def __init__(self, title, spindle=12000):
        self.o = ['%', '( %s )' % title, '( claudecam - generated, do not hand-edit )',
                  'G21 G40 G54', 'G80 G90 G94']
        self.spindle = spindle; self.tool = None
        self.approach, self.clear = 2.0, 3.0
        self.cut_mm = 0.0; self.plunges = 0

    def comment(self, s): self.o.append('( %s )' % s)

    def tool_change(self, n, desc):
        if self.tool is not None:
            self.o += ['M09', 'M05']
        self.o.append('( Tool #%d "%s" )' % (n, desc))
        self.o.append('T%d M06' % n)                 # ONE LINE. Non-negotiable.
        self.o.append('M03 S%d' % self.spindle)
        self.o.append('M07')
        self.tool = n

    def contour(self, pts, depth, feed, plunge):
        self.o.append('G00 X%.4f Y%.4f' % (pts[0][0], pts[0][1]))
        self.o.append('G00 Z%g' % self.approach)
        self.o.append('G01 F%d Z%.4f' % (plunge, -abs(depth)))
        px, py = pts[0]
        for (x, y) in pts[1:]:
            self.o.append('G01 F%d X%.4f Y%.4f' % (feed, x, y))
            self.cut_mm += math.hypot(x-px, y-py); px, py = x, y
        self.o.append('G00 Z%g' % self.clear)
        self.plunges += 1

    def drill(self, x, y, depth, plunge):
        self.o += ['G00 X%.4f Y%.4f' % (x, y), 'G00 Z%g' % self.approach,
                   'G01 F%d Z%.4f' % (plunge, -abs(depth)), 'G00 Z%g' % self.clear]
        self.plunges += 1

    def helical(self, x, y, r, depth, step, feed, plunge):
        """Holes bigger than the bit: circular interpolation, stepping down.
        Factory drills at-size holes in ONE plunge but steps down 0.2 mm for
        anything with XY motion at depth -- we follow that."""
        pts = [(x + r*math.cos(2*math.pi*i/ARC_SEGS),
                y + r*math.sin(2*math.pi*i/ARC_SEGS)) for i in range(ARC_SEGS+1)]
        self.o.append('G00 X%.4f Y%.4f' % pts[0])
        self.o.append('G00 Z%g' % self.approach)
        z = 0.0
        while z < abs(depth) - 1e-9:
            z = min(z + step, abs(depth))
            self.o.append('G01 F%d Z%.4f' % (plunge, -z))
            px, py = pts[0]
            for (cx, cy) in pts[1:]:
                self.o.append('G01 F%d X%.4f Y%.4f' % (feed, cx, cy))
                self.cut_mm += math.hypot(cx-px, cy-py); px, py = cx, cy
        self.o.append('G00 Z%g' % self.clear)
        self.plunges += 1

    def route_slot(self, x1, y1, x2, y2, width, bit, depth, step, feed, plunge):
        """Mill an obround/slot pad (width == the pad's tool dia) with a smaller bit.
        Zig-zag down along the slot axis; if the slot is wider than the bit, add
        parallel offset passes (spaced <= 0.8*bit so they overlap) to clear full
        width. A degenerate (zero-length) slot falls back to a plunge."""
        L = math.hypot(x2-x1, y2-y1)
        if L < 1e-9:
            self.drill(x1, y1, depth, plunge); return
        ux, uy = (x2-x1)/L, (y2-y1)/L
        nx, ny = -uy, ux                              # perpendicular to slot axis
        cover = max(0.0, width - bit)                 # extra width beyond one center pass
        if cover <= 1e-9:
            offs = [0.0]
        else:
            npass = int(math.ceil(cover/(bit*0.8))) + 1
            offs = [-cover/2 + k*cover/(npass-1) for k in range(npass)]
        for o in offs:
            sx, sy = x1+nx*o, y1+ny*o
            ex, ey = x2+nx*o, y2+ny*o
            self.o.append('G00 X%.4f Y%.4f' % (sx, sy))
            self.o.append('G00 Z%g' % self.approach)
            z, cur, at_start = 0.0, (sx, sy), True
            while z < abs(depth) - 1e-9:
                z = min(z + step, abs(depth))
                self.o.append('G01 F%d Z%.4f' % (plunge, -z))      # step down at this end
                tgt = (ex, ey) if at_start else (sx, sy)
                self.o.append('G01 F%d X%.4f Y%.4f' % (feed, tgt[0], tgt[1]))
                self.cut_mm += math.hypot(tgt[0]-cur[0], tgt[1]-cur[1])
                cur, at_start = tgt, not at_start
            self.o.append('G00 Z%g' % self.clear)
            self.plunges += 1

    def render(self):
        return '\n'.join(self.o + ['M09', 'M05', 'M02', '%']) + '\n'

def ring_length(pts):
    return sum(math.hypot(pts[i+1][0]-pts[i][0], pts[i+1][1]-pts[i][1])
               for i in range(len(pts)-1))

def tab_spans(pts, n, width):
    """Pick n tab positions on a closed ring, as (start,end) arc-length spans.

    Tabs go at the MIDPOINT OF THE LONGEST STRAIGHT RUNS, not at even arc-length
    intervals. Even spacing lands tabs on corners, and corners are stiff -- they
    tear unpredictably instead of snapping. On a rectangle this puts one tab in
    the middle of each side, which is what you'd choose by hand."""
    segs = []   # (length, arclen_at_midpoint)
    acc = 0.0
    for i in range(len(pts)-1):
        L = math.hypot(pts[i+1][0]-pts[i][0], pts[i+1][1]-pts[i][1])
        segs.append((L, acc + L/2)); acc += L
    segs.sort(key=lambda t: -t[0])
    usable = [m for (L, m) in segs if L >= width + 2.0]
    if len(usable) < n:
        print('  NOTE: only %d edge(s) long enough for a %.1f mm tab; placing %d'
              % (len(usable), width, len(usable)))
    return [(m - width/2, m + width/2) for m in usable[:n]], acc

def split_ring(pts, spans, total):
    """Return the ring as open polylines with the given arc-length spans removed.
    Split points are interpolated, so a tab edge lands exactly where asked."""
    if not spans: return [pts]
    def inside(t):
        return any(a <= t <= b for (a, b) in spans)
    out, cur, acc = [], [], 0.0
    for i in range(len(pts)-1):
        (x0, y0), (x1, y1) = pts[i], pts[i+1]
        L = math.hypot(x1-x0, y1-y0)
        if L == 0: continue
        # sample this segment at every span boundary that falls inside it
        cuts = sorted(t for (a, b) in spans for t in (a, b) if acc < t < acc + L)
        marks = [acc] + cuts + [acc + L]
        for j in range(len(marks)-1):
            t0, t1 = marks[j], marks[j+1]
            f0, f1 = (t0-acc)/L, (t1-acc)/L
            p0 = (x0 + (x1-x0)*f0, y0 + (y1-y0)*f0)
            p1 = (x0 + (x1-x0)*f1, y0 + (y1-y0)*f1)
            if inside((t0+t1)/2):
                if len(cur) > 1: out.append(cur)
                cur = []
            else:
                if not cur: cur = [p0]
                cur.append(p1)
        acc += L
    if len(cur) > 1: out.append(cur)
    # The ring is cyclic: if neither arc-0 nor arc-total falls inside a tab, the first
    # and last runs are the two halves of ONE continuous run either side of the closure
    # point. Join them, or you get a needless plunge/retract mid-edge.
    if len(out) > 1 and not inside(1e-9) and not inside(total - 1e-9):
        if abs(out[0][0][0]-out[-1][-1][0]) < 1e-6 and abs(out[0][0][1]-out[-1][-1][1]) < 1e-6:
            out = [out[-1] + out[0][1:]] + out[1:-1]
    return out

def order_nearest(loops):
    """Greedy nearest-neighbour on loop start points. Not optimal, but it stops
    the tool crossing the board between every contour."""
    if not loops: return []
    rest = list(loops); out = [rest.pop(0)]
    while rest:
        lx, ly = out[-1][0]
        i = min(range(len(rest)), key=lambda k: (rest[k][0][0]-lx)**2 + (rest[k][0][1]-ly)**2)
        out.append(rest.pop(i))
    return out

# ---------------------------------------------------------------------- main ---
def main():
    a = argparse.ArgumentParser(description=__doc__,
                                formatter_class=argparse.RawDescriptionHelpFormatter)
    a.add_argument('--copper', required=True)
    a.add_argument('--outline')
    a.add_argument('--drill', nargs='+',
                   help='Excellon file(s). KiCad emits PTH and NPTH separately -- pass BOTH. On a milled board there is no plating, so the distinction is cosmetic; both are just holes.')
    a.add_argument('-o', '--out', required=True)
    a.add_argument('--iso-depth', type=float, required=True,
                   help='isolation depth mm, positive (from Stage A)')
    a.add_argument('--tool-dia', type=float, default=0.20,
                   help='DECLARED isolation tool dia. Under-declaring is the safe '
                        'direction: guarantees separation, costs ~15um of trace width')
    a.add_argument('--passes', type=int, default=1)
    a.add_argument('--stepover', type=float, default=0.45, help='fraction of tool dia')
    a.add_argument('--iso-tool', type=int, default=2)
    a.add_argument('--drill-tool', type=int, default=3)
    a.add_argument('--drill-dia', type=float, default=0.80)
    a.add_argument('--board-thick', type=float, default=1.6)
    a.add_argument('--stepdown', type=float, default=0.2)
    a.add_argument('--feed', type=int, default=300)
    a.add_argument('--plunge', type=int, default=300)
    a.add_argument('--spindle', type=int, default=12000)
    a.add_argument('--simplify', type=float, default=0.004)
    a.add_argument('--tabs', type=int, default=0,
                   help='breakaway tabs on the outline. Draw a NORMAL CLOSED outline in '
                        'KiCad -- tabs are a fixturing decision, not a design feature, so '
                        'they belong here and not in the artwork.')
    a.add_argument('--tab-width', type=float, default=2.5, help='mm along the edge')
    a.add_argument('--tab-height', type=float, default=0.4,
                   help='mm of material LEFT at each tab. ~0.4 on 1.5mm stock snaps by '
                        'hand and leaves a ridge you file off in seconds.')
    a.add_argument('--origin', metavar='X,Y', default=None,
                   help="Translate everything so the artwork's min corner lands here, "
                        "e.g. --origin 2,2. KiCad plots relative to the PAGE origin unless "
                        "'Use drill/place file origin' is ticked, which puts the board at "
                        "NEGATIVE Y ~50mm off. Observed 2026-08-09: MakeraCAM silently "
                        "emitted an empty toolpath because the board fell outside the stock.")
    a.add_argument('--mirror', choices=['none','x','y'], default='none',
                   help="Mirror copper+drill+outline for a BOTTOM-copper (solder-side) board "
                        "milled copper-up. 'x' flips left-right (KiCad 'flip on Y'); 'y' flips "
                        "top-bottom. Use for any single-sided board routed on B.Cu.")
    a.add_argument('--engrave', metavar='LAYER.gbr', default=None,
                   help="A Gerber (e.g. KiCad User.1) of a mark/logo/text to V-engrave into the "
                        "copper. Its shapes' outlines are traced with the isolation bit at "
                        "--engrave-depth, during the same T2 pass, and it rides the SAME --mirror "
                        "and --origin as the copper so it can't end up flipped or misregistered.")
    a.add_argument('--engrave-depth', type=float, default=0.08,
                   help="Depth (mm, positive) for --engrave lines. Default 0.08 -- cuts through "
                        "35um copper into the substrate for a visible mark.")
    a.add_argument('--edge-margin', type=float, default=0.0, metavar='N',
                   help="Skip any isolation loop lying ENTIRELY within N mm of the artwork "
                        "bounding-box edge (mm; default 0 = off). Kills the ground-pour PERIMETER "
                        "loop -- the one that traces the stock edge. It isolates the pour from "
                        "bare FR4, which buys nothing, and it runs the collet within a millimetre "
                        "of the hold-down clamps. Real traces and pads are interior, so they "
                        "survive the test; every dropped loop is printed with its bounding box "
                        "and length so you can confirm exactly what went.")
    args = a.parse_args()

    r = args.tool_dia/2
    step = args.tool_dia*args.stepover
    cu, nprim = load_copper(args.copper)
    ol_geom = load_copper(args.outline)[0] if args.outline else None
    eng_geom = load_copper(args.engrave)[0] if args.engrave else None
    holes, slots = [], []
    for f in (args.drill or []):
        h, s = load_holes(f); holes += h; slots += s

    # --- mirror (bottom-copper boards) ----------------------------------------
    # A single-sided board whose copper is on the SOLDER (bottom) side is milled
    # copper-up, i.e. the blank is flipped, so the artwork must be mirrored or the
    # finished board comes out reversed. Mirror copper + outline + DRILL together
    # (KiCad's plot-mirror won't touch the Excellon, so do it here) about the
    # board/artwork centre. --mirror x flips left-right ("flip on Y"); y flips top-
    # bottom. Do it BEFORE origin so the shift still lands the min corner correctly.
    if args.mirror and args.mirror != 'none':
        mref = ol_geom if ol_geom is not None else cu
        x0m, y0m, x1m, y1m = mref.bounds
        if args.mirror == 'x':
            fx = lambda X: (x0m + x1m) - X; fy = lambda Y: Y
        elif args.mirror == 'y':
            fx = lambda X: X; fy = lambda Y: (y0m + y1m) - Y
        else:
            sys.exit("ERROR: --mirror must be none|x|y")
        cu = affinity.scale(cu, xfact=-1 if args.mirror=='x' else 1,
                            yfact=-1 if args.mirror=='y' else 1,
                            origin=((x0m+x1m)/2, (y0m+y1m)/2))
        _sc = lambda geom: affinity.scale(geom, xfact=-1 if args.mirror=='x' else 1,
                                          yfact=-1 if args.mirror=='y' else 1,
                                          origin=((x0m+x1m)/2, (y0m+y1m)/2))
        if ol_geom is not None: ol_geom = _sc(ol_geom)
        if eng_geom is not None: eng_geom = _sc(eng_geom)
        holes = [(fx(x), fy(y), d) for (x, y, d) in holes]
        slots = [(fx(x1), fy(y1), fx(x2), fy(y2), w) for (x1, y1, x2, y2, w) in slots]
        print('mirror : %s about board centre (%.2f, %.2f) -- bottom-copper, milled copper-up'
              % (args.mirror, (x0m+x1m)/2, (y0m+y1m)/2))

    # --- origin normalisation -------------------------------------------------
    # Guard against KiCad's page-relative plot origin, which puts a board at
    # negative Y and makes CAM quietly produce nothing.
    ref = cu if ol_geom is None else unary_union([cu, ol_geom])
    if args.origin:
        tx, ty = (float(v) for v in args.origin.split(','))
        dx, dy = tx - ref.bounds[0], ty - ref.bounds[1]
        cu = affinity.translate(cu, dx, dy)
        if ol_geom is not None: ol_geom = affinity.translate(ol_geom, dx, dy)
        if eng_geom is not None: eng_geom = affinity.translate(eng_geom, dx, dy)
        holes = [(x+dx, y+dy, d) for (x, y, d) in holes]
        slots = [(x1+dx, y1+dy, x2+dx, y2+dy, w) for (x1, y1, x2, y2, w) in slots]
        print('origin : shifted by (%+.3f, %+.3f) so artwork starts at (%.3f, %.3f)'
              % (dx, dy, tx, ty))
    elif ref.bounds[0] < 0 or ref.bounds[1] < 0:
        print('WARNING: artwork extends to negative coordinates '
              '(X %.1f, Y %.1f). CAM and Controller will likely machine nothing.'
              % (ref.bounds[0], ref.bounds[1]))
        print('         Either tick "Use drill/place file origin" in KiCad, or pass '
              '--origin 2,2 here.')
    nets = polys(cu)
    print('copper : %d primitives -> %d disjoint nets, %.1f mm2'
          % (nprim, len(nets), cu.area))

    g = GCode('claudecam isolation - iso depth %.3f mm, %d pass(es)'
              % (args.iso_depth, args.passes), spindle=args.spindle)
    g.tool_change(args.iso_tool, 'isolation %.2f mm declared' % args.tool_dia)

    # --- edge margin: the interior test box ------------------------------------
    # A ground pour that reaches the artwork edge produces one isolation loop that
    # simply traces the stock perimeter. It separates the pour from bare FR4 --
    # i.e. from nothing -- and it puts the collet a millimetre from the hold-down
    # clamps. --edge-margin N drops any loop that never reaches more than N mm in
    # from the bounding box. Every real trace/pad is interior, so nothing else
    # qualifies; anything that does is printed before it's dropped.
    ebox = None
    if args.edge_margin > 0:
        bx0, by0, bx1, by1 = (cu if ol_geom is None
                              else unary_union([cu, ol_geom])).bounds
        m = args.edge_margin
        if bx0 + m >= bx1 - m or by0 + m >= by1 - m:
            sys.exit('ERROR: --edge-margin %.2f mm leaves no interior on a %.1f x %.1f mm '
                     'artwork -- it would drop every loop.' % (m, bx1-bx0, by1-by0))
        ebox = box(bx0+m, by0+m, bx1-m, by1-m)
        print('edge-m : %.2f mm; artwork bbox (%.2f, %.2f)-(%.2f, %.2f), keeping loops that '
              'reach inside (%.2f, %.2f)-(%.2f, %.2f)'
              % (m, bx0, by0, bx1, by1, bx0+m, by0+m, bx1-m, by1-m))

    # --- isolation passes
    all_loops = []
    ndropped = 0
    for n in range(args.passes):
        off = r + n*step
        iso = cu.buffer(off, quad_segs=BUF_SEGS, join_style=1)
        loops = [list(LineString(rg).simplify(args.simplify).coords) for rg in rings(iso)]
        merged = len(polys(iso)) < len(nets)
        print('  pass %d @ offset %.3f mm: %d regions, %d loops%s'
              % (n+1, off, len(polys(iso)), len(loops),
                 '   <-- SOME NETS MERGE: no groove between them' if merged else ''))
        if ebox is not None:
            keep, drop = [], []
            for pts in loops:
                (keep if LineString(pts).intersects(ebox) else drop).append(pts)
            for pts in drop:
                ls = LineString(pts)
                dx0, dy0, dx1, dy1 = ls.bounds
                print('    DROPPED (within %.2f mm of edge): bbox (%.2f, %.2f)-(%.2f, %.2f), '
                      '%.1f mm long, %d pts' % (args.edge_margin, dx0, dy0, dx1, dy1,
                                                ls.length, len(pts)))
            print('    edge-margin: %d loop(s) dropped, %d kept' % (len(drop), len(keep)))
            ndropped += len(drop); loops = keep
        all_loops += loops
    g.comment('isolation: %d loops' % len(all_loops))
    for pts in order_nearest(all_loops):
        g.contour(pts, args.iso_depth, args.feed, args.plunge)

    # --- engrave (mark/logo/text) -- same T2 bit, shallower, its own depth
    if eng_geom is not None:
        eloops = [list(LineString(rg).simplify(args.simplify).coords) for rg in rings(eng_geom)]
        # sanity: engraving must sit on copper, not off in bare FR4 or across a trace gap
        off_cu = eng_geom.difference(cu.buffer(0.05)).area
        if off_cu > 0.5:
            print('  WARNING: %.1f mm2 of the engrave layer is NOT over copper -- it will cut '
                  'bare substrate there (invisible). Move the mark onto the pour.' % off_cu)
        g.comment('engrave: %d loops @ %.3f mm' % (len(eloops), args.engrave_depth))
        for pts in order_nearest(eloops):
            g.contour(pts, args.engrave_depth, args.feed, args.plunge)
        print('engrave: %d loops @ %.3f mm (mark/logo, T2)' % (len(eloops), args.engrave_depth))

    # --- verify isolation actually separates the nets, per pass 1
    iso1 = cu.buffer(r, quad_segs=BUF_SEGS, join_style=1)
    shorted = len(nets) - len(polys(iso1))
    if shorted > 0:
        print('  WARNING: %d net(s) merge at pass 1 -- those pairs will NOT be '
              'isolated. Reduce tool dia or increase design clearance.' % shorted)

    # --- drilling
    if args.drill:
        g.tool_change(args.drill_tool, 'drill/outline %.2f mm' % args.drill_dia)
        by = {}
        for (x,y,d) in holes: by.setdefault(round(d,3), []).append((x,y))
        for d in sorted(by):
            if abs(d - args.drill_dia) < 1e-6:
                g.comment('drill %.3f mm x%d - straight plunge' % (d, len(by[d])))
                for (x,y) in by[d]: g.drill(x,y,args.board_thick,args.plunge)
            elif d < args.drill_dia - 1e-6:
                sys.exit('ERROR: %.3f mm hole is smaller than the %.2f mm bit. '
                         'Unmachinable -- fix the artwork.' % (d, args.drill_dia))
            else:
                g.comment('hole %.3f mm x%d - helical, bit %.2f'
                          % (d, len(by[d]), args.drill_dia))
                for (x,y) in by[d]:
                    g.helical(x,y,(d-args.drill_dia)/2, args.board_thick,
                              args.stepdown, args.feed, args.plunge)
        print('drill  : %d holes in %d sizes %s' % (len(holes), len(by), sorted(by)))

        # --- routed slots (oval/obround pads) -----------------------------------
        if slots:
            narrow = [w for (_,_,_,_,w) in slots if w < args.drill_dia - 1e-6]
            if narrow:
                sys.exit('ERROR: %d slot(s) are narrower than the %.2f mm bit '
                         '(min %.3f mm) -- unmachinable, widen the pad or use a '
                         'smaller bit.' % (len(narrow), args.drill_dia, min(narrow)))
            from collections import Counter
            sw = Counter(round(w,3) for (_,_,_,_,w) in slots)
            g.comment('routed slots: %d (%s mm wide) with %.2f mm bit'
                      % (len(slots), sorted(sw), args.drill_dia))
            for (x1,y1,x2,y2,w) in slots:
                g.route_slot(x1,y1,x2,y2, w, args.drill_dia, args.board_thick,
                             args.stepdown, args.feed, args.plunge)
            print('slots  : %d routed, widths %s mm (bit %.2f)'
                  % (len(slots), sorted(sw), args.drill_dia))

    # --- outline LAST: cut the board free before drilling and registration is gone
    if args.outline:
        # An Edge_Cuts stroke buffers into an ANNULUS -- a ring with a hole, where the
        # hole IS the board. Cutting every ring of that (as an earlier version did)
        # puts a second full-depth groove 0.4 mm INSIDE the board perimeter, which
        # severs anything routed near the edge. Fill each ring to a solid first.
        solids = [Polygon(p.exterior) for p in polys(ol_geom)]
        # nesting: a solid contained by another is an internal cutout, not a board
        outer = [s for s in solids
                 if not any(t is not s and t.contains(s) for t in solids)]
        cutouts = [s for s in solids if not any(s.equals(o) for o in outer)]
        board = unary_union(outer)
        rt = args.drill_dia/2
        loops = []
        for p in polys(board.buffer(rt, quad_segs=BUF_SEGS, join_style=2)):
            loops.append(list(p.exterior.coords))          # outward: board stays full size
        for c in cutouts:                                   # inward: tool stays in the hole
            inner = c.buffer(-rt, quad_segs=BUF_SEGS, join_style=2)
            if inner.is_empty:
                sys.exit('ERROR: internal cutout is smaller than the %.2f mm bit -- '
                         'unmachinable, fix the artwork' % args.drill_dia)
            for p in polys(inner): loops.append(list(p.exterior.coords))
        print('outline: 1 board profile + %d internal cutout(s)' % len(cutouts))
        cut = None
        if g.tool != args.drill_tool:
            g.tool_change(args.drill_tool, 'outline %.2f mm' % args.drill_dia)
        g.comment('outline, %d passes of %.2f mm%s'
                  % (math.ceil(args.board_thick/args.stepdown), args.stepdown,
                     ', %d tabs' % args.tabs if args.tabs else ''))
        z_tab = args.board_thick - args.tab_height     # below this, skip the tabs
        for rg in loops:
            pts = list(LineString(rg).simplify(args.simplify).coords)
            spans, total = ([], ring_length(pts)) if not args.tabs \
                           else tab_spans(pts, args.tabs, args.tab_width)
            if spans:
                print('  tabs on this loop at arc-length %s of %.1f mm (each %.1f mm wide, '
                      '%.2f mm left standing)'
                      % ([round((a+b)/2,1) for a,b in spans], total,
                         args.tab_width, args.tab_height))
            z = 0.0
            while z < args.board_thick - 1e-9:
                z = min(z + args.stepdown, args.board_thick)
                if z <= z_tab + 1e-9 or not spans:
                    g.contour(pts, z, args.feed, args.plunge)     # full ring
                else:
                    for run in split_ring(pts, spans, total):     # tabs left standing
                        g.contour(run, z, args.feed, args.plunge)
        print('outline: buffered %.3f mm, %d passes%s' % (args.drill_dia/2,
              math.ceil(args.board_thick/args.stepdown),
              ', tabs left %.2f mm thick' % args.tab_height if args.tabs else ''))

    txt = g.render()
    # ---- self-checks: refuse to write a file that violates its own invariants
    bad = [l for l in txt.splitlines() if l.strip() in ('M06','M6') or
           (l.startswith('T') and l.strip().lstrip('T').isdigit())]
    assert not bad, 'T and M06 got split across lines -- would lose the height map: %r' % bad
    assert 'G02' not in txt and 'G03' not in txt, 'arc emitted; everything should be linear'
    zs = [float(l.split('Z')[1].split()[0]) for l in txt.splitlines()
          if l.startswith('G01') and ' Z' in l]
    deepest = min(zs) if zs else 0
    limit = -(args.board_thick + 0.01)
    assert deepest >= limit, 'Z %.3f is deeper than the board (%.3f)' % (deepest, limit)
    open(args.out,'w').write(txt)
    print('\nwrote %s' % args.out)
    print('  %d lines, %d plunges, %.0f mm of cutting (~%.1f min @ %d mm/min)'
          % (len(txt.splitlines()), g.plunges, g.cut_mm, g.cut_mm/args.feed, args.feed))
    print('  deepest Z %.3f mm   tool changes: %d'
          % (deepest, txt.count(' M06')))
    if args.edge_margin > 0:
        print('  edge-margin %.2f mm: %d isolation loop(s) dropped' % (args.edge_margin, ndropped))
    print('  self-checks: T/M06 on one line OK, no arcs OK, depth within board OK')

if __name__ == '__main__':
    main()
