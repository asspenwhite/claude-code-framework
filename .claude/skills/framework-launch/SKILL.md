---
name: framework-launch
description: Swarm deliberation engine. Each persona runs as a separate Claude instance via Agent tool for genuine isolation. Hub-and-spoke orchestration with complaint routing. Three tiers based on project state.
activates_when: auto review, run all reviews, framework launch, review pipeline, full plan review, deliberate
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Agent
---

# Autoplan - Swarm Deliberation Engine

Not a linear pipeline. A **swarm** where each persona runs in its own context.

Single-context deliberation (one Claude playing all roles) produces polite consensus. Genuine isolation produces genuine disagreement. Each persona is spawned as a separate Agent with its own context window, its own copy of the persona's philosophy, and no visibility into what the other personas are thinking.

The **team lead** (you, the main conversation) orchestrates: spawning agents, collecting reports, routing complaints, and saving everything to `docs/reports/`.

---

## Architecture

```
Team Lead (main conversation — you)
    │
    ├── spawn Agent("ma-brainstorm")        ─┐
    ├── spawn Agent("jobs-ceo")              │  Round 1
    ├── spawn Agent("torvalds-eng")          │  (sequential + parallel per tier)
    ├── spawn Agent("dyson-design")          │
    ├── spawn Agent("atrioc-marketing")     ─┘
    │
    ▼
Collect reports → parse complaints → save to docs/reports/
    │
    ├── spawn Agent("torvalds-rebuttal")    ─┐
    ├── spawn Agent("jobs-rebuttal")         │  Round 2
    ├── spawn Agent("dyson-rebuttal")       ─┘  (parallel, all targets)
    │
    ▼
Collect responses → save updated reports → check for unresolved Blocks
    │
    ▼
Unresolved Blocks? → Present to user → User decides → Final summary
```

**Key principle:** Agents return text. You save files. You route complaints. The agents never see each other directly.

---

## Three Tiers

Detect automatically from project state, or user specifies.

### Tier 1: Greenfield (nothing exists)

**Trigger:** No plan file, no codebase, or user says "new idea" / "starting fresh"

```
Ma (solo) → Jobs (solo) → [Torvalds ∥ Dyson] → Atrioc (solo)
```

**All 5 roles. Maximum deliberation.** Ma goes first because demand validation gates everything. Jobs scopes based on Ma's output. Torvalds and Dyson review in parallel (both read Jobs's scope). Atrioc closes, reading everything.

| Order | Role | Agent | Reads | Parallel? |
|-------|------|-------|-------|-----------|
| 1 | Ma | `ma-brainstorm` | User input only | Solo |
| 2 | Jobs | `jobs-ceo` | Ma's report | Solo |
| 3a | Torvalds | `torvalds-eng` | Jobs's report + Ma's report | Parallel with Dyson |
| 3b | Dyson | `dyson-design` | Jobs's report + Ma's report | Parallel with Torvalds |
| 4 | Atrioc | `atrioc-marketing` | All reports above | Solo |

### Tier 2: Work-in-Progress (something half-assed exists)

**Trigger:** Existing plan file, partial codebase, or user says "review this"

```
Jobs (solo) → [Torvalds ∥ Dyson] → Atrioc (solo)
```

**Skip brainstorm. Demand is assumed.** Jobs scopes the existing work. Torvalds and Dyson review in parallel. Atrioc closes.

### Tier 3: Polish (solid, needs refinement)

**Trigger:** Mature codebase, or user says "polish" / "refine" / "almost done"

```
[Torvalds ∥ Dyson]
```

**No scope changes. Engineering and design only.** Both review the existing state in parallel. Complaints go directly between them.

---

## Orchestration Process

### Step 0: Context Gathering

Before spawning any agents, gather:

1. **Project state** — Read key files: README, any plan/spec docs, package.json/pyproject.toml, existing code structure
2. **User's request** — What the user asked for or described
3. **Existing reports** — Check `docs/reports/` for previous deliberation rounds
4. **Tier detection** — Greenfield / WIP / Polish based on project state or user input

