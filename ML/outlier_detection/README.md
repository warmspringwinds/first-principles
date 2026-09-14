# Outlier detection / open-set classification

You have training data for $C = 30$ classes. At inference time, some inputs come from
classes that did not exist at training time. The system must output

$$
F(x) \in \{1, \dots, 30\} \cup \{\texttt{reject}\},
$$

classifying the known accurately while refusing the unknown — and the only outlier data
available is a small collected set (here: 60 examples, drawn from just 3 of the 8 unknown
classes, mirroring the reality that collected outliers are a biased sample of future
novelty).

## The two notebooks

| read this if you want | notebook |
|---|---|
| The full theory: every score derived, drawn in 2-D, then evaluated honestly at scale | [`outlier_detection_from_first_principles.ipynb`](outlier_detection_from_first_principles.ipynb) |
| The distilled, deployable answer: one encoder, one detector, one threshold, with worked examples | [`simple_baseline.ipynb`](simple_baseline.ipynb) |

Both are self-contained; the baseline can be read without the theory notebook (it
re-derives what it needs).

## Experimental setup

Both notebooks use the same synthetic benchmark, designed so every effect is
reproducible in minutes and the hard case is represented honestly:

- **Generator.** Each class lives in an 8-D latent space and reaches observation space
  through a fixed random nonlinear map into $D = 64$ dimensions, plus noise — so raw
  inputs are deliberately *not* Gaussian per class, and detectors must earn their feature
  space.
- **Unknown classes come in two kinds.** *Near* outliers are drawn from the same latent
  prior as the known classes (new-but-similar categories — the realistic threat model);
  *far* outliers have remote latent means. All results are reported separately for the
  two, because methods that ace far-OOD can fail near-OOD and vice versa.
- **Splits.** Training data fits everything; one or two held-out known-good splits
  calibrate scores and thresholds; a fresh test split verifies promises; outlier test
  sets are split into *seen kinds* (the 3 classes the collected 60 came from) and
  *unseen kinds* (the other 5) to expose overfitting to collected novelty.
- **Determinism.** Fixed seeds throughout; the printed numbers reproduce on re-execution.

## Derivations covered

Everything used is derived on the page, including:

1. **Why softmax confidence cannot detect novelty** — logits are (piecewise) linear, so
   along almost any ray the winning class's margin grows without bound and confidence
   saturates to 1 exactly where no data was ever seen.
2. **Why detection is density estimation** — deciding "does this input belong?" is a
   hypothesis test; the optimal test compares likelihoods, and an unknown alternative
   leaves one usable rule: flag inputs where the training density is low.
3. **Distance = density** — $\log \mathcal{N}(x;\mu,\Sigma) = -\tfrac12 d_{\text{Maha}}^2 + \text{const}$,
   so Mahalanobis scoring is Gaussian density scoring; pooled covariance (30× the
   effective sample size) with Ledoit–Wolf shrinkage keeps the fit invertible.
4. **Relative Mahalanobis** as a likelihood ratio against a background Gaussian, and the
   kNN score from the classical counting-argument density estimate.
5. **Honest evaluation** — AUROC built from the rank (Mann–Whitney) identity and verified
   against a reference implementation; FPR at 95% TPR as the operational number.
6. **The threshold guarantee** — a fresh known-good input is exchangeable with the
   held-out calibration set, so its rank among their scores is uniform: rejecting below
   the 5% score quantile rejects at most ~5% of genuine inputs, with no distributional
   assumptions (conformal prediction, proved in four sentences).
7. **Why "k sigma" fails in high dimensions** — a perfectly normal point sits at
   $\approx\sqrt{D}$ sigmas from its own center, and real features are heavier-tailed
   than Gaussian: the $\chi^2$ fence keeps 82% of good inputs while promising 95%; the
   data quantile keeps 96%.
8. **The encoder that makes the Gaussian assumption true** (baseline notebook) — a
   margin loss with hinge stopping conditions (attraction that knows when to stop), and
   spectral normalization $\bar W = W/\sigma_{\max}(W)$ with residual connections giving
   each block the two-sided bound
   $(1-c)\lVert\Delta\rVert \le \lVert \text{block}(h_1)-\text{block}(h_2)\rVert \le (1+c)\lVert\Delta\rVert$ —
   distances neither erased nor blown up.

## Headline results

- **Density scores dominate confidence scores**: RMDS reaches 0.98 near-OOD AUROC where
  MSP manages 0.90 — and the energy score *inverts* on far-OOD (AUROC 0.44, worse than a
  coin flip) because unbounded inputs let logits grow along rays: any single score can
  fail catastrophically in a regime its benchmarks never exercised.
- **The trained encoder costs no accuracy** — it gains ~1.5–2 points over a plain
  classifier while cutting seed-to-seed detection variance to a third.
- **The threshold keeps its promise** (96.1% of known inputs pass a fence set for 95%)
  and abstention slightly *raises* accuracy on the inputs that are kept.
- **Training on the collected 60 is a trap, demonstrated live**: a detector fitted to
  them scores near-perfectly on the outlier kinds it saw and collapses on kinds it did
  not, while the untouched fence treats all kinds alike. The 60 are a measuring stick —
  their catch-rate estimate is reported with a binomial interval, never a bare point.
- **Near-OOD is the honest hard case**: at a 5% false-reject budget, remote novelty is
  caught almost entirely (~97%) and similar novelty at ~58% — the number to set
  expectations with, measured rather than promised.

## Reproducing

```
pip install numpy scipy scikit-learn matplotlib torch jupyterlab
```

Run either notebook top to bottom; a few minutes on a laptop CPU. All figures and
numbers regenerate deterministically.
