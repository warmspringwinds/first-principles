# Formal verification: from tests to proofs

You write a function and a test suite, and the tests pass. Is the function correct? A
test runs one input; correctness is a claim about *all* of them, and for two 32-bit
arguments that is 2⁶⁴ inputs. This notebook builds, from logic up, a working model of
*how a machine reasons about every input at once*: what a specification is, what a SAT or
SMT solver computes inside, why every verifier approximates and in which direction it
errs, and what symbolic execution, model checking, abstract interpretation and proof
assistants actually compute. Each technique is a readable toy, cross-checked against an
independent oracle. Then it asks what has really been verified, what it cost, and what
changes when an LLM writes the proofs and only the spec is left for a human to review.

## The notebook

| read this if you want | notebook |
|---|---|
| The whole field built from logic up, one runnable toy per technique: why a clean test run bounds a bug's density but never its existence (§1); specs, MiniPy and the over- vs under-approximation shape of every verifier (§2); a CDCL SAT solver with proof certificates and Haken's pigeonhole bound measured (§3); bit-blasting, SMT and DPLL(T) (§4); symbolic execution, bounded model checking and fuzzing (§5); a weakest-precondition verifier and inductive invariants (§6); memory, separation logic, triggers and proof instability (§7); explicit-state model checking on SC and x86-TSO machines, liveness, refinement, k-induction, IC3 and BDDs (§8); interval and octagon abstract interpretation (§9); Curry–Howard, an LCF kernel whose theorems Python lets you forge, and the independent re-checker that catches the forgeries (§10); what has actually been verified, with TimSort's stack bug replayed (§11); why everything isn't verified, as a cost model (§12); simulated LLM proposers while a checker decides (§13); and a field guide to the tools and what each one rests on (§14) | [`formal_verification_from_first_principles.ipynb`](formal_verification_from_first_principles.ipynb) |

This is the software companion to [`Hardware/chip_design/`](../../Hardware/chip_design/).
Formal verification and equivalence checking ("proves netlist ≡ RTL") appear in §6.3 of
that folder's [concepts notebook][hw-concepts] as steps of the flow, and that notebook
moves on; this one opens the box, down to an adder equivalence miter solved by its own
CDCL solver (§3.5) and the multiplier miters where bit-level reasoning stops scaling
(§4.4). [`reading_list.md`](reading_list.md) is the companion syllabus: 75 sources (every
link checked) in 13 sections plus a 12-paper fast path, from Dijkstra's Turing lecture to
the 2020–2026 LLM provers, each tagged with the notebook section it connects to.

[hw-concepts]: ../../Hardware/chip_design/hardware_design_from_first_principles.ipynb

## What is real and what is a toy

The notebook runs one industrial tool, and readable Python for everything else:

