# Agent Prompt Templates

Reference file for framework-launch orchestration. The team lead reads this when spawning agents in Steps 2 and 6.

---

## Round 1: Agent Review Prompt

Use this structure for every persona spawned in Step 2.

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

---

## Steve Jobs: FIRE Directive

Add this to Jobs's prompt (in addition to the standard prompt above):

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

## Incremental Mode: Agent Prompt Addition

When running in incremental mode, append this to every agent's prompt:

```
## Your Previous Report
[paste their last report for this project]

## Previous Action Plan
[paste the last action plan — mark which items were completed]

## Previous Summary
[paste the last deliberation summary — decisions, unresolved tensions]

INSTRUCTIONS: You reviewed this project before. Your previous report is above.
- Focus on what CHANGED since your last review
- Don't repeat findings that were already addressed
- Re-raise issues that were flagged but NOT fixed
- Score relative to last time: improved, same, or regressed
- Note any new issues that emerged from changes made since last review
```

---

## Spawning Sequences by Tier

### Tier 1 (Greenfield — 8 agents)
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

### Tier 2 (WIP — 7 agents)
```python
# Jobs → [Torvalds ∥ Dyson ∥ Su] → [Atrioc ∥ Sacco] → Buffett
# Same as Tier 1 but skip Ma
```

### Tier 3 (Polish — 5 agents)
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

---

## Round 2: Rebuttal Prompt

For each role that received complaints in Round 1, spawn a rebuttal agent:

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
