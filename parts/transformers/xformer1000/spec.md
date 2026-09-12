# xformer1000 — 1:1 audio isolation transformer, subminiature, YELLOW

*Characterised 2026-09-12.*

*Subminiature, yellow. One unit from the unsorted batch in the SMALL AUDIO TRANSFORMERS bin. Measured by Bill on the
Analog Discovery 3 with WaveForms' Impedance Analyzer; analysed in this session. This is the
transformer for the dcrx micamp → Volt balanced/isolated run.*


## Measured

- **Turns ratio: 1 : 1** (scope, 1 kHz, secondary open). Secondary read inverted relative to the
  primary *as clipped* — that is lead choice, not a property; swap the secondary leads for in-phase.
  Mark the in-phase lead pair before it goes back in the bin.

- **DCR: 16 Ω / 20 Ω.** Near-equal, consistent with 1:1.

- **Unloaded |Z| of the primary** (secondary open): 108 Ω @ 20 Hz · 400 Ω @ 100 Hz · 848 Ω @ 300 Hz ·
  1.75 kΩ @ 1 kHz · 3.05 kΩ @ 3 kHz · 7.5 kΩ @ 20 kHz. Rises roughly as √f, not f — a large share of
  the impedance is core loss (eddy current), normal for a small laminated core. "L ≈ 280 mH @ 1 kHz"
  is therefore an upper bound, not the inductance.

- **Loaded |Z|** (2.2 kΩ across the secondary, standing in for the Volt mic input): 673 Ω @ 300 Hz ·
  1.09 kΩ @ 1 kHz · 1.40 kΩ @ 3 kHz · 1.79 kΩ @ 20 kHz. Phase 46° → 20° across the passband.
  HF resistive asymptote ~1.76 kΩ vs the 2.2 kΩ load implies a core-loss shunt of roughly 9 kΩ
  (or a ratio nearer 1 : 1.1 — the scope said 1:1, so core loss is the better read). Half a dB either way.


## What it means for the micamp → Volt run

Modelled as 150 Ω source (micamp `R_ser`) → transformer → 2.2 kΩ load:

| f | loss |
|---|---|
| 300 Hz | −1.75 dB |
| 1 kHz | −1.12 dB |
| 3 kHz | −0.88 dB |

- **Insertion loss ≈ 1 dB at band centre; tilt across 300 Hz–3 kHz = 0.86 dB.** Against 50.9 dB of
  gain that is nothing.

- Below 300 Hz it rolls off — the micamp's 340 Hz low-cut is already doing that on purpose.

- It is a **small-signal 1:1, 600 Ω class**, profile very much like a telecom / modem line-isolation
  transformer (built for the 300–3400 Hz voice band — which is the receiver's passband).


## Decision

**The XLR build goes transformer-balanced, not impedance-balanced.** Secondary floats: pin 2 and
pin 3 across the secondary, pin 1 to shield only. Galvanic isolation between amp and Volt, true
floating balanced output, and the ground loop the noise hunt parked on no longer has a path.
This is the "one part solves both" option from the 2026-08-16 restart brief — with the part already
on the shelf.


## Files

- `2026-09-12-unloaded-Z.csv` — primary |Z|, secondary open, 20 Hz–20 kHz, 60 steps, Rref 1 kΩ.
- `2026-09-12-loaded-2k2-Z-Rs-Xs.csv` — same sweep with 2.2 kΩ on the secondary; |Z|, Rs, Xs.
- `2026-09-12-loaded-2k2-phase.csv` — phase for the loaded sweep.

Setup: WaveForms Impedance Analyzer, circuit `W1-C1-R-C2-DUT-GND`, Rref = 1 kΩ, 1 V amplitude,
no compensation. Bare AD3 without the impedance adapter — expect ~5–10 % absolute accuracy, which is
plenty for this.


## Still open

- **Count.** Bill tests the rest of the batch; how many of these there are is unknown as of 2026-09-12.
- **Marking.** No case marking recorded yet — needed to tell this type from its siblings in the bin.
