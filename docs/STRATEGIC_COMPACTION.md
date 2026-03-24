# Strategic Compaction

Claude Code automatically compacts your context window when it approaches capacity. By default, this happens at ~95% — which often hits mid-thought, losing important context.

**Strategy:** Compact at logical phase transitions, not at arbitrary capacity limits.

## The Problem

Auto-compaction at 95% can:
- Lose track of which files were modified
- Forget key decisions made earlier in the session
- Drop the current plan mid-implementation
- Lose error context during debugging

## When to Compact

Compact at **phase transitions** in the pipeline:

| Transition | Good time to compact |
|------------|---------------------|
| Think → Plan | Research is done, decisions captured |
| Plan → Build | Architecture locked, ready to implement |
| Build → Review | Code written, ready for quality checks |
| Review → Test | Fixes applied, ready for verification |
| Test → Ship | Tests passing, ready to release |

**Never compact:**
- Mid-implementation (you'll lose file context)
- During debugging (you'll lose hypothesis chain)
- While reading multiple files (you'll lose cross-references)

## What to Preserve

Before compacting, summarize:

```markdown
## Session State

### What Worked
- Approach X solved problem Y
- Pattern Z was effective

### What Didn't
- Approach A failed because B
- Assumption C was wrong

### Decisions Made
- Chose X over Y because Z
- Architecture: [key decisions]

### Current State
- Files modified: [list]
- Tests: passing/failing
- Blockers: [any]

### Next Steps
1. Immediate next task
2. Follow-up tasks
3. Open questions
```

## How to Trigger

Tell Claude explicitly:
- "Let's compact before moving to implementation"
- "Save session state and compact"
- "We're done with research, compact and start building"

## Session Persistence

For multi-session work, save your session summary to a project note or CLAUDE.md before ending:

```markdown
## Session Notes (YYYY-MM-DD)

### Completed
- [x] Task 1
- [x] Task 2

### In Progress
- [ ] Task 3 — got through step 2, need to finish step 3

### Key Decisions
- Chose approach X for reason Y

### Resume From
File: src/feature.ts, line 45 — implementing the validation logic
```

This lets the next session pick up exactly where you left off.

## Integration with Pipeline

The pipeline stages are natural compaction boundaries. Each stage produces artifacts that survive compaction:
- Think → design doc
- Plan → plan document
- Build → committed code
- Review → findings in conversation
- Test → test results
- Ship → PR
- Reflect → session summary

As long as artifacts are written to files (not just in conversation), they survive compaction.
