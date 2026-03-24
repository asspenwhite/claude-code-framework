# Safety Modes

Three safety modes protect against accidental damage. All enforced by `.claude/hooks/safety-check.sh`.

---

## Modes

### Careful Mode (`/careful`)

Warns before destructive commands. You can override each warning.

```bash
export CLAUDE_SAFETY_MODE=careful
```

**What triggers warnings:**
- `rm -rf` (except build artifacts: node_modules, dist, .next, __pycache__, target/)
- `DROP TABLE`, `DELETE FROM` (without WHERE clause)
- `git push --force`, `git reset --hard`, `git clean -f`
- `docker system prune`
- `kubectl delete`

**When to use:** Maintenance work, refactoring, working in shared repos.

---

### Freeze Mode (`/freeze <dir>`)

Restricts file edits (Write/Edit tools) to a single directory. Blocks changes outside the allowed path.

```bash
export CLAUDE_SAFETY_MODE=freeze
export CLAUDE_FREEZE_DIR=src/components
```

**When to use:** Debugging (prevents accidentally "fixing" unrelated code), scoped refactors, focused work.

---

### Guard Mode (`/guard <dir>`)

Maximum safety. Combines Careful + Freeze.

```bash
export CLAUDE_SAFETY_MODE=guard
export CLAUDE_FREEZE_DIR=src/
```

**When to use:** Production debugging, live system investigation, high-stakes changes.

---

## Clearing Safety Modes (`/unfreeze`)

```bash
unset CLAUDE_SAFETY_MODE
unset CLAUDE_FREEZE_DIR
```

---

## How It Works

The `safety-check.sh` hook runs as a **PreToolUse** hook on Bash commands:

1. Reads the command from stdin (JSON with `tool_input.command`)
2. Checks against destructive patterns
3. Exit code determines behavior:
   - `0` — Allow (no match or not in safety mode)
   - `1` — Block (freeze violation)
   - `2` — Warn (destructive command detected, user can override)

### Hook Configuration

In `settings.local.json`:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [{
          "type": "command",
          "command": ".claude/hooks/safety-check.sh"
        }]
      }
    ]
  }
}
```

---

## Extending Safety

### Adding Custom Destructive Patterns

Edit `.claude/hooks/safety-check.sh` and add patterns to the `DESTRUCTIVE_PATTERNS` array:

```bash
DESTRUCTIVE_PATTERNS=(
  "rm -rf"
  "DROP TABLE"
  # Add your patterns here:
  "your-dangerous-command"
)
```

### Adding Custom Whitelisted Paths

Add paths to the `SAFE_TARGETS` array for `rm -rf` that shouldn't trigger warnings:

```bash
SAFE_TARGETS=(
  "node_modules" "dist" ".next"
  # Add your build artifacts:
  "your-build-dir"
)
```

---

## Decision Matrix

| Situation | Recommended Mode |
|-----------|-----------------|
| Normal development | No safety mode |
| Refactoring one module | `/freeze src/module` |
| Working in shared repo | `/careful` |
| Debugging production | `/guard src/` |
| Investigating a bug | `/freeze` (prevent unrelated fixes) |
| Code review changes | No safety mode |
