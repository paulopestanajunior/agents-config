# Threat Model Workflow

1. Define the scope: which system, which release, and what is explicitly out.
2. Map trust boundaries and identify every attacker-controlled input crossing
   them, including retrieved content and tool output.
3. Inventory sensitive assets: credentials, personal data, money movement,
   destructive actions, and privileged capabilities.
4. Enumerate abuse cases per boundary, not per file.
5. Rate each by exploitability and impact; drop the ones that are theoretical
   in this system.
6. Name the existing control for each surviving case, or record that none
   exists.
7. Assign an owner and a decision for every gap: fix, accept with rationale, or
   defer with a date.
8. Record residual risk where the team will read it again.
