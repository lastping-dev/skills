# Connect Claude Code

If you already have LastPing tools, for example from the LastPing plugin, skip this
file: LastPing is added. Go back to Step 1 of the skill.

1. Ask: "May I add LastPing to your Claude Code MCP configuration (user scope)?"
   Wait for a yes.
2. Run:
   `claude mcp add --transport http --scope user lastping https://mcp.lastping.dev/mcp`
   If it reports that the server already exists, do not look into why: go to 3.
3. Tell the user: "Type /mcp, choose lastping and sign in to LastPing in the browser
   that opens. If /mcp does not list lastping yet, restart with claude --continue
   first. Then say continue."
4. After continue: `list_monitors` answering is the only check. If the tools are
   still missing, tell the user to restart with `claude --continue` so they load.

The sign-in is the user's. You cannot do it for them.
