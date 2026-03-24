# Claude Code Skills

Skills are the core building blocks of the framework. Each skill works in **two modes**:

1. **Auto-activate** — Core rules load automatically when your task matches. Prevention during creation.
2. **Review mode** — Invoked manually via `/command` for comprehensive audits. Structured output.

---

## How Skills Work

```
You type code → Skills auto-activate → Core rules apply
You type /command → Skill loads Review Mode → Full checklist runs
```

Skills load in 3 levels (progressive disclosure):
1. **Metadata** (~100 tokens) — Always loaded (name, description, activates_when)
2. **SKILL.md body** — When task matches activation trigger
3. **Reference files** — Only when specifically needed (PATTERNS.md, CHECKLIST.md, etc.)

---

## Core Skills (Always Active)

### docs-safety → `/docs-update`
**Activates when:** Modifying TODO.md, CHANGELOG.md, or docs/ files

Prevents documentation mistakes:
- Never delete completed items (mark as [x])
- Add to existing sections (no parallel structures)
- Ask before flagging real data as placeholder

### code-review → `/code-review`
**Activates when:** Writing or modifying code files

Enforces code quality with **Fix-First policy**:
- AUTO-FIX safe issues (dead code, console.log, unused imports)
- ASK about risky changes (security, design decisions)

### design-review → `/design-review`
**Activates when:** Building UI components, styling, visual work

Ensures UI quality with AI slop detection:
- Consistency with design system
- Responsive design patterns
- Letter grade (A-F) using Bruno Sacco's blacklist

### security-audit → `/security-audit`
**Activates when:** Auth, API routes, database queries, user data

Enforces security patterns:
- Server-side validation always
- Input sanitization
- Secrets management

### accessibility → `/accessibility`
**Activates when:** Building UI, forms, interactive elements

WCAG 2.1 AA compliance:
- Color contrast 4.5:1
- Keyboard navigation
- Screen reader compatibility

### user-flow-test → `/user-flow-test`
**Activates when:** Building auth flows, checkout, multi-step processes

End-to-end journey integrity:
- Flow completeness
- Error recovery
- Session persistence

---

## Feature Skills

### frontend-design *(Bruno Sacco persona)*
**Activates when:** UI components, pages, styling

Prevents "AI slop" — the generic patterns Claude defaults to:
- No Inter/Roboto, purple gradients, cookie-cutter layouts
- Timeless, not fashionable

### security
**Activates when:** Auth flows, payments

Deep security patterns with reference files:
- `PATTERNS.md` — Code patterns
- `CHECKLIST.md` — Pre-commit checklist
- `FILES.md` — Critical files

---

## Pipeline Skills

### _preamble (always active)
Common behaviors injected into every session.

### brainstorm → `/brainstorm` *(Jack Ma persona)*
Product discovery and idea validation.

### plan-review-ceo → `/ceo-review` *(Steve Jobs persona)*
CEO/founder scope review — find the 10-star experience.

### plan-review-eng → `/eng-review` *(Linus Torvalds persona)*
Engineering architecture review — lock the execution plan.

### plan-review-design → `/design-review-plan` *(James Dyson persona)*
Design dimension review — rate each dimension 0-10.

### autoplan → `/autoplan`
Deliberation engine — roles argue until consensus. Three tiers (Greenfield / WIP / Polish). Complaints flow between roles. Max 3 rounds. Reports saved per role to `docs/reports/`.

### planner → `/plan`
Architecture planning and implementation sequencing.

### investigation → `/investigate`
Root cause debugging — no fixes without confirmed cause.

### tdd
Test-driven development patterns — Red → Green → Refactor.

### performance *(Lisa Su persona)*
Performance optimization — every cycle counts.

### ai-slop-detection *(Bruno Sacco persona)*
Formal AI design anti-pattern blacklist with letter grades.

### marketing → `/marketing` *(Atrioc persona)*
Content strategy, positioning, and go-to-market — kill the corporate speak.

### qa → `/qa`
Quality assurance with 7-category issue taxonomy.

### shipping → `/ship`
PR creation, version bumping, changelog updates.

### reflect → `/reflect` *(Warren Buffett persona)*
Session retrospective — compound your lessons.

---

## Creating Custom Skills

### Dual-Mode SKILL.md Format

```markdown
---
name: skill-name
description: When this skill should activate. Be specific.
activates_when: specific triggers
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Skill Name

## Core Rules (auto-activate)
Quick patterns that apply during creation.

## Checklist
- [ ] Rule 1 followed
- [ ] Rule 2 followed

---

## Review Mode (/command-name)
Full checklist for comprehensive audits.

### Output Format
Structured findings template.
```

### Guidelines

- **SKILL.md under 500 lines** — Ideally 50-120
- **Put details in reference files** — Load on demand
- **Use tables for quick scanning** — Not prose
- **Include a checklist** — Verifiable completion criteria
- **Add Review Mode** if the skill should be invocable via /command
