#!/usr/bin/env bash
# config-protect.sh — PreToolUse hook for Write/Edit
# Warns before weakening linter/formatter configurations.
# Exit 0 = allow, Exit 2 = warn (show message but allow)

# Get the file path from the tool input (passed as first argument or via stdin)
FILE_PATH="${1:-}"

# If no argument, try reading from the CLAUDE_TOOL_INPUT env var
if [ -z "$FILE_PATH" ]; then
  FILE_PATH="${CLAUDE_TOOL_INPUT_FILE_PATH:-}"
fi

# Config file patterns to protect
CONFIG_PATTERNS=(
  ".eslintrc"
  ".eslintrc.js"
  ".eslintrc.json"
  ".eslintrc.yml"
  "eslint.config"
  ".prettierrc"
  "prettier.config"
  "biome.json"
  "biome.jsonc"
  "tsconfig.json"
  "tsconfig.*.json"
  ".editorconfig"
  ".stylelintrc"
  "deno.json"
)

# Check if the target file is a config file
BASENAME=$(basename "$FILE_PATH" 2>/dev/null)

for pattern in "${CONFIG_PATTERNS[@]}"; do
  case "$BASENAME" in
    $pattern*)
      echo "⚠️  CONFIG PROTECTION: You're modifying '$BASENAME'."
      echo "   Rule: Fix the source code, don't weaken the linter."
      echo "   If this change is intentional (adding stricter rules), proceed."
      echo "   If loosening rules to suppress warnings, fix the code instead."
      exit 2
      ;;
  esac
done

exit 0
