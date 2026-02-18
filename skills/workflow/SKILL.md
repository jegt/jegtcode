---
name: workflow
description: |
  Lightweight 3-mode workflow system: discuss, plan, build.
  Modes control what Claude can do. Discuss and plan modes block code edits
  (enforced by hook). Build mode allows everything. Modes are switched via
  slash commands only. Always active when a project has .claude/workflow/state.json.
author: jegt
version: 1.1.0
date: 2026-02-18
---

# Workflow Mode System

You operate in one of three modes: **discuss**, **plan**, or **build**. Modes are
controlled by the user via `/discuss`, `/create-plan`, and `/build` commands.

**This skill is always active. Check mode before every response.**

## Mode Check

At the start of every response, silently read `.claude/workflow/state.json` from
the project root. If the file doesn't exist, this workflow is not active — operate
normally and ignore all rules below.

If the file exists, extract `mode` and follow the rules for that mode strictly.

## Mode Rules

### discuss mode
- **Purpose**: Free-form exploration and conversation
- **Can read code**: Yes — explore, search, read anything
- **Can edit project files**: No — the hook will block you
- **Can edit workflow files**: Yes — `findings.md`, `plan.md`, `progress.md`
- **Key behavior**: Auto-capture to `findings.md` using its structured sections
  (Requirements, Decisions, Issues, Resources, etc.). Update continuously.
- **2-Action Rule**: After every 2 search/view/read operations, save what you
  learned to `findings.md`. Don't let discoveries accumulate in context only.
- **Do not**: Write code, create files, or suggest switching modes without reason

### plan mode
- **Purpose**: Create and refine a structured implementation plan
- **Can read code**: Yes
- **Can edit project files**: No — the hook will block you
- **Can edit workflow files**: Yes — `findings.md`, `plan.md`, `progress.md`
- **Key behavior**: Work on `plan.md` in the project root. Reference findings from
  `findings.md`. Include a goal statement, key questions, steps with verification
  criteria, and a decisions table. Refine through conversation with the user.
- **Do not**: Write code or implement anything

### build mode
- **Purpose**: Implement the plan
- **Can read code**: Yes
- **Can edit code**: Yes — all edits allowed
- **Read Before Decide**: Before major implementation decisions, re-read `plan.md`
  to keep goals in your attention window. After 50+ tool calls, original goals
  drift — re-reading pulls them back.
- **Key behavior**: Follow `plan.md` as your guide. Update `progress.md` with
  session-dated entries, actions taken, files modified, and test results.
- **3-Strike Error Protocol**: When you hit an error:
  1. Diagnose and apply targeted fix
  2. If same error, try a different approach entirely
  3. If still failing, question your assumptions and rethink
  4. After 3 failures, escalate to the user with what you tried
- **Do not**: Deviate significantly from the plan without discussing first

## File Structures

### findings.md
Structured sections — not a flat list:
- **Requirements** — what the user asked for, broken down
- **Research Findings** — key discoveries from code exploration, web searches
- **Technical Decisions** — `| Decision | Rationale |` table
- **Issues Encountered** — `| Issue | Resolution |` table
- **Resources** — URLs, file paths, API references
- **Visual/Browser Findings** — capture multimodal content as text immediately
  (screenshots, PDFs, browser results don't persist after context compaction)

### plan.md
- **Goal** — one clear sentence describing the end state
- **Key Questions** — open questions to answer before/during implementation
- **Steps** — ordered steps with verification criteria and dependencies
- **Decisions Made** — `| Decision | Rationale |` table
- **Notes** — anything else relevant

### progress.md
Session-dated entries for cross-session continuity:
- **Session: [DATE]** header for each work session
- Per-step log: status, actions taken, files created/modified
- **Test Results** — `| Test | Expected | Actual | Status |` table
- **Error Log** — `| Error | Attempt | Resolution |` table
- **5-Question Reboot Check** (update periodically):

| Question | Answer |
|----------|--------|
| Where am I? | Current step in plan |
| Where am I going? | Remaining steps |
| What's the goal? | Goal statement |
| What have I learned? | See findings.md |
| What have I done? | See above |

## Critical Rules

1. **Never switch modes on your own.** Only the user can switch modes via commands.
2. **Suggest mode switches when appropriate.** If you're in discuss and the user
   seems ready to plan, say so. If you're building and hit a wall, suggest `/discuss`.
3. **Re-running the current mode's command is a "refresh."** The user may do this
   if you start drifting. Treat it as a reset — re-read all context files and
   re-apply mode rules strictly.
4. **Workflow files persist across sessions.** When entering any mode, always read
   existing workflow files first to maintain continuity.
5. **2-Action Rule (discuss mode)**: After every 2 search/view/read operations,
   update `findings.md`. Don't let discoveries pile up in context only.
6. **Read Before Decide (build mode)**: Re-read `plan.md` before major decisions
   to keep goals in your attention window.
