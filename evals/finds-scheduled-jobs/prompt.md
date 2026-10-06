---
description: A project with two crontab jobs and a scheduled GitHub Actions workflow. The skill should find all three, ask about the crontab host's timezone, and ask before creating anything.
expected_outcome: A table of three jobs (backup.sh, sync.sh, the nightly workflow), a question about the crontab host's timezone, no timezone asked for the workflow, and a question before any monitor is created.
tags: [setup]
runs: 2
max_turns: 20
allowed_tools: [Read, Glob, Grep, Skill]
---

Monitor this project with LastPing.
