# Connect any other client

1. Fetch https://lastping.dev/mcp/ and find this client's steps: the "Connect your
   client: sign in" section first, then "Connect your client: API key" (Cursor and
   Windsurf use a key).
2. Walk the user through those steps one at a time, waiting for each. The user
   edits their client's configuration themselves; do not open or read it.
3. For a client that uses an API key: the user creates the key at app.lastping.dev,
   Settings, API keys. Show the config with the placeholder `lp_your_key` and tell
   the user to put it in their configuration and replace it with the key themselves. Never ask for the key.
4. If the client is not on that page: it needs Model Context Protocol over
   Streamable HTTP at https://mcp.lastping.dev/mcp, with either browser sign-in
   (OAuth) or an `Authorization: Bearer <key>` header. If it supports neither, tell
   the user LastPing also works over plain HTTP and REST
   (https://lastping.dev/agents.md) and stop.
5. Tell the user to reload or restart the client if its steps say so, then say continue.
