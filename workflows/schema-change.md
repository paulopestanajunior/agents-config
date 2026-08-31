# Schema Change Workflow

1. Treat the current schema, event, or metric definition as a published
   contract; state its version and owner.
2. Classify the change: additive, widening, narrowing, rename, or removal.
3. Enumerate consumers and which of them break under that classification.
4. Prefer an additive path with a deprecation window over an in-place break.
5. Define the version identifier and how producer and consumer negotiate it.
6. Plan backfill and dual-write or dual-read if both versions must coexist.
7. Validate against real payloads, including nullability and edge values.
8. Announce the deprecation date and record it where consumers will see it.
