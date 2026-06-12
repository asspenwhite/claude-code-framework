# Playbook: Claude Code as Website / SaaS Operator

Running Claude Code as the engineering team of a production SaaS (tested on a
pay-per-usage AI product: web app, API backend, auth, billing, admin surface —
built and operated with Claude as the only engineer).

---

## The Core Discipline: Production ≠ Vibe-Coding

The failure mode of agent-built products isn't bad code — it's *unexamined*
code shipped at agent speed. "Smoke test green → ship" works until the first
real customer. The counterweight is a mandatory per-sprint loop:

```
research → plan → execute → adversarial review → revise → gate
```

- **Adversarial review** is a *fresh context* (subagent or second session)
  prompted to attack the work: failure modes, abuse paths, cost blowups,
  cross-tenant leaks — explicitly NOT style nits. Fresh context matters:
  a reviewer that watched the implementation inherits its blind spots.
- **The gate** is a written checklist the sprint cannot pass without:
  tests green, docs updated, security items checked, rollback known.
- After every milestone, stop and ask the production questions: What breaks
  at 10× load? How does this get abused? What does support look like? What
  does it cost per user?

## Document Spine

| Doc | Purpose |
|-----|---------|
| `docs/DECISIONS.md` | ADRs — every locked decision with context + alternatives. The defense against re-litigating settled questions in fresh sessions. |
| `docs/planning/SPRINT_PLAN.md` | Sprint sequence mapped to launch-readiness items, with status. |
| `docs/planning/DEV_PROCESS.md` | The loop above, written down — so every session runs the same process. |
| `docs/LAUNCH_READINESS.md` | The gate list between you and real customers. |
| `docs/INCIDENT-*.md` | Same-day reports — production incidents AND process incidents (e.g. "agent overwrote reference data during a rescore"). |

## Enterprise Patterns Worth Building Before Customer #1

Studied from a mature B2B SaaS codebase and applied selectively — ordered by
when they must exist:

**Before first signup (retrofitting is painful):**
- Multi-tenant scoping + RLS on every customer-facing table, from migration #1
- Per-tenant usage metering (billing accuracy is a day-one property)
- RPC/endpoint lockdown with *generic* error responses — detailed errors are
  an attacker's map of your API

**Before any enterprise/compliance conversation:**
- Append-only, tamper-evident audit log (chained hashes)
- Retention policy written down

**As the codebase stabilizes:**
- Custom CI lints encoding YOUR invariants: every query tenant-scoped, no
  PII in logs, no error-detail leaks, auth coverage on every route. Generic
  linters can't check these; ask Claude to write them and run as a Stop hook
  during dev (`docs/HOOKS.md`) and as CI blockers in the repo.

## Operating Rules

1. **Additive by default; never overwrite user/customer data without explicit
   consent + a verified snapshot.** One unrecoverable overwrite teaches this
   permanently — pay for the lesson here instead.
2. **Verify before claiming done.** Run the make-or-break check end-to-end
   and measure, before saying "done" — not after.
3. **Positioning and pricing live in ADRs**, not in chat history. Sessions
   drift back to abandoned framings unless the locked decision is written
   where every session reads it.
4. **Pre-launch gates are hooks for the business**: e.g. "no open signups
   until email verification + rate limits exist" written into
   LAUNCH_READINESS — because farmable free credits WILL be farmed.

## Hook Candidates

- `Stop` gate running the custom lint suite — a tenant-scoping miss blocks
  the turn, not the postmortem.
- `PreToolUse` denying edits to `migrations/` outside a planned migration task.
- `PostToolUse` secret-scanning every Write/Edit.
