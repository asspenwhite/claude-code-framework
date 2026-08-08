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
| Context windows | Known per model | Unpublished; Claude Code assumes 200k for all of them |
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

- **The auto-mode safety classifier runs on the session model.** When the
  session model is briefly unavailable upstream, tool gating stalls with
  it — edits queue with "cannot determine safety" until recovery. Two
  consequences: pick a workhorse that classifies tool calls reliably,
  and don't diagnose a frozen session before checking provider status.
- **The picker's Default row resolves through the Opus slot.** Verified
  both directions. Align it with the launch default or never click it.
- **`_NAME` companion vars relabel every slot, Fable included.** Picker
  rows show real model IDs, which matters when the catalog churns.
- **Unknown-model warnings are cosmetic.** Claude Code doesn't recognize
  these model names; auto-compact assumes a 200k window for all of them.
  Set `CLAUDE_CODE_MAX_CONTEXT_TOKENS` if you ever confirm real windows.
- **Resumes are endpoint-agnostic.** `claude --resume <id>` and
  `qlaude --resume <id>` open the same transcript on different backends.

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

## Open Questions

Honest unknowns — fill these in as experience accumulates:

- Real context windows per model (unpublished; the 200k assumption is
  untested at the edges).
- How thinking / effort quality differs across the roster — effort
  levels render and apply, but per-model payoff is unmapped.
- The cost/perf sweet spot for subagents (currently the mid tier by
  default; not systematically compared).
- Whether the classifier follows the session model or the Fable slot
  when the two differ (observed following the session model once; not
  confirmed as the rule).
