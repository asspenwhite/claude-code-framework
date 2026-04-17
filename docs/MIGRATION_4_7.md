# Migrating to Opus 4.7

Checklist for cleaning up Claude 4.6 adaptive thinking workarounds and applying Opus 4.7 defaults across all machines and projects. Run once per machine.

---

## Per-machine cleanup

### 1. Remove adaptive thinking env var from settings.json

```bash
# Location:
# Linux/macOS: ~/.claude/settings.json
# Windows: %USERPROFILE%\.claude\settings.json

# Remove this key from "env" block:
#   "CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING": "1"
# Keep "effortLevel": "high" if you want it as a preference (not a workaround anymore).
```

### 2. Reinstall Claude Code (reverts cli.js / binary patches)

```bash
# npm global install
sudo npm install -g @anthropic-ai/claude-code

# Or if using the native binary, just let it auto-update
# The fresh install has no type:"adaptive" patches to revert
```

### 3. Verify clean install

```bash
# Find the binary/cli.js
CLAUDE_BIN=$(readlink -f "$(command -v claude)")
# Should return 0 — no "adaptive" overrides in the binary
grep -c 'CLAUDE_CODE_THINKING_BUDGET' "$CLAUDE_BIN" 2>/dev/null || echo "clean (binary)"
# For Node installs, also check cli.js
CLI_JS=$(dirname "$CLAUDE_BIN")/../lib/node_modules/@anthropic-ai/claude-code/cli.js
grep -c 'CLAUDE_CODE_THINKING_BUDGET' "$CLI_JS" 2>/dev/null || echo "clean (cli.js)"
```

### 4. Update home-level CLAUDE.md

Remove any references to:
- `docs/CLAUDE_4_6_UPGRADE.md` (replaced by `docs/PROMPTING.md`)
- "Apply the adaptive thinking fix"
- `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING`
- `cli.js` patching

### 5. Update per-project CLAUDE.md files

For each project that uses this framework, ensure:
- The three XML blocks are present: `<parallel_tool_calls>`, `<do_not_overengineer>`, `<context_window>`
- `<default_to_action>` is **not** present (asspenwhite's preference — see `docs/PROMPTING.md`)
- No anti-laziness prompts ("be thorough", "think carefully", "You MUST use X")
- No references to the old adaptive thinking fix

---

## Machine status tracker

| Machine | settings.json | cli.js/binary | Home CLAUDE.md | Status |
|---------|--------------|---------------|----------------|--------|
| Proxmox host | | | | |
| VM100 (Windows) | | | | |
| VM300 (Ubuntu) | | | | |
| MacBook (if applicable) | | | | |

Fill in ✅ / ❌ as you clean each machine.

---

## What changed in Opus 4.7 (reference)

| Change | Impact |
|--------|--------|
| `thinking.budget_tokens` **removed** | Returns 400 error. Use `thinking: {type: "adaptive"}` + `effort` instead. |
| Adaptive thinking is **off by default** | Must opt in with `thinking: {type: "adaptive"}`. |
| `type: "enabled"` with `budget_tokens` → **400 error** | The old 4.5 manual-budget approach no longer works. |
| Sampling params (`temperature`, `top_p`, `top_k`) at non-default → **400 error** | Omit them entirely. |
| Thinking content **hidden by default** | Set `display: "summarized"` to see thinking blocks. |
| New effort level: **`xhigh`** | Between `high` and `max`. Good for coding/agentic work. |
| New tokenizer | Up to 35% more tokens for same text. Adjust `max_tokens` accordingly. |
| Model ID | `claude-opus-4-7` (was `claude-opus-4-6`) |

For full API docs: [docs.anthropic.com](https://docs.anthropic.com/en/docs/about-claude/models)

---

## Related

- [PROMPTING.md](PROMPTING.md) — XML blocks, effort levels, anti-patterns
- [Anthropic migration guide](https://platform.claude.com/docs/en/about-claude/models/migration-guide)
