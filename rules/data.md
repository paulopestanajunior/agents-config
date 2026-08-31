# Data Rules

- Do not fabricate missing data; represent absence explicitly.
- Treat schemas, metric definitions, and event names as contracts. A name that
  two domains read differently is a context boundary, not a data bug.
- Prefer idempotent data processing.
- Check completeness, duplicate handling, and freshness before drawing
  conclusions from data.
- Verify grain before comparing or aggregating. Grain errors produce
  convincing wrong answers rather than obvious failures.
- Freshness and completeness are separate properties; recent data can still be
  partial.
- Reconcile against an authoritative source before explaining a discrepancy.
- Keep data lineage and ownership visible when changing pipelines or marts.
- Do not silently correct data; preserve the audit trail of what changed and
  why.
- Record what a dataset is safe for and what it is not. Fitness is contextual:
  a table valid for one decision can be unsafe for another.
- Knowledge about a specific dataset or schema belongs in the project's own
  context, not in the global harness.
