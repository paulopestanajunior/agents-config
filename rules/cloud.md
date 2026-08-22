# Cloud Rules

- Prefer least-privilege identities and scoped permissions.
- Treat compute, storage, network egress, warehouse scans, managed-service
  tiers, job frequency, and API calls as design constraints.
- Use explicit environment separation for development, staging, and
  production.
- Do not change production resources, budgets, permissions, or networking
  without explicit approval.
- Keep labels/tags, ownership, environment, and billing attribution visible for
  cloud and platform resources.
- Keep provider-specific conventions in project context or overrides, not in
  the global harness.
