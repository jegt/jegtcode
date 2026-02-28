#!/usr/bin/env python3
import json
import sys
import os

MODE_DESCRIPTIONS = {
    "discuss": "Discussion mode — explore freely, no code edits. Capture findings to findings.md.",
    "plan": "Planning mode — create and refine the implementation plan, no code edits.",
    "build": "Build mode — implement the plan. All edits allowed.",
    "verify": "Verify mode — check implementation against plan and findings, no code edits.",
}


def main():
    hook_input = json.loads(sys.stdin.read())
    cwd = hook_input.get("cwd", os.getcwd())
    state_path = os.path.join(cwd, ".claude", "workflow", "state.json")

    if not os.path.exists(state_path):
        sys.exit(0)

    try:
        with open(state_path) as f:
            mode = json.load(f).get("mode", "")
    except (json.JSONDecodeError, IOError):
        sys.exit(0)

    desc = MODE_DESCRIPTIONS.get(mode, f"{mode} mode")

    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "UserPromptSubmit",
            "message": f"[Workflow active: {desc}]"
        }
    }))
    sys.exit(0)


if __name__ == "__main__":
    main()
