# xformer1001 — step-up input transformer (~600:23k line-to-grid, Z ratio 1:39)

*Larger, BLUE*

| | |
|---|---|
| **Ratio (turns)** | 1:6.24 (scope, 1 kHz, open: 146.22 mVpp -> 912 mVpp) |
| **DCR Low (ohm)** | 29 |
| **DCR High (ohm)** | 1950 |
| **Loaded Plateau (ohm)** | 1103 |
| **Load Used (ohm)** | 47000 |
| **Qty** | TBD |
| **Storage Location** | SMALL AUDIO TRANSFORMERS bin |
| **Date Logged** | 2026-09-12 |

**Intended use:** Passive +16 dB step-up ahead of a JFET/op-amp; dynamic-mic input

**Verdict:** Not for the Volt run (reflects 2.2k to ~50 ohm). Good mic/line-to-grid part

**Notes:** Phase crosses 0 at ~7.5 kHz (high-side self-capacitance). Scope ratio DONE 2026-09-12: n=6.24, agrees with the 47k-plateau upper bound (6.53) within 5%; implied core-loss shunt ~13k on the primary side. Unloaded sweep + phase marking still to do.

Full measurement write-up and AD3 sweep data: [spec.md](spec.md) (source: `engineering/transformers/xformer1001/`).

---
*Generated from `engineering/transformers.csv` by `gen-transformer-pages.py` — **do not edit by hand.** This page is the QR target for the unit. Last generated 2026-09-12.*
