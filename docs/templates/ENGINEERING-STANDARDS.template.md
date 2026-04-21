# Engineering Standards

> Copy to `docs/ENGINEERING-STANDARDS.md` (or `docs/workflow/ENGINEERING-STANDARDS.md` if you use a subfolder structure) and tune. The bar is team-specific; the structure is general.

---

**Owner:** [your name / role]
**Purpose:** the bar every plan and implementation must meet before it ships. Partners and future sessions read this to avoid re-litigating the basics.
**Last updated:** [date]

---

## The headline standard

Would an engineer at a top-tier shop walk this into their code review without flinching? If the answer is "well, it works" or "it fixes the bug" — not good enough.

Engineering here is evaluated on architecture + craft, not throughput. A narrow, correct, boundary-setting fix beats three quick patches every time.

---

## Plan standards

Every non-trivial plan (anything touching > 1 file, or any plan that involves a migration, or any plan a partner might read) MUST contain these 11 sections in this order. If a section is genuinely N/A for the task, include it anyway and write "N/A because X." Don't silently omit.

### 1. Problem statement

- Symptom, cited with file:line or screenshot.
- Who feels it (which user, which surface, which flow).

### 2. Root cause

- Not "the code does X." The root cause is the architectural or process condition that ALLOWED X. Example: "there is no single source of truth for per-resource compliance; two code paths reinvent it independently." The symptom is the number mismatch; the cause is the missing boundary.

### 3. All bugs of the same shape

- Before proposing a fix, grep for other instances of the same anti-pattern. If the bug is "two divergent calculations," find the third place that ALSO diverges. Fix the class, not the instance.
- Cite each one with file:line. If you only find the one instance, say so explicitly.

### 4. Proposed architectural boundary

- If the root cause was a missing boundary, introduce it. Usually this is a `lib/` helper that becomes the single source of truth. Name it concretely. Plan names all callers that will switch to it.
- If no new boundary is needed, say why.

### 5. Files touched + what changes

- Per-file bullet. Not a diff, but close to it. Which lines, what replaces them, what gets deleted.
- Include files that are DELETED or where functions/types/fields are removed. If the fix makes scaffolding obsolete, delete the scaffolding in the same PR. Leaving dead code for "later" is a smell.

### 6. Dead code cleanup

- What does this fix make obsolete? Fields on types, helper functions, fallback paths, comments referencing old behavior. Remove them in the same change.
- Do not cleanup unrelated dead code. Scope discipline still matters — this is "cleanup adjacent to the change only."

### 7. Regression guardrail

- What prevents the bug from silently returning? Options, in order of preference:
  1. **Type**: make it impossible to call the wrong function (e.g., the new helper is the only export).
  2. **Test**: integration test that asserts the invariant.
  3. **Lint**: custom ESLint rule or grep-based CI check.
  4. **Doc**: last resort — a comment in the code saying "don't do X and here's why."
- Pick one. "We'll be careful" is not an acceptable answer.

### 8. Verification plan

- How do you prove the fix works, in a way a partner could reproduce?
- UI changes: screenshots with before/after, plus a "cold-reviewer" test — can a reviewer tell from the image alone that the feature works?
- API changes: integration test showing the invariant + curl examples.
- Data changes: a SQL query the reader can run to verify counts.

### 9. Scope discipline — "not doing"

- Explicit bullet list of things considered and cut. Protects against scope creep during implementation.
- Anything that would require new UI from the designer, new DB columns, or new product decisions goes here.
- This section is MANDATORY. Even if short. It's a contract with the reviewer that we won't wander.

### 10. Risks

- What could go wrong that a reasonable reviewer would flag?
- Rollback plan.
- Coordination requirements (migration numbering, partner sync, deploy order).

### 11. Open questions

- Only decisions that actually require human input. If you find yourself padding this section to look thorough, cut the padding.

---

## Implementation standards

### No point fixes on systemic bugs

If the plan's Section 3 finds three instances of the same anti-pattern, the implementation addresses all three. Picking the one you were originally asked about and ignoring the others is the fastest way to re-open the same ticket next week.

### Boundary first, refactor second

If a missing boundary is the root cause, the FIRST commit introduces the boundary + routes ONE caller through it. Subsequent commits migrate the other callers. Don't mix the boundary intro with a giant refactor — the mixed commit is unreviewable.

### Type-level guardrails over runtime ones

A required parameter that makes the wrong call impossible at compile time is better than a test that catches the mistake at runtime. Prefer narrowing the type surface whenever feasible.

### Dead scaffolding goes immediately

If your change makes a helper / field / route obsolete, delete it in the same commit. Comments like `// TODO: remove X once Y lands` are a debt trap; they linger forever.

### Honest semantic notes

If a metric is an approximation, the code says so. Example comment at the call site: `// avg_score is a row-level average scoped to audited items, not a true per-item pass rate. See docs/X.md.` Future engineers, and honest audit conversations with customers, depend on this.

---

## Review checklist (before opening a PR)

Read each item out loud. If you can't answer "yes," fix before opening.

- [ ] Does the plan have all 11 sections?
- [ ] Does Section 3 ("Same-shape bugs") cite concrete file:lines, or explicitly state "only one instance"?
- [ ] Is there a regression guardrail beyond "we'll be careful"?
- [ ] Does the commit delete every piece of scaffolding this change obsoletes?
- [ ] For UI: does at least one screenshot show the user-visible outcome (not just DOM state)?
- [ ] For error paths: is there a visible user cue (toast / banner / inline message)?
- [ ] Is the verification reproducible by a partner without your help?

---

## Red flags

These patterns almost always indicate below-bar work:

- **"Quick fix"** — usually means "skipped Section 3 (same-shape bugs)."
- **"We'll be careful"** as a regression guardrail.
- **"I'll clean up the dead code later"** — later never comes.
- **"The test suite passes"** without a screenshot of the user-visible outcome.
- **A PASS grade on a Playwright sweep without visually verifying each screenshot cold** — the assertions can pass while the screenshots show brokenness.
- **An in-place edit to a plan doc** that expands scope without a fresh re-plan — usually means the patched section is wishful thinking.
- **"It works on my machine"** — verification must be reproducible.

---

## How to apply this doc

- Cite it in the header of every new plan you write: `**Standards:** [docs/workflow/ENGINEERING-STANDARDS.md](...)`.
- Before opening a PR, run through the Review Checklist out loud.
- If a reviewer flags something as below bar, the fix is to add a new Red Flag entry here, not to re-argue the specific case.
- This doc is versioned. If you disagree with a bar, open an ADR proposing the change — don't silently lower it.

---

**Tone in planning docs:** be direct. "This is wrong" beats "this might possibly be suboptimal." Plans are for decisions, not diplomacy.
