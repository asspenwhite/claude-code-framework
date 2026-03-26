# Claude Code Framework - AI Instructions

**Team simulation framework for Claude Code.** 8 department-head personas that review, argue, and push back via isolated agents.

---

## Constraints (CRITICAL)

<constraints critical="true">
  <budget>Zero dependencies — pure markdown + 4 shell scripts</budget>
  <stack>Markdown skills + bash hooks. No npm, no build steps, no runtime.</stack>
  <principle>Genuine agent isolation produces genuine disagreement. No single-context deliberation.</principle>
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
| 🔴 | `docs/ARCHITECTURE.md` | Before modifying framework structure |
| 🟡 | `docs/DECISIONS.md` | Before making scope changes |
| 🟡 | `docs/TODO.md` | Before starting new work |
| 🟢 | `docs/PROCESS.md` | For full 7-stage pipeline details |
| 🟢 | `docs/HOOKS.md` | When modifying hook system |
| 🟢 | `docs/SAFETY.md` | When modifying safety modes |

---

## Pipeline

```
Think → Plan → Build → Review → Test → Ship → Reflect
```

| Stage | Command | Persona |
|-------|---------|---------|
| Think | `/brainstorm` | Jack Ma |
| Plan | `/framework-launch` | 8 personas as isolated agents |
| Build | Skills auto-activate | Sacco, Su, Atrioc |
| Review | `/code-review`, `/security-audit`, `/design-review` | — |
| Test | `/qa`, `/user-flow-test`, `/accessibility` | — |
| Ship | `/ship` | — |
| Reflect | `/reflect` | Buffett |

→ `docs/PROCESS.md` for full pipeline details

---

## Key Commands

| Command | Purpose |
|---------|---------|
| `/framework-launch` | Full team review — 8 personas argue until consensus |
| `/framework-launch auto` | Same but skips user interviews |
| `/framework-launch incremental` | Follow-up — personas see their previous reports |
| `/code-review` | Code quality with Fix-First policy |
| `/security-audit` | Security vulnerability check |
| `/design-review` | Visual UI review + AI slop grade |
| `/ship` | Quality gates → version bump → PR |
| `/reflect` | Session retrospective |
| `/update-framework` | Sync global install from source repo |

→ `.claude/commands/` for all 21 commands

---

## AI Rules

<rules>
  <rule priority="1">Use progressive disclosure - Read 🔴 docs before proposing solutions</rule>
  <rule priority="2">Skills auto-apply - Don't skip guardrails</rule>
  <rule priority="3">Update docs - Keep documentation current</rule>
  <rule priority="4">Never delete history - Mark items done, don't remove</rule>
</rules>

<parallel_tool_calls>
If you intend to call multiple tools and there are no dependencies between them, make all independent tool calls in parallel. Maximize parallel tool calls for speed and efficiency.
</parallel_tool_calls>

<do_not_overengineer>
Only make changes that are directly requested or clearly necessary. Keep solutions simple and focused. Don't add features, refactor code, or make improvements beyond what was asked.
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
  <gotcha context="skills">SKILL.md is the orchestration — PROMPTS.md, FORMATS.md, COMPLAINTS.md are read just-in-time</gotcha>
  <gotcha context="install">Global install at ~/.claude/skills/ and ~/.claude/commands/ — /update-framework syncs</gotcha>
</gotchas>

---

## Quick Reference

| Item | Value |
|------|-------|
| Version | 3.1.2 |
| Personas | 8 (Ma, Jobs, Torvalds, Dyson, Su, Atrioc, Sacco, Buffett) |
| Skills | 23 across 3 modes (auto, review, teammate) |
| Commands | 21 slash commands |
| Hooks | 3 (config-protect, safety-check, quality-gate) |

**Status:** Swarm deliberation ✅ | Interactive interviews ✅ | Incremental mode ✅ | Doc generation ✅ | Context checkpoint ✅
**Not built:** Deploy pipeline, autonomous loop mode, cross-model deliberation

---

*Last updated: 2026-03-25*
