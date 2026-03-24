# Development Pipeline

Think → Plan → Build → Review → Test → Ship → Reflect

Every project follows this pipeline. Each stage has specific skills, commands, and personas. Artifacts flow forward — each stage reads what the previous stage produced.

## The Pipeline

### Think — Validate the Idea

**Command:** `/brainstorm` (Jack Ma persona)
**Purpose:** Discover demand, challenge assumptions, find the narrowest wedge.

Jack Ma asks 6 forcing questions:
1. What demand exists right now?
2. What's the status quo? Why do people tolerate it?
3. Who is *desperate* for this? (Not "who might use it")
4. What's the narrowest wedge to enter?
5. What did you observe firsthand?
6. Where is this in 5 years?

**Output:** Design doc with problem, audience, wedge, risks, next steps.
**Skip when:** Bug fix, refactoring, or clear requirements already exist.

### Plan — Scope → Architecture → Design

Three review commands run in sequence:

| Order | Command | Persona | Question |
|-------|---------|---------|----------|
| 1 | `/ceo-review` | Steve Jobs | Is this insanely great? Is it the simplest version? |
| 2 | `/eng-review` | Linus Torvalds | Is the architecture clean? Will it scale? What breaks first? |
| 3 | `/design-review-plan` | James Dyson | Rate each design dimension 0-10. What makes it a 10? |

**Output:** Scope decision + architecture plan + design ratings.
**Skip when:** Small changes. Use `/plan` for just the architecture without persona reviews.

### Build — Implementation

Skills auto-activate during coding:

| Skill | What it guards |
|-------|---------------|
| code-review | TypeScript, React patterns, code quality |
| security-audit | Auth, API security, data protection |
| frontend-design (Bruno Sacco) | Timeless design, no AI slop |
| ai-slop-detection (Bruno Sacco) | Formal anti-pattern blacklist |
| accessibility | WCAG 2.1 AA compliance |
| performance (Lisa Su) | Every cycle counts |
| tdd | Red → Green → Refactor |
| docs-safety | Documentation integrity |

**Output:** Working code with guardrails applied during creation.

### Review — Quality Audit

Run review commands on the completed work:

```bash
/code-review          # Fix-First: auto-fixes safe issues, asks about risky ones
/security-audit       # Trust nothing client-side
/design-review        # Visual consistency + AI slop grade (A-F)
```

**Output:** Findings + auto-fixes applied. Remaining issues flagged for discussion.

### Test — Verification

```bash
/qa                   # 7-category issue taxonomy, diff-aware
/user-flow-test       # End-to-end journey verification
/accessibility        # WCAG 2.1 AA audit
```

**Output:** Test results with categorized issues and evidence.

### Ship — Release

**Command:** `/ship`
**Purpose:** Quality gates → version bump → changelog → PR creation.

Checklist:
1. Tests pass
2. Lint clean
3. Build succeeds
4. Version bumped (semver)
5. Changelog updated
6. PR created with what/why/how + test plan

**Output:** PR URL, version info.

### Reflect — Learn

**Command:** `/reflect` (Warren Buffett persona)
**Purpose:** Compound your lessons. Honest retrospective.

Warren Buffett asks:
- What worked? (Celebrate compounding wins)
- What didn't? (Be honest about mistakes)
- What patterns emerged? (Promote to CLAUDE.md)
- What decisions were made? (Document for future sessions)

**Output:** Session summary. Suggested additions to CLAUDE.md.

## When to Skip Stages

Not every change needs every stage.

| Change Type | Pipeline |
|-------------|----------|
| Typo fix | Build → Ship |
| Bug fix | Think → Build → Test → Ship |
| Small feature | Plan → Build → Review → Test → Ship |
| New feature | Think → Plan → Build → Review → Test → Ship → Reflect |
| Refactor | Plan → Build → Review → Test → Ship |
| Design overhaul | Think → Plan (all 3 reviews) → Build → Review → Test → Ship → Reflect |

## Diff-Aware Intelligence

Review, Test, and Ship stages scope to the branch diff by default. Run `.claude/hooks/diff-scope.sh` to get the list of changed files. This means:
- `/code-review` only reviews changed files
- `/qa` only tests affected paths
- `/ship` checks only the diff for quality gates

Full audits are available by passing "full" as an argument.

## Artifact Flow

```
Think     → design-doc.md
Plan      → reads design-doc → produces plan.md, architecture, design ratings
Build     → reads plan → produces code (skills auto-activate)
Review    → reads diff → produces findings + auto-fixes
Test      → reads findings → produces test results
Ship      → reads test results → produces PR
Reflect   → reads session → produces summary + CLAUDE.md suggestions
```
