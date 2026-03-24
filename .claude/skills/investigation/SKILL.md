---
name: investigation
description: Root cause debugging with hypothesis testing. Auto-activates when debugging, investigating errors, or analyzing unexpected behavior.
activates_when: debugging, error investigation, unexpected behavior, root cause analysis
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

## Process

```
Reproduce → Isolate → Hypothesize → Verify → Fix → Confirm
```

1. **Reproduce:** Can you trigger the bug reliably?
2. **Isolate:** What's the minimal reproduction case?
3. **Hypothesize:** State your theory explicitly. What evidence would confirm or deny it?
4. **Verify:** Gather evidence. Read code, check logs, add instrumentation.
5. **Fix:** Apply the minimal change that addresses the confirmed root cause.
6. **Confirm:** Verify the fix works AND hasn't introduced regressions.

## Checklist

```
- [ ] Bug reproduced reliably
- [ ] Root cause identified with evidence
- [ ] Fix is minimal (only addresses root cause)
- [ ] No regressions introduced
```

---

## Review Mode (/investigate)

Full investigation report with hypothesis chain.

### When to Invoke

- Bugs with no obvious cause
- Intermittent failures
- Performance regressions
- Unexpected behavior after changes

### Investigation Template

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