Prepare a **context brief** — a concise summary (under 500 words) of the project state that every agent will receive. Include:
- What exists (tech stack, file structure, key decisions already made)
- What the user wants (feature, redesign, new product, etc.)
- Tier and why
- Links to key files the agent should read

### Step 1: Round 1 — Agent Reviews

Spawn agents according to the tier's dependency chain. For each agent:

**Use the Agent tool** with:
- `subagent_type: "general-purpose"`
- `run_in_background: true` (for parallel agents only)
- NO `isolation: "worktree"` (agents only read and produce text, they don't modify code)

**Agent prompt structure:**

```
You are [PERSONA NAME] reviewing a project as part of a deliberation.

Read your full persona file: .claude/skills/[skill-dir]/SKILL.md
Follow the "Teammate Mode" section for output format.

## Context Brief
[paste the context brief here]

## Previous Reports
[paste or reference any reports from earlier in this round]

## Your Task
1. Read the project files listed above
2. Conduct your review following your Review Mode process
3. File complaints against other roles if warranted
4. Return your complete report as text (do NOT save files)

Return your output in EXACTLY this format — the team lead will parse it:

---BEGIN REPORT---
[full review following your SKILL.md Review Mode output format]
---END REPORT---

---BEGIN COMPLAINTS---
[structured complaints, or "NONE" if no complaints]

## Complaint: [Your Role] → [Target Role]
**Severity:** Block / Push-back / Note
**Section:** [which decision in their domain]
**Objection:** [specific issue — not vague]
**Evidence:** [why, citing your persona's principles or decisions]
**Proposed fix:** [what should change]

[repeat for additional complaints]
---END COMPLAINTS---
```

**Spawning sequence by tier:**

#### Tier 1
```python
# 1. Ma (foreground — need result before Jobs)
ma_result = Agent("ma-brainstorm", prompt=build_prompt("ma", context_brief))
save_report("brainstorm", ma_result)

# 2. Jobs (foreground — need result before Torvalds/Dyson)
jobs_result = Agent("jobs-ceo", prompt=build_prompt("jobs", context_brief, [ma_report]))
save_report("ceo", jobs_result)

# 3. Torvalds + Dyson (parallel, background)
torvalds_result = Agent("torvalds-eng", prompt=..., run_in_background=true)
dyson_result = Agent("dyson-design", prompt=..., run_in_background=true)
# wait for both to complete
save_report("engineering", torvalds_result)
save_report("design", dyson_result)

# 4. Atrioc (foreground — reads all above)
atrioc_result = Agent("atrioc-marketing", prompt=build_prompt("atrioc", context_brief, [all_reports]))
save_report("marketing", atrioc_result)
```

#### Tier 2
```python
jobs_result = Agent("jobs-ceo", prompt=...) # foreground
save_report("ceo", jobs_result)

# parallel
torvalds_result = Agent("torvalds-eng", ..., run_in_background=true)
dyson_result = Agent("dyson-design", ..., run_in_background=true)
save_report("engineering", torvalds_result)
save_report("design", dyson_result)

atrioc_result = Agent("atrioc-marketing", prompt=...) # foreground
save_report("marketing", atrioc_result)
```

#### Tier 3
```python
# Both parallel
torvalds_result = Agent("torvalds-eng", ..., run_in_background=true)
dyson_result = Agent("dyson-design", ..., run_in_background=true)
save_report("engineering", torvalds_result)
save_report("design", dyson_result)
```

### Step 2: Save Round 1 Reports

After each agent returns, save its report:

**File path:** `docs/reports/[role]/[YYYY-MM-DD]-[project]-[type].md`

Add the standard header to each report:
```markdown
# [Role] Report: [Project Name]

**Date:** [YYYY-MM-DD]
**Tier:** [Greenfield / WIP / Polish]
**Round:** 1
**Status:** Initial
**Mode:** Swarm (isolated agent)

---

[agent's report content]
```

### Step 3: Parse Complaints

After all Round 1 reports are saved, extract complaints from each agent's output. Build a **complaint ledger:**

| # | From | To | Severity | Objection | Section |
|---|------|----|----------|-----------|---------|
| 1 | Torvalds | Jobs | Block | "Scope is unbuildable" | Feature X |
| 2 | Dyson | Torvalds | Push-back | "Architecture kills UX" | Data model |
| 3 | Atrioc | Jobs | Note | "Users won't understand this" | Naming |

**If no complaints across all reports:** Skip Round 2. Consensus reached.

### Step 4: Round 2 — Rebuttals

For each role that received complaints, spawn a new agent:

**Agent prompt structure:**

```
You are [PERSONA NAME] responding to complaints filed against your review.

Read your full persona file: .claude/skills/[skill-dir]/SKILL.md
Follow the "Teammate Mode — Responding to Complaints" section.

## Your Round 1 Report
[paste their Round 1 report]

## Complaints Against You

### Complaint #1 from [Role]
**Severity:** [level]
**Section:** [section]
**Objection:** [what they said]
**Evidence:** [their reasoning]
**Proposed fix:** [what they want changed]

[repeat for additional complaints]

## Your Task
For EACH complaint, respond with one of:
- **Accept** — "You're right. Here's my updated position."
- **Modify** — "Partially right. Here's a compromise."
- **Overrule** — "I hear you, but no." MUST cite a pivotal decision or principle from your persona.
- **Escalate** — "We can't resolve this. User needs to decide."

Return your output in EXACTLY this format:

---BEGIN RESPONSES---

## Response to Complaint #1 from [Role]
**Decision:** Accept / Modify / Overrule / Escalate
**Reasoning:** [why — citing your persona's principles]
**Changes:** [what you're changing in your recommendation, or why you're not]

[repeat for each complaint]
---END RESPONSES---

---BEGIN UPDATED REPORT---
[your full updated report if any Accept/Modify responses, or "NO CHANGES" if all Overrule/Escalate]
---END UPDATED REPORT---

---BEGIN COUNTER-COMPLAINTS---
[new complaints against the complaining role, if warranted, or "NONE"]
---END COUNTER-COMPLAINTS---
```

**Spawn all rebuttal agents in parallel** (they don't depend on each other):

```python
# All rebuttal agents in parallel
for role in roles_with_complaints:
    Agent(f"{role}-rebuttal", prompt=..., run_in_background=true)
```

### Step 5: Save Round 2 Reports

Save updated reports as: `docs/reports/[role]/[YYYY-MM-DD]-[project]-[type]-round2.md`

Update the complaint ledger with responses.

### Step 6: Round 3 — User Escalation (if needed)

If any **Block** complaints are still unresolved (Overruled or Escalated):

1. Present the disagreement to the user clearly:
   ```
   UNRESOLVED: Torvalds blocks Jobs's scope

   Torvalds says: "[his argument]"
   Jobs says: "[his argument]"

   Who do you side with? Or do you have a different take?
   ```
2. User decides
3. Update the relevant reports with the user's decision
4. Mark complaints as resolved

**Max 3 rounds.** If counter-complaints create new Blocks in Round 2, present ALL remaining disagreements to the user in Round 3. The user is the tiebreaker. Period.

### Step 7: Generate Summary

After all rounds complete, save the deliberation summary:

**File:** `docs/reports/[YYYY-MM-DD]-[project]-summary.md`

```markdown
# Deliberation Summary: [Project Name]

**Date:** [date]
**Tier:** [Greenfield / WIP / Polish]
**Rounds:** [1-3]
**Mode:** Swarm (isolated agents)
**Consensus reached:** [Yes / No — user decided]

## Participants
| Role | Persona | Report | Complaints Filed | Complaints Received |
|------|---------|--------|-----------------|-------------------|
| [role] | [persona] | [link] | [count] | [count] |

## Complaint Ledger
| # | From | To | Severity | Objection | Response | Resolution |
|---|------|----|----------|-----------|----------|------------|
| 1 | [role] | [role] | [sev] | [short] | [Accept/Modify/Overrule/Escalate] | [resolved how] |

## Key Decisions
| # | Decision | Decided By | Method |
|---|----------|-----------|--------|
| 1 | [decision] | [role or user] | [auto / complaint / escalation] |

## Unresolved Tensions
[Any disagreements that were overruled — may resurface later]

## Action Items
- [ ] [action from each review]

## One-Sentence Product
[The final one-sentence description after all reviews]
```

Also update (if they exist):
- `docs/DECISIONS.md` — Append decisions
- `docs/TODO.md` — Append action items

---

## The Complaint System

### Complaint Severity

| Severity | What Happens |
|----------|-------------|
| **Block** | Deliberation pauses for this pair. Target MUST respond. If unresolved after Round 2, escalates to user. |
| **Push-back** | Target reviews in Round 2. Pipeline continues. Auto-decide if principles are clear. |
| **Note** | Logged. No response required. Informational. |

### Response Types

| Response | Meaning | Requirements |
|----------|---------|-------------|
| **Accept** | "You're right." | Updated report saved. |
| **Modify** | "Partially right." | Compromise documented with reasoning. |
| **Overrule** | "No." | MUST cite a pivotal decision or core principle from the persona. No empty overrules. |
| **Escalate** | "Can't resolve." | Added to user decision queue. Both sides presented. |

### Auto-Decision Principles

For Push-back and Note severity, resolve without the user:

1. **User intent wins** — User's original plan clearly states a preference
2. **Simpler wins** — Fewer moving parts between two approaches
3. **Data wins** — Benchmarks, research, or metrics decide
4. **Reversibility wins** — Easier to undo
5. **Shipping wins** — If close, ship sooner
6. **Escalate** — None of the above resolve it → ask the user

### What Gets Auto-Decided vs Escalated

| Auto-decide | Escalate to user |
|------------|-----------------|
| "Add an index" → always yes | CEO vs Eng on scope |
| "Fix spacing" → always yes | Two valid architectures |
| "Kill this buzzword" → always yes | Feature cuts that change identity |
| Security hardening → always yes | Performance vs DX tradeoffs |
| Bug fixes → always yes | Design changes that alter brand |

---

## Common Argument Patterns

Real tensions that surface between isolated agents:

### CEO vs Engineering
```
Jobs: "Add real-time collaboration"
Torvalds: "That's 3 months of infrastructure for V1. Block."
→ Round 2: Jobs Modifies → "Presence indicators only. Defer editing."
```

### Engineering vs Design
```
Torvalds: "Server-side render everything for performance"
Dyson: "That kills client-side interactivity. Form flow becomes impossible. Block."
→ Round 2: Torvalds Modifies → "SSR content pages, CSR interactive flows"
```

### Marketing vs CEO
```
Atrioc: "Nobody outside your team understands 'neural mesh routing.' Push-back."
Jobs: "Accept. Rename to 'smart routing.' Lead with the outcome."
```

---

## Checklist

```
- [ ] Tier detected (Greenfield / WIP / Polish)
- [ ] Context brief prepared (project state, user request, key files)
- [ ] Round 1: Agents spawned per tier dependency chain
- [ ] Round 1: All reports saved to docs/reports/[role]/
- [ ] Round 1: Complaint ledger built
- [ ] Round 2: Rebuttal agents spawned for all targets (if complaints exist)
- [ ] Round 2: Updated reports saved as -round2.md
- [ ] Round 3: Unresolved Blocks escalated to user (if any)
- [ ] Summary saved to docs/reports/[date]-[project]-summary.md
- [ ] DECISIONS.md updated (if exists)
- [ ] TODO.md updated (if exists)
- [ ] All report files cross-reference each other
```
