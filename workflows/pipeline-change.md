# Pipeline Change Workflow

1. State the current contract: grain, keys, partitions, freshness, and owner.
2. Identify downstream consumers: marts, dashboards, events, models, exports.
3. Decide whether the change is backward compatible; if not, plan the migration
   and deprecation window.
4. Design for idempotency and define the backfill strategy and its cost.
5. Apply the change with the smallest reprocessing footprint that is correct.
6. Validate grain, uniqueness, completeness, freshness, and row-count deltas
   against the previous run.
7. Reconcile against an authoritative source before declaring success.
8. Update lineage and ownership, and summarize impact and residual risk.
