#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="~/dev/jegtcode"
REMOTES=("jegt@keep" "doc@keep" "ops@keep" "jegt@inagan")

echo "=== Local ==="
cd "$HOME/dev/jegtcode"
git pull
bash install.sh
echo ""

for remote in "${REMOTES[@]}"; do
  echo "=== $remote ==="
  ssh "$remote" "cd $REPO_DIR && git pull && bash install.sh"
  echo ""
done

echo "Done."
