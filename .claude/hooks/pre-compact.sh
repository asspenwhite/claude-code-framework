#!/usr/bin/env bash
# pre-compact.sh — PreCompact hook
# Saves session state before context compaction.
# Creates/updates a session file with current pipeline stage,
# decisions made, files modified, and blockers.
# Exit 0 = allow (always allow compaction to proceed)

SESSION_DIR="${CLAUDE_SESSION_DIR:-.claude/sessions}"
TODAY=$(date +%Y-%m-%d)
SESSION_FILE="$SESSION_DIR/${TODAY}-session.md"

mkdir -p "$SESSION_DIR"

# If session file doesn't exist, create it with template
if [ ! -f "$SESSION_FILE" ]; then
  cat > "$SESSION_FILE" << 'TEMPLATE'
# Session State

**Date:** SESSION_DATE
**Status:** In Progress

## Pipeline Stage
<!-- Which stage: Think / Plan / Build / Review / Test / Ship / Reflect -->
Unknown

## Decisions Made
<!-- Key decisions from this session -->
- (none yet)

## Files Modified
<!-- Important files changed -->
- (none yet)

## Blockers
<!-- What's blocking progress -->
- (none)

## Context for Next Session
<!-- What the next session needs to know to pick up where you left off -->
- (pending)

## Compaction Log
TEMPLATE
  # Replace date placeholder
  sed -i "s/SESSION_DATE/$TODAY/" "$SESSION_FILE"
fi

# Append compaction event
TIMESTAMP=$(date +%H:%M:%S)
echo "- Compacted at $TIMESTAMP" >> "$SESSION_FILE"

echo "💾 Session state saved to $SESSION_FILE"
echo "   Update this file with decisions and context before ending your session."

exit 0
