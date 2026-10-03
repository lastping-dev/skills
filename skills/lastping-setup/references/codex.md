# Connect Codex

1. Ask: "May I add LastPing to your Codex MCP configuration?" Wait for a yes.
2. Run `codex mcp list`. If `lastping` is listed as Connected, go back to Step 1 of
   the skill. If it is listed and was added with a key, ask the user to delete its
   block from `~/.codex/config.toml` themselves. Do not open that file: it can hold keys.
3. Run: `codex mcp add lastping --url https://mcp.lastping.dev/mcp`
   Codex opens the browser to sign in to LastPing. If no browser opened, run
   `codex mcp login lastping`. If your sandbox blocks the command, give the user
   both commands to run in their own terminal.
4. Codex loads MCP tools when a session starts. Tell the user to restart Codex
   (`codex resume` reopens this conversation) and say continue.
5. After continue: `codex mcp list` lists lastping and `list_monitors` answers.
