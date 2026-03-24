---
name: autoplan
description: Deliberation engine. Roles argue, push back, and iterate until consensus. Three tiers based on project state. Saves reports per role to docs/reports/. One command, full team review.
activates_when: auto review, run all reviews, autoplan, review pipeline, full plan review, deliberate
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Autoplan - Deliberation Engine

Not a linear pipeline. A **boardroom** where the roles argue.

Each role reviews, files complaints against other roles' decisions, and forces rebuttals. The loop continues until consensus or the user breaks the tie. Every round saves a report to `docs/reports/[role]/`.

---

## Three Tiers

Detect automatically from project state, or user specifies.

### Tier 1: Greenfield (nothing exists)

**Trigger:** No plan file, no codebase, or user says "new idea" / "starting fresh"

```
Ma (brainstorm) → Jobs (scope) → Torvalds (architecture) → Dyson (design) → Atrioc (positioning)
     ↑                ↑                  ↑                      ↑                ↑
     └────────────────┴──────────────────┴──────────────────────┴────────────────┘
                              complaints flow backwards
```

**All roles participate. Everything is open. Maximum deliberation.**

| Order | Role | Reads | Produces | Can Complain To |
|-------|------|-------|----------|-----------------|
| 1 | Ma (Brainstorm) | User input | `docs/reports/brainstorm/[date]-discovery.md` | — (first mover) |
| 2 | Jobs (CEO) | Brainstorm report | `docs/reports/ceo/[date]-scope.md` | Ma ("demand isn't validated") |
| 3 | Torvalds (Eng) | CEO scope report | `docs/reports/engineering/[date]-architecture.md` | Jobs ("scope is unbuildable"), Ma ("wrong wedge") |
| 4 | Dyson (Design) | Eng architecture | `docs/reports/design/[date]-dimensions.md` | Torvalds ("architecture kills UX"), Jobs ("vision lost in implementation") |
| 5 | Atrioc (Marketing) | All above | `docs/reports/marketing/[date]-positioning.md` | Jobs ("users won't understand this"), Dyson ("design doesn't communicate value") |

### Tier 2: Work-in-Progress (something half-assed exists)

**Trigger:** Existing plan file, partial codebase, or user says "review this"

```
Jobs (scope) → Torvalds (architecture) → Dyson (design) → Atrioc (positioning)
     ↑                  ↑                      ↑                ↑
     └──────────────────┴──────────────────────┴────────────────┘
                         complaints flow backwards
```

**Skip brainstorm. Demand is assumed. Focus on shaping what exists.**

### Tier 3: Polish (solid, needs refinement)

**Trigger:** Mature codebase, or user says "polish" / "refine" / "almost done"

```
Torvalds (architecture) → Dyson (design)
         ↑                      ↑
         └──────────────────────┘
```

**No scope changes. Engineering and design only. Tight iteration loop.**

---

## The Complaint System

### How Complaints Work

After each role reviews, they can file **complaints** against previous roles' decisions. A complaint is a specific objection with evidence and a proposed alternative.

```markdown
## Complaint: [Role] → [Target Role]

**Report cited:** docs/reports/[target]/[file].md
**Section:** [which decision]
**Objection:** [what's wrong — specific, not vague]
**Evidence:** [why this is wrong — data, precedent, or principle]
**Proposed fix:** [what should change]
**Severity:** Block (can't proceed) | Push-back (should reconsider) | Note (minor concern)
```

### Complaint Severity

| Severity | What Happens |
|----------|-------------|
| **Block** | Deliberation pauses. Target role MUST respond before pipeline continues. |
| **Push-back** | Target role reviews the objection in next round. Pipeline continues. |
| **Note** | Logged for the record. No response required. |

### Response Types

When a role receives a complaint, they respond with one of:

| Response | Meaning |
|----------|---------|
| **Accept** | "You're right. Changing my recommendation." Updated report saved. |
| **Modify** | "Partially right. Here's a compromise." Updated report with reasoning. |
| **Overrule** | "I hear you, but no. Here's why." Must cite a pivotal decision or principle. |
| **Escalate** | "We disagree and neither of us should decide. User needs to call this." |

