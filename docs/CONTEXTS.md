# Contexts

Three modes adjust how Claude approaches your work. Activate them through prompt phrasing — no configuration needed.

## Dev Mode (Default)

**When:** Building features, implementing plans, writing code.

```
Build first, ask questions later. Proactive changes.
```

- Write code immediately
- Make decisions and move forward
- Ask questions only when blocked
- Skills auto-activate for guardrails
- Parallel tool calls for speed

**Example prompts:**
- "Build a user settings page with email and password change"
- "Add pagination to the products API"
- "Refactor the auth middleware to use JWT"

## Research Mode

**When:** Investigating issues, learning codebases, exploring options.

```
Read first, understand before acting. Conservative changes.
```

- Read multiple files before making changes
- Understand existing patterns
- Document findings
- Ask clarifying questions proactively
- Don't modify code unless asked

**Example prompts:**
- "Research mode: how does the auth system work?"
- "Investigate why the payment webhook fails intermittently"
- "Read through the API routes and explain the patterns used"

## Review Mode

**When:** Quality checks, audits, pre-merge verification.

```
Quality focus, checklist-driven. Report findings.
```

- Follow structured checklists
- Report findings with evidence
- Use Fix-First policy (AUTO-FIX safe issues, ASK about risky ones)
- Take screenshots for visual issues
- Produce structured output

**Example prompts:**
- "/code-review" (activates review mode automatically)
- "Review the security of the auth changes"
- "Audit the accessibility of the signup form"

## Skill Priority by Context

| Skill | Dev | Research | Review |
|-------|-----|----------|--------|
| code-review | Auto-activate | — | Full checklist |
| security-audit | Auto-activate | Read-only analysis | Full audit |
| design-review | Auto-activate | — | Full audit + screenshots |
| docs-safety | Auto-activate | — | Verification pass |
| investigation | — | Primary skill | — |
| tdd | Active | — | — |
| performance | Active | Analysis only | Full audit |

## Switching Contexts

You can switch mid-session:
- "Switch to research mode — I need to understand this before changing it"
- "Back to dev mode — I know what to do now"
- "Review mode — let's check this before merging"

The context affects Claude's approach but doesn't change which tools are available.
