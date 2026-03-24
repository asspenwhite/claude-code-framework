# Reports

Your project's institutional memory. Every review, incident, and decision is filed here — like a real company's paper trail.

## Structure

```
reports/
├── brainstorm/       # Jack Ma — product discovery, demand validation
├── ceo/              # Steve Jobs — scope decisions, vision, the no-list
├── engineering/      # Linus Torvalds — architecture verdicts, complexity audits
├── design/           # James Dyson — dimension ratings, AI slop grades
├── marketing/        # Atrioc — positioning, copy teardowns, voice audits
├── incidents/        # Auto-generated when something breaks (P0-P3 severity)
├── qa/               # QA test reports, bug taxonomies
├── security/         # Security audit findings
└── retrospective/    # Warren Buffett — session summaries, compounding lessons
```

## What Gets Auto-Generated

| Event | Report Location | Trigger |
|-------|----------------|---------|
| Something breaks | `incidents/` | Investigation skill auto-activates |
| `/autoplan` runs | Each role's folder + summary | Manual command |
| `/qa` runs | `qa/` | Manual command |
| `/security-audit` runs | `security/` | Manual command |
| `/reflect` runs | `retrospective/` | Manual command |
| Individual role review | That role's folder | `/ceo-review`, `/eng-review`, etc. |

## Report Naming

```
[YYYY-MM-DD]-[project-or-feature]-[type].md

Examples:
  2026-03-23-auth-redesign-scope.md
  2026-03-23-auth-redesign-architecture.md
  2026-03-23-auth-redesign-round2-rebuttal.md
```

## Deliberation

Reports reference each other. When engineering disagrees with CEO scope, the engineering report includes a `## Complaints` section citing the CEO report. The CEO writes a rebuttal in a new report. This continues until consensus.

```
ceo/scope.md → engineering/architecture.md (complaint: scope too broad)
                → ceo/scope-round2.md (rebuttal: narrows scope)
                  → engineering/architecture-round2.md (accepts)
                    → design/dimensions.md (complaint: layout won't work)
                      → engineering/architecture-round3.md (adjusts)
```

## Reading Reports

Start with the **latest** report in each folder. Earlier reports show the deliberation history — useful for understanding WHY decisions were made, not just WHAT was decided.
