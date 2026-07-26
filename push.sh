#!/usr/bin/env bash
#
# push.sh — commit & push the pages/ public repo (theput/pages → GitHub Pages).
#
# Usage:
#   ./push.sh                 # commit everything with a dated default message
#   ./push.sh "your message"  # commit everything with your message
#
# Safe to run from anywhere; it operates on this script's own directory.

set -euo pipefail

# Work in the repo this script lives in (pages/), regardless of caller's cwd.
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Confirm we're in the pages repo, not the private Constellation root.
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not a git repo here. Run this from inside pages/." >&2
  exit 1
fi

# Clear stray lock files (Cowork sandbox leftovers) so git doesn't block.
find .git -name "*.lock" -delete 2>/dev/null || true

# Stage everything (CLAUDE.md and .DS_Store are gitignored, so they stay out).
git add -A

if git diff --cached --quiet; then
  echo "Nothing to commit — working tree clean."
else
  msg="${1:-Update pages ($(date +%Y-%m-%d))}"
  git commit -m "$msg"
  echo "Committed: $msg"
fi

# Sync with remote, then push.
git pull --rebase --autostash --quiet 2>/dev/null || true
git push

echo ""
echo "Pushed to theput/pages. Live in a minute or two:"
echo "  https://theput.github.io/pages/"
