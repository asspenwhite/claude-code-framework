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

---

## Two Modes

### Interactive Mode (Default)

Before each batch of personas reviews, the team lead presents that batch's interview questions to the user. User's answers are included in the agent prompts. After agents return, key findings are shown and the user reacts before the next batch.

```
/framework-launch              → Interactive mode (default)
/framework-launch greenfield   → Interactive, Tier 1
/framework-launch wip          → Interactive, Tier 2
/framework-launch polish       → Interactive, Tier 3
```

### Auto Mode

Skips user interviews. Agents run without user input — useful for quick reviews or when the user trusts the team.

```
/framework-launch auto         → Auto mode, tier auto-detected
/framework-launch auto polish  → Auto mode, Tier 3
```

---

## Architecture

```
Team Lead (main conversation — you)
    │
    ├── INTERVIEW: Ma's questions → user answers
    ├── spawn Agent("ma-brainstorm")
    ├── Show findings → user reacts
    │
    ├── INTERVIEW: Jobs's questions → user answers
    ├── spawn Agent("jobs-ceo")
    ├── Show findings → user reacts
    │
    ├── INTERVIEW: [Torvalds + Dyson + Su] questions → user answers (batched)
    ├── spawn Agent("torvalds-eng")     ─┐
    ├── spawn Agent("dyson-design")      │ parallel
    ├── spawn Agent("su-performance")   ─┘
    ├── Show findings → user reacts
    │
    ├── INTERVIEW: [Atrioc + Sacco] questions → user answers (batched)
    ├── spawn Agent("atrioc-marketing")  ─┐ parallel
    ├── spawn Agent("sacco-slop")       ─┘
    ├── Show findings → user reacts
    │
    ├── INTERVIEW: Buffett's questions → user answers
    ├── spawn Agent("buffett-retro")
    │
    ▼
Collect reports → parse complaints → save to docs/reports/
    │
    ├── Round 2: Rebuttal agents (parallel)
    ├── Round 3: User escalation (if Blocks remain)
    │
    ▼
Generate action plan → update project docs → save summary
    │
    ▼
FIRE recommendations (if any) → present to user → user approves/denies
    │
    ▼
If approved: rewrite fired persona's SKILL.md with replacement
```

**Key principles:**
- Agents return text. You save files. You route complaints.
- **No sugar coating.** Every persona is instructed to be brutally honest. No forced positives. No diplomatic softening.
- The user is a co-founder in the boardroom, not a recipient of a report.

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

### Steve Jobs: The Fire Power

Jobs is the CEO. He can **fire** a persona — recommend permanently replacing the person behind a role with someone better suited to the project.

**This is NOT a mid-session skip.** All 8 personas still participate in the current deliberation. The fire recommendation appears in the **final summary** as a pending board decision.

When Jobs includes a `FIRE` directive in his report:
1. The deliberation completes normally — the fired persona still participates this round
2. In the final summary, the fire recommendation is listed under "Pending Board Decisions"
3. Team lead presents it to the user (the board): "Jobs recommends replacing [Person] as [Role]. Reason: [reason]. Suggested replacement: [new person]. Approve?"
4. **User decides.** If approved, the persona's SKILL.md is rewritten with the new person's philosophy, quotes, pivotal decisions, and decision rules. The role stays — the person changes.
5. If denied, nothing changes.

Jobs should fire sparingly — like killing the Newton. Only when a persona's philosophy actively misaligns with the product's needs. The replacement must be someone whose track record fits better.

**Example:**
```
Jobs recommends: FIRE Atrioc as Marketing head.
Reason: "This is a developer tool. Atrioc's consumer marketing instincts
are wrong for this audience. We need someone who speaks to developers."
Replacement: "DHH — built Basecamp's developer brand through opinionated
honesty, not marketing playbooks."
Board decision: [PENDING USER APPROVAL]
```

---

## Three Tiers

Detect automatically from project state, or user specifies.

### Tier 1: Greenfield (nothing exists)

**Trigger:** No plan file, no codebase, or user says "new idea" / "starting fresh"

```
Ma → Jobs → [Torvalds ∥ Dyson ∥ Su] → [Atrioc ∥ Sacco] → Buffett
```

