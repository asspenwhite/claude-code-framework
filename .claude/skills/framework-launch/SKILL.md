---
name: framework-launch
description: Swarm deliberation engine. Each persona runs as a separate Claude instance via Agent tool for genuine isolation. Interactive user interviews, hub-and-spoke orchestration with complaint routing, actionable plans. Eight personas across three tiers.
activates_when: auto review, run all reviews, framework launch, review pipeline, full plan review, deliberate
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Agent
---

# Framework Launch - Swarm Deliberation Engine

Not a linear pipeline. A **swarm** where each persona runs in its own context.

Single-context deliberation (one Claude playing all roles) produces polite consensus. Genuine isolation produces genuine disagreement. Each persona is spawned as a separate Agent with its own context window, its own copy of the persona's philosophy, and no visibility into what the other personas are thinking.

The **team lead** (you, the main conversation) orchestrates: interviewing the user, spawning agents, collecting reports, routing complaints, updating docs, and generating actionable plans.

**Reference files** — in this same directory (`.claude/skills/framework-launch/`). **You MUST Read these files** at the steps indicated. Do not guess the contents from memory.
- `PROMPTS.md` — Agent prompt templates for Round 1 reviews, Round 2 rebuttals, incremental mode, FIRE directive → Read at Steps 2, 6
- `FORMATS.md` — Output format templates for reports, docs, action plans, summaries, checkpoints → Read at Steps 4, 8.5, 9-12
- `COMPLAINTS.md` — Complaint system reference: severity levels, response types, auto-decision principles, argument patterns → Read at Steps 5-8

---

## Modes

### Interactive Mode (Default)

Before each batch, present interview questions. After agents return, show findings and user reacts.

```
/framework-launch              → Interactive, tier auto-detected
/framework-launch greenfield   → Interactive, Tier 1
/framework-launch wip          → Interactive, Tier 2
/framework-launch polish       → Interactive, Tier 3
```

### Auto Mode

Skips user interviews. Agents review with context brief only.

```
/framework-launch auto         → Auto, tier auto-detected
/framework-launch auto polish  → Auto, Tier 3
```

### Incremental Mode

Feeds previous reports as context. Each persona focuses on what changed, improved, or regressed.

```
/framework-launch incremental        → Interactive + previous reports
/framework-launch auto incremental   → Auto + previous reports
```

→ Read `.claude/skills/framework-launch/PROMPTS.md` for the incremental mode agent prompt addition.

---

## Architecture

```
Team Lead (main conversation — you)
    │
    ├── INTERVIEW → spawn Agent("ma-brainstorm") → user reacts
    ├── INTERVIEW → spawn Agent("jobs-ceo") → user reacts
    ├── INTERVIEW → spawn [torvalds ∥ dyson ∥ su] → user reacts
    ├── INTERVIEW → spawn [atrioc ∥ sacco] → user reacts
    ├── INTERVIEW → spawn Agent("buffett-retro")
    │
    ▼
    Collect reports → parse complaints → save to docs/reports/
    ├── Round 2: Rebuttal agents (parallel)
    ├── Round 3: User escalation (if Blocks remain)
    ▼
    Checkpoint → update docs → action plan → summary → deliberation log
```

**Key principles:**
- Agents return text. You save files. You route complaints.
- **No sugar coating.** Every persona is brutally honest.
- The user is a co-founder in the boardroom, not a report recipient.

---

## Eight Personas

| Role | Persona | Skill File | Domain |
|------|---------|-----------|--------|
| Brainstorm | Jack Ma | `brainstorm/SKILL.md` | Demand validation, market wedge |
| CEO | Steve Jobs | `plan-review-ceo/SKILL.md` | Scope, vision, focus — **can fire personas** |
| Engineering | Linus Torvalds | `plan-review-eng/SKILL.md` | Architecture, data structures, failure modes |
| Design | James Dyson | `plan-review-design/SKILL.md` | 8-dimension design, UX, iteration |
| Performance | Lisa Su | `performance/SKILL.md` | Core Web Vitals, bottlenecks, optimization |
| Marketing | Atrioc | `marketing/SKILL.md` | Positioning, copy, audience |
| AI Slop | Bruno Sacco | `ai-slop-detection/SKILL.md` | Anti-pattern detection, taste grading |
| Retrospective | Warren Buffett | `reflect/SKILL.md` | Deliberation close, compounding lessons |

