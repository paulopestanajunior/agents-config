# Codebase Onboarding Workflow

Use for a brownfield start: an existing repository you have not worked in.

1. Read the entry points first: README, existing agent or contributor docs,
   package manifests, CI configuration, and the run/test commands.
2. Identify the stack and how to build, test, and run it locally. Verify the
   commands rather than trusting the documentation.
3. Map the directories a contributor must inspect first, and which are
   generated, vendored, or dead.
4. Trace the real component boundaries from imports and call paths, not from
   folder names.
5. Follow the important data flows end to end: request, event, batch, or
   analytics.
6. Identify invariants and fragile areas: what breaks silently, what has no
   tests, what the git history shows as repeatedly patched.
7. Fill `PROJECT.md` and `ARCHITECTURE.md` from evidence, and record current
   state in `WORKING_CONTEXT.md`.
8. State explicitly what could not be inferred from the code and needs a human
   answer. An unanswered question is a finding, not a gap to guess at.
