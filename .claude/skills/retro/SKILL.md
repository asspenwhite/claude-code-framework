---
name: retro
description: End-of-session retrospective — harvest corrections, repeated friction, and discoveries from this session into durable config (CLAUDE.md rules, hooks, docs) so the setup compounds.
disable-model-invocation: true
---

# Retro — Make the Session Pay Rent

Review the current session and harvest anything worth keeping. A correction
that lives only in chat history is a correction you'll need again.

## 1. Collect

Scan the conversation for:

- **Corrections** — places the operator said no / stop / wrong / "actually…"
  or redirected your approach
- **Repeats** — instructions given more than once, or given here that were
  also given in a previous session
- **Discoveries** — gotchas, commands, constraints, or system behaviors you
  learned the hard way this session
- **Friction** — permission prompts, missing context, or tool failures that
  slowed the work

## 2. Route each finding to its durable home

| Finding type | Destination |
|--------------|-------------|
| Must hold 100% of the time | A **hook** — draft the matcher + script (see `docs/HOOKS.md`) |
| Guidance requiring judgment | A one-line **CLAUDE.md** addition — and name a line to DELETE to pay for it |
| Project fact / system behavior | **docs/** — RUNBOOK gotcha, DECISIONS entry, or CHANGELOG |
| Failure with a timeline | An **incident report** (`docs/templates/INCIDENT.template.md`) |
| One-off, not worth keeping | Discard — say so explicitly |

## 3. Propose, then apply

Present a table: finding → destination → exact proposed text. Apply only
what the operator approves.

After applying, run the prune check: if CLAUDE.md is over ~150 lines,
propose removals using the test *"would removing this cause mistakes?"* —
the retro must not be a one-way ratchet toward bloat.
