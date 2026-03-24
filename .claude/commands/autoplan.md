Run the deliberation engine — roles argue until consensus.

$ARGUMENTS

Load and follow .claude/skills/autoplan/SKILL.md completely.

## Tier Detection

Detect automatically or from $ARGUMENTS:
- **"greenfield"** / no plan / "new idea" → Tier 1: Ma → Jobs → Torvalds → Dyson → Atrioc
- **"wip"** / existing plan / "review this" → Tier 2: Jobs → Torvalds → Dyson → Atrioc
- **"polish"** / "refine" / "almost done" → Tier 3: Torvalds → Dyson only

## Process

1. Detect tier from project state or $ARGUMENTS
2. For each role in tier order:
   a. Read the role's full SKILL.md
   b. Read all previous reports from this deliberation
   c. Run their Review Mode
   d. File complaints against previous roles (Block / Push-back / Note)
   e. Save report to docs/reports/[role]/[date]-[project]-[type].md
3. Round 2: Rebuttals — each complained-against role responds (Accept / Modify / Overrule / Escalate)
4. If Blocks remain after Round 2: Round 3 — escalate to user
5. Save summary to docs/reports/[date]-[project]-summary.md
6. Update docs/DECISIONS.md and docs/TODO.md

## Rules

- Max 3 rounds. After round 3, user decides everything unresolved.
- Overrule requires citing a pivotal decision or core principle from the persona.
- When a role Accepts/Modifies, downstream roles re-validate affected sections.
- Auto-decide using 6 principles: user intent → simpler → data → reversible → ships sooner → escalate.
- Every report cross-references the reports it read and the complaints it filed/received.
