---
name: Claude Code Framework
type: framework
version: 1.7
---

# Claude Code Framework - AI Instructions

**Lightweight project template for Claude Code.** Plugins + MCP over custom skills. One custom skill: the deliberation engine.

---

## Constraints

<constraints critical="true">
  <budget>Define your budget constraints</budget>
  <stack>Define your stack constraints</stack>
  <principle>Key guiding principle</principle>
</constraints>

---

## Documentation

**Level 1 - This file** (summary) → **Level 2 - docs/** (detail)

| Priority | Doc | When to Read |
|----------|-----|--------------|
| High | `docs/DECISIONS.md` | Before proposing ANY solution |
| High | `docs/CHANGELOG.md` | Before modifying existing code |
| Low | `docs/CLAUDE_4_6_UPGRADE.md` | Reference for 4.6→4.7 API migration (model IDs, new features, prompting) |
| Medium | `docs/api.yaml` | When working with API endpoints |
| Medium | `docs/schema.yaml` | When working with database |

---

## MCP Servers

Use these tools — they're already running and provide capabilities beyond built-in tools.

| Server | Use For |
|--------|---------|
| **Obsidian** | Cross-project knowledge, hub notes, infrastructure docs |
| **context7** | Up-to-date library/framework documentation |
| **Playwright** | Visual testing, browser snapshots, E2E flows |
| **Figma** | Design context from real Figma files |

### Obsidian Integration

Before starting work:
1. Query the vault for existing context on this project
2. Check infrastructure notes if making infra changes
3. After significant decisions, update the project's hub note

---

## Plugins

Claude Code plugins load on-demand and are maintained upstream. Prefer these over custom skills.

| Need | Plugin |
|------|--------|
| Code quality | `code-review` |
| Security | `security-guidance` |
| Frontend design | `frontend-design` |
| PR workflow | `pr-review-toolkit` |
| Commits | `commit-commands` |
| Design review | `figma` |

---

## Deliberation Engine

Run `/deliberate` to launch the swarm deliberation. Each of 8 personas runs as an isolated Agent for genuine disagreement. Zero startup cost (`disable-model-invocation: true`) -- only loads when invoked.

| Tier | Personas | When |
|------|----------|------|
| Greenfield | 8 (Ma -> Jobs -> Torvalds/Dyson/Su -> Atrioc/Sacco -> Buffett) | New project |
| WIP | 7 (skip Ma) | Half-finished |
| Polish | 5 (Torvalds/Dyson/Su -> Sacco -> Buffett) | Almost done |

Details: `.claude/skills/deliberate/SKILL.md`

---

## AI Rules

<rules>
  <rule priority="1">Read docs/ before proposing solutions</rule>
  <rule priority="2">Query Obsidian vault for cross-project context</rule>
  <rule priority="3">Use context7 for library docs - training data may be stale</rule>
  <rule priority="4">Test with Playwright - verify UI works visually</rule>
  <rule priority="5">Update docs after changes</rule>
</rules>

<parallel_tool_calls>
If you intend to call multiple tools and there are no dependencies between them, make all independent tool calls in parallel.
</parallel_tool_calls>

<do_not_overengineer>
Only make changes that are directly requested or clearly necessary. Keep solutions simple and focused. Don't add features, refactor code, or make improvements beyond what was asked.
</do_not_overengineer>

<context_window>
Your context window will be automatically compacted as it approaches its limit. Do not stop tasks early due to context concerns.
</context_window>

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

**Status:** Feature 1 ✅ | Feature 2 ⏳
**Not built:** Feature 3, Feature 4

---

*Last updated: 2026-04-14*

---

## Proactiveness preference (asspenwhite)

Apply `<parallel_tool_calls>`, `<do_not_overengineer>`, `<context_window>` to every project's CLAUDE.md. Do NOT apply `<default_to_action>` — the preference is for Claude to confirm-then-act on ambiguous intent. See `docs/CLAUDE_4_6_UPGRADE.md` §Proactiveness Controls.
