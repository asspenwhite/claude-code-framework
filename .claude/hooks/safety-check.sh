#!/usr/bin/env bash
# safety-check.sh — PreToolUse hook for Bash
# Warns before destructive commands. Supports safety modes.
# Exit 0 = allow, Exit 1 = block, Exit 2 = warn
#
# Modes (set CLAUDE_SAFETY_MODE env var):
#   careful  — warn on destructive commands (default when set)
#   freeze   — block edits outside CLAUDE_FREEZE_DIR
#   guard    — both careful + freeze

COMMAND="${1:-}"
SAFETY_MODE="${CLAUDE_SAFETY_MODE:-}"
FREEZE_DIR="${CLAUDE_FREEZE_DIR:-}"

# If no command provided, allow
[ -z "$COMMAND" ] && exit 0

# --- Destructive command detection ---
DESTRUCTIVE_PATTERNS=(
  "rm -rf"
  "rm -r "
  "rmdir"
  "DROP TABLE"
  "DROP DATABASE"
  "TRUNCATE"
  "DELETE FROM"
  "git push --force"
  "git push -f "
  "git reset --hard"
  "git checkout -- ."
  "git checkout ."
  "git clean -f"
  "git clean -fd"
  "git branch -D"
  "docker system prune"
  "docker volume rm"
  "kubectl delete"
  "terraform destroy"
)

# Whitelisted build artifact paths (safe to delete)
WHITELIST_PATTERNS=(
  "node_modules"
  "dist/"
  ".next/"
  "__pycache__"
  "target/"
  ".cache/"
  ".turbo/"
  "build/"
  "*.pyc"
  ".pytest_cache"
  "coverage/"
)

is_whitelisted() {
  local cmd="$1"
  for pattern in "${WHITELIST_PATTERNS[@]}"; do
    if echo "$cmd" | grep -q "$pattern"; then
      return 0
    fi
  done
  return 1
}

# Check for destructive commands
for pattern in "${DESTRUCTIVE_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qi "$pattern"; then
    # Check whitelist
    if is_whitelisted "$COMMAND"; then
      exit 0
    fi

    echo "⚠️  SAFETY WARNING: Potentially destructive command detected."
    echo "   Command: $COMMAND"
    echo "   Pattern: $pattern"
    echo ""
    echo "   This command could cause data loss or be hard to reverse."
    echo "   If this is intentional, proceed. Otherwise, consider a safer alternative."
    exit 2
  fi
done

# --- Freeze mode: block edits outside allowed directory ---
if [ -n "$FREEZE_DIR" ]; then
  # Check if command references files outside freeze dir
  # This is a basic check - the hook on Write/Edit is more precise
  if echo "$COMMAND" | grep -qE "(>|>>|tee|mv|cp)" && ! echo "$COMMAND" | grep -q "$FREEZE_DIR"; then
    echo "🔒 FREEZE MODE: Edits restricted to $FREEZE_DIR"
    echo "   Command appears to modify files outside the allowed directory."
    echo "   Use /unfreeze to remove this restriction."
    exit 1
  fi
fi

exit 0
