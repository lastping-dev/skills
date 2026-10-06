# Connect Codex

If you already have LastPing tools, skip this file and go back to Step 1 of the skill.

1. Ask: "May I add LastPing to your Codex MCP configuration?" Wait for a yes.
2. Run: `codex mcp add lastping --url https://mcp.lastping.dev/mcp`
   Codex opens the browser to sign in to LastPing. If it reports that the server
   already exists, or no browser opened, run `codex mcp login lastping`. If your
   sandbox blocks the command, give the user both commands to run in their own
   terminal. Never inspect the configuration to find out why.
3. Codex loads MCP tools when a session starts. Tell the user to restart Codex
   (`codex resume` reopens this conversation) and say continue.
4. After continue: `list_monitors` answering is the only check.
