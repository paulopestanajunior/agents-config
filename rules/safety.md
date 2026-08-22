# Safety Rules

- Do not hardcode secrets, tokens, credentials, API keys, or sensitive local
  paths.
- Do not invent facts that should come from code, data, APIs, tools, or current
  documentation.
- Do not perform destructive actions without explicit approval.
- Treat production changes, credential changes, permission changes, and data
  deletion as high-risk operations that require explicit user approval.
- Preserve user changes in dirty worktrees; never revert unrelated work.
