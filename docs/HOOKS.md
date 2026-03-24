# Hooks System

Hooks are shell scripts that fire during Claude Code sessions. They provide runtime safety, quality gates, and automation without any dependencies.

## Hook Events

Claude Code supports 7 lifecycle events:

| Event | When | Use for |
|-------|------|---------|
| **PreToolUse** | Before a tool runs | Block dangerous operations, warn on risky changes |
| **PostToolUse** | After a tool completes | Auto-format, quality checks, logging |
| **PostToolUseFailure** | After a tool fails | Error tracking, retry logic |
| **SessionStart** | Session begins | Load context, detect environment |
| **PreCompact** | Before context compaction | Save state before context is compressed |
| **Stop** | Claude stops responding | Persist session state, track costs |
| **SessionEnd** | Session ends | Final cleanup |

## Included Hooks

The framework ships with 3 hooks + 1 utility:

### 1. Config Protection (`config-protect.sh`)

**Event:** PreToolUse on Write/Edit
**Purpose:** Warns before weakening linter/formatter configurations.

If you're editing `.eslintrc`, `biome.json`, `tsconfig.json`, etc., the hook warns:
> "Fix the source code, don't weaken the linter."

This prevents the common AI pattern of loosening lint rules to suppress warnings instead of fixing the actual code.

**Protected files:** eslint, prettier, biome, tsconfig, editorconfig, stylelint, deno configs.

### 2. Safety Check (`safety-check.sh`)

**Event:** PreToolUse on Bash
**Purpose:** Warns before destructive commands.

Detected patterns:
- `rm -rf` (except build artifacts)
- `DROP TABLE`, `DROP DATABASE`, `TRUNCATE`
- `git push --force`, `git reset --hard`, `git clean -f`
- `docker system prune`, `kubectl delete`, `terraform destroy`

**Whitelisted:** Build artifacts (node_modules, dist, .next, __pycache__, target/, .cache/)

### 3. Quality Gate (`quality-gate.sh`)

**Event:** PostToolUse on Write/Edit
**Purpose:** Auto-runs formatter on saved files.

Detects and runs the appropriate formatter:
| Extension | Formatter (tries in order) |
|-----------|---------------------------|
| `.ts/.tsx/.js/.jsx` | biome, prettier |
| `.py` | ruff, black |
| `.go` | gofmt |
| `.rs` | rustfmt |

Only runs if the formatter is installed. Silent on success. Never blocks.

### 4. Diff Scope (`diff-scope.sh`)

**Type:** Utility (not a hook — called by skills)
**Purpose:** Lists files changed vs base branch.

```bash
.claude/hooks/diff-scope.sh        # Auto-detects main or master
.claude/hooks/diff-scope.sh develop # Specify base branch
```

Used by review/QA skills for diff-aware intelligence.

## Safety Modes

Three modes control hook behavior, set via `CLAUDE_SAFETY_MODE`:

| Mode | Command | Behavior |
|------|---------|----------|
| **careful** | `/careful` | Warn on destructive Bash commands |
| **freeze** | `/freeze src/` | Block file edits outside specified directory |
| **guard** | `/guard src/` | Both careful + freeze |
| (clear) | `/unfreeze` | Remove all restrictions |

### When to Use

| Situation | Mode |
|-----------|------|
| Refactoring a specific module | `/freeze src/auth/` |
| Maintenance on production | `/careful` |
| Debugging live system | `/guard src/debug/` |
| Normal development | No mode needed |

## Configuration

Add hooks to `.claude/settings.local.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [{ "type": "command", "command": ".claude/hooks/config-protect.sh" }]
      },
      {
        "matcher": "Bash",
        "hooks": [{ "type": "command", "command": ".claude/hooks/safety-check.sh" }]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [{ "type": "command", "command": ".claude/hooks/quality-gate.sh" }]
      }
    ]
  }
}
```

## Writing Custom Hooks

### Script Template

```bash
#!/usr/bin/env bash
# my-hook.sh — [Event] hook for [Tool]
# Purpose: What this hook does
# Exit 0 = allow, Exit 1 = block, Exit 2 = warn

# Get tool input
FILE_PATH="${1:-}"

# Your logic here

exit 0
```

### Steps

1. Create script in `.claude/hooks/`
2. Make executable: `chmod +x .claude/hooks/my-hook.sh`
3. Add to `settings.local.json` under the appropriate event and matcher
4. Test by triggering the matched tool

### Exit Code Reference

| Code | Effect | Use when |
|------|--------|----------|
| `0` | Allow | Check passed, proceed normally |
| `1` | Block | Dangerous operation, prevent it |
| `2` | Warn | Risky but allowed, show message |
