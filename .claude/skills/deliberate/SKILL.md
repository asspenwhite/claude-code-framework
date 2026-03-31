---
name: deliberate
description: Swarm deliberation engine — each persona runs as an isolated Agent for genuine disagreement. Hub-and-spoke orchestration with complaint routing. Three tiers, interactive or auto mode.
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Agent
---

# Deliberate — Swarm Deliberation Engine

Single-context deliberation (one Claude playing all roles) produces polite consensus. Genuine isolation produces genuine disagreement. Each persona is spawned as a separate Agent with its own context window and no visibility into what others are thinking.

You (the main conversation) are the **team lead**: interview the user, spawn agents, collect reports, route complaints, update docs.

**Reference files** in `.claude/skills/deliberate/`:
- `PROMPTS.md` — Agent prompt templates (Round 1, Round 2, FIRE directive) -> Read at Steps 2, 6
- `FORMATS.md` — Report/doc/action-plan templates -> Read at Steps 4, 8.5, 9-12
- `COMPLAINTS.md` — Severity levels, auto-decision principles -> Read at Steps 5-8
- `personas/` — 8 persona files (ma, jobs, torvalds, dyson, su, atrioc, sacco, buffett)

---

## Modes

| Command | Mode | Notes |
|---------|------|-------|
| `/deliberate` | Interactive, auto-detect tier | Default |
| `/deliberate greenfield` | Interactive, Tier 1 | All 8 personas |
| `/deliberate wip` | Interactive, Tier 2 | 7 personas (skip Ma) |
| `/deliberate polish` | Interactive, Tier 3 | 5 personas |
| `/deliberate auto` | Auto, auto-detect tier | Skips interviews |
| `/deliberate auto polish` | Auto, Tier 3 | Combined |
| `/deliberate incremental` | Interactive + previous reports | Focus on changes |

---

## Three Tiers

**Tier 1: Greenfield** (nothing exists)
```
Ma -> Jobs -> [Torvalds || Dyson || Su] -> [Atrioc || Sacco] -> Buffett
```

**Tier 2: WIP** (something half-finished)
```
Jobs -> [Torvalds || Dyson || Su] -> [Atrioc || Sacco] -> Buffett
```

**Tier 3: Polish** (solid, needs refinement)
```
[Torvalds || Dyson || Su] -> Sacco -> Buffett
```

---

## Eight Personas

| Role | Persona | File | Domain |
|------|---------|------|--------|
| Brainstorm | Jack Ma | `personas/ma.md` | Demand validation, market wedge |
| CEO | Steve Jobs | `personas/jobs.md` | Scope, vision, focus -- can FIRE personas |
| Engineering | Linus Torvalds | `personas/torvalds.md` | Architecture, data structures, failure modes |
| Design | James Dyson | `personas/dyson.md` | 8-dimension design, UX, iteration |
| Performance | Lisa Su | `personas/su.md` | Bottlenecks, profiling, performance per watt |
| Marketing | Atrioc | `personas/atrioc.md` | Positioning, copy, audience |
| AI Slop | Bruno Sacco | `personas/sacco.md` | Anti-pattern detection, design tokens |
| Retrospective | Warren Buffett | `personas/buffett.md` | Deliberation close, moats, compounding lessons |

---

## Orchestration Process

### Step 0: Context Gathering

1. **Query Obsidian vault** for the project's hub note — get cross-project context, prior decisions, related infrastructure
2. **Read project files** — README, CLAUDE.md, plan/spec docs, package.json/pyproject.toml, code structure
3. **Check `docs/reports/`** for previous deliberation rounds
4. **Read living docs** — DECISIONS.md, TODO.md, ARCHITECTURE.md (institutional memory)
5. **Detect tier** from project state or user input

Prepare a **context brief** (under 500 words): what exists, what the user wants, tier, key file paths, vault context.

### Step 0.5: Scaffold Docs

On first run, create: `docs/reports/{brainstorm,ceo,engineering,design,performance,marketing,ai-slop,retrospective}`

Create missing living docs with minimal headers (DECISIONS, TODO, ARCHITECTURE, CONSTRAINTS, DESIGN, PERFORMANCE, MARKETING, LESSONS). Do NOT overwrite existing files.

