#!/usr/bin/env bash
# session-start.sh — SessionStart hook
# Loads previous session state on new session start.
# Checks for recent session files and notifies of available context.
# Exit 0 = allow (always allow, this is informational)

SESSION_DIR="${CLAUDE_SESSION_DIR:-.claude/sessions}"
MAX_AGE_DAYS=7

# Create session dir if it doesn't exist
mkdir -p "$SESSION_DIR"

# Find the most recent session file (within MAX_AGE_DAYS)
LATEST=$(find "$SESSION_DIR" -name "*.md" -mtime -${MAX_AGE_DAYS} -type f 2>/dev/null | sort -r | head -1)

if [ -n "$LATEST" ]; then
  BASENAME=$(basename "$LATEST")
  AGE_HOURS=$(( ( $(date +%s) - $(date -r "$LATEST" +%s 2>/dev/null || stat -c %Y "$LATEST" 2>/dev/null || echo 0) ) / 3600 ))

  echo "📋 Previous session found: $BASENAME (${AGE_HOURS}h ago)"
  echo "   Path: $LATEST"
  echo "   Read this file to resume where you left off."
  echo ""

  # Count total session files
  TOTAL=$(find "$SESSION_DIR" -name "*.md" -type f 2>/dev/null | wc -l)
  if [ "$TOTAL" -gt 1 ]; then
    echo "   ($TOTAL total session files in $SESSION_DIR)"
  fi
fi

exit 0
