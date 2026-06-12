# Incident Report — [one-line description of what broke]

| | |
|---|---|
| **Date** | YYYY-MM-DD |
| **Severity** | SEV-1 (Critical) / SEV-2 (High) / SEV-3 (Moderate) / SEV-4 (Low) |
| **Status** | Open / Mitigated / Resolved |
| **Duration** | [first symptom → full recovery, or best estimate] |
| **Detection** | [Monitoring alert / user-reported / found during unrelated work] |
| **Trigger** | [Operator change / deploy / external dependency / hardware / unknown] |

---

## Summary

2–4 sentences: what broke, the mechanism, and the blast radius. Write it so
someone who wasn't there understands the incident without reading further.

## Impact

| Asset | Impact | Data loss |
|-------|--------|-----------|
| [system/service] | [what was unavailable or degraded] | None / [details] |

## Timeline

| Time | Event |
|------|-------|
| HH:MM | [First change / first symptom] |
| HH:MM | [Detection] |
| HH:MM | [Diagnosis steps — include wrong turns, they're the lessons] |
| HH:MM | [Fix applied] |
| HH:MM | [Verified recovered] |

## Root Cause

The actual mechanism, not the proximate symptom. If an API call replaced an
array instead of merging it, say that. If a staged-but-unapplied change got
re-asserted by a later operation, say that. "X was misconfigured" is a
symptom — *why* it was misconfigured is the root cause.

## Resolution

What fixed it, exactly — commands, config values, reverted changes. Enough
detail to repeat (or reverse) the fix.

## Lessons Learned

- **What worked:** [detection, rollback path, docs that helped]
- **What didn't:** [missing monitoring, docs gaps, assumptions that bit]

## Follow-ups / Prevention

- [ ] [Concrete action item with owner, e.g. "snapshot raw object before every mutating API call"]
- [ ] [Doc to update, e.g. RUNBOOK gotchas section]
- [ ] [Monitoring/alert to add]

---

## Conventions

- **File naming:** `docs/INCIDENT-YYYY-MM-DD-short-slug.md` (sorts chronologically, greppable)
- **Write it the same day.** Detail decays fast; the timeline is the first thing you lose.
- **Never delete or rewrite an incident report.** Append corrections with a dated note.
- **Cross-link:** reference the CHANGELOG entry for the change that triggered it, and link the incident from any RUNBOOK gotcha it produced.
