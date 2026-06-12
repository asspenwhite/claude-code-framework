# Documentation Workflow

How to keep docs in sync with code automatically.

---

## The Problem

Code changes but docs don't. Result: outdated documentation, confused developers, lost decisions.

## The Solution

This template enforces a **docs-as-code** workflow:
- Every change updates relevant docs
- Decisions are logged when made
- TODOs are tracked and completed
- Changelogs are maintained automatically

---

## Documentation Files

Your project should have these files in `docs/`:

| File | Purpose | Template |
|------|---------|----------|
| `README.md` | Project overview, setup, scripts | [PROJECT_README.template.md](templates/PROJECT_README.template.md) |
| `CHANGELOG.md` | Version history | [CHANGELOG.template.md](templates/CHANGELOG.template.md) |
| `TODO.md` | Active tasks by priority | [TODO.template.md](templates/TODO.template.md) |
| `DECISIONS.md` | Architectural decisions with context | [DECISIONS.template.md](templates/DECISIONS.template.md) |
| `API.md` | API routes, requests, responses | [API.template.md](templates/API.template.md) |
| `SCHEMA.md` | Database tables, RLS, queries | [SCHEMA.template.md](templates/SCHEMA.template.md) |
| `LOGIC_AUDIT.md` | User states, page logic, edge cases | [LOGIC_AUDIT.template.md](templates/LOGIC_AUDIT.template.md) |

Operational projects (a network, a hypervisor, a live service) add three more:

| File | Purpose | Template |
|------|---------|----------|
| `AS-BUILT.md` | Live state — what exists *right now*, snapshot-dated | [AS-BUILT.template.md](templates/AS-BUILT.template.md) |
| `RUNBOOK.md` | Access, write-safety rules, common ops, gotchas | [RUNBOOK.template.md](templates/RUNBOOK.template.md) |
| `INCIDENT-YYYY-MM-DD-slug.md` | One per outage, written same-day | [INCIDENT.template.md](templates/INCIDENT.template.md) |

For these repos the CHANGELOG doubles as an **append-only audit log**: every
change records the instruction, the action, and the rollback. See
`playbooks/README.md` for the full doctrine.

```
docs/
├── README.md        # Project overview
├── CHANGELOG.md     # Version history
├── TODO.md          # Active task list
├── DECISIONS.md     # Architectural decisions
├── API.md           # API documentation
├── SCHEMA.md        # Database schema
├── LOGIC_AUDIT.md   # User flow documentation
└── templates/       # Templates to copy from
```

### Using Templates

Copy templates to start each doc:

```bash
cp docs/templates/TODO.template.md docs/TODO.md
cp docs/templates/DECISIONS.template.md docs/DECISIONS.md
# etc.
```

Or let Claude create them when you run the customization prompt.

---

## CHANGELOG.md

Track all changes using [Keep a Changelog](https://keepachangelog.com/) format.

### Template

```markdown
# Changelog

All notable changes to this project.

## [Unreleased]

### Added
- New features go here

### Changed
- Changes to existing features

### Fixed
- Bug fixes

### Removed
- Removed features

### Security
- Security fixes

---

## [1.0.0] - YYYY-MM-DD

### Added
- Initial release features
```

### Rules

1. **Always update under [Unreleased]** - Never create new versions yourself
2. **Use correct categories** - Added/Changed/Fixed/Removed/Security
3. **Be specific** - Include file paths when relevant
4. **Update after every change** - Part of the completion process

---

## DECISIONS.md

Log architectural decisions as they're made.

### Template

```markdown
# Decision Log

Add new entries at the top.

---

## YYYY-MM-DD: Decision Title

- **Context:** Why did this come up?
- **Decision:** What did we decide?
- **Alternatives:** What else was considered?
- **Reasoning:** Why this approach?
- **Outcome:** What was the result?

---
```

### When to Log

- Choosing a technology/library
- Changing architecture patterns
- Security decisions
- Major refactors
- Anything you'd want to remember in 6 months

---

## TODO.md

Track active tasks with clear status.

### Template

```markdown
# Project TODO

Active tasks organized by priority.

---

## High Priority

- [ ] **Task name** - Description
  - File: `path/to/file.tsx`
  - Notes: Additional context

- [x] **Completed task** - Description
  - Completed: YYYY-MM-DD

---

## Medium Priority

- [ ] Task description

---

## Low Priority / Future

- [ ] Backlog items

---

## Completed

- [x] Historical completed items

---

*Last updated: YYYY-MM-DD*
```

### Rules

1. **Mark complete immediately** - When done, check it off
2. **Include file paths** - Where will this be implemented?
3. **Prioritize clearly** - High/Medium/Low
4. **Archive to Completed** - Don't delete, move to completed section

---

## LOGIC_AUDIT.md

Document user flows and application logic.

### Template

```markdown
# Logic Audit

User states, routing logic, and application flow.

---

## User States

| State | Description | Has Account | Has Paid |
|-------|-------------|-------------|----------|
| visitor | Not logged in | No | No |
| registered | Has account | Yes | No |
| subscribed | Paid customer | Yes | Yes |
| churned | Cancelled subscription | Yes | No |

---

## Page Logic

### /page-name

**File:** `src/app/page-name/page.tsx`

| Condition | Behavior |
|-----------|----------|
| Not logged in | Redirect to /login |
| Logged in | Show content |

**Status:** ✅ Implemented

---

## Edge Cases

### Edge Case Name
- ✅ How it's handled

---

## Testing Checklist

- [ ] Test scenario 1
- [ ] Test scenario 2
```

---

## Automated Documentation Updates

### Claude Instructions (in CLAUDE.md)

Add this to your CLAUDE.md:

```markdown
## Documentation Updates

After making changes, update relevant docs:

| Change Type | Update |
|-------------|--------|
| Any code change | `docs/CHANGELOG.md` under [Unreleased] |
| Complete a task | `docs/TODO.md` - mark as done |
| Architecture decision | `docs/DECISIONS.md` - add entry |
| User flow change | `docs/LOGIC_AUDIT.md` - update flow |
| API change | `docs/API.md` - update endpoints |
| Database change | `docs/SCHEMA.md` - update schema |
```

### Using the docs-update Agent

Run after any session with significant changes:

```bash
claude /docs-update
```

The agent will:
1. Check what files changed
2. Update CHANGELOG.md with changes
3. Mark completed TODOs
4. Verify docs match implementation
5. Report any missing documentation

---

## Best Practices

1. **Update docs with code** - Same commit, same PR
2. **Be specific in changelogs** - File paths, function names
3. **Log decisions immediately** - Before you forget the reasoning
4. **Review docs in PRs** - Docs changes should be reviewed too
5. **Run /docs-update regularly** - Catch drift before it accumulates

---

## Example Workflow

```
1. Make code changes
2. Update CHANGELOG.md under [Unreleased]
3. Mark TODO items complete
4. Log any decisions made
5. Run /docs-update to verify
6. Commit everything together
```
