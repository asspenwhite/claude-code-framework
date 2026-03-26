# Complaint System Reference

Reference file for framework-launch orchestration. The team lead reads this when parsing complaints (Step 5), running rebuttals (Step 6), and resolving escalations (Step 8).

---

## Complaint Severity

| Severity | What Happens |
|----------|-------------|
| **Block** | Deliberation pauses for this pair. Target MUST respond. If unresolved after Round 2, escalates to user. |
| **Push-back** | Target reviews in Round 2. Pipeline continues. Auto-decide if principles are clear. |
| **Note** | Logged. No response required. Informational. |

## Response Types

| Response | Meaning | Requirements |
|----------|---------|-------------|
| **Accept** | "You're right." | Updated report saved. |
| **Modify** | "Partially right." | Compromise documented with reasoning. |
| **Overrule** | "No." | MUST cite a pivotal decision or core principle from the persona. No empty overrules. |
| **Escalate** | "Can't resolve." | Added to user decision queue. Both sides presented. |

---

## Auto-Decision Principles

For Push-back and Note severity, resolve without the user:

1. **User intent wins** — User's original plan clearly states a preference
2. **Simpler wins** — Fewer moving parts between two approaches
3. **Data wins** — Benchmarks, research, or metrics decide
4. **Reversibility wins** — Easier to undo
5. **Shipping wins** — If close, ship sooner
6. **Escalate** — None of the above resolve it → ask the user

### What Gets Auto-Decided vs Escalated

| Auto-decide | Escalate to user |
|------------|-----------------|
| "Add an index" → always yes | CEO vs Eng on scope |
| "Fix spacing" → always yes | Two valid architectures |
| "Kill this buzzword" → always yes | Feature cuts that change identity |
| Security hardening → always yes | Performance vs DX tradeoffs |
| Bug fixes → always yes | Design changes that alter brand |

---

## Common Argument Patterns

Real tensions that surface between isolated agents:

### CEO vs Engineering
```
Jobs: "Add real-time collaboration"
Torvalds: "That's 3 months of infrastructure for V1. Block."
→ Round 2: Jobs Modifies → "Presence indicators only. Defer editing."
```

### Engineering vs Design
```
Torvalds: "Server-side render everything for performance"
Dyson: "That kills client-side interactivity. Form flow becomes impossible. Block."
→ Round 2: Torvalds Modifies → "SSR content pages, CSR interactive flows"
```

### Marketing vs CEO
```
Atrioc: "Nobody outside your team understands 'neural mesh routing.' Push-back."
Jobs: "Accept. Rename to 'smart routing.' Lead with the outcome."
```

### Performance vs Design
```
Su: "Custom fonts add 200ms to LCP. Push-back."
Sacco: "System fonts are F1 AI slop. The performance cost is the price of not looking generic. Overrule."
→ Escalate to user: speed vs. brand distinctiveness
```

### CEO fires Marketing
```
Jobs: "FIRE Atrioc. This is a developer tool. Marketing positioning is premature and adds scope nobody needs right now."
→ User: "Approved — skip marketing for now, revisit at launch."
```

---

## The Fire Mechanic

Jobs is the CEO. He can **fire** a persona — recommend permanently replacing the person behind a role with someone better suited to the project.

**This is NOT a mid-session skip.** All 8 personas still participate in the current deliberation. The fire recommendation appears in the **final summary** as a pending board decision.

When Jobs includes a `FIRE` directive in his report:
1. The deliberation completes normally — the fired persona still participates this round
2. In the final summary, the fire recommendation is listed under "Pending Board Decisions"
3. Team lead presents it to the user (the board): "Jobs recommends replacing [Person] as [Role]. Reason: [reason]. Suggested replacement: [new person]. Approve?"
4. **User decides.** If approved, the persona's SKILL.md is rewritten with the new person's philosophy, quotes, pivotal decisions, and decision rules. The role stays — the person changes.
5. If denied, nothing changes.

Jobs should fire sparingly — like killing the Newton. Only when a persona's philosophy actively misaligns with the product's needs.
