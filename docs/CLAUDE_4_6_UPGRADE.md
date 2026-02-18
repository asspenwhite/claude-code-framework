# Claude 4.6 Upgrade Guide

Migration guide and new features for Claude Opus 4.6 (`claude-opus-4-6`).

---

## Quick Migration Checklist

### Breaking Changes (will error without fixing)

- [ ] Remove all assistant message **prefills** — returns `400` on Opus 4.6
- [ ] Parse tool call JSON with `json.loads()` / `JSON.parse()`, never raw string matching

### Deprecated (still work, will break in future)

- [ ] Replace `thinking: {type: "enabled", budget_tokens: N}` → `thinking: {type: "adaptive"}`
- [ ] Move from `client.beta.messages.create` → `client.messages.create` for adaptive thinking
- [ ] Remove `betas=["interleaved-thinking-2025-05-14"]` from Opus 4.6 requests
- [ ] Remove `betas=["effort-2025-11-24"]` — effort is now GA
- [ ] Remove `betas=["fine-grained-tool-streaming-2025-05-14"]` — now GA
- [ ] Migrate `output_format={...}` → `output_config={"format": {...}}`

### Prompting Updates (for CLAUDE.md and skills)

- [ ] Remove anti-laziness prompts: `"be thorough"`, `"think carefully"`, `"do not be lazy"`
- [ ] Soften aggressive tool imperatives: `"You MUST use X"` → `"Use X when it would help"`
- [ ] Remove `"Use the think tool to plan"` instructions
- [ ] Add `<parallel_tool_calls>` XML block to CLAUDE.md
- [ ] Add `<do_not_overengineer>` XML block to CLAUDE.md
- [ ] Add `<context_window>` XML block to CLAUDE.md

---

## Model IDs

| Model | API ID | Max Output | Context |
|-------|--------|-----------|---------|
| Claude Opus 4.6 | `claude-opus-4-6` | **128K** | 200K (1M beta) |
| Claude Sonnet 4.6 | `claude-sonnet-4-6` | 64K | 200K (1M beta) |
| Claude Haiku 4.5 | `claude-haiku-4-5-20251001` | 64K | 200K |

> Opus 4.6 doubled max output from 64K → 128K. Use streaming for `max_tokens > 21,333`.

---

## New Features

### Adaptive Thinking

The flagship change. Claude dynamically decides when and how much to think based on query complexity. Replaces manual `budget_tokens`.

```python
# DEPRECATED (Opus 4.5 style)
response = client.beta.messages.create(
    model="claude-opus-4-5",
    max_tokens=16000,
    thinking={"type": "enabled", "budget_tokens": 32000},
    betas=["interleaved-thinking-2025-05-14"],
    messages=[...],
)

# CURRENT (Opus 4.6)
response = client.messages.create(
    model="claude-opus-4-6",
    max_tokens=16000,
    thinking={"type": "adaptive"},
    output_config={"effort": "high"},  # max | high | medium | low
    messages=[...],
)
```

Interleaved thinking is **automatic** on Opus 4.6 with adaptive thinking — no beta header needed.

### Effort Levels (Now GA)

Controls reasoning depth without managing token budgets. New `max` level for Opus 4.6 only.

| Level | Behavior | Use Case |
|-------|----------|----------|
| `max` | Absolute maximum capability | Deepest reasoning, hardest problems |
| `high` | Default — Claude almost always thinks | Complex coding, agentic tasks |
| `medium` | Moderate thinking, may skip on simple queries | Balanced workflows |
| `low` | Minimal thinking, maximum speed | Simple subagents, high volume |

```python
output_config={"effort": "medium"}  # top-level param, not nested
```

### Compaction API (Beta, Opus 4.6 Only)

Server-side automatic context summarization — effectively infinite conversations.

```python
response = client.beta.messages.create(
    betas=["compact-2026-01-12"],
    model="claude-opus-4-6",
    max_tokens=4096,
    messages=messages,
    context_management={
        "edits": [{
            "type": "compact_20260112",
            "trigger": {"type": "input_tokens", "value": 150000},
            "pause_after_compaction": False,
        }]
    },
)
# Returns stop_reason="compaction" when paused
# Pass the compaction block back in next request
```

> `usage.input_tokens` excludes compaction costs — sum `usage.iterations` for true billing.

### Memory Tool (Now GA)

Client-side file-based memory for cross-conversation persistence.

```python
client.messages.create(
    model="claude-opus-4-6",
    max_tokens=2048,
    messages=[...],
    tools=[{"type": "memory_20250818", "name": "memory"}],
)
```

Claude automatically checks a `/memories` directory and can `view`, `create`, `str_replace`, `insert`, `delete`, `rename` memory files. You implement the handler.

### 128K Output Tokens

Opus 4.6 doubled from 64K → 128K. Use `.stream()` for `max_tokens > 21,333`:

```python
with client.messages.stream(
    model="claude-opus-4-6",
    max_tokens=100000,
    messages=[...],
) as stream:
    message = stream.get_final_message()
```

### Tools Now GA (No Beta Headers Required)

| Tool | Old Status | New Status |
|------|-----------|------------|
| Code execution | Beta | **GA** |
| Web fetch | Beta | **GA** |
| Memory tool | Beta | **GA** |
| Fine-grained tool streaming | Beta (header required) | **GA** |
| Programmatic tool calling | Beta | **GA** |

### New Stop Reasons

```python
match response.stop_reason:
    case "end_turn":    # Normal completion
    case "max_tokens":  # Hit output limit
    case "tool_use":    # Tool call
    case "refusal":     # NEW — Claude declined the request
    case "model_context_window_exceeded":  # NEW — hit context window limit
    case "compaction":  # NEW — compaction paused (pause_after_compaction: true)
```

---

## Claude Agent SDK

The Claude Code SDK has been **renamed to the Claude Agent SDK**:

```bash
# Python
pip install claude-agent-sdk

# TypeScript
npm install @anthropic-ai/claude-agent-sdk
```

```python
from claude_agent_sdk import query, ClaudeAgentOptions

async for message in query(
    prompt="Find and fix the bug in auth.py",
    options=ClaudeAgentOptions(
        allowed_tools=["Read", "Edit", "Bash"],
    ),
):
    print(message)
```

Key additions vs old SDK:
- `agents` dict for defining subagents
- `hooks` for PostToolUse callbacks
- `resume=session_id` for session resumption
- `mcp_servers` for inline MCP configuration

---

## Prompting Best Practices for 4.6

### CLAUDE.md XML Blocks

These belong in every project's CLAUDE.md:

```xml
<parallel_tool_calls>
If you intend to call multiple tools and there are no dependencies between them,
make all independent tool calls in parallel. Maximize parallel tool calls for
speed and efficiency.
</parallel_tool_calls>

<do_not_overengineer>
Only make changes that are directly requested or clearly necessary. Keep solutions
simple and focused. Don't add features, refactor code, or make improvements beyond
what was asked. Don't add docstrings, comments, or type annotations to code you
didn't change.
</do_not_overengineer>

<context_window>
Your context window will be automatically compacted as it approaches its limit,
allowing you to continue working indefinitely. Do not stop tasks early due to
context concerns.
</context_window>
```

### Proactiveness Controls

For more autonomous behavior (default for coding agents):

```xml
<default_to_action>
Implement changes rather than only suggesting them. If the user's intent is unclear,
infer the most useful likely action and proceed, using tools to discover missing
details instead of asking.
</default_to_action>
```

For more conservative behavior (review agents, docs agents):

```xml
<do_not_act_before_instructions>
Do not implement changes unless clearly instructed. When intent is ambiguous, default
to providing information and recommendations rather than taking action.
</do_not_act_before_instructions>
```

### What to Remove

| Pattern | Problem | Fix |
|---------|---------|-----|
| `"be thorough"` | Amplifies proactiveness, wastes tokens | Remove entirely |
| `"do not be lazy"` | Same | Remove entirely |
| `"think carefully"` | Same | Remove entirely |
| `"You MUST use [tool]"` | Causes overtriggering | `"Use [tool] when it would help"` |
| `"Use the think tool to plan"` | Over-planning before acting | Remove entirely |
| Assistant prefills | Returns 400 error | Use structured outputs instead |

### Replacing Prefills

```python
# BROKEN on Opus 4.6 — prefilling assistant turn
messages=[
    {"role": "user", "content": "..."},
    {"role": "assistant", "content": "```json\n"},  # 400 error
]

# FIX A — structured outputs
output_config={"format": {"type": "json_schema", "schema": {...}}}

# FIX B — system prompt instruction
# "Respond with only valid JSON. Do not wrap in markdown code blocks."

# FIX C — continuation prompt (for interrupted responses)
messages=[
    {"role": "user", "content": "Your previous response was interrupted and ended with `[text]`. Continue from where you left off."}
]
```

---

## Key GitHub Repos

| Repo | Purpose |
|------|---------|
| `github.com/anthropics/claude-agent-sdk-python` | Python Agent SDK (formerly Claude Code SDK) |
| `github.com/anthropics/claude-agent-sdk-typescript` | TypeScript Agent SDK |
| `github.com/anthropics/anthropic-cookbook` | Official examples: compaction, memory, programmatic tools |
| `github.com/anthropics/anthropic-sdk-python` | Base Python client |
| `github.com/anthropics/anthropic-sdk-typescript` | Base TypeScript client |

---

## Related Docs

- [ARCHITECTURE.md](ARCHITECTURE.md) — Skills, agents, commands system
- [MCP.md](MCP.md) — MCP server setup
