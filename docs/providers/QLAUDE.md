# QLAUDE — Working Doctrine on a QwenCloud Backend

[QWENCLOUD.md](QWENCLOUD.md) gets you wired. This document is the other
half: how to run this framework day-to-day once Claude Code is talking to
QwenCloud instead of Anthropic. What carries over unchanged, what swaps,
and what only exists on this side.

"qlaude" here means any wrapper built per QWENCLOUD.md — a shell function
that points Claude Code at the QwenCloud endpoint with deliberate model
mapping. Field notes below are verified against Claude Code 2.1.226 and a
Team-edition Token Plan seat, August 2026.

---

## What Carries Over Unchanged

The framework's doctrine is model-agnostic. All of it applies on qlaude
exactly as written:

- **Progressive disclosure.** CLAUDE.md is Level 1, docs/ is Level 2,
  Claude reads on demand.
- **Docs describe what IS.** AS-BUILT vs DRAFT separation, append-only
  audit CHANGELOG, same-day incident reports.
- **Hooks over repetition.** Anything that must hold 100% of the time is
  a hook, regardless of which model is answering.
- **The verification loop.** A named Check command, and the
  adversarial-reviewer subagent attacking the diff in fresh context.
- **The playbooks.** Repo-per-system, read-only first, docs before action.
- **`/retro`.** Corrections compound into config no matter the backend.

None of these care what model answers. Treat them as load-bearing.

---

## What Swaps

The Claude-tuned items get qlaude equivalents:

| Framework item | Claude-native | qlaude equivalent |
|----------------|---------------|-------------------|
| `MODEL_NOTES.md` | Claude 5 era tuning | The roster below — same idea, different catalog |
| Tier names | Fable / Opus / Sonnet / Haiku | Picker rows show real model IDs; think in **roles**, not names |
| Cost discipline | Per-token: minimize spend | Flat subscription: minimize opportunity cost (see below) |
| Context windows | Known per model | Vendor specs below; Claude Code still assumes 200k |
| Model stability | Rarely renamed | Catalog churns; re-verify names when one 404s |

---

## The Roster — Roles, Not Names

The five-slot mapping from QWENCLOUD.md, as a working playbook for which
model to reach for:

| Slot | Model | Role | Reach for it when |
|------|-------|------|-------------------|
| Fable | flagship (e.g. `qwen3.8-max`) | The hard brain | Hardest reasoning, long-horizon tasks, anything the workhorse botched |
| Opus | strong generalist (e.g. `glm-5.2`) | Daily workhorse | The default session model; ~95% of work |
| Sonnet | mid tier (e.g. `qwen3.7-max`) | Subagent default | Delegated work, background agents |
| Haiku | fast coding model (e.g. `kimi-k2.7-code`) | Quick iterations | Fast edits, simple lookups, cheap loops |
| Custom | extra model (e.g. `deepseek-v4-pro`) | Specialist | What you mapped it for |
| *(no slot)* | everything else | Overrides | `/model <id>` mid-session, `QLAUDE_MODEL=<id>` at launch |

**Cost routing on a flat subscription.** On metered Anthropic pricing you
minimize tokens. On a flat plan the flagship burns allowance fastest, so
it lives in the Fable slot and gets reached for deliberately — it does
not ride as the session default. The workhorse carries the volume; the
flagship carries the hard 5%.

---

## qlaude-Specific Behavior (Field Notes)

Observed in daily use; treat as ground truth until contradicted:

- **The auto-mode safety classifier runs on the Sonnet slot, not the
  session model.** On a third-party base URL Claude Code resolves the
  classifier to `ANTHROPIC_DEFAULT_SONNET_MODEL` when that slot is
  deliberately set, and falls back to the session model only when it
  isn't. Verified two ways: the resolution chain carved from the 2.1.226
  binary, and a live auto-mode probe that logged the classifier calling
  `qwen3.7-max` (the Sonnet slot) while the session ran `glm-5.2`.
  `CLAUDE_CODE_SUBAGENT_MODEL` is a separate knob and doesn't affect it.
  Mechanics worth knowing: the classifier is two-stage, skips actions
  that acceptEdits mode would allow anyway (in-repo writes, built-in-safe
  commands like `echo`), and costs roughly 11 seconds per action it does
  judge. When the classifier model fails upstream, tool gating blocks for
  safety until recovery — that, not a frozen session, is what an outage
  stall looks like. In August 2026 the Sonnet slot was unset, so the
  classifier followed the session model (`qwen3.8-max`) and its upstream
  outage blocked edits; the five-slot mapping is itself the fix.
- **The picker's Default row resolves through the Opus slot.** Verified
  both directions. Align it with the launch default or never click it.
- **`_NAME` companion vars relabel every slot, Fable included.** Picker
  rows show real model IDs, which matters when the catalog churns.
