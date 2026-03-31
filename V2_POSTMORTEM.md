# Framework v2.0–v3.1.2 Postmortem

**Date:** 2026-03-30
**Versions covered:** v2.0 (d1406a4, 2026-03-23) through v3.1.2 (6f6f108, 2026-03-25)
**Decision:** Roll back master to 56315df (2026-02-17). This branch preserved as `v2-archive`.

---

## What v2.0 Added

A single commit (d1406a4) on 2026-03-23 transformed the framework from a lightweight template into a full development pipeline:

| Component | Count | Lines Added |
|-----------|-------|-------------|
| Skills | +16 new (23 total) | ~2,176 in skills alone |
| Commands | +14 new (24 total) | ~522 |
| Hooks | +4 shell scripts | ~218 |
| Docs | +6 new files | ~607 |
| **Total** | **67 files changed** | **+3,891 / -1,728** |

### Skills Added (v2.0)
_preamble, accessibility, ai-slop-detection, brainstorm, docs-safety, investigation, marketing, performance, plan-review-ceo, plan-review-design, plan-review-eng, planner, qa, reflect, security-audit, shipping, tdd

### Commands Added (v2.0)
brainstorm, careful, ceo-review, design-review-plan, eng-review, freeze, guard, investigate, marketing, plan, qa, reflect, ship, unfreeze

### Hooks Added (v2.0)
config-protect.sh, diff-scope.sh, quality-gate.sh, safety-check.sh

### Architecture Changes (v2.0–v3.1.2)
- Replaced separate Skills + Agents with "Unified Skills" (one SKILL.md with auto-activate + review + teammate modes)
- Added 8-persona swarm deliberation engine (`/framework-launch`)
- Added 7-stage pipeline: Think → Plan → Build → Review → Test → Ship → Reflect
- Added three project tiers: Greenfield (8 personas), WIP (7), Polish (5)
- Added complaint system with hub-and-spoke routing
- Added context checkpoint (Step 8.5) to survive compaction
- Added docs scaffolding (Step 0.5) for first runs

---

## What It Produced

68 generated report files across 3 projects:

| Project | Files | Sessions |
|---------|-------|----------|
| DuranArt | 42 | 4 sessions (initial, polish, redesign, rebuild) |
| Stumbler-Code | 18 | 2 sessions (initial + v2) |
| Super Bay Factory V2 | 8 | 1 session (polish) |

Reports are preserved in each project's `docs/reports/` directory.

---

## What Worked

### 1. Swarm Deliberation with Genuine Isolation
The core innovation. Each persona runs as a separate Claude instance via the Agent tool, producing genuine disagreement instead of polite consensus. This is validated by the output quality — Jobs and Torvalds had a real disagreement on DuranArt (feature-first vs infrastructure-first) that surfaced a legitimate architectural decision.

**Evidence:**
- DuranArt CEO report: Jobs identified that the type system was designed but completely ignored (Artwork type has `medium, dimensions, year, client, series context` — none displayed on site)
- DuranArt Engineering report: Torvalds found `use client` on Line 1 destroying SSG, 8.8MB unoptimized images, magic-number grid layout
- Stumbler-Code: Atrioc found STATE_KEY flag-before-action bug that was a real launch blocker
- SBF-V2: 5 independent personas converged on the same structural problems — removing subjectivity

### 2. Named Personas with Real Decision Frameworks
The celebrity personas weren't gimmicks — their real-world decisions created distinctive voices:
- **Buffett's "30-day MVP or stop"** discipline prevented Stumbler-Code from expanding indefinitely
- **Sacco's "20-year test"** flagged glass morphism as a dating risk on DuranArt
- **Jobs's "dead buttons are a cardinal sin"** caught fake shop/booking links on DuranArt
- **Torvalds's** specific line-number references and architecture criticism

### 3. Non-Technical Blockers Surfaced
The framework's best finding across all 3 projects was non-code issues:
- DuranArt: Anthony never filled out CONTENT-NEEDED.md — code was premature
- SBF-V2: Photographer recruitment is the existential risk, not code polish
- Stumbler-Code: 250MB ZIP in git history, dev machine telemetry IDs in defaults

### 4. Action Plans Were Executable
The consolidated action plans had specific file paths, line numbers, hour estimates, and phase chunking (P0/P1/P2). The SBF-V2 action plan even included copy-paste CSS token sets.

### 5. AI Slop Detection
Sacco's slop detection was structurally useful — not just catching obvious tells (Inter font, purple gradients) but identifying deeper patterns: "six consecutive sections use the exact same template" and "23 backdrop-filter elements will age like BMW flame surfacing."

---

## What Failed

### 1. Startup Performance (THE reason for rollback)
23 skills (6,439 lines) loaded metadata at startup. Even with progressive disclosure, the sheer number of skill directories caused visible slowdown in Claude Code initialization. The framework that was supposed to make Claude Code better made it slower to start.

### 2. Context Exhaustion
The framework's own v3.1.1 incident report documents this: Greenfield runs hit ~170k tokens by Round 2, triggering auto-compaction that wiped all reports from memory. The fix (Step 8.5 checkpoint + disk reads) was a band-aid for a fundamental problem — too many skills competing for context space.

### 3. Duplicate Coverage with Claude Plugins
By March 2026, Claude's official plugin marketplace provides:
- `code-review` — overlaps with framework's code-review skill
- `security-guidance` — overlaps with framework's security-audit skill
- `frontend-design` — overlaps with framework's frontend-design skill
- `pr-review-toolkit` — overlaps with framework's shipping skill

These plugins load on-demand and are maintained upstream. The framework skills were static markdown files the user had to maintain.

