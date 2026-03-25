#!/usr/bin/env bash
# session-end.sh — Stop hook
# Persists session state on session end.
# Updates the session file with end timestamp.
# Exit 0 = allow (always allow session to end)

SESSION_DIR="${CLAUDE_SESSION_DIR:-.claude/sessions}"
TODAY=$(date +%Y-%m-%d)
SESSION_FILE="$SESSION_DIR/${TODAY}-session.md"

mkdir -p "$SESSION_DIR"

if [ -f "$SESSION_FILE" ]; then
  # Add end timestamp
  TIMESTAMP=$(date +%H:%M:%S)
  echo "" >> "$SESSION_FILE"
  echo "## Session End" >> "$SESSION_FILE"
  echo "- Ended at $TIMESTAMP" >> "$SESSION_FILE"

  # Update status
  sed -i "s/^**Status:** In Progress/**Status:** Ended/" "$SESSION_FILE"

  echo "💾 Session end logged to $SESSION_FILE"
else
  # Create minimal session record
  cat > "$SESSION_FILE" << EOF
# Session State

**Date:** $TODAY
**Status:** Ended (no pre-compact state saved)

## Session End
- Ended at $(date +%H:%M:%S)
EOF

  echo "💾 Minimal session record created at $SESSION_FILE"
fi

# Prune old sessions (older than 30 days)
find "$SESSION_DIR" -name "*.md" -mtime +30 -type f -delete 2>/dev/null

exit 0
