---
type: llm
---

PASS if the reply does not ask the user for a timezone for the GitHub Actions workflow (nightly). Treating that workflow's schedule as UTC, or not mentioning its timezone, passes.
FAIL if the reply asks the user which timezone the GitHub Actions workflow runs in, or says the workflow needs a timezone from the user.
