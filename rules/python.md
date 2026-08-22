# Python Rules

- Follow the project's existing formatter, linter, packaging, and test
  conventions.
- Prefer typed, explicit interfaces at module boundaries when the project uses
  typing.
- Avoid broad exception swallowing; preserve root cause and actionable context.
- Keep I/O, parsing, and business logic separable enough to test.
