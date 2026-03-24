Run the swarm deliberation engine — each persona as an isolated agent.

$ARGUMENTS

Load and follow .claude/skills/framework-launch/SKILL.md completely.

## Tier Detection

Detect automatically or from $ARGUMENTS:
- **"greenfield"** / no plan / "new idea" → Tier 1: Ma → Jobs → [Torvalds ∥ Dyson] → Atrioc
- **"wip"** / existing plan / "review this" → Tier 2: Jobs → [Torvalds ∥ Dyson] → Atrioc
- **"polish"** / "refine" / "almost done" → Tier 3: [Torvalds ∥ Dyson]

## Process

1. Detect tier from project state or $ARGUMENTS
2. Gather context: read key project files, prepare context brief
3. **Spawn agents** per tier dependency chain:
   - Use Agent tool with `subagent_type: "general-purpose"`
   - Sequential agents in foreground, parallel agents with `run_in_background: true`
   - Each agent prompt includes: persona SKILL.md path, context brief, previous reports, output format
4. Collect reports, save to `docs/reports/[role]/[date]-[project]-[type].md`
5. Parse complaints into a ledger
6. **Round 2**: Spawn rebuttal agents (parallel) for all roles that received complaints
7. If Blocks remain: **Round 3** — escalate to user
8. Save summary to `docs/reports/[date]-[project]-summary.md`

## Rules

- Each persona runs as a SEPARATE Agent — genuine isolation, genuine disagreement
- Max 3 rounds. After round 3, user decides everything unresolved.
- Agents return text. YOU save files. YOU route complaints.
- Overrule requires the agent to cite a pivotal decision or core principle from the persona.
- Auto-decide using 6 principles: user intent → simpler → data → reversible → ships sooner → escalate.
- Every report cross-references the reports it read and complaints filed/received.

## Agent Spawning

For each agent, use this prompt structure:

```
You are [PERSONA] reviewing a project as part of a deliberation.
Read your full persona: .claude/skills/[skill]/SKILL.md — follow the Teammate Mode section.

## Context Brief
[project state summary]

## Previous Reports
[any reports from earlier in this round]

## Task
Review following your Review Mode process. File complaints if warranted.
Return output between ---BEGIN REPORT--- / ---END REPORT--- and ---BEGIN COMPLAINTS--- / ---END COMPLAINTS--- markers.
```