- **Unknown-model warnings are cosmetic, and now actionable.** Claude
  Code doesn't recognize these model names, so it assumes a 200k window
  for all of them — auto-compact fires early. To claim the real window:
  append `[1m]` to the model name — verified 2026-08-08 to strip
  client-side on 2.1.226 (a suffixed model returns clean; the endpoint
  never sees the suffix, so no 404). Wire it per-model — clean for a mixed
  1M/256k roster (suffix the 1M models, leave the rest). The global
  `CLAUDE_CODE_MAX_CONTEXT_TOKENS` is a single number and can't express a
  mixed roster, so prefer the suffix. The windows table below is what
  there is to claim.
- **Resumes are endpoint-agnostic.** `claude --resume <id>` and
  `qlaude --resume <id>` open the same transcript on different backends.
- **WebSearch and MCP servers are backend-agnostic.** Verified live on
  qlaude: WebSearch executes (it's client-side in 2.1.226, not an
  Anthropic server tool), and every configured MCP server loads and
  responds. MCP servers are spawned by the Claude Code client; only tool
  definitions and results cross the wire to the endpoint. Caveat: MCPs
  that need interactive OAuth may be absent in headless/cron runs.

---

## Cross-Provider Workflow

If you keep a real Anthropic setup alongside qlaude (recommended when
affordable), the two compose:

- `claude` and `qlaude` coexist with zero cross-talk; each launch picks
  its backend.
- A conversation can bounce between providers mid-stream via resume.
  Explore cheap on qlaude, then resume the same transcript on Anthropic
  for the part where you want the Claude flagship — or the reverse.
- Rule of thumb: **volume on the subscription, judgment on the best
  model you can afford.** Provider choice becomes a per-task decision
  instead of a monthly religion.

---

## Resolved Unknowns — August 2026

The original four open questions, answered by vendor specs, endpoint
probes, binary reading, and a scored bake-off.

**Context windows.** Vendor-published specs, with the endpoint's
enforced max-output caps verified by probe:

| Model | Context (vendor spec) | max_tokens cap (probed) |
|-------|-----------------------|--------------------------|
| `qwen3.8-max` | 1M | not probeable — server clamps silently |
| `qwen3.7-max` | ~1M (991k) | 131,072 |
| `glm-5.2` | 1M | 131,072 |
| `kimi-k2.7-code` | 262,144 | 262,144 |
| `deepseek-v4-pro` | 1M | not probeable — server clamps silently |
| `deepseek-v4-flash` | 1M | not probeable — server clamps silently |

The endpoint's vendor is also its host (QwenCloud publishes and serves
these models), so there's no vendor/host drift to worry about — five of
six models are genuinely 1M (`kimi-k2.7-code` is 256k). The per-model
`[1m]` suffix is verified 2026-08-08 to strip client-side on 2.1.226: a
suffixed model returns a clean reply, no 404 — the endpoint never sees
the suffix. Wire `[1m]` onto your 1M model IDs and leave non-1M
unsuffixed. (`CLAUDE_CODE_MAX_CONTEXT_TOKENS` is a single global number
and can't express a mixed 1M/256k roster, so prefer the suffix.)

**Effort payoff.** A scored bake-off (objective merge-intervals task,
generated code executed against 7 tests) ran the roster across effort
levels: 10/10 runs scored full marks — `glm-5.2` at low/high/max,
`qwen3.8-max` at low/high/max, and the rest of the roster at high. The
task was too easy to discriminate: effort levels applied but showed no
measurable quality difference. Wall times per run: glm-5.2 9–15s,
qwen3.8-max 16–18s, qwen3.7-max 11s, kimi-k2.7-code 16s,
deepseek-v4-pro 9s, deepseek-v4-flash 12s. Working rule until a harder
test says otherwise: effort is a speed/quota dial, not a quality dial,
at this tier.

**Subagent sweet spot.** `qwen3.7-max` keeps the slot: full marks in
the bake-off, already wired as the subagent default. The classifier
finding changes the calculus though — the Sonnet slot belongs to the
classifier and `CLAUDE_CODE_SUBAGENT_MODEL` is independent of it, so
the subagent model can be chosen on cost/perf alone. `deepseek-v4-flash`
matched quality at the roster's lowest latency and is the cheaper
alternative whenever delegated work feels over-served.

**Classifier model choice.** Resolved in the field note above: Sonnet
slot, with session-model fallback when the slot is unset.

**Honest residuals** — what this didn't settle:

- Bake-off ceiling: a task every model aces can't rank models or
  effort. Real discrimination needs harder tasks; until then treat the
  defaults as unchallenged, not validated.
- The exact window readout isn't capturable in `-p` mode — confirm with
  `/context` in an interactive session after wiring. The `[1m]` strip
  itself is verified live; the global `CLAUDE_CODE_MAX_CONTEXT_TOKENS`
  can't express a mixed 1M/256k roster, so use the suffix.
- Subagent candidates were compared on one-shot prompts, not real
  multi-step delegated work.
