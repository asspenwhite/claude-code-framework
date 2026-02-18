---
name: Project Name
type: project-type
stack: Your Stack Here
port: 3000
---

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
**Level 3 - .claude/** (skills/agents)

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

## Skills (Auto-loaded)

### Core Skills
| Skill | Activates When |
|-------|----------------|
| `docs-safety` | Modifying TODO.md, CHANGELOG.md, any docs |
| `code-review` | Writing or modifying code files |
| `design-review` | Building UI, styling, visual work |
| `security-audit` | Auth, API routes, user data |

### Feature Skills
| Skill | Activates When |
|-------|----------------|
| `frontend-design` | UI components, styling |
| `security` | Auth flows, payments |

→ `.claude/skills/` for full skill files

---

## Agents (Manual `/command`)

| Agent | Command | Use For |
|-------|---------|---------|
| design-review | `/design-review` | UI audit |
| security-audit | `/security-audit` | Security check |
| code-review | `/code-review` | Code quality |
| docs-update | `/docs-update` | Sync docs |

→ `.claude/agents/` for full agent instructions

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
