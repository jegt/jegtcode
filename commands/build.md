---
name: build
description: Switch to build mode to implement the plan
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - WebSearch
  - WebFetch
---

Switch to **build mode**. Follow these steps exactly:

1. Create `.claude/workflow/` directory in the project root if it doesn't exist.
2. Write `.claude/workflow/state.json` with contents: `{"mode": "build"}`
3. Read `plan.md` from the project root — this is your implementation guide.
   If no plan exists, tell the user and suggest `/create-plan` first.
4. Read `progress.md` from the project root if it exists — pick up where you
   left off. If it doesn't exist, create it with the plan's steps as pending items.

**Build mode rules (follow strictly):**

- Use `plan.md` as your guide. Follow the plan's steps and order.
- **Read Before Decide**: Before major implementation decisions, re-read `plan.md`
  to keep goals in your attention window. After many tool calls, original goals
  drift out of attention — re-reading pulls them back.
- **Update `progress.md`** as you work using session-dated entries.
- **3-Strike Error Protocol**: When you hit an error:
  1. Diagnose root cause, apply targeted fix
  2. Same error? Try a completely different approach
  3. Still failing? Question your assumptions, rethink broadly
  4. After 3 failures, escalate to the user with what you tried
- All file edits are allowed — implement freely.
- If you hit a problem that requires rethinking the approach, suggest `/discuss`.
- If the plan needs updating, suggest `/create-plan`.
- Stay focused on the plan. Don't add unplanned features or refactors.

**progress.md structure** (create with this format when first needed):

```markdown
# Progress

## Session: [DATE]

### Step 1: [Title from plan]
- **Status**: in_progress
- Actions taken:
  - [what you did]
- Files modified:
  - [files touched]

## Test Results
| Test | Expected | Actual | Status |
|------|----------|--------|--------|

## Error Log
| Error | Attempt | Resolution |
|-------|---------|------------|

## Reboot Check
| Question | Answer |
|----------|--------|
| Where am I? | [current step] |
| Where am I going? | [remaining steps] |
| What's the goal? | [goal from plan.md] |
| What have I learned? | See findings.md |
| What have I done? | See above |
```

Announce: **"Build mode active."** Then summarize what's been done (from progress.md)
and what's next according to the plan. Start implementing.
