# Changelog

## 1.1.0 - 2026-08-31

### Added

- `skills/ml-lifecycle-engineer`: model and dataset registry, versioning,
  promotion path, serving, retraining, champion/challenger and shadow runs,
  rollback, production drift, and training/serving consistency.
- `skills/llm-guardrails`: input filtering, output validation, prompt and tool
  injection defense, PII redaction before the model, refusal policy, cost and
  loop ceilings, and action allowlists.
- `skills/ai-governance`: model cards, fairness and explainability
  requirements, human oversight, training data provenance and legal basis,
  regulatory mapping, and approval records.
- Data workflows: `pipeline-change`, `metric-discrepancy`, `schema-change`, and
  `tracking-implementation`. `metric-discrepancy` drives the previously orphan
  `data-quality-auditor` role.
- Operational workflows: `model-promotion`, `threat-model`, and `incident`.
  Security, model promotion, and incident response previously existed as skills
  with no execution sequence.
- Project entry workflows: `project-kickoff` for a greenfield idea or briefing
  and `codebase-onboarding` for an existing repository. Both fill the artifacts
  that `init-project` creates empty.
- `rules/secrets.md` and `rules/guardrails.md`.
- `templates/MODEL_CARD.md`, `templates/DATASET_CONTRACT.md`, and
  `templates/WORKING_CONTEXT.md`.
- `scripts/validate-components.sh` and `.ps1`: verify skill frontmatter,
  resolve every `-> Component` delegation edge against discovered components,
  report unresolved targets, and flag mutual delegation and unqualified domain
  labels.

### Changed

- Resolve component boundaries by an ordered cascade on the temporal scope of
  the object — versioned artifact, per-request decision, or repository artifact
  — replacing the ambiguous split between `ai-ml-engineer` and
  `agentic-ai-engineer`. This assigns a single owner for memory, RAG, model
  routing, tool contracts, and coordinator topology.
- `ai-ml-engineer` narrows to model-call design: tool contracts and coordinator
  delegation move to `agentic-ai-engineer`, the eval block moves to
  `llm-evaluation`, and RAG is qualified as corpus construction.
- `agentic-ai-engineer` drops the dangling claim that `ai-ml-engineer` covers
  model lifecycle, and states positive ownership of per-request concerns.
- `data-scientist`, `data-engineer`, `secops`, `security-engineer`,
  `llm-evaluation`, and `agent-observability` route to the new owners;
  `agent-observability` now requires model and prompt version as trace fields.
- Entry points `devops`, `software-architect`, `solution-architect`,
  `roles/architect`, and `finops` route to the full AI cluster instead of
  defaulting to `ai-ml-engineer`.
- Close the feature-store dead zone: feature definition belongs to
  `data-scientist`, the table and its contract to `data-engineer`, and serving
  with point-in-time correctness to `ml-lifecycle-engineer`.
- Weave bounded context, ubiquitous language, and anti-corruption layer into
  `software-architect`, `data-engineer`, `analytics-instrumentation`, and
  `solution-architect` rather than adding a domain-modeling skill.
- Expand `rules/data.md` with grain, fitness, reconciliation, and audit-trail
  constraints; expand `rules/llm.md` with guardrail-layer separation and the
  model promotion gate.
- `init-project.sh` and `.ps1` create `WORKING_CONTEXT.md` and print the
  follow-up workflow, closing the gap between bootstrap and the components that
  fill the artifacts.
- Document the boundary writing rule in `AGENTS.md`: every delegation names the
  sub-object, never the bare domain.

### Validation

- Run `validate-components.sh` and `.ps1`: 75 components, 80 edges, 0 errors;
  remaining warnings are intended mutual delegations with distinct sub-objects.
- Confirm no dangling delegation target and that prompt injection terminates in
  `llm-guardrails` with no return edge.
- Confirm terms absent before this release (`model registry`, `retraining`,
  `champion`, `canary`, `shadow`, `model card`, `fairness`, `refusal`, `LGPD`)
  now resolve to the owning components.
- Regenerate adapters and catalog; verify 32 Copilot profiles and byte-identical
  output on a second run.

## 1.0.0 - 2026-08-22

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
- Harden shell and PowerShell generator parity to avoid markdown escape
  corruption, duplicate bundle headings, partial bundle writes, and recurring
  generated-file churn.
- Harden PowerShell install path handling for existing or dangling links.

### Added

- Add canonical component directories for roles, workflows, profiles, rules,
  templates, scripts, and adapters.
- Add dynamic discovery for `skills/<name>/SKILL.md`, `roles/*.md`,
  `workflows/*.md`, `profiles/*.md`, and `rules/*.md` in adapter/catalog
  generation.
- Add generated adapters for Claude, Codex, Copilot, Kimi, and ZCode.
- Add installer support for shell and PowerShell, including Kimi/ZCode links
  and Claude RTK settings preservation.
- Add Codex skill installation through per-skill links into `~/.codex/skills`,
  preserving Codex system skills.
- Move replaced Codex skill directories to `~/.codex/skills-backups` so backup
  copies do not remain discoverable as active skills.
- Prune stale Codex skill links managed by the harness when skills are renamed
  or removed.
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
- Validate generated bundles contain a single generated banner and no nested
  component-index H1.
- Validate automatic discovery with temporary skill plus temporary workflow,
  then remove fixtures and regenerate.
- Validate `init-project.sh` dry-run, execution, and idempotency, including
  spec directories.
- Confirm no hardcoded references to temporary discovery fixtures remain.

## Versioning Policy

- `MAJOR`: breaking changes to directory layout, script contracts, adapter
  paths, or project bootstrap behavior.
- `MINOR`: compatible new skills, roles, workflows, profiles, rules, templates,
  adapters, or installer capabilities.
- `PATCH`: documentation fixes, wording improvements, and non-breaking script
  fixes.
