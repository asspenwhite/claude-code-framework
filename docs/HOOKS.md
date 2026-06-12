# Hooks — Deterministic Guarantees

The single most important thing the community learned since this framework's
last pass:

> **CLAUDE.md is advisory. Hooks are deterministic.**
> Claude follows CLAUDE.md instructions most of the time (~80% is the number
> people quote). A hook fires 100% of the time. If something must happen
> *every time without exception* — formatting, lint, a protected path, an
> audit-log entry — it belongs in a hook, not in prose.

This also works in reverse: if a rule in your CLAUDE.md keeps getting
ignored, don't add MORE prose (that bloats context and dilutes every other
rule). Convert it to a hook and delete the prose.

---

## How Hooks Work

Hooks are shell commands (or HTTP calls, prompts, or agents) that Claude Code
runs automatically at lifecycle events. Configured in `settings.json`:

| Location | Scope | Shared with team |
|----------|-------|------------------|
| `~/.claude/settings.json` | all your projects | no |
| `.claude/settings.json` | this project | yes (commit it) |
| `.claude/settings.local.json` | this project | no (gitignore it) |

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "type": "command", "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/lint-changed.sh" }
        ]
      }
    ]
  }
}
```

**Exit code semantics** (command hooks):

| Exit | Meaning |
|------|---------|
| `0` | Success. stdout JSON (if any) is processed. |
| `2` | **Block.** stderr is fed back to Claude as the reason. On `PreToolUse` this blocks the tool call; on `Stop` it prevents the turn from ending. |
| other | Non-blocking error; stderr shown, execution continues. |

## The Events That Matter

There are ~30 events; these cover nearly every real use case:

| Event | Fires | Use it for |
|-------|-------|-----------|
| `PreToolUse` | before a tool call | block writes to protected paths, deny dangerous commands, enforce a required prior step |
| `PostToolUse` | after a tool call succeeds | auto-format / lint after every edit, validate output |
| `UserPromptSubmit` | before Claude sees your prompt | inject context (live state, reminders), block bad prompts |
| `Stop` | when Claude tries to finish a turn | verification gate — block the stop until tests pass or required docs were updated |
| `SessionStart` | session begins/resumes | load fresh state into context (git status, service health) |
| `PreCompact` | before context compaction | snapshot anything that must survive summarization |
| `SubagentStop` | a subagent finishes | validate subagent output before it's trusted |

Full event list and JSON control fields: [official hooks reference](https://code.claude.com/docs/en/hooks).

**Tip:** Claude writes good hooks. Prompt it: *"Write a PostToolUse hook that
runs eslint on every file you edit"* and review the result.

---

## Hooks Shipped With This Template

| Hook | Event | Status |
|------|-------|--------|
| `.claude/hooks/protect-paths.sh` | `PreToolUse` (Edit\|Write) | **Active** — blocks writes to `.env`, `*.enc`, `secrets/` (allows `.env.example`). Covers Edit/Write only; add a Bash matcher if you need shell-level coverage. |
| `.claude/hooks/docs-sync-gate.sh` | `Stop` | **Opt-in** — blocks the turn from ending while tracked files changed but `docs/CHANGELOG.md` didn't. Self-disables if the repo has no `docs/CHANGELOG.md`. |

Enable the docs-sync gate by adding to `.claude/settings.json`:

```json
"Stop": [
  { "hooks": [ { "type": "command", "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/docs-sync-gate.sh" } ] }
]
```

It's opt-in because it judges by `git status`: in a repo that was dirty
before the session it will ask once for an entry covering pre-existing
drift. Adopt it when you adopt the audit-CHANGELOG workflow.

---

## Starter Recipes

### 1. Lint/format after every edit

`PostToolUse`, matcher `Edit|Write` → run your formatter on the changed file
(read `tool_input.file_path` from the JSON on stdin). Ends the "please run
prettier" instruction era.

### 2. Protect paths that must never be touched

`PreToolUse`, matcher `Edit|Write`:

```bash
#!/bin/bash
FILE=$(jq -r '.tool_input.file_path // empty')
case "$FILE" in
  */migrations/*|*.env|*/secrets/*)
    echo "Blocked: $FILE is protected. Ask the operator." >&2
    exit 2 ;;
esac
exit 0
```

### 3. Audit-log enforcement (ops repos)

For repos that administer real infrastructure: a `Stop` hook that checks
whether `docs/CHANGELOG.md` was modified whenever mutating commands ran this
session — and blocks the turn from ending until the audit entry exists.
"Every change gets logged" stops being a request and becomes a property of
the system.

### 4. Verification gate

`Stop` hook that runs your test suite (or build, or smoke script) and exits 2
on failure with the output on stderr. Claude keeps iterating until the check
passes instead of declaring victory. (Claude Code force-ends the turn after 8
consecutive blocks, so the loop can't run away.)

### 5. Session-start state injection

`SessionStart` hook that prints current live state (service health, pending
migrations, open incidents) to stdout — it lands in context before the first
prompt, so Claude starts every session already knowing what's true.

---

## Lessons From Running Hooks in Production

1. **Start with one or two.** Add a hook when a rule has actually been
   violated, not speculatively.
2. **Over-hooking creates friction.** A team we studied ran post-response
   validators + mandatory cross-review hooks on every response — engineers
   reported it taxed creative work. Hooks are for *guarantees*; guidance
   stays in CLAUDE.md where Claude can exercise judgment.
3. **Block messages are prompts.** Whatever your hook prints to stderr on
   exit 2 is what Claude reads next — write it as an instruction ("Run X
   first, then retry"), not just an error.
4. **Keep hooks fast.** They run synchronously in the loop. A slow lint on
   every edit is a worse tax than no lint.
5. **Version them with the repo.** Hooks in `.claude/settings.json` +
   `.claude/hooks/*.sh` are part of the project's operating contract — review
   changes to them like code.
