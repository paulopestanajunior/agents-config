# Evaluate Agent Workflow

1. Define the agent behavior to evaluate and the change under test.
2. Select representative tasks, including common, edge, and high-risk cases.
3. Define success criteria before running: correctness, artifacts, safety,
   validation, tool behavior, latency, and cost where measurable.
4. Run or inspect a baseline when possible.
5. Run or inspect the changed agent under comparable conditions.
6. Compare outcomes, tool calls, edited files, validation, failures, latency,
   token/cost usage, and regressions.
7. Convert failures into regression cases or concrete harness changes.

Use this workflow when evaluating prompts, adapters, workflows, roles, tools,
or agentic systems end to end. Use LLM Evaluation instead when the question is
only model/prompt response quality.
