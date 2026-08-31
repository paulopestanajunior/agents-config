# Metric Discrepancy Workflow

1. State both numbers, their exact definitions, and the decision they affect.
2. Confirm they are comparable: same grain, time zone, date boundary, filter,
   and population.
3. Rule out timing before logic: freshness, late-arriving data, and incomplete
   partitions.
4. Compare layer by layer — source, transformation, serving, consumption — and
   locate the first layer where the numbers diverge.
5. Check the usual causes at that layer: duplication, join fan-out, silent type
   coercion, deduplication key, consent or sampling filters.
6. Quantify the gap and state how much of it is explained.
7. Name the owner for remediation and whether the metric is safe for the
   decision in the meantime.
8. Record the audit trail: checks run, evidence, unexplained remainder.
