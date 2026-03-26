# Project Name - AI Instructions

**Brief project description.** One or two sentences max.

---

## Constraints (CRITICAL)

<constraints critical="true">
  <budget>Define your budget constraints</budget>
  <stack>Define your stack constraints</stack>
  <principle>Key guiding principle</principle>
</constraints>

→ `docs/CONSTRAINTS.md` for full limits (if exists)

---

## Documentation (Progressive Disclosure)

**Level 1 - This file** (summary)
**Level 2 - docs/** (detail)
**Level 3 - .claude/** (skills, hooks)

| Priority | Doc | When to Read |
|----------|-----|--------------|
| 🔴 | `docs/CONSTRAINTS.md` | Before proposing ANY solution |
| 🔴 | `docs/REFERENCE.md` | Before modifying existing code |
| 🟡 | `docs/api.yaml` | When working with API endpoints |
| 🟡 | `docs/schema.yaml` | When working with database |
| 🟢 | `docs/MCP.md` | When testing or using tools |

---

## MCP Tools

| Server | Key Tools | Use For |
|--------|-----------|---------|
| Playwright | `browser_navigate`, `browser_snapshot` | Visual testing |
| Supabase | `execute_sql`, `apply_migration` | Database |
| Context7 | `resolve-library-id`, `query-docs` | Library docs |

→ `docs/MCP.md` for full tools and examples

---

## Hooks (Runtime Safety)

| Hook | Event | Purpose |
|------|-------|---------|
| `config-protect.sh` | PreToolUse (Write/Edit) | Warns before weakening linter configs |
| `safety-check.sh` | PreToolUse (Bash) | Warns before destructive commands |
| `quality-gate.sh` | PostToolUse (Write/Edit) | Auto-formats saved files |

→ `docs/HOOKS.md` for hook system details
→ `docs/SAFETY.md` for safety modes (careful/freeze/guard)

---

## Pipeline

```
Think → Plan → Build → Review → Test → Ship → Reflect
```

| Stage | Command | Persona |
|-------|---------|---------|
| Think | `/brainstorm` | Jack Ma |
| Plan | `/framework-launch` (swarm: 8 personas as isolated agents, interactive interviews) | Ma ↔ Jobs ↔ Torvalds ↔ Dyson ↔ Su ↔ Atrioc ↔ Sacco ↔ Buffett |
| Build | Skills auto-activate | Sacco, Su, Atrioc |
| Review | `/code-review`, `/security-audit`, `/design-review` | — |
| Test | `/qa`, `/user-flow-test`, `/accessibility` | — |
| Ship | `/ship` | — |
| Reflect | `/reflect` | Buffett |

→ `docs/PROCESS.md` for full pipeline documentation

---

## Skills (Auto-loaded)

### Core Skills
| Skill | Activates When |
|-------|----------------|
| `code-review` | Writing or modifying code files |
| `security-audit` | Auth, API routes, user data |
| `design-review` | Building UI, styling, visual work |
| `docs-safety` | Modifying TODO.md, CHANGELOG.md, any docs |
| `accessibility` | Building UI, forms, interactive elements |
| `user-flow-test` | Auth flows, checkout, multi-step processes |

### Feature Skills
| Skill | Persona | Activates When |
|-------|---------|----------------|
| `frontend-design` | Bruno Sacco | UI components, styling |
| `ai-slop-detection` | Bruno Sacco | Building UI (co-activates with frontend-design) |
| `performance` | Lisa Su | Performance optimization, bundle size |
| `marketing` | Atrioc | Writing copy, landing pages, positioning |
| `security` | — | Auth flows, payments |
| `tdd` | — | Writing tests, test-first workflows |

### Pipeline Skills
| Skill | Persona | Command |
|-------|---------|---------|
| `brainstorm` | Jack Ma | `/brainstorm` |
| `plan-review-ceo` | Steve Jobs | `/ceo-review` |
| `plan-review-eng` | Linus Torvalds | `/eng-review` |
| `plan-review-design` | James Dyson | `/design-review-plan` |
| `planner` | — | `/plan` |
| `investigation` | — | `/investigate` |
| `qa` | — | `/qa` |
| `shipping` | — | `/ship` |
| `reflect` | Warren Buffett | `/reflect` |

→ `.claude/skills/` for full skill files

---

## Commands

### Review Commands
| Command | Purpose |
|---------|---------|
| `/code-review` | Code quality with Fix-First policy |
| `/security-audit` | Security vulnerability check |
| `/design-review` | Visual UI review + AI slop grade |
| `/accessibility` | WCAG 2.1 AA compliance |
| `/user-flow-test` | End-to-end journey testing |
| `/docs-update` | Documentation sync |

### Planning Commands
| Command | Persona | Purpose |
|---------|---------|---------|
| `/brainstorm` | Jack Ma | Product discovery |
| `/ceo-review` | Steve Jobs | Scope review |
| `/eng-review` | Linus Torvalds | Architecture review |
| `/design-review-plan` | James Dyson | Design critique |

### Pipeline Commands
| Command | Purpose |
|---------|---------|
| `/plan` | Architecture planning |
| `/investigate` | Root cause debugging |
| `/marketing` | Content & positioning review |
| `/qa` | Quality assurance testing |
| `/ship` | PR + release workflow |
| `/reflect` | Session retrospective |

### Safety & Maintenance Commands
| Command | Purpose |
|---------|---------|
| `/careful` | Toggle destructive command warnings |
| `/freeze <dir>` | Restrict edits to one directory |
| `/guard <dir>` | Both careful + freeze |
| `/unfreeze` | Clear all safety modes |
| `/update-framework` | Sync global install from source repo or GitHub |

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

→ `docs/REFERENCE.md` for full gotchas

---

## Quick Reference

| Item | Value |
|------|-------|
| Port | 3000 |
| Stack | Define here |
| Database | Define here |

**Status:** Feature 1 ✅ | Feature 2 ✅ | Feature 3 ⏳
**Not built:** Feature 4, Feature 5

---

*Last updated: DATE*