**All 8 roles. Maximum deliberation.** Ma validates demand. Jobs scopes (and may fire). Torvalds, Dyson, Su review in parallel. Atrioc and Sacco review in parallel. Buffett closes.

| Order | Role | Agent | Reads | Parallel? |
|-------|------|-------|-------|-----------|
| 1 | Ma | `ma-brainstorm` | User input + interview answers | Solo |
| 2 | Jobs | `jobs-ceo` | Ma's report + interview answers | Solo |
| 3a | Torvalds | `torvalds-eng` | Jobs + Ma reports + interview answers | Parallel |
| 3b | Dyson | `dyson-design` | Jobs + Ma reports + interview answers | Parallel |
| 3c | Su | `su-performance` | Jobs + Ma reports + interview answers | Parallel |
| 4a | Atrioc | `atrioc-marketing` | All above + interview answers | Parallel |
| 4b | Sacco | `sacco-slop` | All above + interview answers | Parallel |
| 5 | Buffett | `buffett-retro` | Everything + interview answers | Solo (closer) |

### Tier 2: Work-in-Progress (something half-finished exists)

**Trigger:** Existing plan file, partial codebase, or user says "review this"

```
Jobs → [Torvalds ∥ Dyson ∥ Su] → [Atrioc ∥ Sacco] → Buffett
```

**Skip brainstorm. Demand is assumed.** 7 roles.

### Tier 3: Polish (solid, needs refinement)

**Trigger:** Mature codebase, or user says "polish" / "refine" / "almost done"

```
[Torvalds ∥ Dyson ∥ Su] → Sacco → Buffett
```

**No scope changes. Engineering, design, performance, and taste only.** 5 roles.

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

### Step 1: User Interviews (Interactive Mode Only)

For each batch of personas about to review, present their interview questions to the user. Questions are defined in each persona's SKILL.md under "User Interview Questions."

**Batch the questions by phase.** Don't ask 24 questions upfront — ask each batch right before those personas run:

#### Phase 1: Ma (Tier 1 only)
```
Before Jack Ma reviews your idea, he wants to know:

1. Who is *desperate* for this? Not interested — desperate.
2. What are they doing today without your product? How painful is that?
3. Why you? Why now? What do you see that bigger players don't?
```

#### Phase 2: Jobs
```
Before Steve Jobs reviews the scope, he wants to know:

1. What is the ONE thing this product does better than anything else?
2. What have you decided NOT to build? What did you kill?
3. Describe this product in one sentence to someone at a bar.
```

#### Phase 3: Torvalds + Dyson + Su (batched)
```
Three reviewers are about to work in parallel. Quick answers for each:

ENGINEERING (Torvalds):
1. What's the hardest technical problem in this project?
2. What are you building from scratch vs. using existing tools?
3. Where do you expect this to break first under real load?

DESIGN (Dyson):
1. Who is the user and what are they doing in the first 30 seconds?
2. What's the most important action on the main screen?
3. What existing product does this feel closest to?

PERFORMANCE (Su):
1. What's your performance target? (load time, response time, throughput)
2. What's the heaviest operation in the system?
3. Have you measured anything yet, or starting from zero?
```

#### Phase 4: Atrioc + Sacco (batched)
```
Two reviewers are about to work in parallel:

MARKETING (Atrioc):
1. Who are you selling to? Job title, company size, pain level.
2. What do competitors call themselves? How are you different?
3. One sentence someone would use to recommend this to a friend?

AI SLOP (Sacco):
1. What's the brand personality? If this product were a person, how would they carry themselves?
2. Do you have existing brand guidelines (colors, fonts, visual language)?
3. What products do you want this to look NOTHING like?
```

#### Phase 5: Buffett
```
Before Warren Buffett closes the deliberation:

1. What's the biggest risk you know about but haven't addressed?
2. What would make you abandon this project entirely?
3. What's the one thing that went right so far that you want to protect?
```

**In auto mode:** Skip all interviews. Agents review with context brief only.

### Step 2: Agent Reviews (Round 1)

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

