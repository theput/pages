#!/usr/bin/env python3
"""
render-figures.py - regenerate every Mims figure in the repo.

Finds every  **/figures/src/*.py , runs it from its figures/ directory with
assets/mims on the path, so each script writes its SVG next to the others:

    lab/rockmite-40m/figures/src/pa-lpf.py  ->  lab/rockmite-40m/figures/pa-lpf.svg

Run from anywhere in the repo:  python3 assets/mims/render-figures.py
push.sh calls this before committing, so pushed SVGs always match their scripts.
"""
import os
import subprocess
import sys

mims_dir = os.path.dirname(os.path.abspath(__file__))
root = os.path.dirname(os.path.dirname(mims_dir))        # assets/mims -> repo root
env = dict(os.environ, PYTHONPATH=mims_dir + os.pathsep + os.environ.get("PYTHONPATH", ""))

n = 0
for dirpath, dirnames, filenames in os.walk(root):
    if ".git" in dirpath or "_site" in dirpath:
        continue
    if os.path.basename(dirpath) == "src" and os.path.basename(os.path.dirname(dirpath)) == "figures":
        figdir = os.path.dirname(dirpath)
        for f in sorted(filenames):
            if f.endswith(".py"):
                rel = os.path.relpath(os.path.join(dirpath, f), root)
                r = subprocess.run([sys.executable, os.path.join("src", f)], cwd=figdir, env=env)
                print(("ok   " if r.returncode == 0 else "FAIL ") + rel)
                n += 1
print(f"{n} figure(s)")
