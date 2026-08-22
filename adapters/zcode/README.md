# ZCode Adapter

ZCode consumes this harness through generated global instructions and the
canonical skill directory.

Run `scripts/generate-adapters.sh` to generate `AGENTS.md` from the
canonical component directories, then `scripts/install.sh` to link:

- `adapters/zcode/AGENTS.md` to `~/.zcode/AGENTS.md`;
- `skills/` to `~/.zcode/skills`.

Do not copy global skills, roles, workflows, profiles, or rules into projects.
Project-local context belongs in the project's own `AGENTS.md`, `PROJECT.md`,
`ARCHITECTURE.md`, docs, and `.agents/overrides/`.
