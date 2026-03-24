---
name: planner
description: Architecture planning and implementation sequencing. Auto-activates when planning features, migrations, or multi-file changes.
activates_when: planning features, architecture decisions, multi-file changes, migrations, implementation strategy
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Planner - Architecture Planning

Break big work into sequenced, testable steps.

## Core Rules (auto-activate)

### Planning Checklist

```
✓ Understand requirements before proposing solutions
✓ Identify all files that will change
✓ Sequence changes by dependency order
✓ Each step should leave the codebase working
✓ Identify risks and unknowns upfront
✓ Define rollback strategy for risky changes
✗ Don't start coding before the plan is clear
✗ Don't change everything at once
✗ Don't plan for hypothetical future requirements
```

### File Impact Assessment

Before any multi-file change:
1. List every file that will be created, modified, or deleted
2. Mark dependencies between files
3. Order changes so tests pass after each step

### Risk Identification

| Risk Level | Criteria | Action |
|-----------|----------|--------|
| **High** | Breaking API, data migration, auth changes | Plan rollback, add feature flag |
| **Medium** | New dependency, schema change, config change | Test in isolation first |
| **Low** | Refactor, rename, add tests | Proceed with confidence |

## Checklist

```
- [ ] Requirements understood (asked clarifying questions)
- [ ] All affected files identified
- [ ] Changes sequenced by dependency
- [ ] Risks identified with mitigation
- [ ] Each step leaves codebase working
```

---

## Review Mode (/plan)

Structured architecture plan with open questions.

### When to Invoke

- New feature implementation
- Large refactors
- System migrations
- Multi-service changes

### Plan Template

```markdown
## Plan: [Feature/Change Title]

### Requirements
- [What needs to happen]
- [Acceptance criteria]

### Open Questions
- [ ] [Thing that needs clarification before starting]

### File Changes

| Order | File | Action | Why |
|-------|------|--------|-----|
| 1 | path/to/file | Create/Modify/Delete | reason |

### Dependencies
[What must happen before what]

### Risks
| Risk | Impact | Mitigation |
|------|--------|------------|
| [risk] | [what breaks] | [how to handle] |

### Rollback
[How to undo if things go wrong]

### Steps
1. [First change — what and why]
2. [Second change — what and why]
3. [Verify — how to confirm it works]
```
