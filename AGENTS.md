# AGENTS.md

Global harness for coding agents. This file is the operational entry point;
details live in focused resources.

## Core Defaults

- Understand the local project before modifying it.
- Keep changes scoped to the requested task.
- Follow existing project conventions before introducing new patterns.
- Do not invent business, sports, financial, or technical facts without an
  explicit source or tool result.
- Do not hardcode secrets, tokens, credentials, or sensitive local paths.
- Do not run real deploys, destructive operations, commits, pushes, or history
  rewrites without explicit user approval.
- Validate changes with the relevant tests, lint, type checks, or targeted
  manual checks before claiming success.

## Navigation

- `skills/`: domain expertise, discovered as `skills/<name>/SKILL.md`.
- `roles/`: operating stance, discovered as `roles/<name>.md`.
- `workflows/`: repeatable procedures, discovered as `workflows/<name>.md`.
- `profiles/`: depth and autonomy settings, discovered as `profiles/<name>.md`.
- `rules/`: durable constraints, discovered as `rules/<name>.md`.
- `templates/`: project-local starter files.
- `adapters/`: vendor-specific compatibility layers generated from or pointing
  back to the canonical global harness.

## Component Boundaries

Components delegate to each other with `-> Component Name`. Every delegation
names the **sub-object**, never the bare domain. "RAG -> X" or "drift -> Y"
creates an ambiguous edge that another component will claim back; "corpus
construction" and "production drift monitoring" do not. Run
`scripts/validate-components.sh` (or `.ps1`) after editing boundaries: it
resolves every edge, reports unresolved targets, and flags mutual delegation
for review.

## Layering

The global harness defines how agents work.
The project defines how that system works.
The task defines what needs to be done now.

Project-specific stack, architecture, commands, external services, decisions,
and exceptions belong in the project's own `AGENTS.md`, `PROJECT.md`,
`ARCHITECTURE.md`, docs, or `.agents/overrides/`, not in this global file.
