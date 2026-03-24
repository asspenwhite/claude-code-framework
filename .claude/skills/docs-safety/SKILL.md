---
name: docs-safety
description: Critical rules for documentation updates. Auto-activates when modifying TODO.md, CHANGELOG.md, or any docs/ files. Prevents history deletion and organization mistakes.
activates_when: modifying docs, TODO.md, CHANGELOG.md, DECISIONS.md, API docs, README
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Docs Safety - Critical Rules

"Docs Are Code" — documentation should always reflect the current state of the code.

These rules apply EVERY TIME you touch documentation files.

## NEVER Do These

```
✗ Delete completed items from TODO.md
✗ Remove project history
✗ Create parallel structures (no "Phase 2:" when "Priority 1:" exists)
✗ Scatter related items across sections
✗ Assume something is test data without asking
✗ Rewrite entire files (make targeted edits)
```

## ALWAYS Do These

```
✓ Mark completed items as [x]
✓ Add to EXISTING sections
✓ Follow existing priority/organization structure
✓ Keep related items grouped
✓ Ask if unsure whether data is real
✓ Update "Last updated" dates
```

## Recovery

```bash
# If you mess up any doc
git checkout docs/TODO.md
git checkout docs/CHANGELOG.md
# Then make targeted edits only
```

## TODO.md Pattern

```markdown
# CORRECT - Add to existing section
### Priority 1: Current Work
- [x] Existing completed item     ← Keep this
- [ ] New item you're adding      ← Add here

# WRONG - Creating parallel structure
### Phase 2: New Work              ← Don't create this
- [ ] Item that belongs above
```

## Verification Before Flagging

Before flagging as "test data to remove":

| Item | Action |
|------|--------|
| Sponsors/Partners | ASK - may be real |
| Revenue numbers | ASK - could be real |
| User accounts | Check if seed data |
| Placeholder text | Safe to flag |

## Checklist

```
- [ ] No completed items deleted
- [ ] Added to existing sections
- [ ] Related items grouped
- [ ] Dates updated
- [ ] No parallel structures created
```

---

## Review Mode (/docs-update)

**Philosophy:** "Docs Are Code" — documentation should always reflect the current state of the code.

### When to Invoke

- After any code changes
- At end of work sessions
- Before PRs/commits
- When features are completed

### Documentation Checklist

#### CHANGELOG.md
- [ ] New features added under "Added"
- [ ] Changes listed under "Changed"
- [ ] Bug fixes under "Fixed"
- [ ] Removed features under "Removed"
- [ ] Security fixes under "Security"

#### TODO.md
- [ ] Completed tasks marked with [x]
- [ ] New tasks added with [ ]
- [ ] Priorities updated
- [ ] File paths included

#### DECISIONS.md
- [ ] New architectural decisions logged
- [ ] Context and reasoning captured
- [ ] Alternatives documented
- [ ] Date included

#### API.md (if API changed)
- [ ] New endpoints documented
- [ ] Request/response examples updated
- [ ] Auth requirements noted

#### SCHEMA.md (if database changed)
- [ ] New tables documented
- [ ] Column changes noted
- [ ] RLS policies listed

#### LOGIC_AUDIT.md (if flows changed)
- [ ] User states updated
- [ ] Page logic documented
- [ ] Edge cases listed

### Tools

1. **Git** — Check what changed: `git diff --name-only`, `git log --oneline -5`
2. **Read** — Review changed files
3. **Edit** — Update documentation

### CHANGELOG Format

```markdown
## [Unreleased]

### Added
- New feature description - File: `path/to/file.tsx`

### Changed
- What changed and why

### Fixed
- Bug that was fixed
```

### Decision Log Format

```markdown
## YYYY-MM-DD: Decision Title

- **Context:** Why did this come up?
- **Decision:** What we decided
- **Alternatives:** What else was considered
- **Reasoning:** Why this approach
```

### Output Format

```markdown
## Documentation Update Report

### Files Changed
- `src/file.ts` (NEW/MODIFIED)

### Updates Made
- CHANGELOG: Added X
- TODO: Marked Y complete

### Missing Documentation
| File | What's Missing |
|------|----------------|

### Verification
- [x] CHANGELOG reflects changes
- [ ] API.md needs endpoint documentation
```
