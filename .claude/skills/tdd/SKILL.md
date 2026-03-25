---
name: tdd
description: Test-driven development patterns. Auto-activates when writing tests or implementing test-first workflows.
activates_when: writing tests, test-driven development, test failures, adding test coverage
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, mcp__context7__resolve-library-id, mcp__context7__query-docs
---

# TDD - Test-Driven Development

Red → Green → Refactor. Write the test first, then the code.

## Core Rules (auto-activate)

### The Cycle

```
1. RED    — Write a failing test for the behavior you want
2. GREEN  — Write the minimum code to make it pass
3. REFACTOR — Clean up while keeping tests green
```

### Test Quality

```
✓ Test behavior, not implementation
✓ One concept per test
✓ Tests are independent (no shared state between tests)
✓ Tests are deterministic (same result every time)
✓ Descriptive test names that read as documentation
✗ Don't test implementation details (private methods, internal state)
✗ Don't use random/time-dependent values without seeding
✗ Don't write tests that pass when the code is wrong
```

### Naming Convention

```
// Describe the behavior, not the method
"should return empty array when no items match filter"  // GOOD
"test filterItems"                                       // BAD

// Framework-agnostic patterns
describe("UserAuth", () => {
  it("should reject expired tokens")
  it("should refresh tokens before expiry")
  it("should redirect unauthenticated users to login")
})
```

### Test Pyramid

```
        /  E2E  \        Few, slow, expensive
       / Integration \    Some, moderate
      /    Unit Tests  \  Many, fast, cheap
```

- **Unit:** Pure functions, business logic, utilities
- **Integration:** API routes, database queries, component rendering
- **E2E:** Critical user flows only (auth, checkout, core journey)

### Library Docs

Before writing tests, verify testing framework APIs with Context7 MCP:

```
✓ Use Context7 to check test runner APIs (Jest, Vitest, Playwright, etc.)
✓ Verify matcher syntax — don't guess from memory, check current docs
✓ Check framework-specific setup/teardown patterns
```

## Checklist

```
- [ ] Test written before code
- [ ] Test fails for the right reason (not a syntax error)
- [ ] Minimum code written to pass
- [ ] Refactored after green
- [ ] Test name describes behavior
```
