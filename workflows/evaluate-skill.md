# Evaluate Skill Workflow

1. Identify the skill and the behavior it is supposed to improve.
2. Prepare tasks that should trigger the skill and adjacent tasks that should
   not trigger it.
3. Define evaluation criteria before running: activation precision,
   correctness, validation, tool behavior, latency, token/cost usage, and
   regression.
4. Compare baseline without the skill against execution with the skill when
   possible.
5. Inspect whether the skill description, body, boundaries, and catalog text
   agree.
6. Patch the smallest part that explains the observed failure.
7. Re-run the relevant skill tasks and adjacent non-skill tasks.

Use this workflow when creating, changing, or auditing `SKILL.md` files. Do
not use it as a generic code review workflow.
