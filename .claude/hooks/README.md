# Hooks

Runtime hooks that fire during Claude Code sessions. These provide safety guardrails, quality gates, and utility functions.

## Included Hooks

| Hook | Event | Purpose |
|------|-------|---------|
| `config-protect.sh` | PreToolUse (Write/Edit) | Warns before weakening linter/formatter configs |
| `safety-check.sh` | PreToolUse (Bash) | Warns before destructive commands (rm -rf, DROP TABLE, force-push) |
| `quality-gate.sh` | PostToolUse (Write/Edit) | Auto-runs formatter on saved files |
| `diff-scope.sh` | Utility | Lists changed files vs base branch (used by skills) |

## Exit Codes

| Code | Meaning |
|------|---------|
| `0` | Allow — tool use proceeds normally |
| `1` | Block — tool use is prevented |
| `2` | Warn — show message but allow tool use |

## Safety Modes

Set `CLAUDE_SAFETY_MODE` environment variable:

| Mode | Behavior |
|------|----------|
| `careful` | Warns before destructive commands |
| `freeze` | Blocks edits outside `CLAUDE_FREEZE_DIR` |
| `guard` | Both careful + freeze |

Toggle via commands: `/careful`, `/freeze <dir>`, `/guard <dir>`, `/unfreeze`

## Configuration

Hooks are configured in `.claude/settings.local.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      { "matcher": "Write|Edit", "hooks": [{ "type": "command", "command": ".claude/hooks/config-protect.sh" }] },
      { "matcher": "Bash", "hooks": [{ "type": "command", "command": ".claude/hooks/safety-check.sh" }] }
    ],
    "PostToolUse": [
      { "matcher": "Write|Edit", "hooks": [{ "type": "command", "command": ".claude/hooks/quality-gate.sh" }] }
    ]
  }
}
```

## Writing Custom Hooks

1. Create a shell script in `.claude/hooks/`
2. Make it executable: `chmod +x .claude/hooks/your-hook.sh`
3. Add it to `settings.local.json` under the appropriate event
4. Use exit codes to control behavior (0=allow, 1=block, 2=warn)

## All 7 Claude Code Hook Events

| Event | When it fires | Use for |
|-------|--------------|---------|
| `PreToolUse` | Before any tool runs | Safety checks, config protection |
| `PostToolUse` | After a tool completes | Formatting, quality gates |
| `PostToolUseFailure` | After a tool fails | Error tracking, MCP reconnection |
| `SessionStart` | When Claude session begins | Load context, detect environment |
| `PreCompact` | Before context compaction | Save state summaries |
| `Stop` | When Claude stops responding | Session persistence, cost tracking |
| `SessionEnd` | When session ends | Cleanup |
