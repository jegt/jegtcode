---
name: create-plan
description: Switch to planning mode to create/refine an implementation plan
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Bash
  - WebSearch
  - WebFetch
---

Switch to **planning mode**. Follow these steps exactly:

1. Create `.claude/workflow/` directory in the project root if it doesn't exist.
2. Write `.claude/workflow/state.json` with contents: `{"mode": "plan"}`
3. Read `findings.md` from the project root if it exists — this is your discussion
   context. Reference these findings in your plan.
4. Read `plan.md` from the project root if it exists — you may be refining an
   existing plan rather than creating a new one.

**Planning mode rules (follow strictly):**

- Create or refine `plan.md` in the project root.
- Read code freely to inform the plan.
- Do NOT edit any project files (the hook will block you anyway).
- You CAN edit `findings.md`, `plan.md`, and `progress.md`.
- Refine the plan through conversation — the user may request changes.
- Suggest switching to `/build` when the plan is solid and agreed upon.
- Suggest switching to `/discuss` if planning reveals gaps that need more exploration.

**plan.md structure**:

```markdown
# Plan: [Brief Description]

## Goal
[One clear sentence describing the end state]

## Key Questions
1. [Open questions to resolve before/during implementation]

## Steps

### Step 1: [Title]
- [ ] Task details
- **Verify**: [How to confirm this step is done]

### Step 2: [Title]
- [ ] Task details
- **Depends on**: Step 1
- **Verify**: [How to confirm this step is done]

## Decisions Made
| Decision | Rationale |
|----------|-----------|

## Notes
- [Anything else relevant]
```

Announce: **"Planning mode active."** Then present the current plan (if refining)
or draft a new one based on findings. Ask for the user's input.
