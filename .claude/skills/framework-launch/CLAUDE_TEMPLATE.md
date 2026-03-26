# Project Name - AI Instructions

**Brief project description.** One or two sentences max.

---

## Constraints (CRITICAL)

<constraints critical="true">
  <budget>Define your budget constraints</budget>
  <stack>Define your stack constraints</stack>
  <principle>Key guiding principle</principle>
</constraints>

→ `docs/CONSTRAINTS.md` for full limits

---

## Documentation (Progressive Disclosure)

**Level 1 - This file** (summary)
**Level 2 - docs/** (detail)
**Level 3 - .claude/** (skills, hooks)

| Priority | Doc | When to Read |
|----------|-----|--------------|
| 🔴 | `docs/CONSTRAINTS.md` | Before proposing ANY solution |
| 🔴 | `docs/ARCHITECTURE.md` | Before modifying code structure |
| 🟡 | `docs/DECISIONS.md` | Before making scope changes |
| 🟡 | `docs/TODO.md` | Before starting new work |
| 🟡 | `docs/DESIGN.md` | Before building UI |
| 🟡 | `docs/PERFORMANCE.md` | Before optimizing |
| 🟢 | `docs/MARKETING.md` | Before writing copy |
| 🟢 | `docs/LESSONS.md` | After completing work |
| 🟢 | `docs/DELIBERATION_LOG.md` | To see project review history |

---

## Pipeline

```
Think → Plan → Build → Review → Test → Ship → Reflect
```

| Stage | Command |
|-------|---------|
| Think | `/brainstorm` |
| Plan | `/framework-launch` |
| Review | `/code-review`, `/security-audit`, `/design-review` |
| Test | `/qa`, `/user-flow-test`, `/accessibility` |
| Ship | `/ship` |
| Reflect | `/reflect` |

→ `docs/PROCESS.md` for full pipeline details

---

## AI Rules

<rules>
  <rule priority="1">Use progressive disclosure - Read 🔴 docs before proposing solutions</rule>
  <rule priority="2">Skills auto-apply - Don't skip guardrails</rule>
  <rule priority="3">Test with Playwright - Verify UI works</rule>
  <rule priority="4">Update docs - Keep documentation current</rule>
  <rule priority="5">Never delete history - Mark items done, don't remove</rule>
</rules>

<parallel_tool_calls>
If you intend to call multiple tools and there are no dependencies between them, make all independent tool calls in parallel. Maximize parallel tool calls for speed and efficiency.
</parallel_tool_calls>

<do_not_overengineer>
Only make changes that are directly requested or clearly necessary. Keep solutions simple and focused. Don't add features, refactor code, or make improvements beyond what was asked. Don't add comments, docstrings, or type annotations to code you didn't change.
</do_not_overengineer>

<context_window>
Your context window will be automatically compacted as it approaches its limit, allowing you to continue working indefinitely. Do not stop tasks early due to context concerns.
</context_window>

<strategic_compaction>
Compact at phase transitions (Think→Plan, Plan→Build, Build→Review, etc.), not at 95% capacity. Preserve: decisions made, current file list, blockers, next steps. Never compact mid-implementation.
</strategic_compaction>

---

## Key Gotchas

<gotchas>
  <gotcha context="docs">Never delete completed items - mark as [x]</gotcha>
  <gotcha context="docs">Add to existing sections - don't create parallel structures</gotcha>
  <gotcha context="data">Ask before flagging real data as placeholder</gotcha>
</gotchas>

---

## Quick Reference

| Item | Value |
|------|-------|
| Port | 3000 |
| Stack | Define here |
| Database | Define here |

**Status:** Feature 1 ⏳ | Feature 2 ⏳
**Not built:** Feature 3, Feature 4

---

*Last updated: DATE*
