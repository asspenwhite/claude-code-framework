---
name: code-review
description: Code quality patterns for TypeScript and React. Auto-activates when writing or modifying code files.
activates_when: writing code, editing functions, creating components, refactoring
allowed-tools: Read, Write, Edit, Glob, Grep, mcp__context7__resolve-library-id, mcp__context7__query-docs
---

# Code Review - Quality Patterns

"Simple, Secure, Maintainable" — catch bugs and enforce patterns before they ship.

## TypeScript

```
✓ Explicit types for function parameters
✓ Interfaces over type aliases for objects
✓ Zod schemas for external/user data
✓ Proper error handling with typed errors
✗ No `any` types without justification
✗ No implicit any
✗ No type assertions without validation
```

## React Patterns

```
✓ Keys on mapped elements
✓ Loading and error states handled
✓ Empty states designed
✓ Proper cleanup in useEffect
✗ No unnecessary useEffect
✗ No inline object/function definitions in props
✗ No state that can be derived
```

## Code Quality

```
✓ Error messages are user-friendly
✓ Constants instead of magic numbers
✓ DRY - extract repeated logic
✓ Single responsibility functions
✗ No console.log in production
✗ No commented-out code
✗ No overly complex functions (>50 lines)
```

## Performance

```
✓ Memoize expensive calculations
✓ Lazy load heavy components
✓ Paginate large lists
✗ No N+1 queries
✗ No unnecessary re-renders
✗ No blocking operations on main thread
```

## Security

```
✓ Validate all user input
✓ Sanitize output to prevent XSS
✓ Use parameterized queries
✗ No secrets in client code
✗ No eval() or innerHTML with user data
```

## Checklist

```
- [ ] Types are explicit and correct
- [ ] Error states handled
- [ ] No console.log left behind
- [ ] Performance considered
- [ ] Security checked
```

---

## Review Mode (/code-review)

**Philosophy:** "Simple, Secure, Maintainable" — catch bugs and enforce patterns before they ship.

### When to Invoke

- Before merging PRs
- After significant changes
- During refactoring
- When onboarding new patterns

### Diff-Aware

When invoked, scope to branch diff by default. Run `.claude/hooks/diff-scope.sh` to get changed files. Review only those files unless full audit requested.

### Fix-First Policy

Don't just list findings — act on them.

**AUTO-FIX** (do it, don't ask):
- Dead code removal
- Unused imports
- `console.log` removal
- Magic numbers → named constants
- Stale/outdated comments
- N+1 queries → batch queries
- Missing error handling on awaits

**ASK** (report to user, don't auto-fix):
- Security implications
- Race conditions
- Design decisions
- Changes > 20 lines
- Breaking API changes
- Enum completeness changes

**Suppressions** (do NOT flag):
- Test files (`*.test.*`, `*.spec.*`) — relaxed rules
- Generated code — don't touch
- Intentional patterns marked with `// eslint-disable` or `// @ts-ignore` with explanation

### Full Checklist

#### Error Handling
- [ ] Async operations have try/catch
- [ ] Errors logged appropriately
- [ ] User sees helpful error messages
- [ ] Errors don't expose sensitive info

#### TypeScript
- [ ] No `any` types (except justified cases)
- [ ] Proper type definitions
- [ ] Null checks where needed
- [ ] Consistent interfaces

#### React Patterns
- [ ] No unnecessary re-renders
- [ ] Proper key props on lists
- [ ] useEffect dependencies correct
- [ ] Loading/error states handled

#### Code Quality
- [ ] No commented-out code
- [ ] No console.logs in production
- [ ] Functions do one thing
- [ ] Names are descriptive

#### Security Basics
- [ ] No hardcoded secrets
- [ ] Input validation present
- [ ] Auth checks in place
- [ ] Data properly sanitized

### Tools

1. **Grep** for patterns — `any` types, console.log, hardcoded secrets
2. **Read** changed files
3. **TypeScript** compiler output

### Output Format

```markdown
## Code Review Results

### Auto-Fixed
| File | Fix | Lines |
|------|-----|-------|

### Needs Discussion
| File | Issue | Severity | Question |
|------|-------|----------|----------|

### Summary
- Auto-fixed: X | Needs discussion: X | Passing: X
```

---

## Verification Retry Loop

After applying fixes, verify they actually work. Max 3 cycles before escalating to user.

```
Cycle 1: Apply fix → run check (build/lint/test) → pass? Done. Fail? →
Cycle 2: Analyze failure → apply refined fix → run check → pass? Done. Fail? →
Cycle 3: Analyze again → apply fix → run check → pass? Done. Fail? →
STOP: Escalate to user. "I've tried 3 fixes and the check still fails. Here's what I tried and what's still breaking."
```

**Rules:**
- Each cycle must try a DIFFERENT approach, not the same fix again
- Log what was tried and why it failed
- After 3 failures, your mental model of the problem is wrong — stop digging (Buffett principle)
- Never silently skip a failing check
