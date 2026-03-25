---
name: investigation
description: Root cause debugging with hypothesis testing. Auto-activates when debugging, investigating errors, or analyzing unexpected behavior. Automatically generates incident reports.
activates_when: debugging, error investigation, unexpected behavior, root cause analysis, something broke, error, crash, failure
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Investigation - Root Cause Debugging

"No Fix Without Root Cause" — the Iron Law of debugging.

## Core Rules (auto-activate)

### The Iron Law

**Never apply a fix without first confirming the root cause.** Symptom-level fixes create technical debt and mask real problems.

### 3-Strike Rule

If 3 attempted fixes fail, **STOP**. Re-analyze from scratch:
1. Your mental model of the system is wrong
2. You're fixing a symptom, not the cause
3. The bug is somewhere you haven't looked

### Scope Lock

When investigating, **don't fix unrelated issues** you discover. Log them and move on. Fixing tangential bugs mid-investigation creates noise and makes it harder to verify the original fix.

### Auto-Incident Report

**Every time something breaks, an incident report is automatically generated.** This is not optional. If the investigation skill activates because of a bug, error, crash, or unexpected behavior, a report MUST be saved to `docs/reports/incidents/` before the investigation is considered complete.

This applies when:
- A test fails unexpectedly
- A build breaks
- A runtime error occurs
- A feature stops working
- A deployment fails
- A regression is discovered
- Performance degrades significantly
- Data is corrupted or lost

## Process

```
Detect → Reproduce → Isolate → Hypothesize → Verify → Fix → Confirm → Report
```

1. **Detect:** What broke? Capture the exact error, stack trace, or symptom.
2. **Reproduce:** Can you trigger the bug reliably?
3. **Isolate:** What's the minimal reproduction case?
4. **Hypothesize:** State your theory explicitly. What evidence would confirm or deny it?
5. **Verify:** Gather evidence. Read code, check logs, add instrumentation.
6. **Fix:** Apply the minimal change that addresses the confirmed root cause.
7. **Confirm:** Verify the fix works AND hasn't introduced regressions.
8. **Report:** Save incident report to `docs/reports/incidents/`.

## Checklist

```
- [ ] Bug reproduced reliably
- [ ] Root cause identified with evidence
- [ ] Fix is minimal (only addresses root cause)
- [ ] No regressions introduced
- [ ] Incident report saved to docs/reports/incidents/
```

---

## Incident Report (Auto-Generated)

**Saved to:** `docs/reports/incidents/[YYYY-MM-DD]-[short-slug].md`

The report is generated automatically at the END of every investigation. It captures what happened, why, how it was fixed, and what to do to prevent it from happening again.

### Severity Classification

| Severity | Criteria | Response |
|----------|----------|----------|
| **P0 — Critical** | Data loss, security breach, complete outage | Drop everything. Fix now. |
| **P1 — High** | Major feature broken, significant user impact | Fix within the session. |
| **P2 — Medium** | Feature degraded, workaround exists | Fix soon, but not blocking. |
| **P3 — Low** | Minor issue, cosmetic, edge case | Fix when convenient. |

### Report Template

