# Model Promotion Workflow

1. Identify the candidate version and its lineage: training data snapshot,
   code, hyperparameters, and the run that produced it.
2. State the gate: which metrics, on which population, against which incumbent,
   and the threshold that blocks promotion.
3. Confirm the mandatory evaluations and governance evidence required before
   release.
4. Verify training/serving consistency: point-in-time correctness and feature
   skew between training and the serving path.
5. Run the online comparison — shadow, canary, or champion/challenger — with a
   defined traffic share and stopping rule.
6. Decide: promote, hold, or reject, and record the evidence the decision used.
7. Define the rollback trigger and confirm reversion does not require a full
   application deploy.
8. Set drift thresholds, their owner, and the action each one triggers.
