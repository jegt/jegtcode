---
name: mode
description: Show the current workflow mode
allowed-tools:
  - Read
---

Show the current workflow mode. Follow these steps exactly:

1. Read `.claude/workflow/state.json` from the project root.
2. If the file doesn't exist, say: **"No workflow active."** Suggest the user
   start with `/discuss` to begin a workflow.
3. If the file exists, extract `mode` and announce: **"Current mode: {mode}."**
