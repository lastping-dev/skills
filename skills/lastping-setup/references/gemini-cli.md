# Connect Gemini CLI

1. Ask: "May I add LastPing to ~/.gemini/settings.json?" Wait for a yes.
2. Merge this into the file; keep everything already there:

   {"mcpServers": {"lastping": {"httpUrl": "https://mcp.lastping.dev/mcp"}}}

   Use `httpUrl`, not `url`: Gemini CLI reads `url` as SSE, which LastPing does not
   speak. Show the user only the lastping block you are adding, never the rest of
   the file: it can hold other servers' secrets. Never print other entries.
3. Tell the user: "Restart Gemini CLI, run /mcp auth lastping and sign in to
   LastPing in the browser that opens. /mcp then lists lastping. Then ask me again:
   Monitor this project with LastPing."
