# Install the skill in other agents

The open skills CLI installs the lastping-setup skill into Codex, Cursor, VS Code and
other coding agents. It downloads the CLI from npm and runs it, so the version is
pinned to the one this repository's CI tests:

```
npx skills@1.7.0 add lastping-dev/skills
```

This installs the lastping-setup skill only. The skill connects LastPing with you in
Claude Code, Codex, Antigravity CLI and VS Code, and walks any other assistant
through https://lastping.dev/mcp/. You sign in once, in your browser.
