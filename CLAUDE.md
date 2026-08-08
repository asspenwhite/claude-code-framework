---
name: Claude Code Framework
type: framework
version: 1.9
---

# Claude Code Framework - AI Instructions

**Lightweight project template for Claude Code.** Plugins + MCP over custom skills, hooks for guarantees, docs for state. One custom skill: `/retro` (session retrospective).

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
| Medium | `docs/api.yaml` | When working with API endpoints |
| Medium | `docs/schema.yaml` | When working with database |

Operational projects (networks, hosts, live services) add: `docs/AS-BUILT.md`
(live state), `docs/RUNBOOK.md` (ops + gotchas), `docs/INCIDENT-*.md`
(outage reports). Templates in `docs/templates/`; role guides in `docs/playbooks/`.
Third-party model endpoint: `docs/providers/` (wrapper pattern, picker mapping, cost routing).

---

## MCP Servers

Use these tools — they're already running and provide capabilities beyond built-in tools.

| Server | Use For |
|--------|---------|
| **Obsidian** | Cross-project knowledge, hub notes, infrastructure docs |
| **context7** | Up-to-date library/framework documentation |
| **Playwright** | Visual testing, browser snapshots, E2E flows |

### Obsidian Integration

Before starting work:
1. Query the vault for existing context on this project
2. Check infrastructure notes if making infra changes
3. After significant decisions, update the project's hub note

---

## Hooks

CLAUDE.md is advisory; hooks are deterministic. Rules that must hold 100% of
the time (format-after-edit, protected paths, audit-log entries, verification
gates) live in `.claude/settings.json` hooks, not in this file. See `docs/HOOKS.md`.

Shipped active: `protect-paths.sh` (blocks Edit/Write to secrets paths).
Shipped opt-in: `docs-sync-gate.sh` (Stop gate — no turn ends with unlogged changes).

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

---

## AI Rules

<rules>
  <rule priority="1">Read docs/ before proposing solutions</rule>
  <rule priority="2">Query Obsidian vault for cross-project context</rule>
  <rule priority="3">Use context7 for library docs - training data may be stale</rule>
  <rule priority="4">Test with Playwright - verify UI works visually</rule>
  <rule priority="5">Update docs after changes — CHANGELOG always; AS-BUILT + incident report for operational changes</rule>
  <rule priority="6">Run the Check command (Quick Reference) and show its output before claiming work done</rule>
  <rule priority="7">After implementing anything non-trivial, have the adversarial-reviewer subagent attack the diff before calling it done</rule>
</rules>

<do_not_overengineer>
Only make changes that are directly requested or clearly necessary. Keep solutions simple and focused. Don't add features, refactor code, or make improvements beyond what was asked.
</do_not_overengineer>

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
| **Check command** | Define here — the one command that proves work is done (test suite, build, smoke script) |

**Status:** Feature 1 ✅ | Feature 2 ⏳
**Not built:** Feature 3, Feature 4

---

*Last updated: 2026-06-12 (v1.9 — Claude 5 era; see docs/MODEL_NOTES.md)*
