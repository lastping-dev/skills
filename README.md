# LastPing skills

Agent skills for [LastPing](https://lastping.dev), the dead man's switch for cron
jobs, CI/CD pipelines and AI agents.

## Install

```
npx skills add lastping-dev/skills
```

Then ask your coding agent: **Monitor this project with LastPing**

## lastping-setup

- Connects LastPing's MCP server (https://mcp.lastping.dev/mcp). In Claude Code, Codex,
  Antigravity CLI and VS Code the skill connects LastPing with you; any other
  assistant is walked through https://lastping.dev/mcp/. You sign in once, in your
  browser.
- Finds the scheduled jobs in the project (crontab, GitHub Actions schedules,
  Kubernetes CronJobs, systemd timers), shows you the list, and creates monitors only
  after you agree.
- Adds the pings to each job, showing you every change first.
- Optionally reports Claude Code or Codex's own runs, with traces.

What it never does: ask for or handle your API key, tracing key or webhook URLs;
change a file without showing you; delete, pause or edit existing monitors.

Free for individuals. MIT licence.
