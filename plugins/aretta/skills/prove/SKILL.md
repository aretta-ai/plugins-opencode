---
name: prove
description: Run formal verification with the Aretta proof agent.
---

IMMEDIATELY call the `prove` tool from the aretta-proof MCP server. Do NOT explain or add preamble before calling the tool.

If the user provides arguments: pass their message as the `prompt` parameter. If they mention specific files, include those as `source_files`.

If NO arguments are provided: construct the prompt yourself by summarizing your current session context. Include in the prompt:
- What files the user has read or edited in this session
- What code was discussed, any bugs or issues mentioned
- Any pf: annotations you've seen (pf:invariant, pf:ensures, pf:never)
- The relevant source code
- End with: "Based on this context, find the most interesting property to verify — especially one likely to FAIL. Build a faithful model and look for counterexamples."

After the tool returns, interpret the result: explain what was proved or failed, summarize trust levels, and highlight any trust gaps or assumptions.

$ARGUMENTS
