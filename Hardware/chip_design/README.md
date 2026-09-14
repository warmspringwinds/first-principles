# Chip design: from RTL to silicon

You write a few dozen lines of RTL. Months later a physical object made of ~10¹⁰ switches
either runs at the promised frequency or it doesn't. These notebooks build a working model
of *everything in between* — the physics, the design flow, the tools, the economics — and
then run a complete flow, stage by stage, on one small block you can see every gate and
every wire of.

## The two notebooks

| read this if you want | notebook |
|---|---|
| The concepts, from physics up: why gates have delay, why registers exist, what synthesis, placement and routing compute, what Synopsys/Cadence/Siemens sell, what the open-source stack can do, why chiplets exist, what a 2 nm wafer costs — every claim either derived in a runnable cell or read out of a real standard-cell library | [`hardware_design_from_first_principles.ipynb`](hardware_design_from_first_principles.ipynb) |
| The process, watched: one 4-bit multiply-accumulate unit pushed through RTL → simulation → synthesis → floorplan → placement → clock tree → routing → extraction → signoff timing → power → LVS/DRC → GDSII, with the artifact of every stage drawn; then timing closure (ECOs, then pipelining), and a section on **PPA estimation** — why it is done, from which stage the numbers can be predicted and how precisely (measured on a dataset of RTL variants against the flow's own noise floor), and module-level vs tile-level estimation, demonstrated on a mini-tile | [`rtl_to_gds_visualized.ipynb`](rtl_to_gds_visualized.ipynb) |

The second notebook is the one to open if you want to *see* a chip being made; the first
explains why each stage exists and what it costs at scale. Both are inspired by
[physical-intuition/kimi-chip](https://github.com/physical-intuition/kimi-chip), an LLM
meta-harness that pushed a MAC array from 100 MHz to ~1 GHz with the same open tools and
library used here; its iteration history is replayed as data in both notebooks.
[`reading_list.md`](reading_list.md) is the companion syllabus for RTL-stage PPA
estimation (68 papers, ordered as a learning path).

## What is real and what is a toy

The flow notebook runs the actual open-source tools where they exist and readable Python
where the real tools are proprietary or too large to explain:

- **Real:** [Icarus Verilog](https://github.com/steveicarus/iverilog) simulates the RTL
  (the waveforms are drawn from the VCD it writes); [Yosys](https://github.com/YosysHQ/yosys)
  + ABC elaborate and synthesize it to the **Nangate45** open standard-cell library, whose
  Liberty timing tables (downloaded from
  [OpenROAD-flow-scripts](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts)
  on first run) drive every timing number; the routing grid, wire widths and via rules
  come from the same library's tech LEF.
- **Toy, in plain Python, each short enough to read in full:** a Liberty parser and
  graph-based static timing analyzer with bilinear NLDM interpolation, a simulated-annealing
  placer, a two-level clock tree, a maze router on the real metal2/metal3 track grid with
  rip-up-and-reroute and PathFinder-style negotiated congestion, parasitic extraction to a
  valid SPEF, power from gate-level toggle activity, geometry-based LVS, a via-spacing DRC
  rule, and a GDSII writer (KLayout opens the result).
- **Honestly omitted** (named in the text): hold timing, multi-corner and on-chip-variation
  analysis, DFT/scan, IR drop, crosstalk, metal fill, cell-internal power.

The flow is deterministic: the same seed reproduces every number bit for bit, which is
what makes the seed-to-seed noise floor in the PPA-estimation section a real measurement.

## Headline results

- **The gate-level netlist of a 4-bit MAC is 128 Nangate45 cells and 173 µm²**, with a
  13-gate critical path from an input through the multiplier and the carry chain into the
  accumulator. Its pre-layout timing meets 1 GHz with 94 ps to spare; after placement,
  routing and extraction it misses by 5 ps — the everyday post-layout surprise, caused by
  the ~30% of load capacitance that wires add and synthesis cannot see.
- **ECOs close small misses, not structural ones**: upsizing 13 cells on the critical path
  recovers the 1 GHz target for 4% area; pushed to 800 ps, sizing stalls 60 ps short and
  the fix has to be made in the RTL. Registering the product (the kimi-chip "X5" move)
  meets 800 ps at 1.24× area — the entire flow re-runs on the new RTL in seconds.
- **The estimation ladder, measured across twelve RTL variants**: post-synthesis timing
  with pin loads only is 15% optimistic (but ranks designs perfectly); a 1990s wireload
  model brings that to 4%; placement-aware wire estimates to 2%; power goes from 36% to
  6% error along the same rungs; area is known at synthesis. A leave-one-out linear model
  on word-level RTL features predicts area to 3%, power to 15% and fmax to 19% — timing is
  the hard target, and the one miss is traced to a hand-written operator delay model, which
  is why real RTL-stage models learn from the bit-level graph.
- **Module vs tile, demonstrated**: four `mac2` modules plus a reduction adder tree form a
  206-cell mini-tile that runs at 1271 MHz where the module alone runs at 2053. A hierarchical
  roll-up (4 × the module + the glue synthesized on its own) accounts for the cells and area
  exactly and still misses the tile — fmax by 28%, power by 11%, wirelength by 58% — because
  the critical path crosses a module boundary, the modules' own internal nets stretch 2.6×
  once placed among neighbours, and one clock tree spans everything. That residual is what
  tile-level estimation is about; the modules are the easy part.
- **The label-noise floor**: the same RTL through the same flow with four placement seeds
  moves fmax by 1.6% and power by 1.1%. An estimator that "beats" this is fitting the seed.

## Reproducing

Reading requires nothing — all outputs are embedded. To re-execute the concepts notebook:

```
pip install numpy scipy matplotlib jupyterlab
```

The flow notebook additionally wants the two open-source tools (macOS/Homebrew shown;
Linux package managers carry both):

```
brew install yosys icarus-verilog
```

Without them it falls back to the saved netlists and waveform in
[`flow_artifacts/`](flow_artifacts/) and says so; with them, every stage runs live, the
full notebook takes ~5 minutes on a laptop CPU (the twelve-design dataset is most of it),
and it writes its own SPEF, GDSII, timing reports and netlists into that folder.
