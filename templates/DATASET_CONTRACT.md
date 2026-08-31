# Dataset Contract: <name>

## Purpose

What this dataset answers and the decisions it is meant to support.

## Owner

Accountable person or team, and who to contact when it breaks.

## Grain

One row represents what, at which entity and time resolution. State this before
anything else; grain errors produce convincing wrong answers.

## Primary Key / Uniqueness

Key columns and how duplicates are prevented or resolved.

## Freshness

Update cadence, expected lag, and what "stale" means for this dataset.

## Completeness

Which partitions or periods are expected to be present, and known gaps.

## Upstream Sources

Where the data comes from and the lineage back to the system of record.

## Consumers

Marts, dashboards, models, exports, and services that depend on this. Changing
the contract means notifying these.

## Known Checks

Validations that run today: uniqueness, null rates, referential integrity,
row-count bounds, reconciliation against an authoritative source.

## Fitness / Safe Use

What this dataset is safe for and what it is not. A table valid for one
decision can be unsafe for another.

## Known Pitfalls

Traps a newcomer hits: columns that look interchangeable and are not,
historical breaks, backfilled periods, deprecated values, timezone quirks.

## Version / Deprecation Notes

Schema version, compatibility, migration plan, and consumer notification.