### Deliberation Rounds

```
Round 1: Sequential reviews (each role reviews and may file complaints)
Round 2: Rebuttals (each complained-against role responds)
Round 3: Final (if Blocks remain unresolved → escalate to user)

Max 3 rounds. If still disagreeing after round 3 → user decides everything.
```

---

## The Deliberation Loop

### Round 1: Initial Reviews

Read each role's full SKILL.md and run their Review Mode:

**Step 1 — Brainstorm (Tier 1 only)**
- Read `skills/brainstorm/SKILL.md`
- Run Ma's 6 forcing questions
- Save: `docs/reports/brainstorm/[date]-[project]-discovery.md`

**Step 2 — CEO Scope**
- Read `skills/plan-review-ceo/SKILL.md`
- Read previous reports (brainstorm if Tier 1)
- Run Jobs Test, choose scope mode, build the no-list
- File complaints against brainstorm if demand assumptions are weak
- Save: `docs/reports/ceo/[date]-[project]-scope.md`

**Step 3 — Engineering Architecture**
- Read `skills/plan-review-eng/SKILL.md`
- Read CEO scope report
- Run architecture checklist, data structures audit, failure modes
- File complaints against CEO if scope is unbuildable / too complex / wrong abstraction level
- Save: `docs/reports/engineering/[date]-[project]-architecture.md`

**Step 4 — Design Dimensions**
- Read `skills/plan-review-design/SKILL.md`
- Read engineering architecture report
- Rate all 8 dimensions, run AI slop check, assumption test
- File complaints against engineering if architecture kills UX
- File complaints against CEO if vision was lost in implementation details
- Save: `docs/reports/design/[date]-[project]-dimensions.md`

**Step 5 — Marketing Positioning (Tier 1 & 2 only)**
- Read `skills/marketing/SKILL.md`
- Read all previous reports
- Run positioning framework, Bar Test, Cringe Test
- File complaints against CEO if users won't understand the product
- File complaints against design if the UI doesn't communicate the value prop
- Save: `docs/reports/marketing/[date]-[project]-positioning.md`

### Round 2: Rebuttals

For each complaint filed in Round 1:

1. Load the target role's SKILL.md (to stay in character)
2. Read the complaint
3. Respond: Accept / Modify / Overrule / Escalate
4. If Accept or Modify: save updated report as `[date]-[project]-[type]-round2.md`
5. If Overrule: must cite a pivotal decision or core principle from the persona
6. If Escalate: add to the user decision queue

**Key rule:** When a role Accepts or Modifies, downstream roles that depend on that decision must re-validate their affected sections. Example: If CEO narrows scope after eng complaint, design must re-check if dimension ratings still apply.

### Round 3: Resolution (if needed)

If any **Block** complaints are still unresolved:

1. Surface all unresolved disagreements to the user
2. Present both sides with evidence
3. User decides
4. Update reports with final decisions
5. Mark complaints as resolved

### Auto-Decision Principles

For complaints that can be resolved without the user (Push-back and Note severity):

1. **User intent wins** — If the user's original plan clearly states a preference
2. **Simpler wins** — Between two approaches, fewer moving parts
3. **Data wins** — Benchmarks, user research, or metrics decide
4. **Reversibility wins** — Choose the option easier to undo
5. **Shipping wins** — If both are close, ship sooner
6. **Escalate** — If none of the above resolve it, ask the user

---

## What Gets Auto-Decided vs Escalated

| Auto-decide | Escalate to user |
|------------|-----------------|
| Eng says "add an index" → always yes | CEO vs Eng on scope (vision vs buildability) |
| Design says "fix spacing" → always yes | Two valid architectures with different tradeoffs |
| Marketing says "kill this buzzword" → always yes | Feature cuts that change the product's identity |
| Security hardening → always yes | Performance vs developer experience tradeoffs |
| Bug fixes → always yes | Design changes that alter brand personality |
| Obvious simplification → always yes | Marketing positioning that changes target audience |

