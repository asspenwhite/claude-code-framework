#!/usr/bin/env bash
# PreToolUse hook (matcher: Edit|Write) — blocks writes to paths that hold
# secrets. Exit 2 = block; stderr becomes Claude's instruction.
# Note: covers the Edit/Write tools only. A Bash `echo >> .env` is not
# matched — add a Bash matcher with your own command filter if you need that.
INPUT=$(cat)
FILE=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)
[ -z "$FILE" ] && exit 0

case "$FILE" in
  *.env.example|*.env.template) exit 0 ;;
  *.env|*/.env.*|*.enc|*/secrets/*)
    echo "Blocked: '$FILE' is a protected path (secrets). Ask the operator to make this change. If this protection is wrong for the project, the operator can edit .claude/hooks/protect-paths.sh." >&2
    exit 2 ;;
esac
exit 0
