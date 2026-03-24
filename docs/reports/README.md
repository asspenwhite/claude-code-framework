# Reports

Your project's institutional memory. Every review, every incident, every decision — filed and searchable.

## Departments

```
reports/
├── brainstorm/       Product discovery — demand validation, wedge strategy
├── ceo/              Scope & vision — what to build, what to cut
├── engineering/      Architecture — data structures, interfaces, failure modes
├── design/           Design — 8 dimensions rated 0-10, AI slop grades
├── marketing/        Positioning — copy teardowns, voice audits, landing pages
├── incidents/        Incidents — auto-generated when something breaks
├── qa/               QA — test reports with 7-category bug taxonomy
├── security/         Security — audit findings, vulnerability assessments
└── retrospective/    Retrospective — session summaries, compounding lessons
```

## What Gets Filed Automatically

| Event | Report | Location |
|-------|--------|----------|
| Something breaks | Incident report (P0-P3 severity, root cause, prevention) | `incidents/` |
| `/framework-launch` runs | Each role's review + deliberation summary | Role folders + summary |
| `/qa` runs | Test report with categorized issues | `qa/` |
| `/security-audit` | Security findings | `security/` |
| `/reflect` | Session retrospective | `retrospective/` |
| Any individual role review | That role's report | Role folder |

## File Naming

```
[YYYY-MM-DD]-[project-or-feature]-[type].md

Examples:
  2026-03-24-auth-redesign-scope.md
  2026-03-24-auth-redesign-architecture.md
  2026-03-24-auth-redesign-round2-rebuttal.md
  2026-03-24-login-crash-incident.md
```

## Deliberation Paper Trail

During `/framework-launch`, departments argue. The paper trail shows how decisions were made:

```
ceo/scope.md                           CEO sets scope
  → engineering/architecture.md        Eng reviews, files complaint: "scope too broad"
    → ceo/scope-round2.md             CEO rebuts: narrows scope, cites "350 → 10 products"
      → engineering/arch-round2.md    Eng accepts narrowed scope
        → design/dimensions.md        Design reviews, files complaint: "layout won't work"
          → engineering/arch-round3.md Eng adjusts architecture
            → [date]-summary.md       Final consensus with all decisions
```

## Reading Reports

Start with the **latest** report in each folder. Earlier reports show the deliberation history — useful for understanding WHY decisions were made.

Summaries (in the root of `reports/`) aggregate all decisions, unresolved tensions, and action items from a deliberation.
