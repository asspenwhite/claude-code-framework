# Output Format Templates

Reference file for framework-launch orchestration. The team lead reads this when saving reports (Step 4), updating docs (Step 9), generating action plans (Step 10), summaries (Step 11), and deliberation logs (Step 12).

---

## Report Header (Step 4)

Add this header to every saved report. **Detect run number** by counting existing report files for this role in `docs/reports/[role]/`.

```markdown
# [Role] Report: [Project Name]

**Date:** [YYYY-MM-DD]
**Tier:** [Greenfield / WIP / Polish]
**Run:** [N] (count of previous reports for this role + 1)
**Status:** [Initial / Incremental / Redesign — based on mode and context]
**Mode:** Swarm (isolated agent)
**Honesty:** Unfiltered

---

[agent's report content]
```

---

## Doc Creation Formats (Step 9)

When a living doc doesn't exist yet, create it using these templates:

### DECISIONS.md
```markdown
# Decisions

## Deliberation: [YYYY-MM-DD] ([Tier] — [Mode])

| # | Decision | Decided By | Rationale | Status |
|---|----------|-----------|-----------|--------|
| 1 | [decision] | [persona/user] | [why] | Active |
```

### TODO.md
```markdown
# TODO

## High Priority
- [ ] [task] — from [persona], [date]

## Medium Priority
- [ ] [task] — from [persona], [date]

## Low Priority
- [ ] [task] — from [persona], [date]
```

### ARCHITECTURE.md
```markdown
# Architecture

## Deliberation: [YYYY-MM-DD]

### Stack
[from Torvalds's report]

### Key Decisions
[architecture decisions with rationale]

### Data Model
[if discussed]

### Failure Modes
[identified risks]
```

### DESIGN.md
```markdown
# Design System

## Deliberation: [YYYY-MM-DD]

### Design Tokens
[from Sacco's report — colors, fonts, spacing]

### Component Specs
[from Dyson's report — key components with variants/states]

### Anti-Patterns
[from Sacco's AI slop report — what to avoid]

### Dimension Scores
[from Dyson's 8-dimension ratings]
```

### Other Docs
For CONSTRAINTS.md, PERFORMANCE.md, MARKETING.md, MARKET.md, LESSONS.md — use the minimal headers created in Step 0.5, then append a dated section: `## Deliberation: [YYYY-MM-DD] ([Tier] — [Mode])` with the relevant persona's contributions.

---

## Doc Update Rules (Step 9)

- If file doesn't exist: **create it** using the template above
- If file exists: **append** a new dated section — never overwrite existing content
- Header each new section with: `## Deliberation: [YYYY-MM-DD] ([Tier] — [Mode])`
- Mark items from this deliberation with the date
- Use the exemplar pattern: bayareatrafficschool's DECISIONS.md format (context/decision/reasoning)
- **This step is not optional.** If context was compacted, re-read reports from disk and still execute.

---

## Action Plan (Step 10)

**File:** `docs/reports/[YYYY-MM-DD]-[project]-action-plan.md`

```markdown
# Action Plan: [Project Name]

**Generated:** [date]
**From:** Framework Launch — [Tier] deliberation
**Participants:** [list of personas who reviewed]

## Immediate Actions (do these first)
| # | Task | Owner Domain | Priority | From |
|---|------|-------------|----------|------|
| 1 | [specific, actionable task] | [Engineering/Design/etc.] | P0 | [persona who recommended it] |
| 2 | ... | ... | P0 | ... |

## Next Sprint
| # | Task | Owner Domain | Priority | From |
|---|------|-------------|----------|------|
| 1 | [task] | [domain] | P1 | [persona] |

## Backlog
| # | Task | Owner Domain | Priority | From |
|---|------|-------------|----------|------|
| 1 | [task] | [domain] | P2 | [persona] |

## Decisions Made
| # | Decision | Decided By | Rationale |
|---|----------|-----------|-----------|
| 1 | [decision] | [persona or user] | [why] |

## Risks to Watch
| Risk | Flagged By | Mitigation |
|------|-----------|------------|
| [risk] | [persona] | [plan] |

## How to Execute
To start working through this plan:
1. Open this file in Claude Code
2. Say: "Work through the action plan starting from the top"
3. Claude will execute each task, checking off as completed
```

---

