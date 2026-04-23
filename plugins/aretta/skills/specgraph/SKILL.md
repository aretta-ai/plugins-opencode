---
name: specgraph
description: Query the specification argument graph — coverage, gaps, impact analysis. Manage spec nodes and edges.
---

IMMEDIATELY call the `specgraph` tool from the aretta-proof MCP server. Do NOT explain or add preamble before calling the tool.

Determine the action from the user's message:
- "stats" / "overview" / "how many specs" → action: "stats"
- "list" / "show specs" / "what specs exist" → action: "list"
- "coverage" / "what's covered" → action: "coverage" (need node_id — ask or use a root goal)
- "gaps" / "what's undefended" / "attacks" → action: "gaps"
- "impact" / "what does this file affect" → action: "impact" (need file_path)
- "dashboard" / "visualize" / "open graph" → action: "dashboard"
- "create" / "add node" → action: "create_node" (need node_type + title)
- "update" / "mark verified" → action: "update_node" (need node_id + fields)
- "link" / "connect" / "edge" → action: "create_edge" (need source_id + target_id + edge_type)

If NO arguments provided: call with action "stats" to show the graph overview.

After the tool returns, interpret the result clearly — summarize coverage status, gaps, or node details in a readable format.

$ARGUMENTS
