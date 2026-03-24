# Reports

Each role saves review reports to its own folder. During `/autoplan`, roles argue with each other — complaints flow between departments until consensus or the user decides.

## Structure

```
reports/
├── brainstorm/       # Jack Ma — product discovery, demand validation
├── ceo/              # Steve Jobs — scope decisions, vision, the no-list
├── engineering/      # Linus Torvalds — architecture verdicts, complexity audits
├── design/           # James Dyson — dimension ratings, AI slop grades
├── marketing/        # Atrioc — positioning, copy teardowns, voice audits
├── qa/               # QA test reports, bug taxonomies
├── security/         # Security audit findings
└── retrospective/    # Warren Buffett — session summaries, compounding lessons
```

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