- **Real:** [Z3](https://github.com/Z3Prover/z3), Microsoft Research's SMT solver, as
  oracle, backend and object of study. Its SAT engine runs on the toy's exact pigeonhole
  and multiplier CNFs (§3.5, §4.4); it rewrites and bit-blasts words (§4.4); answers
  theory queries over uninterpreted functions, arithmetic and arrays (§4.5); is the
  backend of the symbolic executor and the bounded model checker (§5) and of the verifier
  that discharges the VC generator's conditions (§6); instantiates quantifiers under the
  settings Dafny gives it (§7); answers the k-induction and IC3 queries (§8); grades
  abstract-interpretation alarms as an exact oracle (§9); returns `unknown` on the Peano
  goals that need induction, then closes the base and step cases of three of the four
  once handed the induction scheme (§10.1); and minimises TimSort's counterexample,
  checks the proposed invariants and runs the three verifier builds of the portfolio
  experiment (§11, §13, §14). Every call runs under a timeout or a resource limit, and
  `unknown` is never reported as proved.
- **Toy, in plain Python, each short enough to read in full:** an exhaustive tester for
  one 32-bit argument and a line/branch coverage tracer (§1); MiniPy, a small Python
  subset with a parser and an interpreter, and a bounded-exhaustive checker (§2); Tseitin
  encoding, a CDCL solver with one ablation flag per component (DPLL is all flags off), a
  RUP proof checker and a cutting-planes checker (§3); a bit-blaster with structural
  hashing and a DPLL(T) loop over difference logic (§4); a KLEE-style symbolic executor,
  a CBMC-style bounded model checker and an AFL-style fuzzer (§5); a weakest-precondition
  VC generator with a passive-form builder (§6); three memory models and a brute-force
  separation-logic checker (§7); an explicit-state model checker on SC and x86-TSO
  machines, a lasso finder, a refinement checker, k-induction, IC3 and a BDD package
  (§8); interval and octagon analyzers on one fixpoint engine (§9); a simply typed
  λ-calculus checker, an LCF kernel with an untrusted tactic layer and a de Bruijn
  re-checker (§10); TimSort's run-length stack machine (§11); a cost-vs-loss model (§12);
  Houdini and a pass@k estimator (§13). Each algorithmic toy (solver, executor, checker,
  analyzer, kernel) is cross-checked, in the section that builds it, against an
  independent oracle: brute force, exhaustive enumeration at small sizes, or Z3. The cost
  model is a model, and prints the assumptions it rests on instead.
- **Honestly omitted or illustrative only** (named in the text): the Dafny, Lean, TLA+
  and Rust snippets are never executed, and no tool besides Z3 is run (KeY, Kani, CBMC,
  TLC and Astrée appear only as sourced data); DRAT/LRAT deletions and verified proof
  checkers; extended resolution; theory propagation inside DPLL(T); KLEE's search
  heuristics, state merging and concolic testing; interpolation and CEGAR; polyhedra as a
  real abstract domain (emulated with Z3 over ℚ on straight-line code); strong fairness;
  automatic termination provers. Industrial results (SAT records, Astrée's false-alarm
  counts, seL4's effort, the bugs found in verified systems, the LLM-prover benchmarks)
  are tabulated from their sources, not reproduced.

Everything is seeded and CPU-only: each cell that needs randomness makes its own
generator from a named seed, so the toys' counts (conflicts, states, paths, fuzzing
campaigns, analyzer verdicts) reproduce exactly, and Z3's `rlimit` work counts are
deterministic for a given Z3 version. What may vary between runs is whatever Z3 chooses
or a timeout cuts off (counterexamples and counterexamples to induction, IC3's lemma set,
Z3's instance and conflict counts) and every wall-clock time. The notebook's prose does
not hard-code those values (where it names one, it says "in this run"), and every
counterexample is replayed concretely before it is believed.

## Headline results

- **100% coverage, zero bugs found.** The textbook suite 5, −5, 0 reaches 100% line and
  100% branch coverage of `abs32` and finds nothing (registered prediction "100% line and
  branch coverage exposes the bug": WRONG); the only suite that finds the bug,
  `INT32_MIN` alone, has 67% line and 50% branch coverage. Coverage counts code that ran,
  and the bug is a value: of the 2,147,483,648 inputs that take the `x < 0` branch
  exactly 1 fails, so covering that branch with a random negative input finds the bug
  with probability 2⁻³¹ = 4.7 × 10⁻¹⁰ (§1.4). Density belongs to the test distribution,
  not to the bug: the binary-search midpoint `(lo + hi) >> 1` overflows on half of all
  uniform valid pairs, yet never in a search over an array of fewer than 2³⁰ + 1 elements
  (§1.3).
- **What each CDCL component buys, and where none of them helps.** On an adder
  equivalence miter (a + b against b + a, no shared gates) DPLL makes exactly 4ʷ − 1
  decisions, and removing clause learning costs at least 350× at w = 8, where it hits its
  conflict cap; both as predicted (the second's numeric scoring rule was fixed after the
  prose prediction). The prediction that every other component is a tuning knob worth
  under 10× failed: without VSIDS the solver falls back to a static order that decides
  every bit of a before any bit of b, so its learned clauses span a median 27 bit
  positions instead of 1, and it needs 16.6× the conflicts at w = 32 (13,337 against
  804). On pigeonhole no configuration escapes the exponential, as Haken's resolution
  bound says none can: full CDCL's conflicts grow 3.5 to 5.4× per extra hole and PHP(9,8)
  is out of its reach at 30,000 conflicts; turning restarts off gets one hole further,
  still exponentially. A cutting-planes refutation of the same CNF, a proof system that
  can count, has 2n(n−1) + 1 lines (§3.5).
- **Bit-blasting stops at multiplication because of structure, not size.** Proving
  `mul(a, b) == mul(b, a)` with two shift-add multipliers costs the toy CDCL 7557
  conflicts at w = 7 and 69,886 at w = 8, while the CNF grows only about as w². Z3 shows
  both sides of the trade: its word-level rewriter puts the factors in canonical order
  and proves `a*b == b*a` at w = 64 with 0 SAT conflicts, while bit-blasting a
  hand-written shift-add circuit against `a*b` first exhausts its deterministic work
  budget at w = 10 under Z3 5.3.1 (both predicted right; §4.4).
- **No search technique dominates; each has its own cost driver.** A 32-bit magic-value
  compare (p = 2.33 × 10⁻¹⁰) defeats blind and coverage-guided fuzzing in 30,000 runs but
  falls to symbolic execution on its first path, and to BMC; split into four byte
  compares, it takes the guided fuzzer a median of 19,088 runs over the 5 scored
  campaigns (22,857 over all 25). `popcount(x) == 16` is the reverse: one random input in
  seven triggers it, yet depth-first symbolic execution finds no failing path in its
  first 2000 (the section's kept failure), because the first failing path's index doubles
  with every two bits of width (exact at w = 8 to 20), to 65,536 at 32 bits; BMC folds
  all 2³² paths into one formula. Coverage guidance hurts there too: 2 of 200 guided
  campaigns miss within 1000 runs a bug blind fuzzing finds in a median of 4, because
  almost every input covers the same edges, so the corpus never grows past its seed, and
  even AFL's hit-count buckets would add no foothold before the bug itself (§5.5).
- **A trigger is a program for the solver.** The registered prediction that a matching
  loop makes Z3 instantiate until the timeout failed: under Dafny's Z3 settings one
  looping axiom ∀x. f(x) = f(g(x)) stops by itself after 88 instances, 2 × max(eager
  threshold 44, lazy threshold 20). The generation cap limits a chain's depth, not its
  breadth: two looping axioms run to the timeout on an invalid goal, and on a valid
  depth-d goal cost exactly 4(2ᵈ − 1) instances at every proved d ≥ 2, where the
  terminating trigger needs d. True lemmas hurt too (prediction "true lemmas can only
  help": WRONG): each of 6 sets of ambient lemmas raised Z3's median work on the
  binary-search VC, the looping `pred` lemma by 4.9× with a 5.29× spread across its 41
  equivalent runs, yet all 287 runs proved the theorem; at this scale instability shows
  up as cost (§7.5–7.6; Z3 5.3.1, counts from the shipped run).
- **Peterson's mutex: correct, broken by the hardware, and out of reach of plain
  induction.** Safe on all 40 reachable states under sequential consistency (SC), it lets
  both threads into the critical section after 6 steps on an x86-TSO machine with
  per-thread store buffers, validated on the store-buffering (SB) litmus test (registered
  prediction "Peterson stays safe": WRONG); one mfence per thread restores mutual
  exclusion on all 178 states. Under SC it is also a kept failure for symbolic proof:
  plain k-induction proves it for no k, because 54 unreachable states lie on cycles the
  step check can use, each with a thread past its flag write whose flag is down. The
  loop-free variant needs k = 30, adding one missing lemma lets plain k-induction finish
  at k = 3, and IC3, using one-step queries only, proves it outright (§8.2, §8.5–8.6).
- **Two wrong predictions about one midpoint.** Intervals do not prove
  `lo + ((hi − lo) >> 1)` overflow-free (registered prediction "intervals prove it":
  WRONG): `hi − lo` forgets `lo ≤ hi`, so the box puts the result in [−1073741824,
  3221225470], a false alarm that Z3 refutes. Octagons cannot state the coefficient-2
  relation 2t ≤ d ≤ 2t + 1, yet they do prove the check (registered prediction "octagons
  cannot": WRONG): it needs only the shadow t ≤ d, which closure chains with d + lo ≤
  INT32_MAX. Both analyzers pass an executed-claims soundness harness on 308 programs and
  7588 concrete runs with 0 broken claims (empirical evidence of soundness, not a proof),
  where a planted rounding bug breaks 33 (§9.2–9.5).
- **An LCF kernel in Python can be forged; a de Bruijn checker catches the forgery.** A
  capability token in a closure, `__slots__` and a refusing `__setattr__` block all 3
  front-door attacks, including a `str` subclass whose `==` always says yes, but all 4
  introspection attacks (`object.__new__`, `object.__setattr__`, the token read from
  `__closure__`) produce a theorem printing ⊢ Z = S Z, and the kernel's own TRANS builds
  ⊢ add(Z, Z) = S Z on top (registered prediction "unforgeable": WRONG). An independent
  55-line checker that re-derives the exported proof text rejects 5/5 forgeries and
  accepts 5/5 genuine theorems; its first version read the claim off the object and was
  fooled by the lying string. 20,000 random derivation records give 0 disagreements
  between the kernel and the checker, and no false theorem (§10.4).
- **TimSort's invariant breaks at 256 elements, silently.** In a model that lets every
  run be 16 long, explicit-state search over all 107,695 reachable stacks of arrays up to
  200 elements and a Z3 minimisation over the paper's five-push pattern agree on the
  smallest violation, pushes [70, 52, 17, 16, 18]. Real TimSort's minRun depends on the
  array length, and under Java's rule the smallest array that breaks the run-length-stack
  invariant is those five runs plus a final run of 83, 256 elements (registered
  prediction "needs millions": WRONG). Java's 2015 bound of 49 slots rested on de Gouw et
  al.'s Lemma 1, which holds on all 1384 violating stacks up to 200 elements but fails on
  Auger et al.'s published counterexample, scaled to a legal 4848-element Java input;
  their 1,091,482,190-element input needs 50 slots, while the fixed merge logic never
  needs more than 18 on it (§11.4–11.5).
- **A 100× cheaper prover buys about 10×, not 100×.** In Amdahl's law for proofs the spec
  is the serial fraction. Its measured share runs from 2.4% (seL4's effort split) to
  11.6% (CompCert's line counts), so a 100× cheaper LLM prover makes verification only
  8.0× to 29.3× cheaper (registered prediction ≥ 50×: WRONG), and even a free prover is
  capped at 1/(spec share): 41× for seL4's effort split, 23× or 9× under its other
  readings. In the notebook's cost model, at an assumed one critical escape per million
  unverified lines (δ = 10⁻⁶; nobody publishes δ), 10× cheaper verification puts only 2
  of the 5 domains above the web app in "verify": avionics, which is there already, and
  the cloud control plane. The registered prediction that all 5 verify at 10× is WRONG
  there and at both ends of the plausible band, δ = 10⁻⁷ and 10⁻⁵; the OS kernel would
  need δ > 8.4 × 10⁻⁵ (§12.5).
- **The checker scales; the spec and the verifier's encoding of machine arithmetic are
  what can still be wrong.** Among 585 list pipelines, 19 of them correct sorts, a
  pipeline accepted at bound L = 5 is correct 4.5% of the time under the spec "sorted",
  29.7% under "sorted+len" and 100.0% under "sorted+perm", as predicted; `return x * x`
  against `ensures(result >= 0)` passes the escape-hatch linter, the VC check and both
  cover (non-vacuity) checks, and is not abs (§13.2–13.3). A first-proof-wins portfolio
  of three verifier builds reports 22 false proofs, the union of build B's 9 (integers
  that forget wrap-around) and build C's 13 (unsigned compares), where the worst single
  build reports 13 and the correct build A none (registered prediction "at least as safe
  as its worst member": WRONG). A veto by a replayed counterexample has 0 false proofs
  and keeps all 87 valid ones, a record inherited from the one correct build (§14.2).

## Reproducing

Reading requires nothing — all outputs are embedded. To re-execute:

```
pip install numpy matplotlib jupyterlab z3-solver
```

Install into a Python 3.12 or newer environment and run the notebook on that
environment's kernel (the code uses 3.12 f-string syntax, and the §1.4 coverage tracer
uses `sys.monitoring`). The notebook then runs top to bottom in about 3
minutes on a laptop CPU. Z3 is optional: without it the whole notebook still runs, in
about 80 s, with the toy solvers standing in where they can and a one-line skip where
only Z3 will do (most of §5–§7, k-induction and IC3 in §8, §9's exact oracle, §10.1,
§13.1's invariant experiments and §13.3's vacuity demo, and Z3's own runs elsewhere). The
shipped outputs were produced with Z3 5.3.1, the version the setup cell prints. The
shipped file stores its figures as 256-colour PNGs to stay around 5 MB; re-executing
writes full-colour figures, about 10 MB.
