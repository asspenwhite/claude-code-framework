# Complaint System Reference

Read at Steps 5-8 when parsing complaints, running rebuttals, and resolving escalations.

---

## Severity Levels

| Severity | Effect |
|----------|--------|
| **Block** | Pipeline pauses. Target MUST respond. Unresolved after Round 2 -> user decides. |
| **Push-back** | Target reviews in Round 2. Pipeline continues. Auto-decide if principles clear. |
| **Note** | Logged only. No response required. |

## Response Types

| Response | Meaning | Requirement |
|----------|---------|-------------|
| **Accept** | "You're right." | Updated report saved. |
| **Modify** | "Partially right." | Compromise documented. |
| **Overrule** | "No." | MUST cite persona principle. |
| **Escalate** | "Can't resolve." | Both sides presented to user. |

---

## Auto-Decision Principles

For Push-back and Note severity, resolve without the user:

1. **User intent wins** -- user's plan clearly states a preference
2. **Simpler wins** -- fewer moving parts
3. **Data wins** -- benchmarks or metrics decide
4. **Reversibility wins** -- easier to undo
5. **Shipping wins** -- if close, ship sooner
6. **Escalate** -- none of the above resolve it

### Auto-decide vs Escalate

| Auto-decide | Escalate to user |
|------------|-----------------|
| "Add an index" | CEO vs Eng on scope |
| "Fix spacing" | Two valid architectures |
| "Kill this buzzword" | Feature cuts that change identity |
| Security hardening | Performance vs DX tradeoffs |
| Bug fixes | Design changes that alter brand |

---

## Common Argument Patterns

### CEO vs Engineering
```
Jobs: "Add real-time collaboration"
Torvalds: "That's 3 months of infra for V1. Block."
-> Round 2: Jobs Modifies -> "Presence indicators only."
```

### Engineering vs Design
```
Torvalds: "SSR everything for performance"
Dyson: "Kills interactivity. Block."
-> Round 2: Torvalds Modifies -> "SSR content, CSR interactive flows"
```

### Performance vs AI Slop
```
Su: "Custom fonts add 200ms to LCP. Push-back."
Sacco: "System fonts are AI slop. Overrule."
-> Escalate: speed vs brand distinctiveness
```

### CEO fires Marketing
```
Jobs: "FIRE Atrioc. Developer tool doesn't need consumer marketing."
-> User: "Approved -- skip marketing, revisit at launch."
```

---

## The FIRE Mechanic

Jobs can recommend permanently replacing a persona. NOT a mid-session skip -- fired persona still participates this round.

1. Deliberation completes normally
2. FIRE recommendation appears in final summary as pending board decision
3. Team lead presents to user: approve or deny
4. If approved: persona file rewritten with replacement's philosophy
5. If denied: nothing changes

Use sparingly -- like killing the Newton.
