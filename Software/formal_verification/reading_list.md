# The Formal Verification Syllabus

75 verified sources for learning formal verification, ordered as a learning path: from why testing cannot show absence, through the logic and the solvers underneath every tool (SAT, SMT), program logics, symbolic execution and bounded model checking, model checking, abstract interpretation and proof assistants, to the systems that were actually verified, the industrial reports, and the 2020–2026 wave of LLM provers. Primary focus: **software** (with a two-paper hardware coda). The companion notebook, [formal_verification_from_first_principles.ipynb](formal_verification_from_first_principles.ipynb), is the **build-it-yourself prequel**: it builds a readable toy of each technique (a CDCL solver, a bit-blaster, a symbolic executor, a VC generator, an explicit-state model checker, k-induction and IC3, an interval analyzer, an LCF kernel), so most papers below read as the industrial version of something you have already run. The tag after each entry names the notebook section it connects to: the one that builds the toy version, or the one that uses the result.

**The whole field in one line:** `program + spec → [VCs | transition system | abstract domain | proof term] → solver or kernel → certificate or counterexample → independent re-check` — prove *for every input* what a test suite can only sample.

## Fast path — 12 papers, in order

1. [How Amazon Web Services Uses Formal Methods](https://doi.org/10.1145/2699417) (Communications of the ACM 2015)
2. [Extra, Extra - Read All About It: Nearly All Binary Searches and Mergesorts are Broken](https://research.google/blog/extra-extra-read-all-about-it-nearly-all-binary-searches-and-mergesorts-are-broken/) (Google Research Blog 2006)
3. [An Extensible SAT-solver (MiniSat)](https://doi.org/10.1007/978-3-540-24605-3_37) (SAT 2003; LNCS 2919, published 2004)
4. [An Axiomatic Basis for Computer Programming](https://doi.org/10.1145/363235.363259) (Communications of the ACM 1969)
5. [Dafny: An Automatic Program Verifier for Functional Correctness](https://doi.org/10.1007/978-3-642-17511-4_20) (LPAR-16 2010)
6. [KLEE: Unassisted and Automatic Generation of High-Coverage Tests for Complex Systems Programs](https://www.usenix.org/conference/osdi-08/klee-unassisted-and-automatic-generation-high-coverage-tests-complex-systems) (OSDI 2008)
7. [Model Checking: Algorithmic Verification and Debugging](https://doi.org/10.1145/1592761.1592781) (Communications of the ACM 2009; Turing Award lecture)
8. [Scaling Static Analyses at Facebook](https://doi.org/10.1145/3338112) (Communications of the ACM 2019)
9. [Propositions as Types](https://doi.org/10.1145/2699407) (Communications of the ACM 2015)
10. [seL4: Formal Verification of an OS Kernel](https://doi.org/10.1145/1629575.1629596) (SOSP 2009)
11. [An Empirical Study on the Correctness of Formally Verified Distributed Systems](https://doi.org/10.1145/3064176.3064183) (EuroSys 2017)
12. [A Benchmark for Vericoding: Formally Verified Program Synthesis](https://arxiv.org/abs/2509.22908) (arXiv 2025; Dafny 2026 workshop at POPL 2026)

## 1. Orientation & surveys

- **[The Humble Programmer (EWD 340)](https://www.cs.utexas.edu/~EWD/transcriptions/EWD03xx/EWD340.html)** — E. W. Dijkstra, ACM Turing Award Lecture, CACM 1972. `§1`. Start of the long path. Dijkstra's Turing lecture repeats the testing-shows-presence-not-absence line (the notebook's §1 thesis, first written in EWD249) and makes the case for proofs; short, and still the best one.
- **[Formal Methods: Practice and Experience](https://doi.org/10.1145/1592434.1592436)** — J. Woodcock, P. G. Larsen, J. Bicarregui, J. Fitzgerald, ACM Computing Surveys 2009. `§12.3`. The industrial census before the cloud era: 62 projects that used formal methods, what for, and what they reported it cost (self-reported, so biased toward successes).
- **[QED at Large: A Survey of Engineering of Formally Verified Software](https://arxiv.org/abs/2003.06458)** — T. Ringer, K. Palmskog, I. Sergey, M. Gligoric, Z. Tatlock, Foundations and Trends in Programming Languages 2019. `§12.2`. The map of proof engineering (183 pages): how large verified systems are built and maintained. Read the intro and the case studies; keep the rest as reference.

## 2. Logic & computability

- **[On Computable Numbers, with an Application to the Entscheidungsproblem](https://doi.org/10.1112/plms/s2-42.1.230)** — A. M. Turing, Proc. London Mathematical Society 1936 (vol. 42, issue dated 1937). `§2.4`. Where undecidability starts. Read the diagonal argument; §2.4's proof of Rice's theorem reduces to it. Skip the machine tables.
- **[Classes of Recursively Enumerable Sets and Their Decision Problems](https://doi.org/10.1090/S0002-9947-1953-0053041-6)** — H. G. Rice, Transactions of the AMS 1953. `§2.4`. Rice's theorem: every non-trivial semantic property is undecidable. The reason every tool on this list gives up soundness, completeness or automation (§2.4).
- **[The Complexity of Theorem-Proving Procedures](https://doi.org/10.1145/800157.805047)** — S. A. Cook, STOC 1971. `§3.2`. SAT is NP-complete. The result that makes 'just ask the SAT solver' sound hopeless, and the background for why industrial solvers working anyway is surprising.

## 3. SAT & SMT

Lineage: DPLL → GRASP's clause learning → Chaff's engineering → MiniSat → certified UNSAT proofs; an SMT solver puts theories on top.

- **[A Machine Program for Theorem-Proving](https://doi.org/10.1145/368273.368557)** — M. Davis, G. Logemann, D. Loveland, Communications of the ACM 1962. `§3.2`. DPLL: unit propagation, branching, backtracking. Every solver in this section is a refinement of this procedure.
- **[GRASP: A Search Algorithm for Propositional Satisfiability](https://doi.org/10.1109/12.769433)** — J. P. Marques-Silva, K. A. Sakallah, IEEE Transactions on Computers 1999. `§3.2`. Conflict analysis, clause learning and non-chronological backjumping: the step from DPLL to CDCL that the notebook's implication-graph figure draws.
- **[Chaff: Engineering an Efficient SAT Solver](https://doi.org/10.1145/378239.379017)** — M. W. Moskewicz, C. F. Madigan, Y. Zhao, L. Zhang, S. Malik, DAC 2001. `§3.2`. Two-watched literals, VSIDS and restarts: the engineering that made CDCL industrial. Short and concrete.
- **[An Extensible SAT-solver (MiniSat)](https://doi.org/10.1007/978-3-540-24605-3_37)** ★ — N. Eén, N. Sörensson, SAT 2003 (LNCS 2919, published 2004). `§3.2`. The readable reference implementation. Compare it line by line with the notebook's `cdcl()`.
- **[Solving and Verifying the Boolean Pythagorean Triples Problem via Cube-and-Conquer](https://arxiv.org/abs/1605.00723)** — M. J. H. Heule, O. Kullmann, V. W. Marek, SAT 2016. `§3.7`. An UNSAT answer is a claim; a DRAT proof (almost 200 TB here) is the certificate. Why 'don't trust the solver, check the proof' scales.
- **[Z3: An Efficient SMT Solver](https://doi.org/10.1007/978-3-540-78800-3_24)** — L. de Moura, N. Bjørner, TACAS 2008. `§4.5`. The short tool paper for the solver this notebook uses as ground truth: a SAT core plus cooperating theory solvers.
- **[Provably Correct Peephole Optimizations with Alive](https://doi.org/10.1145/2737924.2737965)** — N. P. Lopes, D. Menendez, S. Nagarakatte, J. Regehr, PLDI 2015. `§4.3`. SMT proves LLVM peephole rewrites correct for all inputs, at every feasible type assignment up to a width bound; translating more than 300 InstCombine rewrites found 8 wrong. The industrial version of §4.3's `x / 2` vs `x >> 1` demo.

## 4. Program logics & deductive verification

- **[An Axiomatic Basis for Computer Programming](https://doi.org/10.1145/363235.363259)** ★ — C. A. R. Hoare, Communications of the ACM 1969. `§6.1`. Turns 'is this program right?' into a proof obligation {P} C {Q}; the rules the notebook's VC generator implements, plus the three alternative axioms for machine-integer overflow that §2's semantics choose between.
- **[Guarded Commands, Nondeterminacy and Formal Derivation of Programs](https://doi.org/10.1145/360933.360975)** — E. W. Dijkstra, Communications of the ACM 1975. `§6.2`. Weakest preconditions: push the postcondition backwards through the program. The calculus vcgen() mechanizes.
- **[Extra, Extra - Read All About It: Nearly All Binary Searches and Mergesorts are Broken](https://research.google/blog/extra-extra-read-all-about-it-nearly-all-binary-searches-and-mergesorts-are-broken/)** ★ — J. Bloch, Google Research Blog 2006. `§1`. The `(low + high) / 2` overflow that sat in the JDK's binary search for about nine years: the midpoint bug every technique in the notebook attacks.
- **[Separation Logic](https://doi.org/10.1145/3211968)** — P. W. O'Hearn, Communications of the ACM 2019. `§7.2`. Reasoning about pointers by local footprints; the logic under Infer and most heap verifiers. The readable overview of Reynolds' LICS 2002 paper.
- **[Dafny: An Automatic Program Verifier for Functional Correctness](https://doi.org/10.1007/978-3-642-17511-4_20)** ★ — K. R. M. Leino, LPAR-16 2010. `§6.7`. Specs, loop invariants and termination measures in a real language, discharged automatically by an SMT solver: the notebook's VC generator, grown up.
- **[Verus: A Practical Foundation for Systems Verification](https://doi.org/10.1145/3694715.3695952)** — A. Lattuada et al., SOSP 2024. `§11`. SMT-based proofs for Rust, evaluated on page tables, allocators and distributed systems: the current practical frontier for verifying systems code.

## 5. Symbolic execution, BMC & fuzzing

- **[Symbolic Execution and Program Testing](https://doi.org/10.1145/360248.360252)** — J. C. King, Communications of the ACM 1976. `§5.2`. Run the program on symbols, fork at branches, collect path conditions: the notebook's symex() in its original form.
- **[KLEE: Unassisted and Automatic Generation of High-Coverage Tests for Complex Systems Programs](https://www.usenix.org/conference/osdi-08/klee-unassisted-and-automatic-generation-high-coverage-tests-complex-systems)** ★ — C. Cadar, D. Dunbar, D. Engler, OSDI 2008. `§5.2`. Symbolic execution on real C utilities with solver-generated tests; the paper to read for what path explosion looks like in practice.
- **[An Empirical Study of the Reliability of UNIX Utilities](https://doi.org/10.1145/96267.96279)** — B. P. Miller, L. Fredriksen, B. So, Communications of the ACM 1990. `§5.5`. The birth of fuzzing: random input crashes standard utilities. The cheap baseline every formal method has to beat.
- **[Symbolic Model Checking without BDDs](https://doi.org/10.1007/3-540-49059-0_14)** — A. Biere, A. Cimatti, E. Clarke, Y. Zhu, TACAS 1999. `§5.3`. Bounded model checking: unroll k steps into one SAT query. The idea behind CBMC, Kani and the notebook's bmc().
- **[A Tool for Checking ANSI-C Programs (CBMC)](https://doi.org/10.1007/978-3-540-24730-2_15)** — E. Clarke, D. Kroening, F. Lerda, TACAS 2004. `§5.3`. CBMC: bit-precise BMC for real C. Still an industrial workhorse two decades later.
- **[Verifying Dynamic Trait Objects in Rust (Kani)](https://doi.org/10.1145/3510457.3513031)** — A. VanHattum, D. Schwartz-Narbonne, N. Chong, A. Sampson, ICSE-SEIP 2022. `§5.3`. Kani, the bit-precise model checker for Rust; start here if you write Rust and want proofs from cargo.

## 6. Model checking

Lineage: temporal logic → explicit-state checking → BDDs → SAT-based bounded model checking → IC3.

- **[The Temporal Logic of Programs](https://doi.org/10.1109/SFCS.1977.32)** — A. Pnueli, FOCS 1977. `§8.3`. LTL: 'always', 'eventually' and the safety/liveness split behind the notebook's lasso counterexamples.
- **[Model Checking: Algorithmic Verification and Debugging](https://doi.org/10.1145/1592761.1592781)** ★ — E. M. Clarke, E. A. Emerson, J. Sifakis, Communications of the ACM 2009 (Turing Award lecture). `§8`. The inventors' own account of model checking from temporal logic to SAT-based methods; the best single entry point.
- **[Graph-Based Algorithms for Boolean Function Manipulation](https://doi.org/10.1109/TC.1986.1676819)** — R. E. Bryant, IEEE Transactions on Computers 1986. `§8.7`. ROBDDs: canonical shared Boolean functions, and why variable ordering decides between linear and exponential size (the notebook's BDD plot).
- **[Symbolic Model Checking: 10^20 States and Beyond](https://doi.org/10.1016/0890-5401(92)90017-A)** — J. R. Burch, E. M. Clarke, K. L. McMillan, D. L. Dill, L. J. Hwang, Information and Computation 1992 (LICS 1990). `§8.7`. BDDs plus fixpoints: model checking without enumerating states. The paper that made state explosion negotiable.
- **[SAT-Based Model Checking without Unrolling (IC3)](https://doi.org/10.1007/978-3-642-18275-4_7)** — A. R. Bradley, VMCAI 2011. `§8.6`. IC3/PDR: build an inductive invariant one clause at a time. Reshaped hardware model checking, and shows how invariants can be found rather than supplied.

## 7. Abstract interpretation & static analysis

- **[Abstract Interpretation: A Unified Lattice Model for Static Analysis of Programs by Construction or Approximation of Fixpoints](https://doi.org/10.1145/512950.512973)** — P. Cousot, R. Cousot, POPL 1977. `§9.1`. The founding paper: lattices, Galois connections, widening. Dense; read it after the notebook has shown you an interval analyzer.
- **[The Octagon Abstract Domain](https://doi.org/10.1007/s10990-006-8609-1)** — A. Miné, Higher-Order and Symbolic Computation 2006. `§9.5`. Relational invariants of the form ±x ± y ≤ c: the fix for the interval domain's false alarm, and part of Astrée.
- **[A Static Analyzer for Large Safety-Critical Software (Astrée)](https://doi.org/10.1145/781131.781153)** — B. Blanchet, P. Cousot, R. Cousot, J. Feret, L. Mauborgne, A. Miné, D. Monniaux, X. Rival, PLDI 2003. `§9.6`. Abstract interpretation tuned until it proves absence of run-time errors in synchronous flight-control code with few or no false alarms.
- **[Scaling Static Analyses at Facebook](https://doi.org/10.1145/3338112)** ★ — D. Distefano, M. Fähndrich, F. Logozzo, P. W. O'Hearn, Communications of the ACM 2019. `§9.6`. Infer and Zoncolan at Facebook scale (Zoncolan alone covers over 100 million lines of Hack): why reporting at code-review time, not soundness, decided adoption (§9.6).
- **[A Few Billion Lines of Code Later: Using Static Analysis to Find Bugs in the Real World](https://doi.org/10.1145/1646353.1646374)** — A. Bessey et al., Communications of the ACM 2010. `§9.6`. Coverity's war stories: false positives, unparseable code, the social side of tools. The antidote to 'sound is all that matters'.

## 8. Proof assistants & Curry–Howard

- **[Propositions as Types](https://doi.org/10.1145/2699407)** ★ — P. Wadler, Communications of the ACM 2015. `§10.2`. Curry–Howard as a story: proofs are programs and propositions are types, the idea §10.2's type checker implements.
- **[From LCF to HOL: A Short History](https://www.cl.cam.ac.uk/archive/mjcg/papers/HolHistory.pdf)** — M. Gordon, In Proof, Language, and Interaction (Milner festschrift), MIT Press 2000. `§10.3`. Why a tiny trusted kernel plus untrusted tactics is safe: the LCF architecture that also makes LLM-written proofs trustworthy.
- **[The Lean 4 Theorem Prover and Programming Language](https://doi.org/10.1007/978-3-030-79876-5_37)** — L. de Moura, S. Ullrich, CADE-28 2021. `§10.5`. System description of the prover behind Mathlib and most 2024–2026 AI-for-math results.
- **[The Lean Mathematical Library](https://doi.org/10.1145/3372885.3373824)** — The mathlib Community, CPP 2020. `§13.4`. How a community-maintained formal library is organized; the corpus that LLM provers train and are tested on.

## 9. Landmark verified systems

Read them as §11 does: each result is *implementation ⊑ spec under assumptions*, and the bugs live outside the theorem.

- **[seL4: Formal Verification of an OS Kernel](https://doi.org/10.1145/1629575.1629596)** ★ — G. Klein et al., SOSP 2009. `§11`. 8,700 lines of C proved to refine an abstract specification, with about 200,000 lines of Isabelle (frameworks and libraries included). The 600 lines of assembler, the boot code, cache management, the compiler and the hardware are assumed correct, and the paper lists each assumption.
- **[Formal Verification of a Realistic Compiler (CompCert)](https://doi.org/10.1145/1538788.1538814)** — X. Leroy, Communications of the ACM 2009. `§11`. A C compiler proved in Coq to preserve program semantics; the clearest statement of what 'verified' buys and what it trusts.
- **[Finding and Understanding Bugs in C Compilers (Csmith)](https://doi.org/10.1145/1993498.1993532)** — X. Yang, Y. Chen, E. Eide, J. Regehr, PLDI 2011. `§11.3`. More than 325 previously unknown bugs reported across 11 compilers. In CompCert, Csmith found wrong-code bugs only in the unverified front end (six) and in a gap in its PowerPC semantics (two), none in the verified middle-end; as of early 2011 the development version was the only compiler tested in which it found no wrong-code errors, after about six CPU-years of testing. Some of the best evidence that proofs work, and that the bugs move to the proof's boundary.
- **[IronFleet: Proving Practical Distributed Systems Correct](https://doi.org/10.1145/2815400.2815428)** — C. Hawblitzel et al., SOSP 2015. `§11`. Dafny plus TLA-style refinement for a Paxos-based replicated state machine and a sharded key-value store, liveness included.
- **[HACL*: A Verified Modern Cryptographic Library](https://doi.org/10.1145/3133956.3134043)** — J.-K. Zinzindohoué, K. Bhargavan, J. Protzenko, B. Beurdouche, CCS 2017. `§11.6`. C crypto code extracted from F* with proofs of memory safety, functional correctness and timing side-channel resistance (secret independence); its code now ships in CPython's hashlib, Firefox and Linux (§11.6). The domain where proof most clearly pays.
- **[OpenJDK's java.utils.Collection.sort() Is Broken: The Good, the Bad and the Worst Case](https://doi.org/10.1007/978-3-319-21690-4_16)** — S. de Gouw, J. Rot, F. S. de Boer, R. Bubel, R. Hähnle, CAV 2015. `§11.4`. A failed KeY proof exposes TimSort's broken run-length invariant; the notebook's case-study section replays the mechanism.
- **[An Empirical Study on the Correctness of Formally Verified Distributed Systems](https://doi.org/10.1145/3064176.3064183)** ★ — P. Fonseca, K. Zhang, X. Wang, A. Krishnamurthy, EuroSys 2017. `§11.3`. 16 bugs in IronFleet, Verdi and Chapar, caused by broken assumptions mostly at the interface between verified and unverified code, and none in the verified protocols. Read it to learn exactly what a proof does not cover.

## 10. Industrial experience reports

- **[Météor: A Successful Application of B in a Large Project](https://doi.org/10.1007/3-540-48119-2_22)** — P. Behm, P. Benoit, A. Faivre, J.-M. Meynadier, FM'99. `§11.6`. Paris Métro Line 14's driverless control software developed in the B method: the classic large proof-based development.
- **[SLAM and Static Driver Verifier: Technology Transfer of Formal Methods inside Microsoft](https://doi.org/10.1007/978-3-540-24756-2_1)** — T. Ball, B. Cook, V. Levin, S. K. Rajamani, IFM 2004. `§8.6`. Software model checking with predicate abstraction, shipped to Windows driver writers: how a research tool became a product.
- **[SAGE: Whitebox Fuzzing for Security Testing](https://doi.org/10.1145/2093548.2093564)** — P. Godefroid, M. Y. Levin, D. Molnar, Communications of the ACM 2012. `§5.5`. Concolic testing at Microsoft scale on file parsers: symbolic execution as an industrial bug-finder.
- **[How Amazon Web Services Uses Formal Methods](https://doi.org/10.1145/2699417)** ★ — C. Newcombe, T. Rath, F. Zhang, B. Munteanu, M. Brooker, M. Deardeuff, Communications of the ACM 2015. `§8.1`. TLA+ on DynamoDB, S3 and other core systems, including a bug whose shortest trace needed 35 steps; written by engineers for engineers.
- **[Using Lightweight Formal Methods to Validate a Key-Value Storage Node in Amazon S3](https://doi.org/10.1145/3477132.3483540)** — J. Bornholt et al., SOSP 2021. `§12.3`. Executable reference models plus property-based testing and model checking on ShardStore; prevented 16 issues from reaching production. The middle of the market.
- **[Cedar: A New Language for Expressive, Fast, Safe, and Analyzable Authorization](https://doi.org/10.1145/3649835)** — J. W. Cutler et al., OOPSLA 2024. `§11`. A production policy language designed for a sound and complete SMT encoding, so policy changes can be checked for unintended permission changes.
- **[Systems Correctness Practices at Amazon Web Services](https://doi.org/10.1145/3729175)** — M. Brooker, A. Desai, Communications of the ACM 2025 (first in ACM Queue 2024). `§12.3`. The decade-later sequel to the 2015 paper: how AWS's correctness toolbox widened beyond TLA+ to P, deterministic simulation testing, fault injection and proofs at critical boundaries.

## 11. LLMs + formal verification (2020–2026)

Keep formal and informal results apart: a kernel-checked proof and a human-graded one are different evidence (§13.4).

- **[Generative Language Modeling for Automated Theorem Proving (GPT-f)](https://arxiv.org/abs/2009.03393)** — S. Polu, I. Sutskever, arXiv 2020. `§13.4`. Where the line starts: the first deep-learning prover whose proofs were adopted into a formal library (Metamath).
- **[LeanDojo: Theorem Proving with Retrieval-Augmented Language Models](https://arxiv.org/abs/2306.15626)** — K. Yang et al., NeurIPS 2023 (Datasets & Benchmarks). `§13`. Open tooling to drive Lean from Python plus a retrieval-augmented prover trained in one GPU-week: the hands-on entry point.
- **[PutnamBench: Evaluating Neural Theorem-Provers on the Putnam Mathematical Competition](https://arxiv.org/abs/2407.11214)** — G. Tsoukalas et al., NeurIPS 2024 (Datasets & Benchmarks). `§13.4`. 640 Putnam theorems in 1,692 Lean 4/Isabelle/Coq formalizations at release (672 Lean problems by 2026): the benchmark that 2026 provers saturated (§13.4).
- **[DafnyBench: A Benchmark for Formal Software Verification](https://arxiv.org/abs/2406.08467)** — C. Loughridge et al., arXiv 2024. `§13.4`. 750+ Dafny programs (about 53,000 lines) where the LLM must supply the hints; best 2024 model at 68%, a task the vericoding authors report at 96% a year later (union of models; best single model 89%). The software counterpart to math benchmarks.
- **[Olympiad-Level Formal Mathematical Reasoning with Reinforcement Learning (AlphaProof)](https://doi.org/10.1038/s41586-025-09833-y)** — T. Hubert, R. Mehta, L. Sartran et al., Nature 2026 (vol. 651; online 12 Nov 2025). `§13.1`. RL against the Lean checker as an exact reward; silver-medal-equivalent at IMO 2024 with AlphaGeometry 2. The verifier-as-reward argument, at scale.
- **[Aristotle: IMO-level Automated Theorem Proving](https://arxiv.org/abs/2510.01346)** — T. Achim et al. (Harmonic), arXiv 2025. `§13.4`. Lean proof search plus informal lemma generation: gold-medal-equivalent on IMO 2025 with machine-checked proofs (the formal statements were written by hand).
- **[A Benchmark for Vericoding: Formally Verified Program Synthesis](https://arxiv.org/abs/2509.22908)** ★ — S. Bursuc et al., arXiv 2025 (Dafny 2026 workshop at POPL 2026). `§13.4`. Coins 'vericoding': 12,504 specs in Dafny, Verus and Lean; the union of off-the-shelf LLMs solved 82% of the Dafny, 44% of the Verus and 27% of the Lean tasks (best single models 67.5%, 30.9% and 17.9%). The bottleneck moves to the spec.
- **[AlgoVeri: An Aligned Benchmark for Verified Code Generation on Classical Algorithms](https://arxiv.org/abs/2602.09464)** — H. Zhao et al., ICML 2026. `§13.4`. The same 77 algorithm contracts in Dafny, Verus and Lean; Gemini-3 Flash falls from 40.3% (Dafny) to 24.7% (Verus) to 7.8% (Lean). The automation gradient across tools, measured.
- **[Prediction: AI Will Make Formal Verification Go Mainstream](https://martin.kleppmann.com/2025/12/08/ai-formal-verification.html)** — M. Kleppmann, Blog post, 8 Dec 2025. `§12.5`. The 'why now' essay: LLMs make proofs cheap, checkers keep LLMs honest, and culture becomes the limit.

## 12. Hardware coda

- **[Formal Verification in Hardware Design: A Survey](https://doi.org/10.1145/307988.307989)** — C. Kern, M. R. Greenstreet, ACM TODAES 1999. `§12.4`. Model checking, automata-theoretic techniques and theorem proving as hardware teams used them; the bridge back to the chip-design notebook.
- **[Replacing Testing with Formal Verification in Intel Core i7 Processor Execution Engine Validation](https://doi.org/10.1007/978-3-642-02658-4_32)** — R. Kaivola et al., CAV 2009. `§12.4`. Intel's account of making formal verification, rather than simulation, the main validation method for a CPU execution engine. Hardware's answer to 'is it worth it?'.

## 13. Textbooks & free courses

- **[Logic in Computer Science: Modelling and Reasoning about Systems (2nd ed.)](https://doi.org/10.1017/CBO9780511810275)** — M. Huth, M. Ryan, Cambridge University Press 2004. `§2–§8`. The gentlest textbook: propositional and predicate logic, LTL/CTL model checking, Hoare logic and BDDs in one volume.
- **[Decision Procedures: An Algorithmic Point of View (2nd ed.)](https://doi.org/10.1007/978-3-662-50497-0)** — D. Kroening, O. Strichman, Springer 2016. `§3–§4`. SAT, bit-vectors, arrays, theory combination, DPLL(T): the textbook version of the SAT and SMT sections.
- **[Handbook of Satisfiability (2nd ed.)](https://www.iospress.com/catalog/books/handbook-of-satisfiability-2)** — A. Biere, M. Heule, H. van Maaren, T. Walsh (eds.), IOS Press 2021 (FAIA vol. 336). `§3`. 1,484 pages of reference. Read the CDCL and proof-checking chapters; keep the rest for lookups.
- **[Program Proofs](https://program-proofs.com/)** — K. R. M. Leino, MIT Press 2023. `§6`. Learn deductive verification by doing it in Dafny, from the language's author. The most direct follow-on to the Hoare-logic section.
- **[Software Foundations (Vol. 1 Logical Foundations; Vol. 2 Programming Language Foundations)](https://softwarefoundations.cis.upenn.edu/)** — B. C. Pierce et al., Online textbook series (Rocq). `§10`. Every page is a machine-checked proof script. Volume 1 for Curry–Howard in practice, Volume 2 for Hoare logic inside a proof assistant.
- **[Concrete Semantics with Isabelle/HOL](http://concrete-semantics.org/)** — T. Nipkow, G. Klein, Springer 2014 (free PDF). `§6, §9`. Semantics, compiler correctness, Hoare logic and abstract interpretation, all formalized in Isabelle, with 115 exercises.
- **[Theorem Proving in Lean 4](https://lean-lang.org/theorem_proving_in_lean4/)** — J. Avigad, L. de Moura, S. Kong, S. Ullrich, Online book (Lean FRO). `§10`. The standard Lean 4 tutorial: dependent types, tactics, induction. Enough to read the proofs LLM provers emit.
- **[Principles of Model Checking](https://iccl.inf.tu-dresden.de/web/Book3004)** — C. Baier, J.-P. Katoen, MIT Press 2008. `§8`. The model-checking reference: transition systems, LTL/CTL, partial-order reduction, timed and probabilistic systems.
- **[Specifying Systems: The TLA+ Language and Tools for Hardware and Software Engineers](https://lamport.azurewebsites.net/tla/book.html)** — L. Lamport, Addison-Wesley 2002 (free PDF). `§8.1`. The TLA+ book. The first seven chapters (83 pages) are enough to start writing specs.
- **[Static Program Analysis](https://cs.au.dk/~amoeller/spa/)** — A. Møller, M. I. Schwartzbach, Lecture notes, Aarhus University (revised Sept 2026). `§9`. Free, compact course on lattices, dataflow analysis, widening and interprocedural analysis: the textbook for the abstract-interpretation section.
- **[Principles of Abstract Interpretation](https://mitpress.mit.edu/9780262044905/principles-of-abstract-interpretation/)** — P. Cousot, MIT Press 2021. `§9`. The theory from its inventor. Heavy going; read it after Møller & Schwartzbach.

## What this list leaves open

1. **Is the spec right?** A kernel certifies that a proof proves a statement, not that the statement means what you meant. The vericoding authors judged roughly 9% of inspected successful specs too weak, and the benchmarks themselves carried wrong formal statements (PutnamBench, miniF2F); statement checking is in its infancy (notebook §13.2–§13.4).
2. **Keeping proofs alive.** *QED at Large* treats proof maintenance as a central open problem; SMT-backed proofs can break when nothing semantic changed (notebook §7.6), and seL4's re-verification cost followed the invariants a change touched rather than its size (§12.2).
3. **Programs lag mathematics.** Lean mathematics benchmarks were saturated in 2026. When the model must write the verified program itself, the union of 2025 models succeeded on 82% / 44% / 27% of the vericoding benchmark's Dafny / Verus / Lean tasks (Sep 2025), and AlgoVeri's aligned contracts (Feb 2026) score lower still. The math and program results are months apart and come from different models, and why the gap exists is still an interpretation, not a measurement (§13.4).

---
*75 sources · every DOI resolved in Crossref, every arXiv ID checked against the arXiv API, every other link fetched with a matching title (one exception: MIT Press blocks scripted access, so the Cousot 2021 page was confirmed by search) · compiled October 2026*
