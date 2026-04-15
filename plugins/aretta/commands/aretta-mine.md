---
description: Mine formal specifications from code. Discovers invariants, pre/postconditions, and safety properties. Incremental — only finds new specs not already in .aretta-code/specs/.
---

Before calling the mine tool, you MUST write a comprehensive session context file. Follow these steps exactly:

1. Write the file `.aretta-code/session-context.md` with ALL of the following:
   - Every file you have read in this session (include FULL file contents, not summaries)
   - A summary of what the user has been working on and discussing
   - Any bugs, issues, or concerns mentioned
   - Any existing pf: annotations you have seen
   - Recent git changes if available (git diff output)
   - The project structure (list of key files and directories)

2. After writing the file, call the `mine` tool from the aretta-proof MCP server.

If the user specifies a focus area (e.g., "focus on the auth module"), pass it as the `focus` parameter.

$ARGUMENTS
