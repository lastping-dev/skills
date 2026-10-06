---
type: fixed
expect:
  name: string
---

{"id": "3e9d5a71-8c2b-4f60-a1d4-6b7e0c9f2d83", "slug": "eval-agent", "name": "{{input.name}}", "next": "Attach a monitor with create_monitor agent_id, then call get_ping_instructions with the monitor id and your tool."}
