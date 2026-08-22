# Codex Adapter

Codex consumes the global harness through `AGENTS.md`.

Run `scripts/generate-adapters.sh` to generate `AGENTS.md` from the
canonical component directories, then `scripts/install.sh` to link it as the
global Codex instructions file.

Project-local `AGENTS.md` files should contain project context and overrides,
not copies of global skills, roles, workflows, profiles, or rules.
