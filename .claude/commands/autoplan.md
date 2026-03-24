Run the full review pipeline automatically — CEO → Eng → Design.

$ARGUMENTS

Load and follow the **Review Mode** section in: .claude/skills/autoplan/SKILL.md

Process:
1. Read the plan (active plan file, $ARGUMENTS, or ask)
2. CEO Review (Steve Jobs) — scope decision, one-sentence test, the no list
3. Eng Review (Linus Torvalds) — architecture verdict, data structures, failure modes
4. Design Review (James Dyson) — 8 dimensions rated 0-10, AI slop grade
5. Surface taste decisions for approval (only the hard calls)
6. Save full report to docs/PLAN_REVIEW.md
7. Update docs/DECISIONS.md and docs/TODO.md with new items

Auto-decides using 6 principles: user intent → simpler → data → reversible → ships sooner → flag.
