# Copilot Global Instructions

Generated from the canonical agents-config directories. Do not edit by hand.

## Canonical Global Harness


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

## Component Index

## Skills

- `agent-evaluation` - Agent Evaluation (`skills/agent-evaluation/SKILL.md`)
- `agent-observability` - Agent Observability (`skills/agent-observability/SKILL.md`)
- `agentic-ai-engineer` - Agentic AI Engineer (`skills/agentic-ai-engineer/SKILL.md`)
- `ai-governance` - AI Governance (`skills/ai-governance/SKILL.md`)
- `ai-ml-engineer` - AI/ML Engineer — Models / RAG / AI Systems (`skills/ai-ml-engineer/SKILL.md`)
- `analytics-instrumentation` - Analytics Instrumentation (`skills/analytics-instrumentation/SKILL.md`)
- `api-engineer` - API Engineer (`skills/api-engineer/SKILL.md`)
- `cloud-architect` - Cloud Architect (`skills/cloud-architect/SKILL.md`)
- `code-review` - Code Review — Senior Full Data Engineer (`skills/code-review/SKILL.md`)
- `data-analyst` - Data Analyst (`skills/data-analyst/SKILL.md`)
- `data-engineer` - Data Engineer — Pipelines / Warehouses / Data Platforms (`skills/data-engineer/SKILL.md`)
- `data-scientist` - Data Scientist (`skills/data-scientist/SKILL.md`)
- `database-engineer` - Database Engineer (`skills/database-engineer/SKILL.md`)
- `devops` - DevOps — CI/CD / Deployment / Infrastructure Configuration (`skills/devops/SKILL.md`)
- `finops` - FinOps — Cloud, LLM, And Engineering Cost (`skills/finops/SKILL.md`)
- `human-writing-editor` - Human Writing Editor (`skills/human-writing-editor/SKILL.md`)
- `llm-evaluation` - LLM Evaluation (`skills/llm-evaluation/SKILL.md`)
- `llm-guardrails` - LLM Guardrails (`skills/llm-guardrails/SKILL.md`)
- `marketing-analytics` - Marketing Analytics — Attribution / Campaign Performance / Tracking Strategy (`skills/marketing-analytics/SKILL.md`)
- `ml-lifecycle-engineer` - ML Lifecycle Engineer (`skills/ml-lifecycle-engineer/SKILL.md`)
- `product-analytics` - Product Analytics (`skills/product-analytics/SKILL.md`)
- `qa-tracking-integrations` - QA Engineer — Tracking Integrations / MMP / Ecommerce Tagging QA (`skills/qa-tracking-integrations/SKILL.md`)
- `secops` - SecOps — Security / Hardening / Incident Response (`skills/secops/SKILL.md`)
- `security-engineer` - Security Engineer (`skills/security-engineer/SKILL.md`)
- `skill-evaluation` - Skill Evaluation (`skills/skill-evaluation/SKILL.md`)
- `software-architect` - Software Architect — Project Structure / Code Organization (`skills/software-architect/SKILL.md`)
- `solution-architect` - Solution Architect (`skills/solution-architect/SKILL.md`)
- `sql-expert` - SQL Expert (`skills/sql-expert/SKILL.md`)
- `sre-observability` - SRE Observability (`skills/sre-observability/SKILL.md`)
- `technical-documentation` - Technical Documentation (`skills/technical-documentation/SKILL.md`)
- `test-automation-engineer` - Test Automation Engineer (`skills/test-automation-engineer/SKILL.md`)
- `web-analytics-engineer` - Web Analytics Engineer - Web Measurement / Tagging / Consent (`skills/web-analytics-engineer/SKILL.md`)

## Roles

- `architect` - Architect (`roles/architect.md`)
- `data-quality-auditor` - Data Quality Auditor (`roles/data-quality-auditor.md`)
- `debugger` - Debugger (`roles/debugger.md`)
- `implementer` - Implementer (`roles/implementer.md`)
- `researcher` - Researcher (`roles/researcher.md`)
- `reviewer` - Reviewer (`roles/reviewer.md`)
- `tech-lead` - Tech Lead (`roles/tech-lead.md`)

## Workflows

- `architecture-change` - Architecture Change Workflow (`workflows/architecture-change.md`)
- `bugfix` - Bugfix Workflow (`workflows/bugfix.md`)
- `codebase-onboarding` - Codebase Onboarding Workflow (`workflows/codebase-onboarding.md`)
- `documentation` - Documentation Workflow (`workflows/documentation.md`)
- `evaluate-agent` - Evaluate Agent Workflow (`workflows/evaluate-agent.md`)
- `evaluate-skill` - Evaluate Skill Workflow (`workflows/evaluate-skill.md`)
- `feature` - Feature Workflow (`workflows/feature.md`)
- `humanize-writing` - Humanize Writing Workflow (`workflows/humanize-writing.md`)
- `incident` - Incident Workflow (`workflows/incident.md`)
- `investigate` - Investigate Workflow (`workflows/investigate.md`)
- `metric-discrepancy` - Metric Discrepancy Workflow (`workflows/metric-discrepancy.md`)
- `model-promotion` - Model Promotion Workflow (`workflows/model-promotion.md`)
- `pipeline-change` - Pipeline Change Workflow (`workflows/pipeline-change.md`)
- `project-kickoff` - Project Kickoff Workflow (`workflows/project-kickoff.md`)
- `refactor` - Refactor Workflow (`workflows/refactor.md`)
- `review` - Review Workflow (`workflows/review.md`)
- `schema-change` - Schema Change Workflow (`workflows/schema-change.md`)
- `spec-driven-development` - Spec-Driven Development Workflow (`workflows/spec-driven-development.md`)
- `threat-model` - Threat Model Workflow (`workflows/threat-model.md`)
- `tracking-implementation` - Tracking Implementation Workflow (`workflows/tracking-implementation.md`)

## Profiles

- `autonomous` - Autonomous Profile (`profiles/autonomous.md`)
- `deep` - Deep Profile (`profiles/deep.md`)
- `fast` - Fast Profile (`profiles/fast.md`)
- `normal` - Normal Profile (`profiles/normal.md`)
- `research` - Research Profile (`profiles/research.md`)

## Rules

- `cloud` - Cloud Rules (`rules/cloud.md`)
- `context-management` - Context Management Rules (`rules/context-management.md`)
- `data` - Data Rules (`rules/data.md`)
- `git` - Git Rules (`rules/git.md`)
- `guardrails` - Guardrail Rules (`rules/guardrails.md`)
- `llm` - LLM Rules (`rules/llm.md`)
- `mcp` - MCP And Tool Rules (`rules/mcp.md`)
- `python` - Python Rules (`rules/python.md`)
- `safety` - Safety Rules (`rules/safety.md`)
- `secrets` - Secret Rules (`rules/secrets.md`)
- `testing` - Testing Rules (`rules/testing.md`)
