---
name: user-flow-test
description: End-to-end user journey testing patterns. Auto-activates when building user flows, authentication, or multi-step processes.
activates_when: building auth flows, checkout flows, multi-step forms, user journeys
allowed-tools: Read, Write, Edit, Glob, Grep, mcp__playwright__browser_navigate, mcp__playwright__browser_click, mcp__playwright__browser_fill_form, mcp__playwright__browser_wait_for, mcp__playwright__browser_take_screenshot
---

# User Flow Test - Journey Verification

"Test Like a User" — verify complete user journeys work end-to-end.

## Core Rules (auto-activate)

### Flow Integrity

```
✓ Every step has a clear next action
✓ Back navigation works at every step
✓ Error recovery returns to correct step
✓ Session state persists across page refreshes
✗ No dead-end states
✗ No orphaned form data on navigation
✗ No silent failures
```

### Auth Flow Patterns

```
✓ Sign up → verify → sign in works end-to-end
✓ Sign out clears all session state
✓ Protected routes redirect to login
✓ Session refresh doesn't lose user context
✗ No auth state that only exists client-side
```

### Edge Cases to Consider

```
✓ Browser back/forward during multi-step flows
✓ Double-click/submit prevention
✓ Network interruption mid-flow
✓ Session expiry during long forms
✓ Concurrent sessions behavior
```

## Checklist

```
- [ ] Happy path works end-to-end
- [ ] Error states handled gracefully
- [ ] Back/forward navigation correct
- [ ] Session state persists on refresh
- [ ] Edge cases considered
```

---

## Review Mode (/user-flow-test)

Comprehensive end-to-end user journey testing.

### When to Invoke

- Before major releases
- After flow changes
- When bugs are reported
- During QA cycles

### Test Checklist

#### Authentication Flows
- [ ] Sign up works
- [ ] Sign in works
- [ ] Password reset works
- [ ] Sign out works
- [ ] Session persists on refresh

#### Core User Journeys
- [ ] Primary conversion flow (signup → purchase → success)
- [ ] Content consumption flow
- [ ] Account management flow
- [ ] Error recovery flows

#### Edge Cases
- [ ] Invalid input handling
- [ ] Network errors
- [ ] Session expiry
- [ ] Concurrent sessions
- [ ] Browser back/forward

#### Payment Flows (if applicable)
- [ ] Checkout completes
- [ ] Success page shows correctly
- [ ] Failure handled gracefully
- [ ] Webhooks processed

### Tools

1. **Playwright MCP**
   - `browser_navigate` — Go to pages
   - `browser_fill_form` — Fill forms
   - `browser_click` — Click buttons
   - `browser_wait_for` — Wait for elements
   - `browser_take_screenshot` — Document results

2. **Test data** — Use test accounts and test payment methods

### Flow Templates

#### Authentication Flow
```
1. Navigate to /signup
2. Fill registration form
3. Submit and verify redirect
4. Check email verification (if applicable)
5. Sign in with credentials
6. Verify dashboard loads
```

#### Purchase Flow
```
1. Browse to product
2. Add to cart / Start checkout
3. Fill payment details
4. Complete purchase
5. Verify success page
6. Check order created
```

### Output Format

```markdown
## User Flow Test Results

### Flow: [Flow Name]

#### Steps Executed
| Step | Action | Result | Screenshot |
|------|--------|--------|------------|

#### Issues Found
| Step | Issue | Severity | Notes |
|------|-------|----------|-------|

#### Summary
- Steps: X passed, X failed
- Status: PASS / FAIL
```