---

## Common Argument Patterns

Real tensions that surface in deliberation:

### CEO vs Engineering
```
Jobs: "Add real-time collaboration"
Torvalds: "That's 3 months of infrastructure for a V1. Block."
Resolution: Jobs Modifies → "Add presence indicators only. Defer editing."
```

### Engineering vs Design
```
Torvalds: "Server-side render everything for performance"
Dyson: "That kills client-side interactivity. The form flow becomes impossible. Block."
Resolution: Torvalds Modifies → "SSR for content pages, CSR for interactive flows"
```

### Marketing vs CEO
```
Atrioc: "Nobody outside your team understands what 'neural mesh routing' means. Push-back."
Jobs: "Accept. Rename to 'smart routing.' Lead with the outcome."
```

### Design vs Marketing
```
Dyson: "The hero section needs more whitespace for visual hierarchy"
Atrioc: "You're pushing the CTA below the fold. Push-back."
Resolution: Dyson Modifies → "Reduce hero padding by 30%, keep hierarchy with type scale instead"
```

---

## Report File Format

Every report follows this structure:

```markdown
# [Role] Report: [Project Name]

**Date:** [YYYY-MM-DD]
**Tier:** [Greenfield / WIP / Polish]
**Round:** [1 / 2 / 3]
**Status:** [Initial / Updated after complaint / Final]

---

## Review

[Full review content following the role's SKILL.md Review Mode output format]

---

## Complaints Filed

### Complaint #1 → [Target Role]
- **Severity:** Block / Push-back / Note
- **Report cited:** [path]
- **Objection:** [specific issue]
- **Evidence:** [why — from persona's principles/decisions]
- **Proposed fix:** [what should change]

---

## Complaints Received

### From [Role] — Complaint #N
- **Severity:** [level]
- **Objection:** [what they said]
- **Response:** Accept / Modify / Overrule / Escalate
- **Reasoning:** [why — citing persona's principles]
- **Changes made:** [what was updated, or why nothing changed]

---

## Final Verdict

[Role's final recommendation after all deliberation]
```

---

## Final Output

After deliberation completes, generate a summary:

**Saved to:** `docs/reports/[date]-[project]-summary.md`

```markdown
# Deliberation Summary: [Project Name]

**Date:** [date]
**Tier:** [Greenfield / WIP / Polish]
**Rounds:** [1-3]
**Consensus reached:** [Yes / No — user decided]

## Participants
| Role | Report | Complaints Filed | Complaints Received |
|------|--------|-----------------|-------------------|
| [role] | [link] | [count] | [count] |

## Key Decisions
| # | Decision | Decided By | Method |
|---|----------|-----------|--------|
| 1 | [decision] | [role or user] | [auto / complaint resolved / user escalation] |

## Unresolved Tensions
[Any disagreements that were overruled rather than resolved — may resurface later]

## Action Items
- [ ] [action from CEO review]
- [ ] [action from eng review]
- [ ] [action from design review]
- [ ] [action from marketing review]

## One-Sentence Product
[The final one-sentence description after all reviews]
```

Also updates:
- `docs/DECISIONS.md` — Append decisions from the deliberation
- `docs/TODO.md` — Append action items

---

## Checklist

```
- [ ] Tier detected (Greenfield / WIP / Polish)
- [ ] Round 1: All roles reviewed and filed complaints
- [ ] Round 2: All complaints responded to (Accept/Modify/Overrule/Escalate)
- [ ] Round 3: Unresolved Blocks escalated to user (if any)
- [ ] Reports saved to docs/reports/[role]/ for each round
- [ ] Summary saved to docs/reports/[date]-[project]-summary.md
- [ ] DECISIONS.md updated
- [ ] TODO.md updated
- [ ] All report files cross-reference each other
```
