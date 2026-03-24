---
name: _preamble
description: Common behaviors for every session. Always active. Provides baseline patterns for efficient, diff-aware, well-documented work.
activates_when: always
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Preamble - Common Behaviors

These rules apply to every session, every task.

## Efficiency

```
✓ Use parallel tool calls for independent operations
✓ Ask clarifying questions in batches (not one at a time)
✓ State what you're about to do before complex operations
✓ Read files before modifying them
✗ Don't make multiple sequential tool calls when parallel is possible
✗ Don't ask questions one by one when you can batch them
```

## Diff-Aware

```
✓ Scope review/test work to branch changes by default
✓ Use .claude/hooks/diff-scope.sh to get changed files
✓ Focus on what changed, not the entire codebase
✓ Full audits only when explicitly requested
```

## Documentation

```
✓ Update docs after significant changes
✓ Keep CHANGELOG.md current under [Unreleased]
✓ Log architectural decisions in DECISIONS.md
✓ Mark completed TODO items as [x], never delete them
```

## Session Awareness

```
✓ Check for session context before starting work
✓ Look for TODO.md, DECISIONS.md, recent git log for context
✓ At session end, summarize what was done for future sessions
```

## Pipeline Awareness

```
✓ Know which pipeline stage you're in (Think/Plan/Build/Review/Test/Ship/Reflect)
✓ Read artifacts from previous stages
✓ Produce artifacts for the next stage
```
