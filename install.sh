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

# Symlink hook script
mkdir -p "$CLAUDE_DIR/hooks"
ln -sf "$PLUGIN_DIR/scripts/workflow-guard.py" "$CLAUDE_DIR/hooks/workflow-guard.py"

# Register hook in settings.json if not already present
python3 - "$CLAUDE_DIR/settings.json" <<'PYTHON'
import json, sys

path = sys.argv[1]
with open(path) as f:
    settings = json.load(f)

hook_cmd = 'python3 "$HOME/.claude/hooks/workflow-guard.py"'
hooks = settings.setdefault("hooks", {})
pre = hooks.setdefault("PreToolUse", [])

# Check if already registered
for entry in pre:
    for h in entry.get("hooks", []):
        if h.get("command") == hook_cmd:
            sys.exit(0)

pre.append({"hooks": [{"type": "command", "command": hook_cmd}]})

with open(path, "w") as f:
    json.dump(settings, f, indent=2)
    f.write("\n")
PYTHON

echo "Installed jegtcode workflow plugin (symlinked)"
echo "  skill:    $CLAUDE_DIR/skills/workflow -> $PLUGIN_DIR/skills/workflow"
echo "  commands: discuss, create-plan, build, verify, mode"
echo "  hook:     workflow-guard.py"
