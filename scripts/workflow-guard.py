#!/usr/bin/env python3
import json
import sys
import os


def main():
    hook_input = json.loads(sys.stdin.read())
    tool = hook_input.get("tool_name", "")

    # Gate file-editing tools and built-in plan mode
    if tool not in ("Edit", "Write", "NotebookEdit", "EnterPlanMode"):
        sys.exit(0)

    cwd = hook_input.get("cwd", os.getcwd())
    state_path = os.path.join(cwd, ".claude", "workflow", "state.json")

    # No state file = no workflow active, allow everything
    if not os.path.exists(state_path):
        sys.exit(0)

    try:
        with open(state_path) as f:
            mode = json.load(f).get("mode", "build")
    except (json.JSONDecodeError, IOError):
        sys.exit(0)

    # Always block built-in plan mode when workflow is active
    if tool == "EnterPlanMode":
        print(json.dumps({
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": "deny",
                "permissionDecisionReason":
                    "Blocked: built-in plan mode is disabled when the workflow "
                    "system is active. Use /create-plan instead."
            }
        }))
        sys.exit(0)

    # Build mode allows all edits
    if mode == "build":
        sys.exit(0)

    # In discuss/plan mode, allow workflow files only
    file_path = hook_input.get("tool_input", {}).get("file_path", "")

    allowed = [
        os.path.join(cwd, "findings.md"),
        os.path.join(cwd, "plan.md"),
        os.path.join(cwd, "progress.md"),
    ]

    if file_path in allowed or ".claude/" in file_path:
        sys.exit(0)

    # Block with reason
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason":
                f"Blocked: cannot edit files in {mode} mode. "
                f"Use /build to switch to build mode."
        }
    }))
    sys.exit(0)


if __name__ == "__main__":
    main()
