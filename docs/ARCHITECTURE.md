# Architecture

The framework uses a **3-layer unified architecture** with a **7-stage pipeline**.

---

## Three Layers

```
┌─────────────────────────────────────────────────────────────┐
│ Layer 1: Hooks (Runtime Safety)                              │
│                                                              │
│ Shell scripts triggered by Claude Code events.               │
│ PreToolUse, PostToolUse — block, warn, or auto-fix.         │
│                                                              │
│ config-protect.sh → safety-check.sh → quality-gate.sh       │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ Layer 2: Skills (Prevention + Review)                        │
│                                                              │
│ 22 unified skills. Each works in two modes:                  │
│ • Auto-activate: Core rules load when task matches           │
│ • Review mode: Full audit via /command invocation             │
│                                                              │
│ 8 personas shape judgment (Jobs, Torvalds, Sacco, etc.)     │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ Layer 3: Commands (Slash Interface)                          │
│                                                              │
│ /command files that invoke skills in Review Mode.            │
│ Human-readable triggers for complex workflows.               │
│                                                              │
│ /ship, /investigate, /ceo-review, /qa, /reflect, etc.       │
└─────────────────────────────────────────────────────────────┘
```

---

## Unified Skills (No Agents)

Every skill is a single `SKILL.md` file that handles both prevention and review:

```markdown
---
name: skill-name
description: When this skill should activate
activates_when: specific triggers
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Skill Name

## Core Rules (auto-activate)
Quick patterns that apply during creation.

## Checklist
- [ ] Verifiable completion criteria

---

## Review Mode (/command-name)
Full checklist for comprehensive audits.

## Teammate Mode (Swarm Deliberation)
Instructions for when this persona is spawned as an isolated agent in /autoplan.
```

### Why Unified?

The old architecture had separate Skills (prevention) and Agents (review). This created:
- Duplicate content between skill and agent files
- Confusion about which to edit
- Commands pointing to agents instead of skills

Unified skills: one file, three modes, no duplication.

### Teammate Mode

Five deliberation personas (Jobs, Torvalds, Dyson, Ma, Atrioc) include a **Teammate Mode** section. This tells the persona how to behave when spawned as an isolated Agent during `/autoplan`:
- What context to expect from the team lead
- How to file complaints against other roles
- How to respond to complaints in Round 2
- Which pivotal decisions to cite when overruling

---

## Progressive Disclosure

Skills load in 3 levels to save tokens:

| Level | What Loads | When |
|-------|-----------|------|
| **1. Metadata** (~100 tokens) | Name, description, activates_when | Always (startup) |
| **2. SKILL.md body** (<500 lines) | Core rules, checklist, review mode | When task matches |
| **3. Reference files** (unlimited) | TYPOGRAPHY.md, PATTERNS.md, etc. | When specifically needed |

50-80% token savings vs loading everything upfront.

---

## Pipeline

7 stages. Skip stages for small changes.

```
Think → Plan → Build → Review → Test → Ship → Reflect
```

| Stage | Skills | Personas |
|-------|--------|----------|
| **Think** | brainstorm | Jack Ma |
| **Plan** | plan-review-ceo, plan-review-eng, plan-review-design | Jobs, Torvalds, Dyson |
| **Build** | code-review, security-audit, frontend-design, ai-slop-detection, performance, marketing, tdd, accessibility | Sacco, Su, Atrioc |
| **Review** | code-review, security-audit, design-review | — |
| **Test** | qa, user-flow-test, accessibility | — |
| **Ship** | shipping | — |
| **Reflect** | reflect | Buffett |

See [PROCESS.md](PROCESS.md) for full pipeline documentation.

---

## Hooks

Shell scripts that run on Claude Code events. Exit codes: 0=allow, 1=block, 2=warn.

| Hook | Event | Purpose |
|------|-------|---------|
| `config-protect.sh` | PreToolUse (Write/Edit) | Warns before weakening linter configs |
| `safety-check.sh` | PreToolUse (Bash) | Warns before destructive commands |
| `quality-gate.sh` | PostToolUse (Write/Edit) | Auto-formats saved files |
| `diff-scope.sh` | Utility | Lists changed files vs base branch |

See [HOOKS.md](HOOKS.md) for all 7 hook events and writing custom hooks.

---

## Persona System

8 legendary figures voice key skills. The persona shapes the skill's philosophy, judgment calls, and tone — not as roleplay, but as a decision-making framework.

```
Think:    Jack Ma (brainstorm)
Plan:     Steve Jobs (CEO) → Linus Torvalds (eng) → James Dyson (design)
Build:    Bruno Sacco (frontend/slop) → Lisa Su (performance) → Atrioc (marketing)
Reflect:  Warren Buffett (retrospective)
```

### Swarm Deliberation

During `/autoplan`, 5 deliberation personas (Ma, Jobs, Torvalds, Dyson, Atrioc) run as **separate Claude instances** via the Agent tool. Each gets its own context window loaded only with its persona's SKILL.md and the project context. This isolation is the key innovation:

- **Single-context** (old): One Claude plays all roles → polite consensus, agrees with itself
- **Swarm** (current): Each persona in its own context → genuine disagreement, real pushback

```
Team Lead (main context)
    ├── Agent("ma-brainstorm")      ← own context, own philosophy
    ├── Agent("jobs-ceo")           ← can't see what Torvalds thinks
    ├── Agent("torvalds-eng")       ← can't see what Dyson thinks
    ├── Agent("dyson-design")       ← genuine isolation
    └── Agent("atrioc-marketing")   ← reads all reports last
```

Complaints route through the team lead. The agents never communicate directly. This hub-and-spoke model ensures the team lead controls information flow and can present disagreements cleanly to the user.

---

## Contexts

Three modes activated by task type. See [CONTEXTS.md](CONTEXTS.md).

| Context | Behavior | Priority Skills |
|---------|----------|----------------|
| **Dev** | Build first, minimal questions, proactive changes | code-review, frontend-design, security |
| **Research** | Read first, understand before acting, conservative | investigation, planner |
| **Review** | Quality focus, checklist-driven, report findings | qa, security-audit, design-review |

---

## Safety Modes

Three modes enforced by `safety-check.sh` hook:

| Mode | Command | Behavior |
|------|---------|----------|
| **Careful** | `/careful` | Warns before destructive commands |
| **Freeze** | `/freeze <dir>` | Blocks edits outside directory |
| **Guard** | `/guard <dir>` | Both careful + freeze |

See [SAFETY.md](SAFETY.md) for configuration.

---

## Strategic Compaction

Compact context at **phase transitions**, not at 95% capacity.

- Compact between Think→Plan, Plan→Build, Build→Review, etc.
- Preserve: decisions made, current file list, blockers, next steps
- Never compact mid-implementation

See [STRATEGIC_COMPACTION.md](STRATEGIC_COMPACTION.md).

---

## File Formats

Choose formats for token efficiency:

| Format | Best For | Token Cost |
|--------|----------|-----------|
| **YAML** | Schemas, configs, APIs | Most efficient |
| **Markdown** | Docs, skills, plans | Good (headings aid navigation) |
| **XML** | Constraints, rules | Claude-optimized |
| **JSON** | Settings only | Least efficient (~30% overhead) |

See [FILE_FORMATS.md](FILE_FORMATS.md).