### 4. Duplicate Coverage with MCP Servers
- **Obsidian MCP** provides the cross-project knowledge layer the framework tried to build with brainstorm/investigation skills
- **context7** provides library documentation lookup
- **Playwright** provides real browser testing (replaces user-flow-test skill)
- **Figma plugin** provides actual design review with real Figma data

### 5. The Zero-Dependency Principle Became a Trap
The framework's architecture doc stated: "If it can be a markdown file read by Claude, don't make it a running process." But the inverse is equally true: **if a running process already exists and does the job better, duplicating it as a markdown file is waste.** MCP servers and plugins ARE the running processes, and they're already there.

### 6. Persona Voices Inconsistent in Action Plans
Individual persona reports (CEO, Engineering, AI Slop) had strong, distinctive voices. But the consolidated action plans and summaries lost personality — they read like generic project management output.

### 7. Sacco Diagnosed Without Prescribing
The AI slop detection consistently identified problems ("identical section formula," "glass morphism will date") but rarely proposed specific alternatives. Diagnosis without prescription is incomplete.

---

## Pros vs Cons: v2.0+ vs v1.0 (56315df)

### v2.0+ Advantages
- Swarm deliberation produces genuinely useful multi-perspective analysis
- Named personas create memorable, distinctive review voices
- Non-technical blockers get surfaced (content gaps, recruitment, business risks)
- Action plans are specific and executable
- Complaint/rebuttal system forces real disagreement

### v2.0+ Disadvantages
- Slow startup (23 skills loading)
- Context exhaustion on complex runs
- Duplicates functionality now available in plugins/MCP
- Maintenance burden on user (static markdown vs upstream-maintained plugins)
- Persona quality inconsistent (strong in individual reports, weak in summaries)
- 6,439 lines of skills that Claude reads whether needed or not

### v1.0 (56315df) Advantages
- Lightweight: 7 skills, 6 agents, 6 commands
- Fast startup
- Clear separation: skills (auto) vs agents (manual)
- Template-oriented: meant to be customized per project
- Good documentation (ARCHITECTURE.md, WORKFLOW.md, MCP.md)

### v1.0 (56315df) Disadvantages
- No deliberation engine
- Generic skills (not project-specific)
- No persona system
- Skills overlap with what plugins now provide
- Agents directory is redundant with plugins

---

## What to Preserve for v1.5

### Keep from v2.0+
1. **Swarm deliberation concept** — but as a standalone command, not embedded in 23 skills
2. **Named persona decision frameworks** — Buffett's "30-day MVP or stop," Sacco's "20-year test," Jobs's product critique
3. **The 68 report files** — preserved in each project's `docs/reports/` directory
4. **Anti-sycophancy instruction** — "no forced positives, no 'but' sandwiches"

### Keep from v1.0
1. **Progressive disclosure** — CLAUDE.md → docs/ → .claude/
2. **Token-efficient file formats** — YAML > Markdown > XML > JSON
3. **Claude 4.6 behavior rules** — parallel tool calls, do-not-overengineer, context window XML blocks
4. **CLAUDE.md template structure** — constraints, docs table, rules
5. **Doc templates** — CHANGELOG, TODO, DECISIONS, etc.

### Remove from Both
1. **All overlapping skills** — code-review, security-audit, frontend-design, docs-safety → use plugins
2. **Agents directory** — plugins replace manual agent workflows
3. **Hooks** — config-protect, safety-check, quality-gate → not needed with plugins
4. **Pipeline stages** — the 7-stage pipeline is overhead for a solo developer

### Add for v1.5
1. **Obsidian MCP as knowledge layer** — replace brainstorm/investigation with vault queries
2. **Plugin recommendations** — which official plugins replace which skills
3. **Lightweight deliberation** — the swarm engine as a single command file, not a 1,091-line skill

---

## Generated Report Inventory

### DuranArt (`DuranArt/docs/reports/`)
- 6 summary/action-plan files (3 sessions)
- 4 CEO reports (Jobs)
- 4 Design reports (Dyson/Ive)
- 4 Engineering reports (Torvalds)
- 3 Marketing reports
- 4 Performance reports
- 4 AI Slop reports (Sacco)
- 4 Retrospective reports (Buffett)
- 2 Complaint ledgers, 2 Session states
- 1 First Meeting Prompt

### Stumbler-Code (`stumbler-code/docs/reports/`)
- 3 summary files (v1, v2)
- 3 CEO scope reviews
- 3 Design reviews
- 3 Architecture reviews
- 2 Marketing positioning reports
- 1 Performance report
- 1 AI Slop detection report
- 1 Retrospective

### Super Bay Factory V2 (`super-bay-factory-v2/docs/reports/`)
- 2 summary/action-plan files
- 5 persona polish reports (AI Slop, Design, Engineering, Performance, Retrospective)
- 1 Complaint ledger, 1 Session state

---

## Lessons Learned

1. **Don't bake knowledge into skills when MCP can query it live.** The Obsidian vault has 219K+ characters of searchable project knowledge. A static skill file can't compete.

2. **Plugins > custom skills for generic patterns.** Code review, security, frontend design — these are universal concerns maintained better by the community/Anthropic than by one developer.

3. **The deliberation engine is the unique value.** Everything else in v2.0+ was either duplicating plugins or adding overhead. The swarm with genuine isolation is the one thing plugins can't replicate.

4. **Context budget is finite. Spend it on the project, not the framework.** 6,439 lines of skills means 6,439 lines less of project context. A framework should be as invisible as possible.

5. **Solo developer != engineering team.** The 7-stage pipeline with 8 personas is modeled after a full product team. A solo developer needs a lighter touch — use deliberation for big decisions, plugins for daily guardrails.
