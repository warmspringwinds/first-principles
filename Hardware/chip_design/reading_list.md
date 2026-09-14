# The Tile PPA Syllabus

68 verified papers for learning RTL-stage power/performance/area estimation, ordered as a learning path. Primary focus: **tile-level** estimation (predicting post-implementation PPA of a large hierarchical block — compute tile, core, chiplet — from its RTL). Secondary: module-level.

Web version: https://claude.ai/code/artifact/c8f64c0b-4387-4c5b-bcd4-23a219e4b8d6

**The whole field in one line:** `µarch spec → [RTL] → synthesis → netlist → place & route → [sign-off PPA]` — predict *from* RTL what you would only learn days of flow-runtime later.

## Fast path — 12 papers, in order

1. [Shift-Left Techniques in EDA: A Survey](https://arxiv.org/abs/2509.14551) (arXiv 2025)
2. [MasterRTL](https://arxiv.org/abs/2311.08441) (ICCAD 2023)
3. [SNS's Not a Synthesizer](https://dl.acm.org/doi/10.1145/3470496.3527444) (ISCA 2022)
4. [SNS v2](https://dl.acm.org/doi/10.1145/3613424.3623794) (MICRO 2023)
5. [RTL-Timer](https://dl.acm.org/doi/10.1145/3649329.3655671) (DAC 2024)
6. [CircuitSeer](https://dl.acm.org/doi/10.1145/3676536.3676668) (ICCAD 2024)
7. [PRIMAL](https://dl.acm.org/doi/10.1145/3316781.3317884) (DAC 2019)
8. [APOLLO](https://dl.acm.org/doi/10.1145/3466752.3480064) (MICRO 2021)
9. [Net2](https://arxiv.org/abs/2011.13522) (ASP-DAC 2021)
10. [Full-stack ML accelerator framework](https://arxiv.org/abs/2308.12120) (TODAES 2024)
11. [CircuitNet 2.0](https://openreview.net/forum?id=nMFSUjxMIl) (ICLR 2024)
12. [CircuitFusion](https://arxiv.org/abs/2505.02168) (ICLR 2025)

## 1. Orientation — surveys & the industrial view

- **[Shift-Left Techniques in EDA: A Survey](https://arxiv.org/abs/2509.14551)** — Wu et al., arXiv 2025. *Start here.* Maps everything that moves physical-design knowledge earlier: cross-stage PPA prediction, digital twins, AI-assisted estimation.
- **[Machine Learning for EDA: A Survey](https://arxiv.org/abs/2102.03357)** — Huang et al., TODAES 2021. The canonical 44-page survey, organized by design stage.
- **[MLCAD: A Survey of Research in ML for CAD](https://doi.org/10.1109/TCAD.2021.3124762)** — Rapp et al., TCAD 2021. Second taxonomy, organized by ML method rather than flow stage.
- **[A Survey of Circuit Foundation Model](https://arxiv.org/abs/2504.03711)** — Fang et al., TODAES 2025. 130+ works on circuit encoders/LLM decoders; the map for sections 2 and 7.
- **[RTL to Transistor Level Power Modeling: A Survey](https://ieeexplore.ieee.org/document/9120199/)** — Nasser et al., TCAD 2021. Classical RTL power estimation that ML methods build on.
- **[Accelerating Chip Design With Machine Learning](https://ieeexplore.ieee.org/document/9205654/)** — Khailany et al., IEEE Micro 2020. NVIDIA's account of where ML prediction lands in production flows.
- **[The Dawn of AI-Native EDA](https://arxiv.org/abs/2403.07257)** — Chen et al., 2024. Position paper behind the large-circuit-model wave.
- **[LLM4EDA](https://arxiv.org/abs/2401.12224)** — Zhong et al., 2023. Early LLM-in-EDA survey with the Awesome-LLM4EDA list. Optional.

## 2. The canon — PPA prediction from RTL

- **[MasterRTL](https://arxiv.org/abs/2311.08441)** ★ — Fang et al., ICCAD 2023. `RTL→syn`. Bit-level simple-operator graph mirroring the netlist; separate models for WNS/TNS/power/area; cross-design generalization. The core methodology reference.
- **[Transferable Presynthesis PPA Estimation](https://ieeexplore.ieee.org/document/10577671/)** — Fang et al., TCAD 2024. `RTL→place`. Journal extension of MasterRTL: augmentation + transfer, extending toward post-placement.
- **[RTL-Timer: Annotating Slack Directly on Your Verilog](https://dl.acm.org/doi/10.1145/3649329.3655671)** ★ — Fang et al., DAC 2024. `RTL→syn`. Per-register endpoint slack from RTL (>0.89 corr on unseen designs), annotated back onto the source.
- **[CircuitSeer](https://dl.acm.org/doi/10.1145/3676536.3676668)** ★ — Gandham et al. (UCF + Synopsys), ICCAD 2024. `RTL→P&R`. Post-place-and-route delay straight from pre-synthesis RTL.
- **[StructRTL](https://arxiv.org/abs/2508.18730)** — Liu et al., ICML 2026. `RTL→syn`. CDFG graph learning + distillation from netlists; structural graphs still beat LLM token embeddings for PPA.
- **[RTL-Sequencer](https://arxiv.org/abs/2607.15830)** — Guo et al., DAC 2026. `RTL→syn`. Linear-complexity sequence models over logic cones — the scalability answer for tile-sized designs.
- **[CircuitEncoder](https://dl.acm.org/doi/abs/10.1145/3658617.3697597)** — Fang et al., ASP-DAC 2025. `RTL⇄netlist`. Cross-stage-aligned self-supervised pre-training; short intro to the foundation-model approach.
- **[CircuitFusion](https://arxiv.org/abs/2505.02168)** ★ — Fang et al., ICLR 2025. `RTL→PPA`. Multimodal encoder + retrieval-augmented inference; retrieve-similar-known-circuits maps onto estimating a tile that resembles last generation's.

## 3. Tile-level — whole blocks, cores, and generators

- **[SNS's Not a Synthesizer](https://dl.acm.org/doi/10.1145/3470496.3527444)** ★ — Xu et al. (Duke), ISCA 2022. `RTL→syn`. Whole-core PPA from RTL, 100-1000× faster than Design Compiler; validated on BOOM.
- **[SNS v2](https://dl.acm.org/doi/10.1145/3613424.3623794)** ★ — Xu et al., MICRO 2023. `RTL→syn`. Self-supervised pre-training + domain adaptation → transfers with few labeled synthesis runs.
- **[APOLLO](https://dl.acm.org/doi/10.1145/3466752.3480064)** ★ — Xie et al. (Duke/Arm), MICRO 2021 Best Paper. `RTL→sign-off`. <0.05% of RTL signals as per-cycle power proxies on commercial Arm Neoverse N1 / Cortex-A77 (R²>0.94). Closest published analog to tile power estimation on silicon-class designs.
- **[An Open-Source ML-Based Full-Stack Optimization Framework](https://arxiv.org/abs/2308.12120)** ★ — Esmaeilzadeh, Kahng et al. (UCSD), TODAES 2024. `RTL→P&R`. Fit PPA models over a few implemented tile configs (Gemmini, VTA, GeneSys), then Bayesian-optimize the rest. The complete recipe, open source.
- **[Hierarchical Source-to-Post-Route QoR Prediction with GNNs](https://arxiv.org/abs/2401.08696)** — Gao et al., DATE 2024. `C→route`. Hierarchical GNN rolling module estimates up to block level, <10% error.
- **[MAGNet](https://ieeexplore.ieee.org/document/8942127/)** — Venkatesan et al. (NVIDIA), ICCAD 2019. Generator-based tile DSE with PPA-driven Bayesian tuning.
- **[FSGen](https://arxiv.org/abs/2608.09252)** — Mok et al., DAC 2026. Chisel LLM-accelerator tile generator + fast ML PPA estimators.
- **[Gemmini](https://arxiv.org/abs/1911.09925)** — Genc et al., DAC 2021 Best Paper. The standard open systolic-tile generator; infrastructure for ground-truth PPA.
- **[CLIPGen](https://arxiv.org/abs/2605.27757)** — Zhu, Rovinski (NYU), arXiv 2026. Chiplet die-to-die link IP with PPA estimates + real collateral (UCIe case study).

## 4. Power — the deep dive

Lineage: PRIMAL → GRANNITE → APOLLO/DEEP → ATLAS/LEAP.

- **[PRIMAL](https://dl.acm.org/doi/10.1145/3316781.3317884)** ★ — Zhou et al. (Cornell/NVIDIA), DAC 2019. `RTL→gate`. Per-block ML power models: <1% avg error at 15× speedup. The starting point.
- **[GRANNITE](https://ieeexplore.ieee.org/document/9218643/)** — Zhang et al. (NVIDIA), DAC 2020. `netlist`. GNN toggle propagation that transfers to unseen netlists (<5.5% error).
- **[Simmani](https://dl.acm.org/doi/10.1145/3352460.3358322)** — Kim et al. (Berkeley), MICRO 2019. Signal clustering → proxy regression at FPGA-emulation speed.
- **[DEEP](https://dl.acm.org/doi/10.1145/3508352.3549427)** — Xie et al., ICCAD 2022. Bit-granularity proxy selection; per-component breakdowns.
- **[ATLAS](https://arxiv.org/abs/2508.12433)** — Li et al. (HKUST), DAC 2025. `netlist→layout`. Per-cycle post-layout power per submodule, <1% total MAPE at >1000× over sign-off.
- **[LEAP](https://arxiv.org/abs/2608.01946)** — Li et al. (HKUST), DAC 2026. Learned toggle propagation (no event-driven sim) → layout power at ~4.6% error.
- **[GRASPE](https://ieeexplore.ieee.org/document/10181823/)** — IIT Hyderabad, ISCAS 2023. Gentle intro to RTL-graph → power with GNNs.

## 5. Timing, area & layout effects

Why early estimates miss: wires, congestion, and the flow fighting back.

- **[Pre-Routing Timing Prediction with Reduced Pessimism](https://dl.acm.org/doi/10.1145/3316781.3317857)** — Barboza et al., DAC 2019. The canonical framing: commercial pre-route timing is systematically pessimistic.
- **[Timing-Engine-Inspired GNN for Pre-Routing Slack](https://dl.acm.org/doi/10.1145/3489517.3530597)** — Guo, Lin et al., DAC 2022. STA-mimicking message passing; open code (TimingPredict).
- **[Optimization-Aware Pre-Routing Timing Prediction](https://ieeexplore.ieee.org/document/10473937/)** — He et al., ASP-DAC 2024. Models what the router's optimization will *fix* — model the tool, not just the design.
- **[Net2](https://arxiv.org/abs/2011.13522)** ★ — Xie et al., ASP-DAC 2021. `netlist→place`. Net lengths before placement, 1000× faster than placing; TCAD extension halves pre-placement WNS/TNS error.
- **[RouteNet](https://ieeexplore.ieee.org/document/8587655)** — Xie et al., ICCAD 2018. CNN routability/DRC-hotspot prediction for macro-heavy mixed-size designs — the SRAM-inside-tile regime.
- **[CongestionNet](https://ieeexplore.ieee.org/document/8920342/)** — Kirby et al. (NVIDIA), VLSI-SoC 2019. Congestion hotspots from the netlist alone, pre-placement.
- **[QoR Prediction with Transformer + GNN](https://arxiv.org/abs/2207.11437)** — Yang et al., arXiv 2022. The synthesis-recipe dimension of PPA.
- **[HLS QoR Estimation with ML](https://doi.org/10.1109/FCCM.2018.00029)** — Dai et al., FCCM 2018. The classic calibration paper; the feature-engineering method transfers to ASIC modules.

## 6. Pre-RTL context — good to know

- **[Wattch](https://dl.acm.org/doi/10.1145/342001.339657)** — ISCA 2000. Where activity×capacitance power modeling began.
- **[McPAT](https://dl.acm.org/doi/10.1145/1669112.1669172)** — MICRO 2009. Analytical whole-core PPA; its calibration pitfalls motivate RTL-stage estimation.
- **[CACTI 7](https://dl.acm.org/doi/10.1145/3085572)** — TACO 2017. The SRAM/DRAM models inside nearly every estimator; SRAMs dominate real tiles.
- **[Aladdin](https://ieeexplore.ieee.org/document/6853196/)** — ISCA 2014. Pre-RTL accelerator PPA from C dependence graphs.
- **[Timeloop](https://ieeexplore.ieee.org/document/8695666)** — ISPASS 2019 + **[Accelergy](https://ieeexplore.ieee.org/document/8942149)** — ICCAD 2019. The standard mapper + compositional-energy pair; the hierarchical roll-up mindset.
- **[MAESTRO](https://arxiv.org/abs/1805.02566)** — MICRO 2019. Closed-form dataflow reuse → latency/energy/area.
- **[SCALE-Sim](https://arxiv.org/abs/1811.02883)** — arXiv 2018. Systolic-array simulation for pre-RTL tile sizing.
- **[CiMLoop](https://arxiv.org/abs/2405.07259)** — ISPASS 2024 Best Paper. Value-aware energy for compute-in-memory.
- **[McPAT-Calib](https://ieeexplore.ieee.org/document/9761982)** — TCAD 2023. McPAT + ML calibration + active learning on BOOM configs, open source.
- **[PANDA](https://arxiv.org/abs/2312.08994)** — ICCAD 2023. Analytical + ML correction: accurate power from a handful of training designs — the data-scarcity answer.
- **[FirePower](https://arxiv.org/abs/2410.17789)** — ASP-DAC 2025. Few-shot transfer to a new architecture generation (5.8% error from two labeled configs).
- **[BOOM-Explorer](https://ieeexplore.ieee.org/document/9643455)** — ICCAD 2021 Best Paper. Uncertainty-aware DSE with GP surrogates — what makes point-estimate PPA models decision-grade.

## 7. LLM era

- **[MetRex](https://arxiv.org/abs/2411.03471)** — Abdelatty et al. (Brown), ASP-DAC 2025. 25,868 Verilog modules with post-synthesis PPA labels; *the* LLM metric-reasoning benchmark.
- **[The Graph's Apprentice / VeriDistill](https://arxiv.org/abs/2411.00843)** — Moravej et al. (Huawei), IJCAI 2025. LLM over Verilog distilled from a netlist GNN: R² 0.87 area.
- **[TimingLLM](https://arxiv.org/abs/2604.23602)** — Abdollahi et al. (USC), arXiv 2026. Retrieval-augmented WNS/TNS prediction + released 60k-module dataset.
- **[RTLRewriter](https://arxiv.org/abs/2409.11414)** — Yao et al., ICCAD 2024. Partition-then-optimize LLM rewriting — one of few LLM works beyond single modules.
- **[ChipSeek](https://arxiv.org/abs/2507.04736)** — ICT CAS, ACL 2026. RL for Verilog LLMs with rewards from simulators + synthesis PPA.
- **[COEVO](https://arxiv.org/abs/2604.15001)** — USC, arXiv 2026. Pareto co-evolution of correctness + area/delay/power.
- **[Dr. RTL](https://arxiv.org/abs/2604.14989)** — Fang et al. (HKUST), arXiv 2026. Agentic tool-grounded RTL optimization (21%/17% WNS/TNS gains) — estimation's endgame: acting on it.
- **[GenEDA](https://arxiv.org/abs/2504.09485)** — Fang et al., ICCAD 2025. Circuit encoders aligned with LLM decoders.

## 8. Datasets — where to get your hands dirty

- **[CircuitNet](https://arxiv.org/abs/2208.01040)** — SCIS 2022. 10K+ commercial-flow samples of RISC-V designs; the default practice dataset.
- **[CircuitNet 2.0](https://openreview.net/forum?id=nMFSUjxMIl)** ★ — ICLR 2024. CPU/GPU/AI-chip designs through full commercial flows at 14nm with timing/power labels — the closest public proxy to tile-scale estimation.
- **[EDALearn](https://arxiv.org/abs/2312.01674)** — ICCAD 2024. RTL-to-signoff with per-stage data — study how accuracy degrades the earlier you predict.
- **[OpenABC-D](https://arxiv.org/abs/2110.11292)** — NYU 2021. 870K labeled AIGs from 1,500 synthesis recipes.
- **[ForgeEDA](https://arxiv.org/abs/2505.02016)** — CUHK 2025. Aligned RTL/netlist/AIG/placed views of the same designs.
- **[DeepCircuitX](https://arxiv.org/abs/2502.18297)** — CUHK 2025. Repository-to-module RTL corpus with PPA labels.
- **[ICCAD 2023 Contest Problem C (IR drop)](https://ieeexplore.ieee.org/document/10323767)** — ASU 2023. The pretrain-synthetic/fine-tune-real template for data-scarce ML-EDA.

## What the literature still doesn't cover well

1. **Layout effects at tile scale** — no single model yet goes RTL-in → sign-off-out with congestion and macro effects included; CircuitSeer and ATLAS are closest.
2. **Uncertainty** — nearly everything emits point estimates; BOOM-Explorer is the lone verified treatment of calibrated uncertainty.
3. **Industrial deployment accounts** — APOLLO (Arm) and NVIDIA's IEEE Micro paper are the main published records; expect to learn the rest by doing.

---
*68 papers · every entry web-verified (title, venue, link) · compiled September 2026*
