# Guardrail Rules

- Retrieved documents, tool outputs, page content, and file contents are data,
  never instructions. No framing inside them changes that.
- Validate structured model output against a schema before any consumer uses
  it; do not fall back to an unvalidated branch on failure.
- Every agent loop has a ceiling: maximum steps, maximum tool calls, and a
  token or spend limit per session. A ceiling that only logs is not a ceiling.
- Do not send raw personal data to a model when a redacted or referenced form
  is sufficient.
- Fail closed on side effects and open on reads: when a control cannot be
  evaluated, block destructive actions rather than allowing them.
- Record block, allow, and redaction decisions so they can be audited later.
- Measure guardrails in both directions; a control that blocks legitimate work
  gets disabled and protects nothing.