→ Read `.claude/skills/framework-launch/COMPLAINTS.md` for the FIRE mechanic details and argument patterns.

---

## Three Tiers

Detect automatically from project state, or user specifies.

### Tier 1: Greenfield (nothing exists)
**Trigger:** No plan file, no codebase, or user says "new idea" / "starting fresh"

```
Ma → Jobs → [Torvalds ∥ Dyson ∥ Su] → [Atrioc ∥ Sacco] → Buffett
```

All 8 roles. Ma validates demand. Jobs scopes (and may fire). Torvalds, Dyson, Su in parallel. Atrioc and Sacco in parallel. Buffett closes.

### Tier 2: WIP (something half-finished)
**Trigger:** Existing plan file, partial codebase, or user says "review this"

```
Jobs → [Torvalds ∥ Dyson ∥ Su] → [Atrioc ∥ Sacco] → Buffett
```

Skip brainstorm. Demand assumed. 7 roles.

### Tier 3: Polish (solid, needs refinement)
**Trigger:** Mature codebase, or user says "polish" / "refine" / "almost done"

```
[Torvalds ∥ Dyson ∥ Su] → Sacco → Buffett
```

No scope changes. Engineering, design, performance, and taste only. 5 roles.

---

## Orchestration Process

### Step 0: Context Gathering

Before spawning any agents, gather:

1. **Project state** — Read key files: README, plan/spec docs, package.json/pyproject.toml, code structure
2. **User's request** — What the user asked for or described
3. **Existing reports** — Check `docs/reports/` for previous deliberation rounds
4. **Existing living docs** — Read `docs/DECISIONS.md`, `docs/TODO.md`, `docs/ARCHITECTURE.md`, etc. — institutional memory from previous runs
5. **Tier detection** — Greenfield / WIP / Polish based on project state or user input

Prepare a **context brief** (under 500 words): what exists, what the user wants, tier and why, key file paths, summary of living docs.

### Step 0.5: Scaffold Docs Structure

**On first run**, create the docs scaffold:

```bash
mkdir -p docs/reports/{brainstorm,ceo,engineering,design,performance,marketing,ai-slop,qa,security,retrospective,incidents}
```

**Create missing living docs** with minimal headers:

| File | Header |
|------|--------|
| `docs/DECISIONS.md` | `# Decisions` |
| `docs/TODO.md` | `# TODO\n\n## High Priority\n\n## Medium Priority\n\n## Low Priority` |
| `docs/ARCHITECTURE.md` | `# Architecture` |
| `docs/CONSTRAINTS.md` | `# Constraints` |
| `docs/DESIGN.md` | `# Design System` |
| `docs/PERFORMANCE.md` | `# Performance` |
| `docs/MARKETING.md` | `# Marketing` |
| `docs/LESSONS.md` | `# Lessons` |

Do NOT create `docs/MARKET.md` unless Ma is in the tier. Do NOT overwrite existing files.

**Create or read `docs/DELIBERATION_LOG.md`** — the run history. If it doesn't exist, create with header. If it exists, read to determine run number (existing rows + 1), previous health, and previous decisions. Include run number in the context brief.

### Step 1: User Interviews (Interactive Mode Only)

**Questions are generated per-project, not hardcoded.** Read project context and generate 2-3 questions per persona targeting gaps — things NOT already documented.

**Rules:**
- Questions MUST reference something specific in the project
- Questions MUST target gaps the persona can't figure out from code
- If a previous persona's interview already answered something, don't re-ask
- Fewer sharp questions > many generic ones
- Batch by phase — ask each batch right before those personas run

**Each persona's SKILL.md has "Question Philosophy"** — the types of things they care about:

| Persona | What They Need To Know |
|---------|----------------------|
| Ma | Who actually wants this, what they do without it |
| Jobs | What's in/out, whether the vision is sharp |
| Torvalds | Why things were built this way, where it breaks |
| Dyson | What the user experiences, iteration count |
| Su | What's slow, what matters, what's measured |
| Atrioc | Who's buying, how it's different |
| Sacco | Whether design has a point of view |
| Buffett | What could kill this, what's worth protecting |

**In auto mode:** Skip all interviews.

### Step 2: Agent Reviews (Round 1)

