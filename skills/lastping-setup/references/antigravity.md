# Connect Antigravity CLI

1. Ask: "May I add LastPing to your Antigravity CLI MCP configuration?" Wait for a yes.
2. Run: `agy mcp add lastping https://mcp.lastping.dev/mcp`
   This adds the server, or updates it if it is already there.
3. Tell the user: "In Antigravity CLI type /mcp, choose lastping, choose Authenticate and sign in to LastPing in the browser that opens. If the LastPing tools do not appear, restart with agy -c to continue this conversation. Then say continue."
4. After continue: `list_monitors` answers.

If something fails, go back to the sign-in step. Do not look into Antigravity's own
configuration to find out why.
