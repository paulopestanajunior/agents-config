# Spec-Driven Development Workflow

1. Capture intent: problem, user/business need, constraints, and what must not
   be inferred.
2. Write or update a specification before implementation when the work is
   ambiguous, cross-module, architectural, or difficult to reverse.
3. Review the specification for goals, non-goals, interfaces, edge cases,
   risks, acceptance criteria, and validation.
4. Convert the accepted specification into a plan and task sequence.
5. Implement incrementally against the specification.
6. Validate acceptance criteria, tests, docs, and residual risk.
7. Move completed specs or plans to the appropriate completed folder when the
   project uses that convention.

Use this workflow for ambiguous features, cross-module work, architectural
changes, and business rules the agent must not invent. Do not force a full
spec for trivial fixes, mechanical edits, or already-specified tasks.

```text
SPEC = what / why / constraints / acceptance criteria
PLAN = how / sequence / implementation approach
TASK = concrete unit of execution
```