```markdown
# Incident Report: [Short Title]

**Date:** [YYYY-MM-DD]
**Severity:** [P0 / P1 / P2 / P3]
**Status:** [Resolved / Mitigated / Open]
**Duration:** [time from detection to resolution]

---

## What Happened

[1-3 sentences. Plain language. What the user experienced.]

## Timeline

| Time | Event |
|------|-------|
| [time] | Issue detected: [how — error message, test failure, user report] |
| [time] | Investigation started |
| [time] | Root cause identified |
| [time] | Fix applied |
| [time] | Fix verified |

## Impact

- **Users affected:** [scope — all users, specific flow, specific config]
- **Data impact:** [any data loss or corruption?]
- **Duration of impact:** [how long were users affected?]

## Root Cause

[Detailed explanation. Not just "X was wrong" — explain WHY X was wrong and what chain of events led to it.]

### Hypothesis Chain

| # | Hypothesis | Evidence For | Evidence Against | Verdict |
|---|-----------|-------------|-----------------|---------|
| 1 | [theory] | [supporting] | [contradicting] | Confirmed/Rejected |

## Fix Applied

- **File(s):** [paths]
- **Change:** [what was changed]
- **Commit:** [hash if committed]
- **Why this fix:** [why this approach vs alternatives]

## Verification

- [ ] Original issue no longer reproduces
- [ ] Related flows verified working
- [ ] Tests pass
- [ ] No regressions

## Prevention

### What could have caught this earlier?

- [ ] **Test gap:** [missing test that would have caught this]
- [ ] **Monitoring gap:** [alert or check that should exist]
- [ ] **Process gap:** [review step or guardrail that was missing]

### Action Items

- [ ] [Add test for this scenario]
- [ ] [Add monitoring/alerting]
- [ ] [Update CLAUDE.md with new gotcha if pattern is likely to recur]
- [ ] [Update skill rules if a guardrail should have prevented this]

## Lessons Learned

[What did we learn? What pattern should we remember? Is this a recurring theme?]

---

*This incident report was auto-generated by the investigation skill.*
```

---

## Review Mode (/investigate)

Full investigation with structured hypothesis testing.

### When to Invoke

- Bugs with no obvious cause
- Intermittent failures
- Performance regressions
- Unexpected behavior after changes
- Production incidents
- Test suite failures

### Process

1. **Capture the scene** — Exact error, stack trace, logs, screenshots
2. **Classify severity** — P0/P1/P2/P3 determines urgency
3. **Reproduce** — Find reliable reproduction steps
4. **Build hypothesis chain** — State each theory, test it, confirm or reject
5. **Apply Iron Law** — No fix without confirmed root cause
6. **Apply 3-Strike Rule** — 3 failed fixes = restart from scratch
7. **Fix and verify** — Minimal fix, confirm no regressions
8. **Write incident report** — Auto-saved to `docs/reports/incidents/`
9. **Prevention items** — What test, monitor, or guardrail would prevent recurrence
10. **Update TODO.md** — Add prevention action items

### Investigation Report (during investigation)

Use this lighter format while actively debugging:

```markdown
## Investigation: [Bug Title]

### Symptoms
- What's happening
- When it started
- Frequency (always / intermittent / specific conditions)

### Reproduction Steps
1. Step 1
2. Step 2
3. Expected: X, Actual: Y

### Hypothesis Chain
| # | Hypothesis | Evidence For | Evidence Against | Verdict |
|---|-----------|-------------|-----------------|---------|
| 1 | [theory] | [supporting] | [contradicting] | Confirmed/Rejected |

### Root Cause
[Confirmed cause with evidence]

### Fix Applied
- File: [path]
- Change: [what was changed and why]
- Lines: [line numbers]

### Verification
- [ ] Original bug no longer reproduces
- [ ] Related flows still work
- [ ] No regressions in tests
```

The full incident report is generated from this at the end, with prevention items and lessons learned added.

---

## Iterative Research Loop

When spawning subagents (via Agent tool) for research or data gathering, evaluate what they return. Don't accept the first summary blindly.

```
Cycle 1: Dispatch Agent with query + objective → evaluate return → sufficient? Done. Incomplete? →
Cycle 2: Ask targeted follow-up (what's missing, what needs clarification) → evaluate → sufficient? Done. →
Cycle 3: Final follow-up → evaluate → accept whatever comes back.
Max 3 cycles. Accept after 3 regardless.
```

**Rules:**
- Always pass BOTH the specific query AND the broader objective to the subagent — they lack your context
- Evaluate every return: does it answer the actual question, or just the literal query?
- Follow-up questions should be specific: "What error code?" not "Tell me more"
- After 3 cycles, accept and work with what you have — diminishing returns
