---
name: shipping
description: PR creation, version bumping, and release workflows. Auto-activates when preparing to ship, merge, or release code.
activates_when: creating PR, shipping, deploying, releasing, version bump, changelog update
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Shipping - Release Workflow

"Ship with confidence" — automate the boring, verify the important.

## Core Rules (auto-activate)

```
✓ Sync with base branch before creating PR
✓ Run full quality gate (build → typecheck → lint → test)
✓ Version bump follows semver (patch/minor/major)
✓ CHANGELOG updated under [Unreleased]
✓ PR description includes what/why/how + test plan
✓ One logical change per PR
✗ Don't ship with failing tests
✗ Don't skip the changelog
✗ Don't force-push without explicit approval
```

### Semver

```
MAJOR.MINOR.PATCH

PATCH — Bug fixes, no API changes
MINOR — New features, backwards compatible
MAJOR — Breaking changes
```

### PR Description Template

```markdown
## What
[One sentence describing the change]

## Why
[Motivation — the problem this solves]

## How
[Technical approach — key decisions made]

## Test Plan
- [ ] Unit tests pass
- [ ] Manual testing done
- [ ] Edge cases verified
```

## Checklist

```
- [ ] Base branch synced
- [ ] Tests passing
- [ ] Lint clean
- [ ] Build succeeds
- [ ] CHANGELOG updated
- [ ] Version bumped (if applicable)
- [ ] PR description complete
```

---

## Review Mode (/ship)

Full shipping workflow with quality gates.

### Ship Process

1. **Sync** — Merge/rebase with base branch
2. **Quality Gate** — Build → TypeCheck → Lint → Test → Security check
3. **Version** — Bump version following semver
4. **Changelog** — Update CHANGELOG.md under [Unreleased] with all changes
5. **Diff Review** — Quick review of full diff for anything missed
6. **PR** — Create PR with descriptive title and what/why/how body
7. **Verify** — Confirm CI passes on the PR

### Output Format

```markdown
## Ship Report

### Quality Gates
| Gate | Status |
|------|--------|
| Build | Pass/Fail |
| TypeCheck | Pass/Fail |
| Lint | Pass/Fail |
| Tests | Pass/Fail (X/Y passing) |

### Version
- Previous: X.Y.Z
- New: X.Y.Z+1
- Type: patch/minor/major

### Changelog
[Changes added]

### PR
- URL: [PR URL]
- Title: [PR title]
```
