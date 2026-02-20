# jegtcode

A workflow mode system for Claude Code that prevents premature coding through explicit mode control.

## The problem

Claude drifts out of conversation and starts writing code before you're ready. Existing solutions either rush to planning or lose mode awareness mid-conversation.

## The solution

Four modes with hard enforcement. In discuss and plan mode, a PreToolUse hook physically blocks file edits. You control mode transitions through slash commands — Claude cannot switch modes on its own.

| Mode | Purpose | Can edit code? |
|------|---------|---------------|
| `/discuss` | Free-form exploration | No (blocked) |
| `/create-plan` | Create implementation plan | No (blocked) |
| `/build` | Implement the plan | Yes |
| `/verify` | Check implementation against plan | No (blocked) |

## Install

```bash
git clone <repo-url> ~/dev/jegtcode
cd ~/dev/jegtcode
./install.sh
```

The install script symlinks everything into `~/.claude/` — edits to the source files take effect immediately. Safe to run multiple times.

Restart Claude Code after installing.

## Usage

Start a session in any project and run `/discuss` to activate the workflow. The system is opt-in per project — it only activates when `.claude/workflow/state.json` exists.

### Typical flow

```
/discuss          explore the problem, research code
/create-plan      draft a plan based on findings
/build            implement the plan
/verify           check implementation against plan
```

You can switch between modes in any order. `/clear` between modes gives a fresh context window while the markdown files preserve continuity.

Re-running the current mode's command acts as a refresh if Claude starts drifting.

## Commands

### `/discuss`

Free-form exploration and conversation. Read code, search, research — anything goes except editing project files.

Claude auto-captures key decisions, constraints, and discoveries to `findings.md` in the project root. The **2-Action Rule** ensures findings are saved after every 2 search/view/read operations instead of piling up in context.

`findings.md` uses structured sections: Requirements, Research Findings, Technical Decisions, Issues Encountered, Resources, and Visual/Browser Findings.

### `/create-plan`

Create or refine an implementation plan. Reads `findings.md` for context and writes `plan.md` in the project root.

Named `/create-plan` instead of `/plan` to avoid conflicting with Claude Code's built-in plan mode toggle.

`plan.md` includes: goal statement, key questions, ordered steps with verification criteria, and a decisions table.

### `/build`

Implement the plan. All file edits are allowed. Claude follows `plan.md` as a guide and tracks progress in `progress.md` with session-dated entries.

Built-in guardrails:
- **Read Before Decide** — re-reads `plan.md` before major decisions to keep goals in the attention window
- **3-Strike Error Protocol** — diagnose, try alternative, rethink, then escalate to user

### `/verify`

Read-only audit of the implementation against the plan and findings. Checks:

1. Requirements coverage — does the code satisfy every requirement?
2. Plan completion — was every step completed?
3. Decision adherence — were technical decisions followed?
4. Verification criteria — do the plan's checks pass?
5. No unplanned changes — was anything added that wasn't in the plan?

Appends a verification report to `progress.md` with specific evidence (files, functions, line numbers) and a pass/fail verdict.

## Project files

The workflow creates three markdown files in the project root:

| File | Created by | Purpose |
|------|-----------|---------|
| `findings.md` | `/discuss` | Requirements, decisions, research, constraints |
| `plan.md` | `/create-plan` | Implementation plan with steps and verification criteria |
| `progress.md` | `/build` | Session log, test results, error log, verification reports |

These persist across sessions. When you enter any mode, existing files are read first for continuity.

Internal state is stored in `.claude/workflow/state.json` (just `{"mode": "discuss"}`).

## How enforcement works

Three reinforcement layers prevent drift:

1. **Always-active skill** — injects mode rules into every session via `SKILL.md`
2. **Slash commands** — fresh mode instructions on each switch
3. **PreToolUse hook** — hard blocks Edit/Write/NotebookEdit in discuss, plan, and verify modes. Workflow files (`findings.md`, `plan.md`, `progress.md`) are always allowed.

## Plugin structure

```
jegtcode/
├── .claude-plugin/
│   ├── plugin.json
│   └── marketplace.json
├── skills/workflow/
│   └── SKILL.md
├── commands/
│   ├── discuss.md
│   ├── create-plan.md
│   ├── build.md
│   └── verify.md
├── hooks/
│   └── hooks.json
├── scripts/
│   └── workflow-guard.py
└── install.sh
```
