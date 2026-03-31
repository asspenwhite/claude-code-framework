# Output Format Templates

Reference file for the orchestrator. Read at Steps 4, 8.5, 9-12.

---

## Report Header (Step 4)

```markdown
# [Role] Report: [Project Name]

**Date:** [YYYY-MM-DD]
**Tier:** [Greenfield / WIP / Polish]
**Run:** [N]
**Mode:** Swarm (isolated agent)
**Honesty:** Unfiltered

---

[agent's report content]
```

Detect run number by counting existing reports for this role in `docs/reports/[role]/`.

---

## Doc Creation Templates (Step 9)

### DECISIONS.md
```markdown
# Decisions

## Deliberation: [YYYY-MM-DD] ([Tier] -- [Mode])

| # | Decision | Decided By | Rationale | Status |
|---|----------|-----------|-----------|--------|
| 1 | [decision] | [persona/user] | [why] | Active |
```

### TODO.md
```markdown
# TODO

## High Priority
- [ ] [task] -- from [persona], [date]

## Medium Priority
- [ ] [task] -- from [persona], [date]

## Low Priority
- [ ] [task] -- from [persona], [date]
```

### ARCHITECTURE.md
```markdown
# Architecture

## Deliberation: [YYYY-MM-DD]

### Stack
[from Torvalds]

### Key Decisions
[architecture decisions with rationale]

### Failure Modes
[identified risks]
```

### DESIGN.md
```markdown
# Design System

## Deliberation: [YYYY-MM-DD]

### Design Tokens
[from Sacco -- colors, fonts, spacing]

### Component Specs
[from Dyson -- key components with variants/states]

### Anti-Patterns
[from Sacco -- what to avoid]
```

For other docs (CONSTRAINTS, PERFORMANCE, MARKETING, MARKET, LESSONS): minimal header + dated section with persona contributions.

### Doc Update Rules
- File doesn't exist: create from template
- File exists: append new dated section (`## Deliberation: [YYYY-MM-DD] ([Tier] -- [Mode])`)
- Never overwrite existing content
- This step is NOT optional

---

## Checkpoint Files (Step 8.5)

### Complaint Ledger
**File:** `docs/reports/[YYYY-MM-DD]-[project]-complaint-ledger.md`

```markdown
# Complaint Ledger: [Project Name]
**Date:** [date] | **Rounds completed:** [1-3]

| # | From | To | Severity | Objection | Response | Resolution |
|---|------|----|----------|-----------|----------|------------|
```

### Session State
**File:** `docs/reports/[YYYY-MM-DD]-[project]-session-state.md`

```markdown
# Session State: [Project Name]
**Date:** [date] | **Tier:** [tier] | **Mode:** [mode]

## Saved Report Files
[list each role -> file path]

## Key Decisions Made
[numbered list]

## Ready for Step 9: Yes
```

---

## Action Plan (Step 10)

**File:** `docs/reports/[YYYY-MM-DD]-[project]-action-plan.md`

```markdown
# Action Plan: [Project Name]

**Generated:** [date] | **Tier:** [tier] | **Participants:** [list]

## Immediate Actions (P0)
| # | Task | Domain | From |
|---|------|--------|------|

## Next Sprint (P1)
| # | Task | Domain | From |
|---|------|--------|------|

## Backlog (P2)
| # | Task | Domain | From |
|---|------|--------|------|

## Decisions Made
| # | Decision | Decided By | Rationale |
|---|----------|-----------|-----------|

## Risks to Watch
| Risk | Flagged By | Mitigation |
|------|-----------|------------|
```

---

## Deliberation Summary (Step 11)

**File:** `docs/reports/[YYYY-MM-DD]-[project]-summary.md`

```markdown
# Deliberation Summary: [Project Name]

**Date:** [date] | **Tier:** [tier] | **Rounds:** [1-3] | **Mode:** [mode]

## Participants
| Role | Persona | Complaints Filed | Complaints Received |
|------|---------|-----------------|-------------------|

## Complaint Ledger
| # | From | To | Severity | Resolution |
|---|------|----|----------|------------|

## Key Decisions
| # | Decision | Decided By | Method |
|---|----------|-----------|--------|

## Unresolved Tensions
[overruled disagreements that may resurface]

## Pending Board Decisions
[FIRE recommendations, if any — require user approval]

## Docs Updated
[list]

## One-Sentence Product
[final description after all reviews]
```

---

## Deliberation Log Row (Step 12)

**File:** `docs/DELIBERATION_LOG.md`

```markdown
| [Run #] | [YYYY-MM-DD] | [Tier] | [Mode] | [persona count] | [top decisions] | [health score] |
```
