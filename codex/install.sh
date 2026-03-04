#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

SOURCE_SKILL_DIR="$SCRIPT_DIR/jegtcode"
TARGET_SKILLS_DIR="$CODEX_HOME/skills"
TARGET_SKILL_DIR="$TARGET_SKILLS_DIR/jegtcode"

if [ ! -d "$SOURCE_SKILL_DIR" ]; then
  echo "Error: source skill directory not found: $SOURCE_SKILL_DIR" >&2
  exit 1
fi

mkdir -p "$TARGET_SKILLS_DIR"

if [ -e "$TARGET_SKILL_DIR" ] && [ ! -L "$TARGET_SKILL_DIR" ]; then
  echo "Error: $TARGET_SKILL_DIR exists and is not a symlink." >&2
  echo "Move or remove it, then rerun this installer." >&2
  exit 1
fi

ln -sfn "$SOURCE_SKILL_DIR" "$TARGET_SKILL_DIR"

echo "Installed Codex jegtcode skill (symlinked)"
echo "  skill: $TARGET_SKILL_DIR -> $SOURCE_SKILL_DIR"
echo "Restart Codex to pick up new skills."
