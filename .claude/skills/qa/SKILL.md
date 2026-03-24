---
name: qa
description: Quality assurance testing with 7-category issue taxonomy. Auto-activates when testing, finding bugs, or verifying features.
activates_when: testing features, finding bugs, verifying changes, QA testing, regression testing
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, mcp__playwright__browser_navigate, mcp__playwright__browser_take_screenshot, mcp__playwright__browser_snapshot, mcp__playwright__browser_click
---

# QA - Quality Assurance Testing

Find bugs systematically. Fix them atomically.

## Core Rules (auto-activate)

### Issue Taxonomy

Every bug gets classified. Severity determines fix priority.

| Category | Severity | Description |
|----------|----------|-------------|
| **Crash** | Critical | App crashes, white screen, unrecoverable error |
| **Data Loss** | Critical | User data lost, corrupted, or inaccessible |
| **Security** | Critical | Auth bypass, data exposure, injection |
| **Functional** | High | Feature doesn't work as specified |
| **Visual** | Medium | Layout broken, styling wrong, responsive issues |
| **Performance** | Medium | Slow load, janky interactions, memory leaks |
| **UX** | Low | Confusing flow, missing feedback, poor copy |

### Testing Principles

```
✓ Test the happy path first, then edge cases
✓ One fix per commit — atomic changes
✓ Verify the fix, then check for regressions
✓ Screenshot before and after for visual issues
✓ Scope to changed code paths (diff-aware)
✗ Don't fix and move on without verifying
✗ Don't batch multiple fixes into one commit
✗ Don't test only what you built — test what you broke
```

### Diff-Aware Testing

When invoked on a branch, focus testing on:
1. **Changed files** — Direct impact
2. **Callers of changed functions** — Indirect impact
3. **Related routes/pages** — User-facing impact

Use `.claude/hooks/diff-scope.sh` to get the changed file list.

## Checklist

```
- [ ] Happy path works
- [ ] Edge cases tested
- [ ] Error states handled
- [ ] No regressions in related features
- [ ] Fixes committed atomically
```

---

## Review Mode (/qa)

Full QA testing with categorized findings.

### Testing Tiers

| Tier | Scope | When |
|------|-------|------|
| **Quick** | Changed files only, critical/high bugs | Pre-commit |
| **Standard** | Changed + related paths, all severities | Pre-PR |
| **Exhaustive** | Full regression, all paths | Pre-release |

### QA Process

1. **Scope** — Identify what changed (diff-scope.sh or full app)
2. **Test** — Walk through flows, check each category
3. **Log** — Record every issue with reproduction steps
4. **Prioritize** — Sort by severity (critical first)
5. **Fix** — One commit per fix, verify each
6. **Regress** — Re-test after fixes for regressions

### Output Format

```markdown
## QA Report

### Scope
- Tier: Quick / Standard / Exhaustive
- Files tested: [count]
- Flows tested: [list]

### Issues Found

| # | Category | Severity | Description | Status |
|---|----------|----------|-------------|--------|
| 1 | [type] | [sev] | [description] | Fixed/Open |

### Issue Details

#### Issue #1: [Title]
- **Category:** [type]
- **Severity:** [level]
- **Steps to reproduce:**
  1. Go to...
  2. Click...
  3. Expected: X, Actual: Y
- **Fix:** [file:line — what was changed]
- **Verified:** Yes/No

### Summary
- Issues found: [count]
- Fixed: [count]
- Remaining: [count]
- Ship-ready: Yes / No (reason)
```
