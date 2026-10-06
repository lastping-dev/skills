# LastPing for Claude

[LastPing](https://lastping.dev) is the dead man's switch for cron jobs, CI/CD
pipelines and AI agents: it tells you when a scheduled job, a pipeline or an agent
fails, hangs or goes quiet. This repository is both a Claude plugin and a set of
agent skills.

The plugin gives Claude two things:

- **The LastPing connector**: LastPing's MCP server at https://mcp.lastping.dev/mcp,
  so Claude can list, create and manage your monitors, incidents and alert
  destinations.
- **The lastping-setup skill**: a guided set-up that finds the scheduled jobs in your
  project and monitors them, asking you before every change.

## Install

### As a Claude plugin

From Anthropic's plugin directory: find **LastPing** and add it.

In Claude Code, from this repository's marketplace:

```
/plugin marketplace add lastping-dev/skills
/plugin install lastping@lastping
```

Then sign in: in Claude Code type `/mcp`, choose the plugin's lastping server and
sign in to LastPing in the browser that opens. On claude.ai and in Cowork, connect
LastPing on the plugin's Connectors tab. You need a LastPing account; create one at
https://app.lastping.dev/auth/login?mode=signup (free for individuals).

If you already connected LastPing from the Connectors Directory, the plugin points
at the same server, so you keep one set of LastPing tools and one sign-in.

### As a skill in any coding agent

```
npx skills add lastping-dev/skills
```

This installs the lastping-setup skill only. The skill connects LastPing with you in
Claude Code, Codex, Antigravity CLI and VS Code, and walks any other assistant
through https://lastping.dev/mcp/. You sign in once, in your browser.

## Use it

Ask Claude: **Monitor this project with LastPing**

The lastping-setup skill then:

- Checks that LastPing is connected, and helps you connect it if not.
- Finds the scheduled jobs in the project (crontab, GitHub Actions schedules,
  Kubernetes CronJobs, systemd timers), shows you the list, and creates monitors
  only after you agree.
- Adds the pings to each job, showing you every change first.
- Optionally reports Claude Code, Codex or Antigravity CLI's own runs, with traces.
- Offers an email alert destination, and sends you to the LastPing console for
  Slack, Discord, Teams, Google Chat or webhooks.

## What it runs, sends and fetches

- **MCP connection.** Claude talks to LastPing's MCP server at
  https://mcp.lastping.dev/mcp. You sign in with LastPing in your browser (OAuth);
  the plugin holds no keys. Monitors, incidents and destinations you create or read
  go through this connection to your LastPing account.
- **Reading your project.** The skill reads the project's files to find schedules.
  It sends only what it proposes and you approve (job names, schedules, timezones and
  the file each came from) to LastPing, when it creates the monitors.
- **Editing your project.** With your agreement it adds ping commands to your jobs;
  those jobs then send pings to LastPing when they run.
- **Monitoring Claude Code itself (optional).** If you say yes, the skill installs
  LastPing's Claude Code hook: it writes `~/.claude/lastping-report.sh` and adds hook
  entries to `~/.claude/settings.json`. From then on each Claude Code run sends start,
  step and end pings to https://ping.lastping.dev. Codex and Antigravity CLI get the
  equivalent hook in their own configuration, shown to you before it is written.
- **Tracing (optional).** If you say yes, the skill helps you set up OpenTelemetry
  tracing so your agent's runs report spans, tokens and cost to LastPing. You create
  and store the tracing key yourself; the skill never sees it.
- **Fetching docs.** If its quick-reference notes do not match what it sees, the
  skill reads https://lastping.dev/mcp/ or https://lastping.dev/agents.md.

Nothing is sent anywhere other than LastPing. The plugin runs no hooks or scripts of
its own; everything above happens only when you ask for set-up and agree to the step.
How LastPing handles your data: https://lastping.dev/privacy/

What it never does: ask for or handle your API key, tracing key or webhook URLs;
change a file without showing you; delete, pause or edit existing monitors.

## Licence

MIT. Free for individuals. Support and documentation: https://lastping.dev
