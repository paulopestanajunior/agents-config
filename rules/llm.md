# LLM Rules

- Treat model calls as expensive, non-deterministic network I/O.
- Do not let agents fabricate factual answers outside tool or source evidence.
- Validate structured model output before trusting it.
- Separate prompt quality evaluation from unit tests around orchestration,
  parsing, and tool contracts.
- Measure token cost, latency, retries, and cache hit rate when optimizing LLM
  systems.
- Guardrail enforcement is a layer separate from the model call; designing a
  limit and enforcing it are different responsibilities.
- No model version is promoted without passing a defined evaluation gate, and
  no gate passes without a recorded result.