CRITICAL: Be brutally honest. Do NOT manufacture compliments or find forced positives. If something is bad, say it's bad. If something is mediocre, say it's mediocre. Your honest assessment is what makes this deliberation valuable. Sugar-coated feedback is worse than no feedback.

## Context Brief
[paste the context brief here]

## User's Interview Answers
[paste the user's answers to this persona's questions, or "AUTO MODE — no interview conducted" if auto]

## Previous Reports
[paste or reference any reports from earlier in this round]

## Your Task
1. Read the project files listed above
2. Conduct your review following your Review Mode process
3. Be honest. Do not soften your assessment. Say what is actually true.
4. File complaints against other roles if warranted
5. Include Doc Contributions — what project docs should be created/updated
6. Return your complete report as text (do NOT save files)

Return your output in EXACTLY this format — the team lead will parse it:

---BEGIN REPORT---
[full review following your SKILL.md Teammate Mode output format]

### Doc Contributions
[list of docs to create/update with specific content]
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

**For Steve Jobs specifically**, add to the prompt:

```
## Additional Power: FIRE (Permanent Roster Change)
You may recommend permanently replacing a persona with someone better suited to this project. This is NOT a mid-session skip — the fired persona still participates in this deliberation. Your recommendation goes in the final summary for board (user) approval. If approved, the persona's SKILL.md gets rewritten with the replacement's philosophy.

Use sparingly — like killing the Newton. Only when a persona's philosophy fundamentally misaligns with the product's needs. You MUST suggest a specific replacement person and explain why they're a better fit.

If you want to fire someone, add:

---BEGIN FIRES---
## FIRE: [Target Persona] as [Role]
**Reason:** [why this persona's philosophy misaligns with the product]
**Replacement:** [specific real person] — [why they're a better fit]
**Principle:** [which Jobs principle — the 2x2 grid, killing the Newton, etc.]
---END FIRES---

If no fires: omit this section entirely.
```

**Spawning sequence by tier:**

#### Tier 1
```python
# 1. Ma (foreground — need result before Jobs)
ma_result = Agent("ma-brainstorm", prompt=build_prompt("ma", context, user_answers))
save_report("brainstorm", ma_result)
# Show user: Ma's key findings. User reacts.

# 2. Jobs (foreground — need result before Torvalds/Dyson/Su)
jobs_result = Agent("jobs-ceo", prompt=build_prompt("jobs", context, user_answers, [ma_report]))
save_report("ceo", jobs_result)
# Note any FIRE recommendations for the final summary
# Show user: Jobs's scope decisions. User reacts.

# 3. Torvalds + Dyson + Su (parallel, background)
torvalds_result = Agent("torvalds-eng", prompt=..., run_in_background=true)
dyson_result = Agent("dyson-design", prompt=..., run_in_background=true)
su_result = Agent("su-performance", prompt=..., run_in_background=true)
save_report("engineering", torvalds_result)
save_report("design", dyson_result)
save_report("performance", su_result)
# Show user: all three findings. User reacts.

# 4. Atrioc + Sacco (parallel, background)
atrioc_result = Agent("atrioc-marketing", prompt=..., run_in_background=true)
sacco_result = Agent("sacco-slop", prompt=..., run_in_background=true)
save_report("marketing", atrioc_result)
save_report("ai-slop", sacco_result)
# Show user: both findings. User reacts.

# 5. Buffett (foreground — closer, reads everything)
buffett_result = Agent("buffett-retro", prompt=build_prompt("buffett", context, user_answers, [all_reports]))
save_report("retrospective", buffett_result)
```

#### Tier 2
```python
# Jobs → [Torvalds ∥ Dyson ∥ Su] → [Atrioc ∥ Sacco] → Buffett
# Same as Tier 1 but skip Ma
```

#### Tier 3
```python
# [Torvalds ∥ Dyson ∥ Su] → Sacco → Buffett
# Skip Ma, Jobs, Atrioc
torvalds_result = Agent("torvalds-eng", ..., run_in_background=true)
dyson_result = Agent("dyson-design", ..., run_in_background=true)
su_result = Agent("su-performance", ..., run_in_background=true)
# Show user, user reacts

sacco_result = Agent("sacco-slop", prompt=...)
# Show user, user reacts

buffett_result = Agent("buffett-retro", prompt=...)
```

