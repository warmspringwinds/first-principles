# first-principles

A growing collection of notebooks that take one technical topic at a time and rebuild it
from scratch — machine learning, AI, hardware, and whatever comes next.

## The rules of the house

Every notebook here follows the same discipline:

- **Derive, don't cite.** Each method is built up from the underlying argument — a
  probability identity, a geometry fact, a counting argument — not adopted because a
  paper said so. If a claim can't be derived on the page, it gets measured on the page.
- **Draw the mechanism.** Every important idea gets a picture that shows *why* it works,
  not just that it works. If the intuition doesn't survive being drawn, it wasn't an
  intuition.
- **Run everything.** Notebooks ship with their outputs embedded: every number in the
  prose is produced by a cell above it, on synthetic data designed so results are
  reproducible end to end in minutes on a CPU.
- **Keep the failures.** Methods that lose are shown losing, with the mechanism of the
  failure made visible. Registered predictions get scored even when they turn out wrong —
  especially when they turn out wrong.

## Contents

### `outlier_detection/` — open-set classification

You train a classifier on N known classes; at test time, inputs from classes that never
existed arrive. Classify the known, reject the unknown.

| notebook | what's inside |
|---|---|
| [`outlier_detection_from_first_principles.ipynb`](outlier_detection/outlier_detection_from_first_principles.ipynb) | The full theory, built from zero: why softmax confidence provably fails, why detection is density estimation in disguise (a hypothesis-testing argument), Mahalanobis / relative-Mahalanobis / kNN scores derived and drawn in 2-D, honest evaluation (AUROC from scratch), conformal thresholds with a finite-sample guarantee, and what a small set of collected outliers is — and is not — good for. |
| [`simple_baseline.ipynb`](outlier_detection/simple_baseline.ipynb) | The distilled, deployable pipeline: a classifier trained with a margin loss on a spectral-normalized residual encoder, a Gaussian-per-class detector fitted in closed form, and a threshold read off held-out data with a distribution-free guarantee. Opens with the whole system in prose, equations, and one diagram; ends with worked examples, a live demonstration of the classic mistake (training on your few collected outliers), and a transfer checklist. |

More topics will land as their folders appear.

## Running the notebooks

Reading requires nothing — all outputs are embedded. To re-execute:

```
pip install numpy scipy scikit-learn matplotlib torch jupyterlab
```

Each notebook is self-contained (no imports across notebooks, no external data) and runs
top to bottom in a few minutes on a laptop CPU.
