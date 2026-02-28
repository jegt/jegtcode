#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

# Symlink skill
mkdir -p "$CLAUDE_DIR/skills"
ln -sfn "$PLUGIN_DIR/skills/workflow" "$CLAUDE_DIR/skills/workflow"

# Symlink commands
mkdir -p "$CLAUDE_DIR/commands"
for cmd in "$PLUGIN_DIR/commands/"*.md; do
  ln -sf "$cmd" "$CLAUDE_DIR/commands/$(basename "$cmd")"
done

# Symlink hook scripts
mkdir -p "$CLAUDE_DIR/hooks"
ln -sf "$PLUGIN_DIR/scripts/workflow-guard.py" "$CLAUDE_DIR/hooks/workflow-guard.py"
ln -sf "$PLUGIN_DIR/scripts/workflow-reminder.py" "$CLAUDE_DIR/hooks/workflow-reminder.py"

# Register hooks in settings.json if not already present
python3 - "$CLAUDE_DIR/settings.json" <<'PYTHON'
import json, sys

path = sys.argv[1]
with open(path) as f:
    settings = json.load(f)

hooks = settings.setdefault("hooks", {})

# Register PreToolUse guard hook
guard_cmd = 'python3 "$HOME/.claude/hooks/workflow-guard.py"'
pre = hooks.setdefault("PreToolUse", [])
guard_exists = any(
    h.get("command") == guard_cmd
    for entry in pre for h in entry.get("hooks", [])
)
if not guard_exists:
    pre.append({"hooks": [{"type": "command", "command": guard_cmd}]})

# Register UserPromptSubmit reminder hook
reminder_cmd = 'python3 "$HOME/.claude/hooks/workflow-reminder.py"'
prompt = hooks.setdefault("UserPromptSubmit", [])
reminder_exists = any(
    h.get("command") == reminder_cmd
    for entry in prompt for h in entry.get("hooks", [])
)
if not reminder_exists:
    prompt.append({"hooks": [{"type": "command", "command": reminder_cmd}]})

with open(path, "w") as f:
    json.dump(settings, f, indent=2)
    f.write("\n")
PYTHON

echo "Installed jegtcode workflow plugin (symlinked)"
echo "  skill:    $CLAUDE_DIR/skills/workflow -> $PLUGIN_DIR/skills/workflow"
echo "  commands: discuss, create-plan, build, verify, mode"
echo "  hooks:    workflow-guard.py, workflow-reminder.py"
