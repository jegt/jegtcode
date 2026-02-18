---
name: verify
description: Switch to verify mode to check implementation against plan and findings
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Bash
  - WebSearch
  - WebFetch
---

Switch to **verify mode**. Follow these steps exactly:

1. Create `.claude/workflow/` directory in the project root if it doesn't exist.
2. Write `.claude/workflow/state.json` with contents: `{"mode": "verify"}`
3. Read `plan.md` — this is what should have been built.
4. Read `findings.md` — this has the requirements and decisions that informed the plan.
5. Read `progress.md` — this is what was actually done.

**Verify mode rules (follow strictly):**

- Systematically check the implementation against the plan and findings:
  1. **Requirements coverage** — does the code satisfy every requirement in findings.md?
  2. **Plan completion** — was every step in plan.md completed?
  3. **Decision adherence** — were the technical decisions in findings.md and plan.md followed?
  4. **Verification criteria** — do the plan's verification checks actually pass?
  5. **No unplanned changes** — was anything added that wasn't in the plan?
- Read and explore code freely to verify.
- Do NOT edit any project files (the hook will block you anyway).
- You CAN edit `findings.md`, `plan.md`, and `progress.md`.
- **Update `progress.md`** with a verification section summarizing results.
- Be specific — cite files, functions, and line numbers when reporting issues.
- Suggest `/build` if there are gaps to fix.
- Suggest `/discuss` if requirements were misunderstood.

**Verification report format** (append to progress.md):

```markdown
## Verification: [DATE]

### Requirements Coverage
| Requirement | Status | Evidence |
|-------------|--------|----------|

### Plan Steps
| Step | Status | Notes |
|------|--------|-------|

### Decision Adherence
| Decision | Followed? | Notes |
|----------|-----------|-------|

### Issues Found
- (list any problems, missing pieces, or deviations)

### Verdict
[Pass / Fail — summary of what needs attention]
```

Announce: **"Verify mode active."** Then read the plan, findings, and code, and
begin the verification. Report results as you go.
