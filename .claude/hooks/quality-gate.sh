#!/usr/bin/env bash
# quality-gate.sh — PostToolUse hook for Write/Edit
# Auto-runs formatter on saved files if available.
# Exit 0 always (formatting is best-effort, never blocks).

FILE_PATH="${1:-}"
[ -z "$FILE_PATH" ] && exit 0

# Get file extension
EXT="${FILE_PATH##*.}"

format_file() {
  local tool="$1"
  shift
  if command -v "$tool" &>/dev/null; then
    "$tool" "$@" "$FILE_PATH" 2>/dev/null
    return $?
  fi
  return 1
}

case "$EXT" in
  ts|tsx|js|jsx|mjs|cjs)
    # Try biome first, then prettier
    format_file "biome" "format" "--write" || \
    format_file "npx" "prettier" "--write" 2>/dev/null
    ;;
  py)
    # Try ruff first, then black
    format_file "ruff" "format" || \
    format_file "black" 2>/dev/null
    ;;
  go)
    format_file "gofmt" "-w" 2>/dev/null
    ;;
  rs)
    format_file "rustfmt" 2>/dev/null
    ;;
  # Add more languages as needed
esac

# Always exit 0 — formatting is best-effort
exit 0
