Run the swarm deliberation engine — each persona as an isolated agent, with interactive user interviews.

$ARGUMENTS

Load and follow .claude/skills/framework-launch/SKILL.md completely.

## Mode Detection

- **No `auto` in $ARGUMENTS** → Interactive mode (default): interview the user before each batch
- **`auto` in $ARGUMENTS** → Auto mode: skip interviews, agents review with context only

## Tier Detection

Detect automatically or from $ARGUMENTS:
- **"greenfield"** / no plan / "new idea" → Tier 1: Ma → Jobs → [Torvalds ∥ Dyson ∥ Su] → [Atrioc ∥ Sacco] → Buffett
- **"wip"** / existing plan / "review this" → Tier 2: Jobs → [Torvalds ∥ Dyson ∥ Su] → [Atrioc ∥ Sacco] → Buffett
- **"polish"** / "refine" / "almost done" → Tier 3: [Torvalds ∥ Dyson ∥ Su] → Sacco → Buffett

## Process

1. Detect tier and mode from project state or $ARGUMENTS
2. Gather context: read key project files, prepare context brief
3. **Interview the user** (interactive mode): present each batch's questions before spawning agents
4. **Spawn agents** per tier dependency chain:
   - Use Agent tool with `subagent_type: "general-purpose"`
   - Sequential agents in foreground, parallel agents with `run_in_background: true`
   - Each agent prompt includes: persona SKILL.md path, context brief, user's interview answers, previous reports, output format
   - CRITICAL: Include anti-sycophancy instructions — agents must be brutally honest, no sugar coating
5. **User check-in** after each batch: show key findings, user reacts before next batch
6. Collect reports, save to `docs/reports/[role]/[date]-[project]-[type].md`
7. Parse complaints into a ledger
8. **Round 2**: Spawn rebuttal agents (parallel) for all roles that received complaints
9. If Blocks remain: **Round 3** — escalate to user
10. **Update project docs** — each persona contributes to DECISIONS.md, TODO.md, ARCHITECTURE.md, etc.
11. **Generate action plan** — consolidated tasks Claude can execute immediately → `docs/reports/[date]-[project]-action-plan.md`
12. Save summary to `docs/reports/[date]-[project]-summary.md`
13. **Process fire recommendations** (if any) — present to user for board approval

## Rules

- Each persona runs as a SEPARATE Agent — genuine isolation, genuine disagreement
- **No sugar coating.** Every persona must be brutally honest. No forced positives. No "great foundation" softening.
- Max 3 rounds. After round 3, user decides everything unresolved.
- Agents return text. YOU save files. YOU route complaints.
- Overrule requires the agent to cite a pivotal decision or core principle from the persona.
- Auto-decide using 6 principles: user intent → simpler → data → reversible → ships sooner → escalate.
- Steve Jobs can recommend firing (permanently replacing) a persona — requires user approval. The fired persona's SKILL.md gets rewritten with the replacement.
- Every report cross-references the reports it read and complaints filed/received.
- The action plan must be specific enough for Claude to execute each task without further clarification.

## Agent Spawning

For each agent, use this prompt structure:

```
You are [PERSONA] reviewing a project as part of a deliberation.
Read your full persona: .claude/skills/[skill]/SKILL.md — follow the Teammate Mode section.

CRITICAL: Be brutally honest. No sugar coating. No forced positives. If it's bad, say it's bad.

## Context Brief
[project state summary]

## User's Interview Answers
[user's answers to this persona's questions, or "AUTO MODE" if auto]

## Previous Reports
[any reports from earlier in this round]

## Task
Review following your Review Mode process. File complaints if warranted. Include Doc Contributions.
Return output between ---BEGIN REPORT--- / ---END REPORT--- and ---BEGIN COMPLAINTS--- / ---END COMPLAINTS--- markers.
```
