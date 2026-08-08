# Provider Guide — QwenCloud

Running Claude Code against QwenCloud's Anthropic-compatible endpoint,
with every `/model` picker slot pointed at a model you actually want.
Distilled from daily use of a Team-edition Token Plan seat (August 2026),
specifics genericized.

---

## What QwenCloud Is

QwenCloud sells subscription access to a catalog of models — Qwen,
DeepSeek, Kimi, GLM, MiniMax — behind an Anthropic-compatible API. For
Claude Code, two plan families matter:

| Plan | Base URL (`ANTHROPIC_BASE_URL`) |
|------|----------------------------------|
| Token Plan (incl. Team edition) | `https://token-plan.ap-southeast-1.maas.aliyuncs.com/apps/anthropic` |
| Coding Plan | `https://coding-intl.dashscope.aliyuncs.com/apps/anthropic` |

Gotchas, learned the hard way:

- **The base URL ends at `/apps/anthropic`.** No `/v1` suffix in the env
  var; Claude Code appends paths itself. Adding one breaks it.
- **A key only works against its own plan's URL.** Mixing a key with the
  wrong plan's URL 401s.
- **Don't trust the key prefix to identify the plan.** Docs claim
  `sk-sp-` means Coding Plan, but a Team Token Plan seat key also starts
  with `sk-sp-` and only works on the token-plan URL (curl-verified both
  ways). When in doubt, curl `POST $BASE/v1/messages` against each.
- **Team-edition "members" are labels, not accounts.** A seat is an
  API-key grant attached to a free-text label. The generated key IS the
  seat; on the Basic tier the member gets no console login, no chat app —
  just the key. Regenerating a member's key invalidates the old one.

Qwen ships no installer or config file for Claude Code. Their official
setup doc says to hand-write the env vars into `~/.claude/settings.json` —
which works, but see doctrine #1 in [README.md](README.md) for why a
wrapper function is better when you also use real Anthropic.

---

## The Wrapper

```bash
qlaude() {
  local key
  # Read the seat key from your encrypted store (SOPS+age shown; any
  # encrypted-at-rest store works). Never cache plaintext.
  key="$(decrypt_qwen_key_from_your_store)"
  if [ -z "$key" ]; then
    echo "qlaude: QWEN_API_KEY unavailable — check your secrets store" >&2
    return 1
  fi
  ANTHROPIC_AUTH_TOKEN="$key" \
  ANTHROPIC_BASE_URL="https://token-plan.ap-southeast-1.maas.aliyuncs.com/apps/anthropic" \
  ANTHROPIC_MODEL="${QLAUDE_MODEL:-glm-5.2}" \
  ANTHROPIC_DEFAULT_FABLE_MODEL="qwen3.8-max" \
  ANTHROPIC_DEFAULT_FABLE_MODEL_NAME="qwen3.8-max" \
  ANTHROPIC_DEFAULT_OPUS_MODEL="glm-5.2" \
  ANTHROPIC_DEFAULT_OPUS_MODEL_NAME="glm-5.2" \
  ANTHROPIC_DEFAULT_SONNET_MODEL="qwen3.7-max" \
  ANTHROPIC_DEFAULT_SONNET_MODEL_NAME="qwen3.7-max" \
  ANTHROPIC_DEFAULT_HAIKU_MODEL="kimi-k2.7-code" \
  ANTHROPIC_DEFAULT_HAIKU_MODEL_NAME="kimi-k2.7-code" \
  ANTHROPIC_CUSTOM_MODEL_OPTION="deepseek-v4-pro" \
  ANTHROPIC_CUSTOM_MODEL_OPTION_NAME="deepseek-v4-pro" \
  CLAUDE_CODE_SUBAGENT_MODEL="${QLAUDE_SUBAGENT_MODEL:-qwen3.7-max}" \
  claude "$@"
}
```

Design notes:

- **Fail fast:** empty key → refuse to launch, one-line diagnosis.
- **Decrypt per invocation:** the key never touches disk or shell state
  in plaintext.
- **Two override knobs:** `QLAUDE_MODEL=<id> qlaude` sets the session
  model for one launch; `QLAUDE_SUBAGENT_MODEL=<id> qlaude` sets
  subagents. No arg-parsing framework needed.

