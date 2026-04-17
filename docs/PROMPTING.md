# Prompting Rules

How this framework configures Claude Code via CLAUDE.md. These rules are model-version-agnostic — they apply to Opus, Sonnet, and Haiku across versions.

For model-specific API changes (model IDs, breaking changes, new features), see [Anthropic's official docs](https://docs.anthropic.com/en/docs/about-claude/models).

---

## XML Blocks

These belong in every project's CLAUDE.md:

### Parallel tool calls

```xml
<parallel_tool_calls>
If you intend to call multiple tools and there are no dependencies between them,
make all independent tool calls in parallel.
</parallel_tool_calls>
```

Without this, Claude serializes tool calls even when they're independent. With it, parallel usage approaches ~100%.

### Prevent over-engineering

```xml
<do_not_overengineer>
Only make changes that are directly requested or clearly necessary. Keep solutions
simple and focused. Don't add features, refactor code, or make improvements beyond
what was asked. Don't add docstrings, comments, or type annotations to code you
didn't change.
</do_not_overengineer>
```

Claude is proactive by default — it will add unrequested features, refactor surrounding code, and "improve" things you didn't ask about. This block constrains that.

### Context window

```xml
<context_window>
Your context window will be automatically compacted as it approaches its limit.
Do not stop tasks early due to context concerns.
</context_window>
```

Without this, Claude sometimes stops mid-task saying "I'm running low on context." Compaction handles it automatically.

---

## Proactiveness Controls

For **more autonomous** behavior (coding agents that should act, not ask):

```xml
<default_to_action>
Implement changes rather than only suggesting them. If the user's intent is unclear,
infer the most useful likely action and proceed, using tools to discover missing
details instead of asking.
</default_to_action>
```

For **more conservative** behavior (review agents, docs agents, infra work):

```xml
<do_not_act_before_instructions>
Do not implement changes unless clearly instructed. When intent is ambiguous, default
to providing information and recommendations rather than taking action.
</do_not_act_before_instructions>
```

Choose one per project based on your workflow. The framework's default (asspenwhite's preference) is to **omit `<default_to_action>`** — Claude confirms before acting on ambiguous intent. The other three XML blocks are applied everywhere.

---

## Anti-Patterns to Avoid

| Pattern | Problem | Fix |
|---------|---------|-----|
| `"be thorough"` | Amplifies proactiveness, wastes tokens | Remove entirely |
| `"do not be lazy"` | Same | Remove entirely |
| `"think carefully"` | Same | Remove entirely |
| `"You MUST use [tool]"` | Causes overtriggering | `"Use [tool] when it would help"` |
| `"Use the think tool to plan"` | Over-planning before acting | Remove entirely |
| Assistant message prefills | Returns 400 error on current models | Use structured outputs or system prompt instruction |

---

## Effort Levels

Control reasoning depth via the `effort` parameter (API) or `--effort` flag (Claude Code CLI).

| Level | Use Case |
|-------|----------|
| `low` | Simple subagents, high volume, fast responses |
| `medium` | Balanced workflows |
| `high` | Complex coding, agentic tasks (framework default) |
| `xhigh` | Deep reasoning, hard problems |
| `max` | Absolute maximum capability (CLI: per-session only) |

In Claude Code, set persistently via `settings.json`:
```json
{ "effortLevel": "high" }
```

Or per-session: `claude --effort max` / toggle via `/model` screen.

---

## Current Models (as of April 2026)

| Model | API ID | Notes |
|-------|--------|-------|
| Opus 4.7 | `claude-opus-4-7` | Latest, 1M context, 128k output |
| Sonnet 4.6 | `claude-sonnet-4-6` | Fast, 200k context |
| Haiku 4.5 | `claude-haiku-4-5-20251001` | Fastest, cheapest |

For full API reference, breaking changes, and migration guides: [docs.anthropic.com](https://docs.anthropic.com/en/docs/about-claude/models)

---

## Related

- [ARCHITECTURE.md](ARCHITECTURE.md) — How the framework's progressive disclosure works
- [MCP.md](MCP.md) — MCP server setup guide
