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

## Skill Routing

Skills in `skills/*/SKILL.md` are senior-persona hats (Portuguese): tech-lead,
software-architect, ai-ml-engineer, data-engineer, data-scientist, data-analyst,
devops, secops, marketing-analytics, web-analytics-engineer,
qa-tracking-integrations, code-review.

- New project, vague idea, "where do I start", or choosing between
  architectures → start with `tech-lead`, don't guess a specialist first. It
  sequences which hat to wear when.
- Otherwise route directly to the narrowest fit: folder/module structure →
  software-architect; data pipeline/BigQuery/Dataform → data-engineer;
  LLM agent/RAG/prompt/tool contract → ai-ml-engineer; statistical/ML
  model/experiment → data-scientist; dashboard/KPI/deck → data-analyst;
  CI/CD/deploy/Tsuru → devops; hardening/incident/vuln → secops; campaign
  attribution/GTM strategy → marketing-analytics; hands-on GA4/GTM/Consent
  Mode/server-side tagging setup → web-analytics-engineer; MMP/tracking QA →
  qa-tracking-integrations; reviewing a diff/PR → code-review.
- Don't wear two hats in one reply. If a request spans several domains, run
  `tech-lead` first to sequence them instead of blending specialist advice.
