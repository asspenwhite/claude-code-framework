# Changelog

All notable changes to this project.

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/). This project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [3.1.0] - 2026-03-24

### Added
- **Session memory persistence** — 3 shell hooks (session-start, pre-compact, session-end) save/load session state across compactions and restarts
- **llms.txt pattern** — preamble skill checks `{domain}/llms.txt` before reading full library docs (token savings)
- **Verification retry loops** — code-review and shipping skills retry fixes up to 3 cycles with different approaches before escalating
- **Iterative subagent retrieval** — investigation and planner skills evaluate Agent returns and follow up, max 3 cycles
- **MCP → CLI philosophy** — documented zero-dependency principle in ARCHITECTURE.md (why framework uses built-in tools over MCP)
- **System prompt injection guide** — SETUP.md explains how Claude Code loads instructions and how to customize effectively
- **Auto mode documented in README** — interactive vs auto comparison table
- **Doc contributions table in README** — shows which docs each persona updates
- **Context7 MCP integration** — 6 skills now reference Context7 for up-to-date library docs instead of guessing APIs

### Changed
- `_preamble/SKILL.md` — external docs section now prioritizes Context7 → llms.txt → full docs
- `code-review/SKILL.md` — added Context7 to allowed-tools, added verification retry loop (3-cycle max)
- `plan-review-eng/SKILL.md` — added Context7 for library verification in build-vs-buy decisions
- `planner/SKILL.md` — added Context7 to allowed-tools, added iterative research loop
- `tdd/SKILL.md` — added Context7 for verifying test framework APIs
- `frontend-design/SKILL.md` — added Context7 for component library doc lookups
- `shipping/SKILL.md` — added quality gate retry loop (3-cycle max)
- `investigation/SKILL.md` — added iterative research loop for subagent dispatching
- `settings.local.json.example` — added SessionStart, PreCompact, Stop hook entries
- `docs/ARCHITECTURE.md` — "Zero-Dependency Core, MCP Where It Matters" section (Playwright + Context7 are recommended, not required)

## [3.0.0] - 2026-03-24

### Added
- **Interactive user interviews** — each persona asks the user domain-specific questions before reviewing (default mode)
- **Auto mode** — `/framework-launch auto` skips interviews for quick reviews
- **Lisa Su in deliberation** — performance review at plan stage, parallel with Torvalds + Dyson
- **Bruno Sacco in deliberation** — AI slop detection at plan stage, parallel with Atrioc
- **Warren Buffett in deliberation** — retrospective closes every deliberation
- **Anti-sycophancy rules** — 5 explicit rules enforcing brutally honest reviews, no sugar coating
- **Doc contributions** — each persona recommends updates to project docs (DECISIONS, TODO, ARCHITECTURE, etc.)
- **Action plan generation** — deliberation produces prioritized tasks Claude can execute immediately
- **Fire mechanic** — Steve Jobs can recommend permanently replacing a persona (pending user approval)
- **User check-ins** — user reacts to findings after each batch, not just at the end
- Teammate Mode for Lisa Su (performance/SKILL.md)
- Teammate Mode for Bruno Sacco (ai-slop-detection/SKILL.md)
- Teammate Mode for Warren Buffett (reflect/SKILL.md)

### Changed
- Tier 1 (Greenfield): 5 → 8 agents (Ma → Jobs → [Torvalds ∥ Dyson ∥ Su] → [Atrioc ∥ Sacco] → Buffett)
- Tier 2 (WIP): 4 → 7 agents
- Tier 3 (Polish): 2 → 5 agents ([Torvalds ∥ Dyson ∥ Su] → Sacco → Buffett)
- All 8 personas now have User Interview Questions in Teammate Mode
- All personas instructed to be brutally honest — no forced positives, no "but" sandwiches
- SETUP.md rewritten with clearer global install instructions and projects folder explanation

## [2.0.0] - 2026-03-24

### Added
- **Swarm deliberation** — each persona runs as a separate Claude instance via Agent tool
- **Teammate Mode** — instructions for isolated agent behavior in SKILL.md files
- **Complaint system** — Block/Push-back/Note severity, Accept/Modify/Overrule/Escalate responses
- **Hub-and-spoke architecture** — team lead orchestrates, routes complaints, saves files
- **Three tiers** — Greenfield, WIP, Polish with automatic detection
- `/framework-launch` command (renamed from `/autoplan`)
- Global install option (skills at `~/.claude/skills/`)
- Gstack feature gap analysis (docs/GSTACK_GAPS.md)

### Changed
- Renamed `/autoplan` → `/framework-launch` to avoid gstack collision
- All persona SKILL.md files updated with Teammate Mode sections

## [1.0.0] - 2026-03-23

### Added
- **8 personas** with philosophy, pivotal decisions, and decision rules
- **23 skills** across 3 modes (auto-activate, review, teammate)
- **21 slash commands** for deliberation, review, testing, shipping, safety
- **7-stage pipeline** — Think → Plan → Build → Review → Test → Ship → Reflect
- **3 hooks** — config-protect, safety-check, quality-gate
- **4 safety commands** — /careful, /freeze, /guard, /unfreeze
- Incident report auto-generation
- Progressive disclosure (3-level token-efficient loading)
- Strategic compaction at phase transitions
- Optimized for Claude Opus 4.6

---

## Version Summary

| Version | Date | Highlights |
|---------|------|------------|
| 3.1.0 | 2026-03-24 | Session persistence, Context7 MCP integration, retry loops, llms.txt, system prompt injection guide |
| 3.0.0 | 2026-03-24 | Interactive interviews, 8 personas in deliberation, anti-sycophancy, action plans, fire mechanic |
| 2.0.0 | 2026-03-24 | Swarm deliberation, genuine agent isolation, complaint system, global install |
| 1.0.0 | 2026-03-23 | Initial release — 8 personas, 23 skills, 21 commands, 7-stage pipeline |
