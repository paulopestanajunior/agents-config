# Secret Rules

- Never commit credentials in any form: service account JSON, private keys,
  API tokens, connection strings with embedded passwords, or signed URLs.
- Keep `.env` and equivalent local config out of version control; commit an
  example file with placeholder values instead.
- Never inline a warehouse, database, or API credential in a notebook, query,
  DAG, job definition, or connector configuration. Reference a secret manager
  or an injected environment variable.
- Do not paste credentials into prompts, issue descriptions, commit messages,
  or tool arguments.
- Do not print secrets in logs, error messages, stack traces, or debug output.
- Treat a credential that reached a shared surface as compromised: rotate it
  rather than removing the reference.
- Use scoped, short-lived credentials over long-lived broad ones when the
  platform supports it.
- Do not weaken a secret scan or ignore rule to make a commit pass; fix the
  finding or justify it explicitly.
