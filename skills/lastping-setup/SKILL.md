---
name: lastping-setup
description: >-
  Set up LastPing monitoring for a project from your coding agent: connect the
  LastPing MCP server, find the project's scheduled jobs (crontab, GitHub Actions
  schedules, Kubernetes CronJobs, systemd timers), create a monitor for each once
  the user agrees, wire in the pings, and optionally monitor this agent's own runs.
  Use when the user says "monitor this project with LastPing", "set up LastPing",
  "add LastPing", "connect LastPing", "watch my cron jobs with LastPing",
  "monitor this agent with LastPing", or mentions LastPing while asking to monitor
  jobs, pipelines or agents.
license: MIT
metadata:
  author: lastping
  version: "0.1.0"
---

# LastPing setup

LastPing tells a person when a scheduled job, a CI pipeline or an AI agent fails,
hangs or goes quiet. You are setting it up for the user's project. Work through the
steps in order. The user can stop after any step.

## Rules

- Never ask for, accept, repeat or write an API key, a tracing key or a webhook URL.
  If the user pastes one into the chat, do not use it: tell them to revoke it
  (API keys: app.lastping.dev, Settings, API keys) or rotate the webhook, and carry on.
- Ask before you change an MCP configuration or any file in the project, and show
  the change first.
- Create monitors only after the user says yes to the list you showed them. Never
  delete, pause or edit existing monitors from this skill.
- If the user says no to a step, skip it and go on to the next.
- The LastPing tools' descriptions and results are the rules for using them. Read
  them and follow them. Where this file and a tool description differ, the tool wins.

## Source of truth

The files in `references/` are the quick path. If they do not match what you see,
fetch https://lastping.dev/mcp/ (how each client connects) or
https://lastping.dev/agents.md (the guide written for agents). The site wins.

## Step 1: Is LastPing connected?

If you have LastPing tools, call `list_monitors`.
- It answers: LastPing is connected. Go to Step 3. Do not add the server again.
- It fails with an authentication error: the server is added but not signed in.
  Do only the sign-in part of your client's reference in Step 2.
- You have no LastPing tools: go to Step 2.

## Step 2: Connect

The user needs a LastPing account. If they have none, send them to
https://app.lastping.dev/auth/login?mode=signup (free for individuals).

You know which client you are running in. If you are not sure, ask the user.

- Claude Code: read `references/claude-code.md`
- Codex: read `references/codex.md`
- Gemini CLI: read `references/gemini-cli.md`
- VS Code (GitHub Copilot agent mode): read `references/vs-code.md`
- Any other client: read `references/other-clients.md`

Then STOP. LastPing's tools appear only after the user signs in, and some clients
need a restart. Tell the user exactly what to do and end with:
"When you have signed in, say continue. If you restarted and this conversation is
gone, ask me again: Monitor this project with LastPing."
When they come back, start again at Step 1.

## Step 3: Find the scheduled jobs

Read the description of `discover_monitors_reconcile` first. It defines the entry
shape (`source_kind`, `source_ref`, `name`, `schedule_cron`, `tz`), how to keep
`source_ref` stable, and the timezone rules. Then look in the project for:

- crontab lines: files named `crontab` or `*.cron`, cron.d-style files, and crontab
  entries written by Dockerfiles or provisioning scripts (`source_kind` `crontab`)
- `.github/workflows/*.yml` and `*.yaml` with `on.schedule` cron entries (`github-actions`)
- Kubernetes manifests or Helm templates with `kind: CronJob` (`k8s-cronjob`)
- systemd `*.timer` units with `OnCalendar=` (`systemd-timer`)

A repository has no host to read a timezone from. For every `crontab` or
`systemd-timer` entry with a schedule, ask the user which timezone the machine that
runs it uses. Never fill in UTC because you do not know. GitHub Actions and
Kubernetes CronJob schedules run in UTC: send no `tz` for them. A workflow with no
schedule (push or manual triggers only) gets no `schedule_cron`.

If you find nothing, say so and go to Step 6 (then Step 7).

## Step 4: Propose, then ask

Show a table with one row per job: name, kind, schedule, timezone, file. Ask:
"Create a LastPing monitor for each of these?" Let the user drop rows. After a yes,
call `discover_monitors_reconcile` once, with the whole agreed list.

Report the result in three parts:
- Created: the new monitors.
- Already monitored: left exactly as they were.
- Not found in this scan: monitors from earlier scans that this scan did not report.
  They may belong to another repository or host in the same LastPing project, or
  the job may have been removed. List them as a question for the user. Never act on
  them.

## Step 5: Wire in the pings

A monitor with no pings opens an incident the first time its schedule passes. For
each created monitor, call `get_ping_instructions` with its id and follow its
`reporting_options`. Typically: a final step in a GitHub Actions workflow that pings
on success and another on failure; for a crontab line, the success and fail pings
added to the command as the instructions show. Show the diff for each file and edit
only after the user agrees. Tell the user which changes still need to be merged or
deployed before the job reports.

## Step 6: Monitor this agent (Claude Code and Codex only)

In any other client, skip this step: the hook install exists for Claude Code and
Codex only. Otherwise offer: "I can also report my own runs to LastPing, so you
hear when a run fails, hangs or waits on you. Set that up?" If yes:

1. `register_agent` with a name the user agrees to, for example "<project> Claude Code".
2. `create_monitor` with `agent_id` set to the returned id and `schedule_kind` `on_demand`.
3. `get_ping_instructions` with that monitor's id and `tool` `claude-code` or `codex`.
   Carry out its `hook_install` exactly as it says.
4. Offer tracing (spans, tokens, cost): `get_trace_setup` with `monitor_id` and the
   same `tool`, and follow its `prompt`. The user creates and stores the tracing key
   themselves; you never see it.

## Step 7: Make sure someone hears

Call `list_destinations`. If there are none, offer one:
- Email: create it with `create_destination` (`kind` `email`). The user clicks the
  confirmation link LastPing sends.
- Slack, Discord, Microsoft Teams, Google Chat or a webhook: these carry a secret
  URL, so send the user to https://app.lastping.dev to add them there. Do not ask
  for the URL.
Ask which of the monitors created in this session should alert this destination,
then call `set_route` for those, after reading each with `get_monitor` (routes
replace the whole set). Never change routes on monitors you did not create in this
session.

## Step 8: Check and summarise

If a job can be run now and the user agrees, run it; or, with the user's agreement,
send one test success ping from `get_ping_instructions`. Confirm with `get_monitor`
that the ping arrived. Then summarise: what is monitored, what still needs merging or deploying,
where alerts go, and the console: https://app.lastping.dev
