# Claude Code Framework

Make Claude Code build like a team, not a solo dev.

[![Version](https://img.shields.io/badge/version-3.1.2-blue?style=for-the-badge)](CHANGELOG.md)
[![Use this template](https://img.shields.io/badge/Use%20this%20template-238636?style=for-the-badge&logo=github&logoColor=white)](https://github.com/asspenwhite/claude-code-framework/generate)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)](LICENSE)

---

## The Problem

Out of the box, Claude Code:
- Uses generic "AI slop" patterns (Inter fonts, purple gradients, cookie-cutter layouts)
- Makes scope decisions without pushback
- Ships first-draft architecture nobody reviewed
- Writes copy that sounds like a corporate press release
- Doesn't learn from its mistakes

## The Fix

This framework gives Claude Code a **full team** — 8 department heads who review, argue, and push back on each other's decisions before anything ships.

```
/framework-launch
```

One command. Your project gets reviewed by:

| Department | Head | What They Do |
|-----------|------|-------------|
| Product | Jack Ma | Validates demand — "who is *desperate* for this?" |
| CEO | Steve Jobs | Challenges scope — "is this insanely great, or just feature soup?" |
| Engineering | Linus Torvalds | Audits architecture — "this abstraction layer is vanity. Delete it." |
| Design | James Dyson | Rates 8 dimensions — "prototype 1 of 5,127. Keep going." |
| Marketing | Atrioc | Kills corporate speak — "would you say this at a bar?" |
| Frontend | Bruno Sacco | Catches AI slop — "this will look dated in 6 months." |
| Performance | Lisa Su | Measures everything — "show me the profile, not your guess." |
| Retrospective | Warren Buffett | Compounds lessons — "mistakes on page 1, not page 47." |

**They argue — as separate Claude instances.** Each persona runs in its own context via the Agent tool. Genuine isolation produces genuine disagreement. No sugar coating — every persona is instructed to be brutally honest. Engineering blocks CEO scope ("unbuildable"). Design rejects architecture ("kills UX"). Marketing flags that nobody will understand the positioning. The CEO can even fire a persona and recommend a replacement. Complaints route through a team lead, rebuttals are filed, and consensus is reached — or you break the tie.

**You're in the boardroom.** Each persona interviews you with domain-specific questions before reviewing. You check in after each batch, react to findings, and make the final calls. You're a co-founder, not a report recipient.

---

## Three Tiers

The framework auto-detects what you're working with:

| Tier | You have... | Who reviews |
|------|------------|------------|
| **Greenfield** | Nothing yet | 8 agents: Ma → Jobs → [Torvalds ∥ Dyson ∥ Su] → [Atrioc ∥ Sacco] → Buffett |
| **WIP** | Something half-finished | 7 agents: Jobs → [Torvalds ∥ Dyson ∥ Su] → [Atrioc ∥ Sacco] → Buffett |
| **Polish** | Something solid | 5 agents: [Torvalds ∥ Dyson ∥ Su] → Sacco → Buffett |

Combine modifiers: `/framework-launch auto polish`, `/framework-launch auto incremental`

### Three Run Modes

| Mode | Command | What Happens |
|------|---------|-------------|
| **Interactive** | `/framework-launch polish` | Interviews you before each batch, you check in after findings |
| **Auto** | `/framework-launch auto polish` | Skips interviews, personas review from code + context only |
| **Incremental** | `/framework-launch incremental` | All personas run, but each reads their previous report — focuses on what changed, what improved, what's still broken |

**Interactive** is the boardroom — you're a co-founder. **Auto** is the quick sanity check. **Incremental** is the follow-up meeting where everyone knows the history.

Every persona scores on a **1-10 scale** across their domain dimensions, so you can track improvement between runs.

---

## Doc Contributions

Each persona doesn't just review — they contribute to project documentation:

| Persona | Docs They Update |
|---------|-----------------|
| Jack Ma | `MARKET.md`, `TODO.md`, `CONSTRAINTS.md` |
| Steve Jobs | `DECISIONS.md`, `TODO.md`, `CONSTRAINTS.md` |
| Linus Torvalds | `ARCHITECTURE.md`, `TODO.md`, `CONSTRAINTS.md` |
| James Dyson | `DESIGN.md`, `TODO.md` |
| Lisa Su | `PERFORMANCE.md`, `TODO.md`, `CONSTRAINTS.md` |
| Atrioc | `README.md`, `TODO.md`, `MARKETING.md` |
| Bruno Sacco | `DESIGN.md`, `TODO.md` |
| Warren Buffett | `DECISIONS.md`, `TODO.md`, `LESSONS.md`, `CLAUDE.md` |

After deliberation, the team lead consolidates doc contributions into a prioritized action plan that Claude can execute immediately.

---

## What Happens Automatically

You don't run these — they just happen:

| Event | What fires | Where it saves |
|-------|-----------|---------------|
| You write code | 6 skills auto-activate (code review, security, accessibility, design, docs, performance) | Inline — prevents issues during creation |
| Something breaks | Incident report generated with root cause, timeline, and prevention plan | `docs/reports/incidents/` |
| You run `/framework-launch` | Swarm deliberation — each persona as a separate agent, genuine isolation | `docs/reports/[role]/` per round |
| You run `/reflect` | Session retrospective with compounding lessons | `docs/reports/retrospective/` |
| You edit a linter config | Hook warns before you weaken it | Terminal warning |
| You type `rm -rf` | Hook warns before destructive commands | Terminal warning |
| You save a file | Hook auto-formats it | Formatted file |

---

## The Pipeline

```
Think → Plan → Build → Review → Test → Ship → Reflect
```

Skip stages for small changes. Typo = Build → Ship. New feature = full pipeline.

| Stage | What happens | Command |
|-------|-------------|---------|
| **Think** | Validate demand, find the wedge | `/brainstorm` |
| **Plan** | Departments argue until consensus | `/framework-launch` |
| **Build** | Skills auto-activate during coding | Just code |
| **Review** | Code, security, design audits | `/code-review`, `/security-audit` |
| **Test** | QA testing, accessibility, E2E flows | `/qa`, `/accessibility` |
| **Ship** | Quality gates, version bump, PR | `/ship` |
| **Reflect** | Honest retrospective, lessons learned | `/reflect` |

---

## Quick Start

### Install (recommended)

```bash
# 1. Clone the framework into your projects folder
cd ~/Projects  # or wherever you keep repos
git clone https://github.com/asspenwhite/claude-code-framework.git

# 2. Copy skills and commands to your global Claude config
cd claude-code-framework
cp -r .claude/skills/* ~/.claude/skills/
cp .claude/commands/*.md ~/.claude/commands/
rm -f ~/.claude/skills/README.md ~/.claude/commands/README.md
```

That's it. Every project you open with Claude now has the full framework — all 8 personas, all commands, all auto-activating skills.

The `claude-code-framework/` folder is your **source repo**. When updates ship, pull them and re-copy:

```bash
cd ~/Projects/claude-code-framework
git pull
# Then from any Claude session:
/update-framework
```

Or do it manually:
```bash
cp -r .claude/skills/* ~/.claude/skills/
cp .claude/commands/*.md ~/.claude/commands/
rm -f ~/.claude/skills/README.md ~/.claude/commands/README.md
```

### Alternative: Project-Local Install

If you only want the framework in a single project (not globally):

```bash
cd your-project
git clone --depth 1 https://github.com/asspenwhite/claude-code-framework.git temp
cp -r temp/.claude temp/docs temp/QUICKSTART.md ./
rm -rf temp
```

### Enable Hooks (optional)

```bash
cp .claude/settings.local.json.example .claude/settings.local.json
```

---

## All Commands

### Deliberation
| Command | What it does |
|---------|-------------|
| `/framework-launch` | Full team review — roles argue until consensus |
| `/brainstorm` | Product discovery session |
| `/ceo-review` | Scope & vision challenge |
| `/eng-review` | Architecture audit |
| `/design-review-plan` | 8-dimension design rating |
| `/marketing` | Copy & positioning teardown |

### Build & Review
| Command | What it does |
|---------|-------------|
| `/code-review` | Fix-First — auto-fixes safe issues, asks about risky ones |
| `/security-audit` | Security vulnerability check |
| `/design-review` | Visual QA + AI slop grade (A-F) |
| `/accessibility` | WCAG 2.1 AA compliance audit |
| `/investigate` | Root cause debugging + incident report |
| `/plan` | Architecture planning |

### Test & Ship
| Command | What it does |
|---------|-------------|
| `/qa` | 7-category QA testing |
| `/user-flow-test` | End-to-end journey testing |
| `/ship` | Quality gates → version bump → PR |
| `/reflect` | Session retrospective |

### Safety & Maintenance
| Command | What it does |
|---------|-------------|
| `/careful` | Warn before destructive commands |
| `/freeze <dir>` | Restrict edits to one directory |
| `/guard <dir>` | Both careful + freeze |
| `/unfreeze` | Clear restrictions |
| `/update-framework` | Pull latest framework from GitHub |

---

## Reports (Your Institutional Memory)

Everything saves to `docs/reports/`:

```
docs/reports/
├── brainstorm/       Product discovery reports
├── ceo/              Scope decisions & rebuttals
├── engineering/      Architecture verdicts
├── design/           Dimension ratings & AI slop grades
├── marketing/        Positioning & copy teardowns
├── incidents/        Auto-generated when something breaks
├── qa/               Test reports
├── security/         Security audit findings
└── retrospective/    Session learnings
```

---

## Zero Dependencies

No npm packages. No build steps. No runtime. Pure markdown + 4 shell scripts. Clone it, use it.

---

## Built for Claude Opus 4.6

Optimized prompting for the latest model — parallel tool calls, anti-overengineering constraints, adaptive thinking, softened imperatives. See [docs/CLAUDE_4_6_UPGRADE.md](docs/CLAUDE_4_6_UPGRADE.md).

---

## Docs

| Doc | What it covers |
|-----|---------------|
| [QUICKSTART.md](QUICKSTART.md) | First-time setup prompts |
| [SETUP.md](SETUP.md) | Step-by-step configuration |
| [CHANGELOG.md](CHANGELOG.md) | Version history |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | How the 3-layer system works |
| [docs/PROCESS.md](docs/PROCESS.md) | 7-stage pipeline details |
| [docs/HOOKS.md](docs/HOOKS.md) | Hook system + writing custom hooks |
| [docs/SAFETY.md](docs/SAFETY.md) | Safety modes explained |

---

## Acknowledgments

This framework takes a different approach (team simulation vs toolbox) but exists in the same Claude Code ecosystem as other great projects:

- **[everything-claude-code](https://github.com/affaan-m/everything-claude-code)** by [@affaanmustafa](https://github.com/affaan-m) — Comprehensive Claude Code toolkit with 125+ skills, continuous learning, session persistence, and multi-language support. If you want breadth across languages and frameworks, start there. Their [longform guide](https://cogsec.substack.com) on token economics, memory persistence, and verification patterns is essential reading for any Claude Code user.
- **[gstack](https://github.com/gstack)** — Production-grade CLI framework with browser automation, deploy pipelines, and post-ship monitoring. Several features in our [gap analysis](docs/GSTACK_GAPS.md) are inspired by what gstack ships.

## License

MIT

## Contributing

PRs welcome.
