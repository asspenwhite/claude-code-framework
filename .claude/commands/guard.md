Maximum safety mode — destructive warnings + directory-scoped edits.

$ARGUMENTS — the directory to restrict edits to (e.g., `src/`)

Combines /careful (warns before destructive commands) with /freeze (blocks edits outside directory).

To activate:
```
export CLAUDE_SAFETY_MODE=guard
export CLAUDE_FREEZE_DIR=src/
```

To deactivate, use `/unfreeze`.

See: docs/SAFETY.md for full documentation.