Create or read `docs/DELIBERATION_LOG.md` to determine run number.

### Step 1: User Interviews (Interactive Mode Only)

Generate 2-3 questions per persona targeting gaps not already in docs. Reference something specific in the project. Batch by phase.

Each persona's file has "Question Philosophy" — the types of things they need to know. In auto mode: skip all interviews.

### Step 2: Agent Reviews (Round 1)

Spawn agents per tier using the Agent tool:
- `subagent_type: "general-purpose"`
- `run_in_background: true` for parallel agents

-> **Read `PROMPTS.md`** for agent prompt templates and spawning sequences.

### Step 3: User Check-ins (Interactive Mode)

After each batch, present key findings, verdict, complaints filed, biggest concern. User reacts before continuing.

### Step 4: Save Round 1 Reports

Save to `docs/reports/[role]/[YYYY-MM-DD]-[project]-[type].md`

-> **Read `FORMATS.md`** for report header format.

### Step 5: Parse Complaints

Build complaint ledger. No complaints = skip Round 2.

-> **Read `COMPLAINTS.md`** for severity levels and auto-decision principles.

### Step 6: Round 2 — Rebuttals

Spawn rebuttal agents in parallel for roles that received complaints.

-> **Read `PROMPTS.md`** for rebuttal prompt template.

### Step 7: Save Round 2 Reports

Save as `[filename]-round2.md`. Update complaint ledger.

### Step 8: Round 3 — User Escalation

If Block complaints remain unresolved, present both sides. User decides. Max 3 rounds.

### Step 8.5: Checkpoint (CRITICAL)

Save complaint ledger and session state to disk before synthesizing. Prevents context exhaustion.

-> **Read `FORMATS.md`** for checkpoint file formats.

### Step 9: Update Project Docs (MANDATORY)

Read all saved reports from disk. Extract Doc Contributions. Create or update living docs.

| Doc | Contributors |
|-----|-------------|
| DECISIONS.md | Jobs, Buffett |
| TODO.md | Everyone |
| CONSTRAINTS.md | Jobs, Ma, Torvalds, Su |
| ARCHITECTURE.md | Torvalds |
| DESIGN.md | Dyson, Sacco |
| PERFORMANCE.md | Su |
| MARKETING.md | Atrioc |
| MARKET.md | Ma |
| LESSONS.md | Buffett |

### Step 9.5: Update CLAUDE.md

Verify project CLAUDE.md references all living docs. Update status line. Keep under 150 lines.

### Step 10: Action Plan

-> **Read `FORMATS.md`** for template. Save to `docs/reports/[date]-[project]-action-plan.md`.

### Step 11: Summary

-> **Read `FORMATS.md`** for template. Save to `docs/reports/[date]-[project]-summary.md`.

### Step 12: Update Deliberation Log

Append row to `docs/DELIBERATION_LOG.md`. Update Obsidian vault hub note with deliberation results.

---

## Anti-Sycophancy Rules

1. No forced positives. Nothing good to say = say nothing good.
2. No "but" sandwiches. Just state the criticism.
3. No grading on a curve. Mediocre gets mediocre.
4. Praise must be earned.
5. Say the uncomfortable thing.

---

## Checklist

```
- [ ] Step 0: Vault queried, tier detected, context brief prepared
- [ ] Step 0.5: Docs scaffolded, deliberation log read
- [ ] Step 1: Interviews conducted (if interactive)
- [ ] Step 2-3: Agents spawned, user check-ins after each batch
- [ ] Step 4: Reports saved to docs/reports/[role]/
- [ ] Step 5: Complaint ledger built
- [ ] Step 6-7: Rebuttals spawned (if complaints)
- [ ] Step 8: Blocks escalated to user (if any)
- [ ] Step 8.5: Checkpoint saved
- [ ] Step 9: Living docs updated
- [ ] Step 9.5: CLAUDE.md verified
- [ ] Step 10: Action plan saved
- [ ] Step 11: Summary saved
- [ ] Step 12: Deliberation log + vault updated
```
