# Changelog

## 1.0.0

### Changed

- Reframe the repository as `agents-config`, a vendor-neutral global harness
  for coding agents.
- Translate canonical agent-facing harness content to English while keeping
  human-facing README/docs in Portuguese.
- Preserve existing specialist capabilities, including `finops`, while
  generalizing cloud/data/AI guidance away from a single provider.
- Move `tech-lead` from skill to role and preserve dynamic skill discovery for
  specialist routing.
- Rename the generated adapter entrypoints for Codex, Kimi, and ZCode from
  `AGENTS.generated.md` to the runtime-facing `AGENTS.md`; keep generated
  status in the file header.
- Replace Claude's generated component index with
  `adapters/claude/COMPONENTS.md`, referenced by the Claude adapter wrapper.

### Added

- Add canonical component directories for roles, workflows, profiles, rules,
  templates, scripts, and adapters.
- Add dynamic discovery for `skills/<name>/SKILL.md`, `roles/*.md`,
  `workflows/*.md`, `profiles/*.md`, and `rules/*.md` in adapter/catalog
  generation.
- Add generated adapters for Claude, Codex, Copilot, Kimi, and ZCode.
- Add installer support for shell and PowerShell, including Kimi/ZCode links
  and Claude RTK settings preservation.
- Add `init-project` support for shell and PowerShell with explicit target,
  dry-run, idempotency, overwrite protection, and project-local context only.
- Add project bootstrap structure for `docs/decisions/`,
  `docs/plans/active/`, `docs/plans/completed/`, `docs/specs/active/`,
  `docs/specs/completed/`, and `.agents/overrides/`.
- Add lightweight human documentation in Portuguese:
  `docs/quick-start.md`, `docs/catalog.md`, and `docs/examples.md`.
- Add generated Portuguese catalog support through `docs/catalog.generated.md`
  and optional annotations in `docs/catalog.pt.tsv`.
- Add versioning policy and `VERSION`.
- Add the expanded specialist skill catalog:
  `technical-documentation`, `agentic-ai-engineer`, `llm-evaluation`,
  `api-engineer`, `test-automation-engineer`, `sre-observability`,
  `cloud-architect`, `database-engineer`, `sql-expert`, `security-engineer`,
  and `product-analytics`.
- Add modern analytics, tracking, attribution, and instrumentation coverage:
  `analytics-instrumentation`, expanded `web-analytics-engineer`, expanded
  `qa-tracking-integrations`, and expanded `product-analytics`.
- Add baseline literacy for GA4, Google tag, GTM, sGTM, Measurement Protocol,
  Consent Mode, Firebase Analytics, Adobe Analytics/Tags/Web SDK, Amplitude,
  Mixpanel, PostHog, Segment, mParticle, RudderStack, Snowplow, Tealium,
  Contentsquare, FullStory, Hotjar, Microsoft Clarity, AppsFlyer, Adjust,
  Branch, Singular, Kochava, Meta CAPI, Enhanced Conversions, TikTok Events
  API, Pinterest Conversions API, Shopify, VTEX, WordPress, Magento/Adobe
  Commerce, WooCommerce, and equivalent platforms where relevant.
- Add `templates/TRACKING_PLAN.md` for vendor-neutral event measurement
  contracts.
- Add spec-driven workflow support through
  `workflows/spec-driven-development.md` and `templates/SPEC.md`.
- Add `rules/context-management.md`.
- Add lightweight agent/skill evaluation capabilities:
  `agent-evaluation`, `agent-observability`, `skill-evaluation`,
  `workflows/evaluate-agent.md`, and `workflows/evaluate-skill.md`.

### Removed

- Remove the old `portable/` layout and Claude-specific generated portable
  profiles/templates.
- Remove root `settings.json` in favor of `adapters/claude/settings.json`.
- Remove `skills/tech-lead/SKILL.md` after migrating Tech Lead to
  `roles/tech-lead.md`.

### Validation

- Validate shell script syntax for generation, install, init-project, sync,
  deploy, and portable build scripts.
- Validate Claude settings JSON.
- Validate generated catalog/adapters from canonical discovery.
- Validate automatic discovery with temporary skill plus temporary workflow,
  then remove fixtures and regenerate.
- Validate `init-project.sh` dry-run, execution, and idempotency, including
  spec directories.
- Confirm no hardcoded references to temporary discovery fixtures remain.
- Confirm no commit or push was performed.

## Versioning Policy

- `MAJOR`: breaking changes to directory layout, script contracts, adapter
  paths, or project bootstrap behavior.
- `MINOR`: compatible new skills, roles, workflows, profiles, rules, templates,
  adapters, or installer capabilities.
- `PATCH`: documentation fixes, wording improvements, and non-breaking script
  fixes.
