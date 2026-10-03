# Connect Claude Code

1. Ask: "May I add LastPing to your Claude Code MCP configuration (user scope)?"
   Wait for a yes.
2. Run `claude mcp get lastping`.
   - `lastping` is listed and Connected: if `list_monitors` is available in this
     session, go back to Step 1 of the skill. If it is not, tell the user to restart
     with `claude --continue` so the tools load, then say continue.
   - `lastping` is listed but was added with an API key (the user says so, or it
     shows an Authorization header): ask, then run
     `claude mcp remove lastping --scope user`.
3. Run:
   `claude mcp add --transport http --scope user lastping https://mcp.lastping.dev/mcp`
4. Tell the user: "Type /mcp, choose lastping and sign in to LastPing in the browser
   that opens. If /mcp does not list lastping yet, restart with claude --continue
   first. Then say continue."
5. After continue: `claude mcp get lastping` shows lastping Connected and `list_monitors` answers.

The sign-in is the user's. You cannot do it for them.