### Step 3: User Check-ins (Interactive Mode)

After each batch of agents returns, present key findings to the user:

```
## [Persona] just reviewed. Key findings:

**Verdict:** [one-line summary]
**Complaints filed:** [list or "None"]
**Biggest concern:** [the #1 issue they found]

Any thoughts before we continue to the next batch?
```

The user can:
- **React** — "I disagree with X" / "Good point about Y" — feed this into subsequent agent prompts
- **Continue** — "Keep going" / "Next" — proceed to next batch
- **Override** — "Ignore that complaint" / "That's not a real issue" — mark complaint as user-dismissed

### Step 4: Save Round 1 Reports

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
**Honesty:** Unfiltered

---

[agent's report content]
```

### Step 5: Parse Complaints

After all Round 1 reports are saved, extract complaints from each agent's output. Build a **complaint ledger:**

| # | From | To | Severity | Objection | Section |
|---|------|----|----------|-----------|---------|
| 1 | Torvalds | Jobs | Block | "Scope is unbuildable" | Feature X |
| 2 | Dyson | Torvalds | Push-back | "Architecture kills UX" | Data model |
| 3 | Atrioc | Jobs | Note | "Users won't understand this" | Naming |

**If no complaints across all reports:** Skip Round 2. Consensus reached.

### Step 6: Round 2 — Rebuttals

For each role that received complaints, spawn a new agent:

**Agent prompt structure:**

```
You are [PERSONA NAME] responding to complaints filed against your review.

Read your full persona file: .claude/skills/[skill-dir]/SKILL.md
Follow the "Teammate Mode — Responding to Complaints" section.

CRITICAL: Be honest in your responses. Don't Accept complaints just to be agreeable. Don't Overrule without a real principle. If they're right, say they're right. If they're wrong, say they're wrong and explain why.

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
for role in roles_with_complaints:
    Agent(f"{role}-rebuttal", prompt=..., run_in_background=true)
```

### Step 7: Save Round 2 Reports

Save updated reports as: `docs/reports/[role]/[YYYY-MM-DD]-[project]-[type]-round2.md`

Update the complaint ledger with responses.

### Step 8: Round 3 — User Escalation (if needed)

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

### Step 9: Update Project Docs

After all rounds complete, collect doc contributions from every persona and update project docs:

1. **Collect** — Gather all "Doc Contributions" sections from every report
2. **Merge** — Combine recommendations by doc file (multiple personas may suggest TODO items)
3. **Create or update** the following docs:

| Doc File | Who Contributes | What Goes In |
|----------|----------------|-------------|
| `docs/DECISIONS.md` | Jobs, Buffett | Scope decisions with rationale |
| `docs/TODO.md` | Everyone | Action items, prioritized by importance |
| `docs/CONSTRAINTS.md` | Jobs, Ma, Torvalds, Su | Budget, technical, market, performance constraints |
| `docs/ARCHITECTURE.md` | Torvalds | Architecture decisions, data models |
| `docs/DESIGN.md` | Dyson, Sacco | Design principles, anti-patterns, brand |
| `docs/PERFORMANCE.md` | Su | Baselines, targets, optimization priorities |
| `docs/MARKETING.md` | Atrioc | Audience, positioning, messaging |
| `docs/LESSONS.md` | Buffett | Compounding lessons from this deliberation |

**Rules:**
- Create files that don't exist yet
- Append to existing files (never overwrite existing content)
- Mark items from this deliberation with the date

### Step 10: Generate Action Plan

The most important output. After Buffett closes, generate a **consolidated action plan** that Claude can execute immediately in subsequent conversations.

**File:** `docs/reports/[YYYY-MM-DD]-[project]-action-plan.md`

```markdown
# Action Plan: [Project Name]

**Generated:** [date]
**From:** Framework Launch — [Tier] deliberation
**Participants:** [list of personas who reviewed]

## Immediate Actions (do these first)
| # | Task | Owner Domain | Priority | From |
|---|------|-------------|----------|------|
| 1 | [specific, actionable task] | [Engineering/Design/etc.] | P0 | [persona who recommended it] |
| 2 | ... | ... | P0 | ... |

## Next Sprint
| # | Task | Owner Domain | Priority | From |
|---|------|-------------|----------|------|
| 1 | [task] | [domain] | P1 | [persona] |

## Backlog
| # | Task | Owner Domain | Priority | From |
|---|------|-------------|----------|------|
| 1 | [task] | [domain] | P2 | [persona] |

## Decisions Made
| # | Decision | Decided By | Rationale |
|---|----------|-----------|-----------|
| 1 | [decision] | [persona or user] | [why] |

## Risks to Watch
| Risk | Flagged By | Mitigation |
|------|-----------|------------|
| [risk] | [persona] | [plan] |

## How to Execute
To start working through this plan:
1. Open this file in Claude Code
2. Say: "Work through the action plan starting from the top"
3. Claude will execute each task, checking off as completed
```

### Step 11: Generate Summary

**File:** `docs/reports/[YYYY-MM-DD]-[project]-summary.md`

```markdown
# Deliberation Summary: [Project Name]

**Date:** [date]
**Tier:** [Greenfield / WIP / Polish]
**Rounds:** [1-3]
**Mode:** [Interactive / Auto]
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

## Docs Updated
[List of project docs created or updated during this deliberation]

## Pending Board Decisions
[Fire recommendations from Jobs, if any. Each requires user approval.]

| Persona | Role | Recommendation | Replacement | Reason | Board Decision |
|---------|------|---------------|-------------|--------|---------------|
| [current person] | [role] | FIRE | [proposed replacement] | [Jobs's reason] | [PENDING / APPROVED / DENIED] |

*If approved: the persona's SKILL.md will be rewritten with the replacement's philosophy, quotes, pivotal decisions, and decision rules. The role stays — the person changes.*

## Action Plan
→ See `[date]-[project]-action-plan.md` for the full executable plan.

## One-Sentence Product
[The final one-sentence description after all reviews]
```

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

## Anti-Sycophancy Rules

These apply to ALL personas in the swarm:

1. **No forced positives.** If there's nothing good to say, say nothing good. An honest "this needs work" is more valuable than a manufactured "great foundation."
2. **No "but" sandwiches.** Don't frame criticism as "This is great, BUT..." Just state the criticism.
3. **No grading on a curve.** A mediocre product gets a mediocre review. Don't adjust expectations downward because "it's early."
4. **Praise must be earned.** If you praise something, it must be genuinely impressive — something you'd point to as an example of how to do it right. Otherwise, skip the praise.
5. **Say the uncomfortable thing.** If the idea is bad, say it's bad. If the user's pet feature is the weakest part, say so. The user is paying for honesty, not encouragement.

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

### Performance vs Design
```
Su: "Custom fonts add 200ms to LCP. Push-back."
Sacco: "System fonts are F1 AI slop. The performance cost is the price of not looking generic. Overrule."
→ Escalate to user: speed vs. brand distinctiveness
```

### CEO fires Marketing
```
Jobs: "FIRE Atrioc. This is a developer tool. Marketing positioning is premature and adds scope nobody needs right now."
→ User: "Approved — skip marketing for now, revisit at launch."
```

---

## Checklist

```
- [ ] Tier detected (Greenfield / WIP / Polish)
- [ ] Mode detected (Interactive / Auto)
- [ ] Context brief prepared (project state, user request, key files)
- [ ] User interviews conducted (if interactive mode)
- [ ] Round 1: Agents spawned per tier dependency chain
- [ ] Round 1: User check-ins after each batch
- [ ] Round 1: All reports saved to docs/reports/[role]/
- [ ] Round 1: Complaint ledger built
- [ ] Round 1: FIRE directives processed (if any)
- [ ] Round 2: Rebuttal agents spawned for all targets (if complaints exist)
- [ ] Round 2: Updated reports saved as -round2.md
- [ ] Round 3: Unresolved Blocks escalated to user (if any)
- [ ] Project docs updated (DECISIONS, TODO, ARCHITECTURE, etc.)
- [ ] Action plan saved to docs/reports/[date]-[project]-action-plan.md
- [ ] Summary saved to docs/reports/[date]-[project]-summary.md
- [ ] All report files cross-reference each other
```
