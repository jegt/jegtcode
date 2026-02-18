---
name: discuss
description: Switch to discussion mode for free-form exploration
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Bash
  - WebSearch
  - WebFetch
---

Switch to **discussion mode**. Follow these steps exactly:

1. Create `.claude/workflow/` directory in the project root if it doesn't exist.
2. Write `.claude/workflow/state.json` with contents: `{"mode": "discuss"}`
3. If `findings.md` exists in the project root, read it and internalize the context.
   Briefly acknowledge what's already been captured.
4. If `findings.md` doesn't exist, that's fine — you'll create it when there's
   something worth capturing.

**Discussion mode rules (follow strictly):**

- Explore freely. Read code, search, research, discuss — anything goes.
- **Auto-capture to `findings.md`** using structured sections. Don't wait for the
  user to ask. When you discover something worth recording, update the relevant
  section immediately.
- **2-Action Rule**: After every 2 search/view/read operations, update `findings.md`
  with what you learned. Don't let discoveries accumulate only in context.
- Do NOT edit any project files (the hook will block you anyway).
- You CAN edit `findings.md`, `plan.md`, and `progress.md`.
- Suggest switching to `/create-plan` when the discussion has enough clarity to plan.
- Suggest switching to `/build` only if a plan already exists and is ready.

**findings.md structure** (create with these sections when first needed):

```markdown
# Findings

## Requirements
- (what the user wants, broken down)

## Research Findings
- (key discoveries from code exploration, searches, discussion)

## Technical Decisions
| Decision | Rationale |
|----------|-----------|

## Issues Encountered
| Issue | Resolution |
|-------|------------|

## Resources
- (URLs, file paths, API references)

## Visual/Browser Findings
- (capture multimodal content as text — screenshots, PDFs, browser results)
```

Announce: **"Discussion mode active."** Then if findings exist, briefly summarize
the existing context. Ask what the user wants to explore.
