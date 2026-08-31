# Tracking Implementation Workflow

1. Confirm the measurement question and the decision it serves before naming
   any event.
2. Define the contract: events, properties, identity model, required vs
   optional fields, consent classification, and deduplication key.
3. Decide client vs server ownership per event and the destination mapping.
4. Implement in the tag manager, SDK, or server surface following the contract,
   not the other way around.
5. Verify firing end to end in a non-production environment: trigger, payload,
   identity stitching, and destination arrival.
6. Reconcile counts against an authoritative source and explain any gap.
7. Confirm consent behavior in both granted and denied states.
8. Record the implemented contract and its version where consumers can find it.
