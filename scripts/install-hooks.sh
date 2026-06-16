#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR/.."
cp "$REPO_ROOT/hooks/pre-push" "$REPO_ROOT/.git/hooks/pre-push"
chmod +x "$REPO_ROOT/.git/hooks/pre-push"
git -C "$REPO_ROOT" config push.followTags true
echo "✓ Hook pre-push installato in .git/hooks/"
echo "✓ push.followTags=true configurato"
