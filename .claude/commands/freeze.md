Restrict file edits to a specific directory.

$ARGUMENTS — the directory to restrict edits to (e.g., `src/components`)

Sets CLAUDE_FREEZE_DIR to block Write/Edit operations outside the specified directory.
Useful when debugging to prevent accidentally "fixing" unrelated code.

To activate:
```
export CLAUDE_SAFETY_MODE=freeze
export CLAUDE_FREEZE_DIR=src/components
```

To deactivate, use `/unfreeze`.

See: docs/SAFETY.md for full documentation.
