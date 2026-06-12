# Claude Code Framework

A lightweight project template for [Claude Code](https://code.claude.com/docs) — documentation structure, AI rules, working hooks, and battle-tested playbooks for running Claude Code as an operator, not just a coding assistant.

[![Use this template](https://img.shields.io/badge/Use%20this%20template-238636?style=for-the-badge&logo=github&logoColor=white)](https://github.com/asspenwhite/claude-code-framework/generate)

---

## Apply to a Project

Open Claude Code in any project and say:

```
Apply the claude-code-framework from https://github.com/asspenwhite/claude-code-framework to this project.
```

Claude will clone the framework, copy `CLAUDE.md` + `docs/` + `.claude/` into your project, and customize for your stack (it will ask for project name, description, and tech stack).

### Manual setup

```bash
cd /path/to/your/project
git clone --depth 1 https://github.com/asspenwhite/claude-code-framework.git temp
cp temp/CLAUDE.md ./
cp -r temp/docs temp/.claude ./
rm -rf temp
claude
```

### Operating a system (network, hypervisor, live service)

Read `docs/playbooks/README.md`, pick the playbook nearest your role, and ask Claude to bootstrap the workspace from it — starting read-only: snapshot state, write the AS-BUILT, then plan.

---

## What You Get

- **Progressive disclosure** -- Claude reads what it needs when it needs it
- **Working hooks, active on clone** -- secrets-path protection now, audit-log Stop gate opt-in. CLAUDE.md for guidance, hooks for guarantees
- **A verification loop** -- a named Check command + an adversarial-reviewer subagent that attacks the diff in fresh context before work is called done
- **A self-improvement loop** -- `/retro` harvests session corrections into hooks, CLAUDE.md lines, and docs, so the setup compounds
- **MCP integration** -- points Claude to Obsidian, context7, Playwright
- **Plugin-first** -- uses official Claude Code plugins instead of custom skills
- **Doc templates** -- CHANGELOG, TODO, DECISIONS, API, SCHEMA — plus ops templates: INCIDENT, AS-BUILT, RUNBOOK
- **Role playbooks** -- network admin, virtualization admin, SaaS operator, knowledge base — distilled from daily production use

This is intentionally minimal. The real power comes from Claude Code's plugin ecosystem, MCP servers, and hooks — not static markdown files.

---

## Beyond Coding: The Playbooks

Claude Code runs real systems well when you give it an operating contract. These playbooks are how this framework is actually used day-to-day — genericized for public consumption:

| Playbook | Role |
|----------|------|
| [`docs/playbooks/NETWORK_ADMIN.md`](docs/playbooks/NETWORK_ADMIN.md) | Network administrator (UniFi-style controller APIs, VLAN work, firewall policy) |
| [`docs/playbooks/VIRTUALIZATION_ADMIN.md`](docs/playbooks/VIRTUALIZATION_ADMIN.md) | Proxmox / hypervisor / homelab admin (VMs, GPU passthrough, Docker stacks) |
| [`docs/playbooks/SAAS_OPERATOR.md`](docs/playbooks/SAAS_OPERATOR.md) | Website / SaaS operator (sprint loop with adversarial review, ADRs, launch gates) |
| [`docs/playbooks/KNOWLEDGE_BASE.md`](docs/playbooks/KNOWLEDGE_BASE.md) | Knowledge-base maintainer (Obsidian vault as Claude's cross-project memory) |

Shared doctrine: a repo per system · AS-BUILT vs DRAFT-plan separation · append-only audit CHANGELOG · read-only by default · same-day incident reports. Details in [`docs/playbooks/README.md`](docs/playbooks/README.md).

---

## Hooks: Guarantees, Not Guidance

CLAUDE.md instructions are advisory — followed most of the time. Hooks are deterministic — every time. Anything that must happen without exception (lint after edit, protected paths, audit-log entries, verification gates) belongs in a hook. [`docs/HOOKS.md`](docs/HOOKS.md) covers the events that matter, exit-code semantics, five starter recipes, and lessons from running hooks in production (including why over-hooking backfires).

---

## Recommended Plugins

Install from the official marketplace. These load on-demand -- no startup cost.

```
/plugin install code-review@claude-plugins-official
/plugin install security-guidance@claude-plugins-official
/plugin install frontend-design@claude-plugins-official
/plugin install pr-review-toolkit@claude-plugins-official
/plugin install commit-commands@claude-plugins-official
```

Or browse interactively with `/plugin`. All five names verified against the [official marketplace](https://github.com/anthropics/claude-plugins-official) (June 2026).

---

## Recommended MCP Servers

These give Claude capabilities its built-in tools can't match.

```bash
# Up-to-date library docs (React, Next.js, Prisma, etc.)
claude mcp add context7 -- npx -y @upstash/context7-mcp

# Browser control for visual testing
claude mcp add playwright -- npx @playwright/mcp@latest

# Obsidian vault for cross-project knowledge (if you use Obsidian)
# See: https://github.com/MarkusPfundstein/mcp-obsidian
```

Setup details: [`docs/MCP.md`](docs/MCP.md)

---

## What's Included

```
CLAUDE.md                          -- AI instructions template (customize this)
.claude/
  settings.json                    -- hook wiring (protect-paths active on clone)
  hooks/
    protect-paths.sh               -- PreToolUse: blocks Edit/Write to secrets paths (ACTIVE)
    docs-sync-gate.sh              -- Stop: no turn ends with unlogged changes (opt-in)
  agents/
    adversarial-reviewer.md        -- fresh-context diff attacker (subagent)
  skills/
    retro/SKILL.md                 -- /retro: harvest session corrections into durable config
docs/
  ARCHITECTURE.md                  -- How progressive disclosure works
  WORKFLOW.md                      -- Documentation workflow guide
  HOOKS.md                         -- Deterministic guarantees: events, recipes, lessons
  MODEL_NOTES.md                   -- Claude 5 / Opus 4.8 era notes, proactiveness controls, migration
  MCP.md                           -- MCP server setup guide
  FILE_FORMATS.md                  -- Token-efficient format guidelines
  CLAUDE.md.example                -- Full CLAUDE.md example
  playbooks/                       -- Role playbooks (network, virtualization, SaaS, knowledge base)
  templates/                       -- Doc templates (CHANGELOG, TODO, DECISIONS, INCIDENT, AS-BUILT, RUNBOOK, ...)
```

### /retro — The Compounding Loop

The one custom skill. Run it at the end of a session: it harvests corrections, repeated friction, and hard-won discoveries, routes each to its durable home (a hook if it must hold 100% of the time, a CLAUDE.md line if it needs judgment, docs if it's project fact), and prunes CLAUDE.md so it never bloats. Your setup gets better every session instead of staying static.

---

## Philosophy

1. **Plugins over skills.** Official plugins are maintained upstream, load on-demand, and don't bloat your context window. Don't reinvent them as markdown files.
2. **MCP over static knowledge.** A running Obsidian vault or context7 server has live data. A SKILL.md has stale data.
3. **Hooks over repetition.** If a CLAUDE.md rule keeps getting violated, don't write it louder — make it a hook and delete the prose.
4. **Less is more.** Every line in CLAUDE.md costs context tokens. Keep it short, point to docs/ for detail.
5. **If it changed, log it. If it broke, write the incident.** The audit CHANGELOG and incident corpus become institutional memory Claude reads on demand.
6. **Templates over prescriptions.** This framework gives you structure. You fill in the content.

---

## Model-Era Notes

v1.9 is tuned for the Claude 5 era (Fable 5 / Opus 4.8). What carried over from earlier model generations, what was retired (including the old adaptive-thinking client patch — do not apply it anymore), proactiveness controls, and a migration checklist: [`docs/MODEL_NOTES.md`](docs/MODEL_NOTES.md).

---

## License

MIT