Spawn agents per tier dependency chain using the Agent tool:
- `subagent_type: "general-purpose"`
- `run_in_background: true` for parallel agents
- NO `isolation: "worktree"`

→ **Read `.claude/skills/framework-launch/PROMPTS.md`** for agent prompt templates, Jobs FIRE directive, and spawning sequences by tier.

### Step 3: User Check-ins (Interactive Mode)

After each batch returns, present key findings:

```
## [Persona] just reviewed. Key findings:
**Verdict:** [one-line summary]
**Complaints filed:** [list or "None"]
**Biggest concern:** [the #1 issue]

Any thoughts before we continue?
```

User can react, continue, or override complaints.

### Step 4: Save Round 1 Reports

Save each report to `docs/reports/[role]/[YYYY-MM-DD]-[project]-[type].md`

→ **Read `.claude/skills/framework-launch/FORMATS.md`** for the report header format. Detect run number by counting existing reports for this role.

### Step 5: Parse Complaints

Build a complaint ledger from all reports. If no complaints: skip Round 2.

→ **Read `.claude/skills/framework-launch/COMPLAINTS.md`** for severity levels and auto-decision principles.

### Step 6: Round 2 — Rebuttals

Spawn rebuttal agents in parallel for each role that received complaints.

→ **Read `.claude/skills/framework-launch/PROMPTS.md`** for the rebuttal prompt template.

### Step 7: Save Round 2 Reports

Save as: `docs/reports/[role]/[YYYY-MM-DD]-[project]-[type]-round2.md`. Update complaint ledger with responses.

### Step 8: Round 3 — User Escalation (if needed)

If any **Block** complaints remain unresolved, present both sides to the user. User decides. Max 3 rounds — the user is the tiebreaker.

### Step 8.5: Checkpoint Before Synthesis (CRITICAL)

**Prevents context exhaustion.** By this point, ~170-190k tokens have accumulated. Save everything to disk before synthesizing.

1. **Save complaint ledger** to `docs/reports/[YYYY-MM-DD]-[project]-complaint-ledger.md`
2. **Save session state** to `docs/reports/[YYYY-MM-DD]-[project]-session-state.md`
3. **Announce checkpoint** to user

→ **Read `.claude/skills/framework-launch/FORMATS.md`** for checkpoint file formats.

**After compaction recovery:** Check for session-state file. If it says "Ready for Step 9: Yes", read all reports from disk and continue from Step 9.

### Step 9: Update Project Docs (MANDATORY — Read From Disk)

**This step MUST execute.** Reports without doc updates are snapshots nobody reads. Living docs are institutional memory that compounds.

1. **Read all saved reports from disk** — do NOT rely on context memory
2. **Extract Doc Contributions** from each report's `### Doc Contributions` section
3. **Create or update** each doc:

| Doc File | Who Contributes | What Goes In |
|----------|----------------|-------------|
| `docs/DECISIONS.md` | Jobs, Buffett | Scope decisions with rationale |
| `docs/TODO.md` | Everyone | Action items, prioritized |
| `docs/CONSTRAINTS.md` | Jobs, Ma, Torvalds, Su | Budget, technical, performance limits |
| `docs/ARCHITECTURE.md` | Torvalds | Architecture decisions, data models, failure modes |
| `docs/DESIGN.md` | Dyson, Sacco | Component specs, design tokens, anti-patterns |
| `docs/PERFORMANCE.md` | Su | Baselines, targets, optimization priorities |
| `docs/MARKETING.md` | Atrioc | Audience, positioning, messaging |
| `docs/MARKET.md` | Ma | Demand validation, competitive landscape |
| `docs/LESSONS.md` | Buffett | Compounding lessons |

4. If file doesn't exist: create using template. If exists: append dated section.
5. Header new sections: `## Deliberation: [YYYY-MM-DD] ([Tier] — [Mode])`

→ **Read `.claude/skills/framework-launch/FORMATS.md`** for doc creation templates.

### Step 9.5: Verify and Update CLAUDE.md

The project's CLAUDE.md is the entry point for every future Claude session. It must follow the framework's template structure and stay under **150 lines**.

**If no CLAUDE.md exists:** Create one using the framework's template at `.claude/skills/framework-launch/CLAUDE_TEMPLATE.md`. This template defines the mandatory structure.

