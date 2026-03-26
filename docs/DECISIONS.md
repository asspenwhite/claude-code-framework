# Decisions

Architectural and scope decisions with rationale. Updated after each significant change.

## v3.1.1 — 2026-03-25

| # | Decision | Rationale | Decided By |
|---|----------|-----------|-----------|
| 1 | **Genuine agent isolation over single-context role-play** — Each persona runs as a separate Claude instance via Agent tool | Single-context deliberation produces polite consensus. Isolation produces genuine disagreement. Tested: scripted disagreement ("you MUST find one objection") is equally fake. Isolation IS the mechanism. | User + office-hours (v3.0.0) |
| 2 | **Dynamic interview questions, not hardcoded** — Team lead generates per-project questions from context gaps | Hardcoded questions feel fake — "the questions are always the same even if the doc already has answers." Each persona has Question Philosophy (what they care about) not a literal question list. | User feedback (v3.1.0) |
| 3 | **Zero dependencies** — Pure markdown + shell scripts. No npm, no build step, no runtime. | Maximizes adoption. "Clone it, use it." Most competitors require Node.js, Go, Python, Rust, or WASM. This is a moat. | Core principle (v1.0.0) |
| 4 | **Named celebrity personas** — Jobs, Torvalds, Buffett, etc. instead of generic "CEO", "Engineer" | Memorable, distinctive voices. The persona's real-world decisions (Buffett admitting IBM was a $10B mistake, Dyson's 5,127 prototypes) create genuine decision-making frameworks, not just labels. | Core principle (v1.0.0) |
| 5 | **Hub-and-spoke, not peer-to-peer** — Team lead orchestrates, agents don't talk to each other directly | Peer-to-peer requires agent teams infrastructure that not all users have. Hub-and-spoke works with the standard Agent tool. Complaints route through the team lead. | Architecture review (v3.0.0) |
| 6 | **Reports are snapshots, docs are institutional memory** — Reports save to docs/reports/, living docs save to docs/ root | Reports are per-run ephemeral records. DECISIONS.md, TODO.md, ARCHITECTURE.md etc. are cumulative knowledge that compounds across runs. The docs folder IS the product. | Incident report (v3.1.1) |
| 7 | **Explicit checkpoint before synthesis (Step 8.5)** — Save state to disk before Steps 9-11 | Context exhaustion kills Steps 9-11 in Greenfield runs (~170k tokens by Round 2). Auto-compaction wipes all reports from memory. Checkpoint + disk reads solve this. | Incident report (v3.1.1) |
| 8 | **Design team produces artifacts, not just scores** — Dyson outputs component specs, Sacco outputs design tokens | A 4.6/10 score without specs is useless. A real design handoff includes component variants, spacing, responsive breakpoints, and implementable token values. Modeled after modern Figma standards. | Incident report (v3.1.1) |
| 9 | **Scaffold docs on first run (Step 0.5)** — Create DECISIONS.md, TODO.md, etc. if they don't exist | Three DuranArt runs produced zero living docs because Step 9 can't append to files that don't exist and the step itself was dying from context exhaustion. Scaffolding ensures the target files are always there. | Incident report (v3.1.1) |

## v1.0.0 — v2.x (Legacy Decisions)

| # | Decision | Rationale |
|---|----------|-----------|
| 1 | **Progressive disclosure** — CLAUDE.md (summary) → docs/ (detail) → .claude/skills/ (implementation) | Prevents context bloat. Claude reads what it needs when it needs it. |
| 2 | **Skills auto-activate** — Triggered by file types and task context, not manual invocation | Guardrails shouldn't require the user to remember to invoke them. |
| 3 | **Hook system** — config-protect, safety-check, quality-gate shell scripts | Runtime safety net. Warns before weakening linter configs, destructive commands, auto-formats on save. |
| 4 | **Three tiers** — Greenfield (8 personas) / WIP (7) / Polish (5) | Not every project needs full deliberation. Adapting the team to maturity prevents overkill. |
