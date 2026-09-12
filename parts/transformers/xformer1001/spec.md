# xformer1001 — step-up input transformer (~1 : 6.5), larger, BLUE

*Characterised 2026-09-12 on the AD3 (WaveForms Impedance Analyzer). From the SMALL AUDIO TRANSFORMERS batch.*


## Measured

- **DCR: 29 Ω (low side) / 1.95 kΩ (high side).** A step-up; the DCR ratio is inflated by finer wire on
  the high side.

- **Loaded sweep, 47 kΩ across the high side, driving the 29 Ω side, Rref 1 kΩ:**

  | f | \|Z\| | Rs | Xs | phase |
  |---|---|---|---|---|
  | 20 Hz | 75 Ω | 41 | 63 | 57° |
  | 300 Hz | 612 Ω | 433 | 432 | 45° |
  | 1 kHz | 929 Ω | 851 | 372 | 24° |
  | 3 kHz | 1074 Ω | 1059 | 180 | 10° |
  | 5.5 kHz | **1103 Ω** (plateau) | 1102 | 47 | 2° |
  | 10 kHz | 1073 Ω | 1071 | −58 | −3° |
  | 20 kHz | 889 Ω | 880 | −124 | −8° |

- **Reflected load plateau ≈ 1.1 kΩ.** With 47 kΩ on the high side that gives **n ≈ 6.5** (upper
  bound — any core-loss shunt makes the true n slightly smaller), i.e. an impedance ratio of about
  **1 : 43**.

- **Phase crosses zero at ~7.5 kHz** and goes capacitive above it: the high-Z winding's
  self-capacitance reflected to the primary. Mild HF roll-off; irrelevant in the voice band.

- **Primary magnetising inductance ≳ 0.5 H** (from Xs at 20 Hz; lower bound with DCR folded in).


## What it is

The ratio is the textbook **600 Ω : 25 kΩ line-to-grid** value (1 : 6.45). Low-Z line or mic source
into a tube grid or JFET gate, giving the first ~16 dB of gain for free and noiselessly. DCR of both
windings fits that identity. Size and colour (larger, blue) are consistent with a classic UTC /
Triad / Stancor input transformer, possibly mu-metal cased.

Equivalent framings: 150 Ω : 6.4 kΩ · 200 Ω : 8.6 kΩ · 600 Ω : 26 kΩ.


## Loss from a real source into 47 kΩ (primary-side divider)

| source | 300 Hz | 1 kHz | 3 kHz | tilt |
|---|---|---|---|---|
| 150 Ω | −1.9 dB | −1.3 dB | −1.1 dB | 0.8 dB |
| 600 Ω | −5.9 dB | −4.3 dB | −3.9 dB | 2.1 dB |

Driven from a 600 Ω source it sags at the low end — it wants a lower source impedance than its
nominal, or a higher load than 47 kΩ. From a 150 Ω source it is nearly flat.


## Use

- Passive step-up (~+16 dB) ahead of a JFET or op-amp stage from a low-Z source.
- Dynamic-mic input transformer.
- **Not** for the micamp → Volt run: reflects the Volt's 2.2 kΩ down to ~50 Ω on the micamp's 150 Ω
  output. xformer1000 (the 1:1) is that part.


## Still to measure

- **Turns ratio on the scope** (1 kHz, high side open) — independent check on n ≈ 6.5.
- **Unloaded sweep** of the 29 Ω side, for the true magnetising impedance.
- **In-phase lead pair** — mark it.
- **Count** in the batch.


## Files

- `2026-09-12-loaded-47k-Z-Rs-Xs-phase.csv` — |Z|, Rs, Xs, phase; 20 Hz–20 kHz, 60 steps.
- `2026-09-12-loaded-47k-phase.csv` — phase only (duplicate of the phase column above).

Setup: WaveForms Impedance Analyzer, `W1-C1-R-C2-DUT-GND`, Rref 1 kΩ, 1 V, no compensation.