**If CLAUDE.md exists:** Verify and fix these mandatory sections (from v1):

1. **`<constraints critical="true">`** — XML constraints block at the top. Must exist with project-specific budget, stack, and principle values.
2. **Progressive Disclosure table** — 3 levels (this file → docs/ → .claude/) with 🔴/🟡/🟢 priority docs. Add any living docs from Step 9 that aren't listed:

| Doc | Priority | When to Read |
|-----|----------|-------------|
| CONSTRAINTS.md | 🔴 | Before proposing ANY solution |
| ARCHITECTURE.md | 🔴 | Before modifying code structure |
| DECISIONS.md | 🟡 | Before making scope changes |
| TODO.md | 🟡 | Before starting new work |
| DESIGN.md | 🟡 | Before building UI |
| PERFORMANCE.md | 🟡 | Before optimizing |
| MARKETING.md | 🟢 | Before writing copy |
| LESSONS.md | 🟢 | After completing work |
| DELIBERATION_LOG.md | 🟢 | To see project review history |

3. **`<rules>`** — XML rules block with priority-ordered rules
4. **`<do_not_overengineer>`** — Must exist. Prevents scope creep between runs.
5. **`<context_window>`** and **`<strategic_compaction>`** — Must exist. Prevents early stopping and mid-implementation compaction.
6. **`<gotchas>`** — XML gotchas block with project-specific warnings
7. **Quick Reference** — Stack, port, database, status line with feature checkmarks
8. **Last updated** — Date at the bottom

**Rules:**
- Do NOT overwrite custom sections the user added
- Only ADD or UPDATE the mandatory sections listed above
- **Keep under 150 lines.** If over, move detail into docs/ and link. The commands/skills/hooks tables are framework boilerplate — trim them to the most-used items or link to docs/PROCESS.md
- Update the status line to reflect this run's findings
- Update Quick Reference if stack/port/key info changed

### Step 10: Generate Action Plan

→ **Read `.claude/skills/framework-launch/FORMATS.md`** for the action plan template. Save to `docs/reports/[YYYY-MM-DD]-[project]-action-plan.md`.

### Step 11: Generate Summary

→ **Read `.claude/skills/framework-launch/FORMATS.md`** for the summary template. Save to `docs/reports/[YYYY-MM-DD]-[project]-summary.md`.

### Step 12: Update Deliberation Log

Append a row to `docs/DELIBERATION_LOG.md` with: run number, date, tier, mode, persona count, key decisions, health score.

→ **Read `.claude/skills/framework-launch/FORMATS.md`** for the row format.

---

## Anti-Sycophancy Rules

These apply to ALL personas in the swarm:

1. **No forced positives.** If there's nothing good to say, say nothing good.
2. **No "but" sandwiches.** Don't frame criticism as "This is great, BUT..." Just state the criticism.
3. **No grading on a curve.** Mediocre gets mediocre.
4. **Praise must be earned.** Only praise genuinely impressive work.
5. **Say the uncomfortable thing.** Bad ideas are bad. Say so.

---

## Checklist

```
- [ ] Step 0: Tier detected, context brief prepared, living docs read
- [ ] Step 0.5: Docs scaffolded (DECISIONS, TODO, ARCHITECTURE, etc. exist)
- [ ] Step 0.5: Deliberation log read — run number determined
- [ ] Step 1: User interviews conducted (if interactive mode)
- [ ] Step 2-3: Agents spawned per tier, user check-ins after each batch
- [ ] Step 4: All reports saved to docs/reports/[role]/ with correct run number
- [ ] Step 5: Complaint ledger built
- [ ] Step 6-7: Rebuttal agents spawned, updated reports saved (if complaints)
- [ ] Step 8: Unresolved Blocks escalated to user (if any)
- [ ] Step 8.5: CHECKPOINT — complaint ledger + session state saved to disk
- [ ] Step 9: Living docs ACTUALLY UPDATED (DECISIONS, TODO, ARCHITECTURE, etc.)
- [ ] Step 9.5: CLAUDE.md verified — references all existing docs, status updated
- [ ] Step 10: Action plan saved to docs/reports/[date]-[project]-action-plan.md
- [ ] Step 11: Summary saved to docs/reports/[date]-[project]-summary.md
- [ ] Step 12: Deliberation log updated with this run's row
- [ ] All report files cross-reference each other
```
