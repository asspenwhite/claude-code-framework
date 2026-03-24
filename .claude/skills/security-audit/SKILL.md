---
name: security-audit
description: Security patterns for auth, API routes, and data protection. Auto-activates when working on authentication, API endpoints, database queries, or handling user data.
activates_when: auth, API routes, database queries, user data, payments, webhooks
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Security Audit - Protection Patterns

Apply these patterns when working on auth, APIs, or user data.

## Core Rule

**Trust nothing client-side. Server-side validation is the source of truth.**

## Authentication

```
✓ Verify session/token on every protected route
✓ Check user roles/permissions server-side
✓ Use secure session management
✓ Implement proper logout (invalidate tokens)
✗ Never trust client-side auth state alone
✗ Never skip auth checks for "internal" routes
✗ Never store sensitive data in localStorage
```

## API Security

```
✓ Validate all input parameters
✓ Use parameterized queries (prevent SQL injection)
✓ Rate limit public endpoints
✓ Return generic errors to clients
✗ Never expose stack traces to users
✗ Never trust request headers blindly
✗ Never log sensitive data
```

## Data Protection

```
✓ Encrypt sensitive data at rest
✓ Use HTTPS everywhere
✓ Implement proper CORS policies
✓ Sanitize user input before display (prevent XSS)
✗ Never store passwords in plain text
✗ Never expose internal IDs unnecessarily
✗ Never return more data than needed
```

## Secrets Management

```
✓ Use environment variables for secrets
✓ Different secrets per environment
✓ Rotate secrets regularly
✗ Never commit secrets to git
✗ Never log API keys or tokens
✗ Never expose secrets in client bundles
```

## Common Vulnerabilities

| Vulnerability | Prevention |
|---------------|------------|
| SQL Injection | Parameterized queries |
| XSS | Sanitize output, CSP headers |
| CSRF | CSRF tokens on mutations |
| Auth Bypass | Server-side checks always |
| Data Exposure | Minimal data in responses |

## Checklist

```
- [ ] Auth verified server-side
- [ ] Input validated
- [ ] Output sanitized
- [ ] Secrets not exposed
- [ ] Errors don't leak info
- [ ] Rate limiting in place
```

---

## Review Mode (/security-audit)

**Philosophy:** "Trust Nothing Client-Side" — every security check must happen on the server.

### When to Invoke

- Before deploying auth/payment changes
- After adding new API routes
- During security reviews
- After dependency updates

### Diff-Aware

When invoked, scope to branch diff by default. Run `.claude/hooks/diff-scope.sh` to get changed files. Focus on security-critical changes first.

### Full Audit Checklist

#### Authentication
- [ ] All protected routes check auth
- [ ] API routes verify session
- [ ] Middleware covers all paths
- [ ] Session handling is secure

#### Authorization
- [ ] Users can only access own data
- [ ] Admin routes check roles server-side
- [ ] RLS policies properly configured
- [ ] No privilege escalation possible

#### Payment Security
- [ ] Webhooks verify signatures
- [ ] Payment records created server-side only
- [ ] Refunds revoke access
- [ ] Price validation on server

#### Data Protection
- [ ] No secrets in client code
- [ ] Sensitive data not logged
- [ ] Input validation on server
- [ ] SQL injection prevented

#### API Security
- [ ] Rate limiting in place
- [ ] CORS properly configured
- [ ] Error messages don't leak info
- [ ] Request size limits set

### Tools

1. **Code search** — Grep for dangerous patterns, exposed secrets, missing auth
2. **Database audit** — Review RLS policies, table permissions, constraints
3. **Reference skill** — `.claude/skills/security/CHECKLIST.md`, `.claude/skills/security/PATTERNS.md`

### Anti-Patterns to Flag

```typescript
// CRITICAL: Never trust user_metadata
if (user.user_metadata.isPaid) // WRONG

// CRITICAL: Client-side record creation
await supabase.from('orders').insert() // WRONG (in client code)

// CRITICAL: Missing signature verification
export async function POST(req) {
  const body = await req.json() // WRONG - no signature check
}
```

### Output Format

```markdown
## Security Audit Results

### Critical Findings
| Finding | File | Line | Risk | Fix |
|---------|------|------|------|-----|

### Passed Checks
- [x] Items that passed

### Recommendations
1. High priority fixes
2. Medium priority improvements

### Summary
- Critical: X | High: X | Medium: X | Passed: X
```
