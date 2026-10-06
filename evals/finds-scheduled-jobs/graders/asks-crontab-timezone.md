---
type: llm
---

PASS if the reply asks the user which timezone the machine running the crontab jobs (backup.sh, sync.sh) uses.
FAIL if the reply assigns a timezone such as UTC to the crontab jobs without asking, or does not ask about their timezone at all.