---

## Mapping the `/model` Picker — Five Slots

The picker exposes **five** independently configurable slots:

| Slot | Env var | Example mapping |
|------|---------|-----------------|
| Fable (top tier) | `ANTHROPIC_DEFAULT_FABLE_MODEL` | flagship (e.g. `qwen3.8-max`) |
| Opus | `ANTHROPIC_DEFAULT_OPUS_MODEL` | strong generalist (e.g. `glm-5.2`) |
| Sonnet | `ANTHROPIC_DEFAULT_SONNET_MODEL` | workhorse (e.g. `qwen3.7-max`) |
| Haiku | `ANTHROPIC_DEFAULT_HAIKU_MODEL` | coding/fast tier (e.g. `kimi-k2.7-code`) |
| Custom row | `ANTHROPIC_CUSTOM_MODEL_OPTION` | one extra model (e.g. `deepseek-v4-pro`) |

Verified behaviors (Claude Code 2.1.226, Aug 2026):

- Each `..._MODEL_NAME` companion var relabels the picker row, so rows
  show real model IDs instead of Claude tier names. Works on all five
  slots, Fable included.
- **The picker's "Default" row resolves through the Opus slot.** Verified
  both ways: it tracked whatever Opus pointed at. If Default and your
  launch model should agree, make them the same model.
- Models beyond five live on the override path: `/model <id>` mid-session
  (any string passes through unvalidated on custom base URLs) or
  `QLAUDE_MODEL=<id>` at launch.
- Session resumes are endpoint-agnostic: `claude --resume <id>` and
  `qlaude --resume <id>` open the same transcript on different backends.
  You can bounce a conversation between providers mid-stream.

---

## Cost Routing on a Flat Subscription

A subscription changes the optimization. On metered Anthropic pricing you
minimize tokens; on a flat plan you minimize *opportunity cost* — the
flagship burns allowance fastest, so don't make it the default workhorse:

- **Session default (`ANTHROPIC_MODEL`)** = the strong cheap model
  (here `glm-5.2`). This is what runs 95% of the time, including the
  auto-mode safety classifier and other internal machinery.
- **Flagship lives in the Fable slot**, reached deliberately via `/model`
  for the hardest tasks.
- The six-model example above was curl-verified live before wiring; the
  catalog changes, so re-check the plan's supported-models doc if a name
  404s.

---

## Verify

```bash
# Each model ID resolves on your plan (1-token probe; expects "content" in response)
KEY="$(decrypt_qwen_key_from_your_store)"
BASE="https://token-plan.ap-southeast-1.maas.aliyuncs.com/apps/anthropic"
for m in qwen3.8-max glm-5.2 qwen3.7-max kimi-k2.7-code deepseek-v4-pro; do
  resp=$(curl -s -m 40 -X POST "$BASE/v1/messages" \
    -H "x-api-key: $KEY" -H "anthropic-version: 2023-06-01" \
    -H "content-type: application/json" \
    -d "{\"model\":\"$m\",\"max_tokens\":1,\"messages\":[{\"role\":\"user\",\"content\":\"hi\"}]}")
  echo "$resp" | grep -q '"content"' && echo "$m : OK" || echo "$m : FAIL -> $(echo "$resp" | head -c 200)"
done

# Wrapper sanity
qlaude --version
```

Then open a session, run `/model`, and confirm the rows show your model IDs.

---

## Known Limitations

- **Context windows aren't published.** Claude Code doesn't know these
  model names, so auto-compact assumes a 200k window for all of them.
  Harmless; set `CLAUDE_CODE_MAX_CONTEXT_TOKENS` if you ever confirm a
  different real window.
- **Upstream wobbles are part of the deal.** Cheaper stacks blink
  occasionally; when the session model is briefly unavailable, anything
  that runs on it (including auto-mode's safety classifier) stalls until
  it recovers. Fail-fast wiring and five alternate models are the
  mitigation.
- **Unknown-model warnings.** Claude Code may warn that it doesn't
  recognize the model name. Cosmetic.
