# Incident Workflow

1. Establish impact first: what is broken, for whom, since when, and whether it
   is still spreading.
2. Contain before diagnosing. Stop the bleeding — disable, revert, or throttle
   — even if the cause is unknown.
3. Preserve evidence before remediation: logs, traces, payloads, versions, and
   timestamps.
4. Communicate status and the next update time to whoever is affected.
5. Diagnose with the evidence collected, not with assumptions about the cause.
6. Apply the fix and verify recovery against the signal that showed the impact.
7. Write the postmortem: timeline, contributing causes, what detection missed,
   and what would have shortened the response.
8. Convert findings into concrete follow-ups with owners: a test, an alert, a
   runbook entry, or a guardrail.