## Deliberation Summary (Step 11)

**File:** `docs/reports/[YYYY-MM-DD]-[project]-summary.md`

```markdown
# Deliberation Summary: [Project Name]

**Date:** [date]
**Tier:** [Greenfield / WIP / Polish]
**Rounds:** [1-3]
**Mode:** [Interactive / Auto]
**Consensus reached:** [Yes / No — user decided]

## Participants
| Role | Persona | Report | Complaints Filed | Complaints Received |
|------|---------|--------|-----------------|-------------------|
| [role] | [persona] | [link] | [count] | [count] |

## Complaint Ledger
| # | From | To | Severity | Objection | Response | Resolution |
|---|------|----|----------|-----------|----------|------------|
| 1 | [role] | [role] | [sev] | [short] | [Accept/Modify/Overrule/Escalate] | [resolved how] |

## Key Decisions
| # | Decision | Decided By | Method |
|---|----------|-----------|--------|
| 1 | [decision] | [role or user] | [auto / complaint / escalation] |

## Unresolved Tensions
[Any disagreements that were overruled — may resurface later]

## Docs Updated
[List of project docs created or updated during this deliberation]

## Pending Board Decisions
[Fire recommendations from Jobs, if any. Each requires user approval.]

| Persona | Role | Recommendation | Replacement | Reason | Board Decision |
|---------|------|---------------|-------------|--------|---------------|
| [current person] | [role] | FIRE | [proposed replacement] | [Jobs's reason] | [PENDING / APPROVED / DENIED] |

*If approved: the persona's SKILL.md will be rewritten with the replacement's philosophy, quotes, pivotal decisions, and decision rules. The role stays — the person changes.*

## Action Plan
→ See `[date]-[project]-action-plan.md` for the full executable plan.

## One-Sentence Product
[The final one-sentence description after all reviews]
```

---

## Deliberation Log Row (Step 12)

**File:** `docs/DELIBERATION_LOG.md`

Append one row per run:

```markdown
| [Run #] | [YYYY-MM-DD] | [Tier] | [Mode] | [persona count] | [top 2-3 decisions, comma-separated] | [Buffett's health score or average dimension score] |
```

**Example after 3 runs:**
```markdown
| Run | Date | Tier | Mode | Personas | Key Decisions | Health |
|-----|------|------|------|----------|--------------|--------|
| 1 | 2026-03-24 | Greenfield | Interactive | 8 | Dark theme, Docker + Vercel, anti-slop blacklist | — |
| 2 | 2026-03-25 | WIP | Auto | 7 | Fix dead buttons, kill page-level use client, R2 pipeline | 4.8/10 |
| 3 | 2026-03-26 | WIP | Interactive | 7 | Architectural redesign, multi-page routes, server components | 5.5/10 |
```

This is the **meeting minutes index**. Any human or AI can read this file and instantly understand: how many times has this project been reviewed, what was decided each time, and is it getting better or worse?

---

## Checkpoint Files (Step 8.5)

### Complaint Ledger
**File:** `docs/reports/[YYYY-MM-DD]-[project]-complaint-ledger.md`

```markdown
# Complaint Ledger: [Project Name]
**Date:** [date]
**Rounds completed:** [1-3]

| # | From | To | Severity | Objection | Response | Resolution |
|---|------|----|----------|-----------|----------|------------|
| 1 | [role] | [role] | [sev] | [summary] | [Accept/Modify/Overrule/Escalate] | [outcome] |
```

### Session State
**File:** `docs/reports/[YYYY-MM-DD]-[project]-session-state.md`

```markdown
# Session State: [Project Name]
**Date:** [date]
**Tier:** [tier]
**Mode:** [mode]
**Rounds completed:** [count]

## Saved Report Files
- brainstorm: docs/reports/brainstorm/[filename]
- ceo: docs/reports/ceo/[filename]
- engineering: docs/reports/engineering/[filename]
- design: docs/reports/design/[filename]
- performance: docs/reports/performance/[filename]
- marketing: docs/reports/marketing/[filename]
- ai-slop: docs/reports/ai-slop/[filename]
- retrospective: docs/reports/retrospective/[filename]

## Key Decisions Made
1. [decision] — decided by [role/user]

## Fire Recommendations
[list or "None"]

## Ready for Step 9: Yes
```
