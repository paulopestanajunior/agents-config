# Project Kickoff Workflow

Use for a greenfield start: an idea, a briefing, or an empty repository.

1. Restate the problem in two or three sentences and confirm it before
   proposing any solution.
2. Name who it is for, the decision or job it serves, and what success looks
   like in observable terms.
3. Define the MVP scope and, explicitly, the non-goals. The non-goals are the
   half that keeps the plan honest.
4. Surface the blocking decisions — data availability, stack, runtime, data
   model, integration constraints, compliance — and name the specialist who
   owns each.
5. Sequence the work: what must be resolved before what, and what can run in
   parallel.
6. Fill `PROJECT.md` (purpose, stack, directories, external services, commands)
   and `ARCHITECTURE.md` (components, boundaries, data flow, invariants,
   risks). Leave a field blank only when the answer is genuinely undecided, and
   mark it as such.
7. Record the current state in `WORKING_CONTEXT.md`: active constraints, open
   decisions, and what is in flight.
8. Write the plan to `docs/plans/active/` and state what is deferred past the
   MVP.
