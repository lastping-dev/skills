---
description: The user asks Claude Code to report its own runs to LastPing. The skill should take the Claude Code hook path and never ask for or show a key.
expected_outcome: register_agent, an on-demand monitor, then get_ping_instructions with tool claude-code; the reply describes the hook install and asks for no key.
tags: [agent]
runs: 2
max_turns: 20
allowed_tools: [Read, Glob, Grep, Skill]
---

I use Claude Code in this project. Monitor this agent's own runs with LastPing so I hear when a run fails or hangs. Name it "demo-app Claude Code". I only run it when I'm working, never on a schedule. You have my go-ahead for the LastPing steps.
