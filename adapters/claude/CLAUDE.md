# Claude Code Adapter

This adapter preserves Claude Code compatibility while keeping reusable rules in
the canonical global harness.

Claude should load the root `CLAUDE.md`, which references:

- `AGENTS.md` for global defaults and navigation;
- this adapter for Claude-specific compatibility;
- `adapters/claude/COMPONENTS.md` for the generated component index;
- `skills/*/SKILL.md` through Claude Code's native skill discovery.

## Claude-Specific Notes

- `@RTK.md` remains loaded from the root `CLAUDE.md` for token reduction.
- `settings.json` for the `rtk hook claude` hook lives in this adapter.
- Do not duplicate global rules here; add reusable behavior to `rules/`,
  `roles/`, `workflows/`, `profiles/`, or `skills/`.

@adapters/claude/COMPONENTS.md
