# Kimi Code Adapter

Kimi Code consumes this harness through generated global instructions and the
canonical skill directory.

Run `scripts/generate-adapters.sh` to generate `AGENTS.md` from the
canonical component directories, then `scripts/install.sh` to link:

- `adapters/kimi/AGENTS.md` to `$KIMI_CODE_HOME/AGENTS.md`
  (default `~/.kimi-code/AGENTS.md`);
- `skills/` to `$KIMI_CODE_HOME/skills`.

Do not copy global skills, roles, workflows, profiles, or rules into projects.
Project-local context belongs in the project's own `AGENTS.md`, `PROJECT.md`,
`ARCHITECTURE.md`, docs, and `.agents/overrides/`.
