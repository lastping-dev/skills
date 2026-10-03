# Connect Antigravity CLI

1. Ask: "May I add LastPing to your Antigravity CLI MCP configuration?" Wait for a yes.
2. Run `agy mcp list | grep -i lastping`. If lastping is listed, go back to Step 1 of the skill.
3. Run: `agy mcp add lastping https://mcp.lastping.dev/mcp`
4. Tell the user: "In Antigravity CLI type /mcp, choose lastping, choose Authenticate and sign in to LastPing in the browser that opens. If the LastPing tools do not appear, restart with agy -c to continue this conversation. Then say continue."
5. After continue: `list_monitors` answers.

Never open ~/.gemini/config/mcp_config.json yourself: it can hold other servers' keys.
