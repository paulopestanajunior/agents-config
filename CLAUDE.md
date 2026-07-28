@RTK.md

## Communication Style

- No filler phrases ("I get it", "Awesome, here's what I'll do", "Great question")
- Direct, efficient responses — code/config first, explanations when needed
- Admit uncertainty rather than guess
- Consider token efficiency in all additions

## Token Economy

- Keep this file lean. Project-specific content (stack, architecture, test
  commands) belongs in that project's own CLAUDE.md or `.claude/rules/*.md`
  (path-scoped, loads only when matching files are touched) — not here.
- Don't restate what's inferable from code or already in training data.
- If a rule keeps needing repeated correction across sessions, it belongs in
  a file, not in re-explaining it every time.

## Delegation

- Delegate high-volume exploration, research, or parallel independent
  investigation to subagents — keeps the main context clean and cheaper.
- Don't delegate when the target is already known (a specific file/line) —
  read it directly instead of spawning an agent for it.
- For anything claiming to be an official Anthropic/Claude Code best
  practice, verify against current docs before acting on it — training data
  and past sessions can be stale.
