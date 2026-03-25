# Claude Code Framework

Make Claude Code build like a team, not a solo dev.

[![Use this template](https://img.shields.io/badge/Use%20this%20template-238636?style=for-the-badge&logo=github&logoColor=white)](https://github.com/asspenwhite/claude-code-framework/generate)

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

**They argue — as separate Claude instances.** Each persona runs in its own context via the Agent tool. Genuine isolation produces genuine disagreement. Engineering blocks CEO scope ("unbuildable"). Design rejects architecture ("kills UX"). Marketing flags that nobody will understand the positioning. Complaints route through a team lead, rebuttals are filed, and consensus is reached — or you break the tie.

---

## Three Tiers

The framework auto-detects what you're working with:

| Tier | You have... | Who reviews |
|------|------------|------------|
| **Greenfield** | Nothing yet | 5 agents: Ma → Jobs → [Torvalds ∥ Dyson] → Atrioc |
| **WIP** | Something half-finished | 4 agents: Jobs → [Torvalds ∥ Dyson] → Atrioc |
| **Polish** | Something solid | 2 agents: [Torvalds ∥ Dyson] |

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

### Global Install (works in every project)

```bash
git clone https://github.com/asspenwhite/claude-code-framework.git
cd claude-code-framework
cp -r .claude/skills/* ~/.claude/skills/
cp .claude/commands/*.md ~/.claude/commands/
rm -f ~/.claude/skills/README.md ~/.claude/commands/README.md
```

Start Claude from your projects folder — all skills and commands are available in every child project.

### Project-Local Install (single project only)

```bash
cd your-project
git clone --depth 1 https://github.com/asspenwhite/claude-code-framework.git temp
cp -r temp/.claude temp/docs temp/QUICKSTART.md ./
rm -rf temp
claude
```

### Enable Hooks

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

### Safety
| Command | What it does |
|---------|-------------|
| `/careful` | Warn before destructive commands |
| `/freeze <dir>` | Restrict edits to one directory |
| `/guard <dir>` | Both careful + freeze |
| `/unfreeze` | Clear restrictions |

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
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | How the 3-layer system works |
| [docs/PROCESS.md](docs/PROCESS.md) | 7-stage pipeline details |
| [docs/HOOKS.md](docs/HOOKS.md) | Hook system + writing custom hooks |
| [docs/SAFETY.md](docs/SAFETY.md) | Safety modes explained |

---

## License

MIT

## Contributing

PRs welcome.
