---
name: jegtcode
description: |
  Codex workflow mode system with four modes: discuss, plan, build, verify.
  Uses .codex/workflow/state.json plus findings.md, plan.md, and progress.md
  to keep context across sessions and reduce premature coding.
author: jegt
version: 1.0.0
date: 2026-03-03
---

# Workflow Mode System (Codex)

Use this skill when the user asks to discuss, create a plan, build, verify,
or references `findings.md`, `plan.md`, or `progress.md`.

## Mode State

- Persist mode in `.codex/workflow/state.json` as `{"mode":"discuss"}` (or plan/build/verify).
- At the start of each response, read mode state if the file exists.
- If mode file is missing, operate normally unless the user asks to switch mode.

## Mode Switching

When the user asks to switch mode (`discuss`, `plan` or `create plan`,
`build`, `verify`):

1. Create `.codex/workflow/` if needed.
2. Write `.codex/workflow/state.json` with the selected mode.
3. Read existing workflow files for continuity.
4. Announce mode activation briefly and continue in that mode.

## Mode Rules

### discuss

- Purpose: exploration, discovery, clarification.
- Read/search freely.
- Do not edit project code unless the user explicitly asks to override mode.
- Capture discoveries in `findings.md`.
- After every 2 meaningful read/search actions, update `findings.md`.
- Suggest `plan` once requirements and constraints are clear.

### plan

- Purpose: create/refine implementation plan.
- Read code and findings to inform planning.
- Do not implement code changes.
- Write/refine `plan.md`.
- Suggest `build` when the plan is concrete and agreed.

### build

- Purpose: implement the plan.
- Use `plan.md` as execution guide.
- Update `progress.md` with session date, actions, touched files, and test results.
- If blocked repeatedly, summarize attempts and ask user for direction.
- Avoid large unplanned scope changes without user confirmation.

### verify

- Purpose: validate implementation against requirements and plan.
- Do not fix code directly; report gaps with concrete evidence.
- Check requirements coverage, step completion, and decision adherence.
- Append verification report to `progress.md`.
- Suggest `build` for fixes or `discuss` if requirements are unclear.

## Workflow Files

### findings.md

Use sections:
- Requirements
- Research Findings
- Technical Decisions
- Issues Encountered
- Resources

### plan.md

Include:
- Goal
- Key Questions
- Ordered steps with per-step verification criteria
- Decisions Made
- Notes

### progress.md

Track:
- Session date
- Per-step status and actions
- Files modified
- Test results
- Error log
- Verification reports

## Behavior Notes

- Respect explicit user instructions over default mode behavior.
- Do not switch modes without user intent.
- If the user asks "what mode are we in?", read and report state.
- Treat "create plan" and "create-plan" as `plan` mode intent.
