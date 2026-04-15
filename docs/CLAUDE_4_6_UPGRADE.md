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

## Adaptive Thinking Fix (Claude Code client regression)

Adaptive thinking is the 4.6 API default and the correct abstraction at the API layer (see "Adaptive Thinking" above). But **Claude Code's client** applies `type:"adaptive"` aggressively — including in subagent and init paths that no longer respect user settings — and the server-side classifier misjudges many prompts as trivial and skips reasoning entirely. The result is a measurable quality regression on tasks the user expected reasoning on.

### What we measured

Benchmark (Opus + Sonnet 4.6, peak + off-peak, n=60 runs, isolated config, no MCP/plugins):

| Finding | Impact |
|---------|--------|
| Adaptive skips thinking on 60–80% of "easy" tasks | Wrong answers on cognitive-trap questions |
| Sonnet with forced thinking | -16% cost, -16% latency at peak — adaptive is *not* a neutral optimization |
| `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1` env var | Only covers 1 of 5 code paths in `cli.js` |

Sources:
- Our benchmark report ("Adaptive Thinking is a Quality, Cost, and Latency Regression").
- GitHub issue [anthropics/claude-code#42796](https://github.com/anthropics/claude-code/issues/42796) (closed, 440 comments) — related thinking-depth redaction regression.

### The three layers (all needed for full-max, no regression)

| Layer | What | Why |
|-------|------|-----|
| 1. `effort: "max"` in `settings.json` | Tells client to *request* max reasoning depth | The documented intensity dial (`--effort max`) |
| 2. Patch client: `type:"adaptive"` → `type:"enabled"` | *Prevents* the server's adaptive classifier from overriding our request | Without this, `effort: max` can be silently downgraded |
| 3. `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1` env var | Main-path fallback after auto-updates wipe the patch | Keeps 1 of 5 paths fixed between patch runs |

### How to apply (give this to Claude Code)

On a fresh machine, open `claude` and say:

> Apply the adaptive thinking fix per `docs/CLAUDE_4_6_UPGRADE.md` — all three layers.

The agent should execute:

**Step A — settings.json** (`~/.claude/settings.json`; on Windows, `%USERPROFILE%\.claude\settings.json`). Merge (don't overwrite) these keys:

```json
{
  "effortLevel": "max",
  "env": {
    "CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING": "1"
  }
}
```

> Schema docs only enumerate `low|medium|high` for `effortLevel`, but Claude Code accepts `"max"` (matches the `--effort max` CLI flag for Opus 4.6). `CLAUDE_CODE_THINKING_BUDGET` only has effect on the Node `cli.js` patch variant below — skip on native-binary installs.

**Step B — detect install type:**

```bash
CLAUDE_BIN=$(readlink -f "$(command -v claude)")
file "$CLAUDE_BIN"
```

- If output contains `PE32+` or `ELF` or `Mach-O` → **native binary** (follow Step C-native).
- If output contains `text` or `script` → **Node install** (follow Step C-node).

**Step C-native — patch native binary** (Windows `.exe`, Linux ELF, macOS Mach-O):

Equal-length replacement only. `type:"adaptive"` is 15 chars; replace with `type:"enabled" ` (note trailing space — 15 chars, valid JS). `budget_tokens` injection not possible on binary; layer 1 (`effort: max`) provides budget via the client's settings path.

```bash
cp "$CLAUDE_BIN" "$CLAUDE_BIN.bak.$(date +%s)"
# perl handles binary safely on all platforms
perl -i -pe 's/type:"adaptive"/type:"enabled" /g' "$CLAUDE_BIN"
# Verify
grep -ac 'type:"adaptive"' "$CLAUDE_BIN"   # expect 0
grep -ac 'type:"enabled" ' "$CLAUDE_BIN"    # expect ≥ 5
```

**Step C-node — patch cli.js** (traditional npm/nvm/volta/brew install):

Resolve cli.js:

```bash
# Claude's bin is usually a Node wrapper; cli.js sits beside or under ../lib/node_modules/@anthropic-ai/claude-code/
CLI_JS=$(dirname "$CLAUDE_BIN")/cli.js
[ -f "$CLI_JS" ] || CLI_JS=$(dirname "$CLAUDE_BIN")/../lib/node_modules/@anthropic-ai/claude-code/cli.js
```

Richer patch with tunable budget:

```bash
cp "$CLI_JS" "$CLI_JS.bak.$(date +%s)"
if sed --version 2>/dev/null | grep -q GNU; then
  sed -i 's/{type:"adaptive"}/{type:"enabled",budget_tokens:+process.env.CLAUDE_CODE_THINKING_BUDGET||24000}/g' "$CLI_JS"
else
  # BSD sed (macOS default)
  sed -i '' 's/{type:"adaptive"}/{type:"enabled",budget_tokens:+process.env.CLAUDE_CODE_THINKING_BUDGET||24000}/g' "$CLI_JS"
fi
# Verify
grep -c 'type:"adaptive"' "$CLI_JS"              # expect 0
grep -c 'CLAUDE_CODE_THINKING_BUDGET' "$CLI_JS"  # expect ≥ 5
```

**Step D — verify end-to-end:**

1. `grep -c 'type:"adaptive"' <patched-binary-or-cli.js>` → 0.
2. Start a fresh Claude Code session. Ask an easy task ("add a print statement to foo.py").
3. Open the session JSONL at `~/.claude/projects/<slug>/<session-id>.jsonl`.
4. `grep -c '"thinking"' <session>.jsonl` should be ≥ 1 per assistant turn. Before the fix, often 0 on easy tasks.

### After Claude Code auto-updates

Layer 2 is overwritten on every `claude` update. Layer 3 (env var) keeps the main path covered in the gap. Re-apply:

> Claude, re-apply the adaptive thinking patch (layer 2) per `docs/CLAUDE_4_6_UPGRADE.md` — settings and env var are already set.

Optionally pin version by disabling auto-update — trades away upstream fixes.

### Re-verify before recommending

Anthropic may fix this upstream. Before telling another machine to apply, check #42796 and related open issues. If `grep -c 'type:"adaptive"' <fresh-cli.js-or-binary>` returns 0 on a clean install, the fix has shipped and this section is archived.

---

## Related Docs

- [ARCHITECTURE.md](ARCHITECTURE.md) — Skills, agents, commands system
- [MCP.md](MCP.md) — MCP server setup
