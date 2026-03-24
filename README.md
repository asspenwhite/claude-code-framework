# Claude Code Framework

A complete AI-guided development framework for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Skills, hooks, personas, and a 7-stage pipeline — zero dependencies, pure markdown + shell scripts.

[![Use this template](https://img.shields.io/badge/Use%20this%20template-238636?style=for-the-badge&logo=github&logoColor=white)](https://github.com/asspenwhite/claude-code-framework/generate)

---

## What This Framework Does

Without configuration, Claude Code uses generic patterns, misses security issues, and doesn't know your project's rules. This framework fixes that with three layers:

```
Hooks (runtime safety — block destructive commands, protect configs, auto-format)
  └── Skills (prevention + review — 22 skills, 8 legendary personas)
       └── Commands (slash interface — /ship, /investigate, /ceo-review, etc.)
```

### The Pipeline

Every feature flows through 7 stages. Skip stages for small changes (typo = Build → Ship).

```
Think → Plan → Build → Review → Test → Ship → Reflect
```

| Stage | Persona | Command |
|-------|---------|---------|
| **Think** | Jack Ma | `/brainstorm` |
| **Plan** | Jobs ↔ Torvalds ↔ Dyson ↔ Atrioc | `/autoplan` (roles argue until consensus) |
| **Build** | Bruno Sacco, Lisa Su, Atrioc | Skills auto-activate |
| **Review** | — | `/code-review`, `/security-audit`, `/design-review` |
| **Test** | — | `/qa`, `/user-flow-test`, `/accessibility` |
| **Ship** | — | `/ship` |
| **Reflect** | Warren Buffett | `/reflect` |

### Three Tiers (auto-detected)

| Tier | Starting from... | Who argues |
|------|-----------------|------------|
| **Greenfield** | Nothing | Ma → Jobs ↔ Torvalds ↔ Dyson ↔ Atrioc |
| **WIP** | Something half-assed | Jobs ↔ Torvalds ↔ Dyson ↔ Atrioc |
| **Polish** | Something solid | Torvalds ↔ Dyson |

Complaints flow backwards. Engineering can block CEO scope. Design can reject architecture. Marketing can flag that nobody will understand the product. Max 3 rounds, then user decides. Reports saved to `docs/reports/[role]/`.

---

## Prerequisites

1. **Node.js** — [Download](https://nodejs.org/) (LTS)
2. **Claude Code** — `npm install -g @anthropic-ai/claude-code` then `claude auth`
3. **Git** — [Download](https://git-scm.com/downloads)

---

## Quick Start

### New Project

1. Click **"Use this template"** → **"Create a new repository"**
2. Clone your new repo: `git clone https://github.com/YOU/your-repo.git`
3. `cd your-repo && claude`
4. Paste the setup prompt from [QUICKSTART.md](QUICKSTART.md)

### Existing Project

```bash
cd /path/to/your/project
git clone --depth 1 https://github.com/asspenwhite/claude-code-framework.git temp-template
cp -r temp-template/.claude temp-template/docs temp-template/QUICKSTART.md ./
rm -rf temp-template
claude
```

### Enable Hooks (Recommended)

Copy the example settings to activate safety hooks:

```bash
cp .claude/settings.local.json.example .claude/settings.local.json
```

See [docs/HOOKS.md](docs/HOOKS.md) for configuration details.

---

## What's Included

```
.claude/
├── hooks/                         # Runtime safety (Phase 2)
│   ├── config-protect.sh          # Warns before weakening linter configs
│   ├── safety-check.sh            # Warns before destructive commands
│   ├── quality-gate.sh            # Auto-formats saved files
│   └── diff-scope.sh              # Lists changed files vs base branch
│
├── skills/                        # 22 unified skills (auto-activate + review mode)
│   ├── _preamble/                 # Always-active common behaviors
│   ├── code-review/               # Fix-First policy (auto-fix safe issues)
│   ├── security-audit/            # Security patterns + OWASP checks
│   ├── design-review/             # Visual QA + AI slop grading
│   ├── frontend-design/           # Bruno Sacco — timeless UI patterns
│   ├── ai-slop-detection/         # Bruno Sacco — 10 anti-pattern blacklist
│   ├── marketing/                 # Atrioc — content strategy & positioning
│   ├── brainstorm/                # Jack Ma — product discovery
│   ├── plan-review-ceo/           # Steve Jobs — scope & vision
│   ├── plan-review-eng/           # Linus Torvalds — architecture
│   ├── plan-review-design/        # James Dyson — design dimensions
│   ├── performance/               # Lisa Su — every cycle counts
│   ├── reflect/                   # Warren Buffett — session retrospective
│   ├── investigation/             # Root cause debugging
│   ├── tdd/                       # Test-driven development
│   ├── planner/                   # Architecture planning
│   ├── qa/                        # 7-category QA testing
│   ├── shipping/                  # PR + release workflow
│   ├── accessibility/             # WCAG 2.1 AA compliance
│   ├── user-flow-test/            # E2E journey testing
│   ├── docs-safety/               # Documentation integrity
│   └── security/                  # Deep security patterns
│
└── commands/                      # Slash commands → skill review modes
    ├── brainstorm.md              # /brainstorm — Jack Ma product discovery
    ├── ceo-review.md              # /ceo-review — Steve Jobs scope review
    ├── eng-review.md              # /eng-review — Linus Torvalds architecture
    ├── design-review-plan.md      # /design-review-plan — James Dyson design
    ├── marketing.md               # /marketing — Atrioc content review
    ├── plan.md                    # /plan — architecture planning
    ├── investigate.md             # /investigate — root cause debugging
    ├── qa.md                      # /qa — quality assurance
    ├── ship.md                    # /ship — PR + release
    ├── reflect.md                 # /reflect — Warren Buffett retrospective
    ├── code-review.md             # /code-review — Fix-First code review
    ├── security-audit.md          # /security-audit — security check
    ├── design-review.md           # /design-review — visual QA
    ├── accessibility.md           # /accessibility — WCAG audit
    ├── user-flow-test.md          # /user-flow-test — E2E testing
    ├── docs-update.md             # /docs-update — sync docs
    ├── careful.md                 # /careful — destructive command warnings
    ├── freeze.md                  # /freeze — restrict edits to directory
    ├── guard.md                   # /guard — maximum safety mode
    └── unfreeze.md                # /unfreeze — clear safety modes

docs/
├── ARCHITECTURE.md                # 3-layer unified architecture
├── PROCESS.md                     # 7-stage pipeline
├── HOOKS.md                       # Hook system documentation
├── SAFETY.md                      # Safety modes (careful/freeze/guard)
├── CONTEXTS.md                    # Dev/Research/Review modes
├── STRATEGIC_COMPACTION.md        # Smart context management
├── WORKFLOW.md                    # Documentation workflow
├── MCP.md                         # MCP server setup
├── FILE_FORMATS.md                # Token-efficient file formats
├── CLAUDE_CODE_INTERNALS.md       # Session storage internals
├── CLAUDE_4_6_UPGRADE.md          # Claude 4.6 migration guide
├── CLAUDE.md.example              # CLAUDE.md template
└── templates/                     # Document templates
```

---

## Key Features

### Unified Skills (No Separate Agents)

Each skill works in **two modes**:
1. **Auto-activate** — Core rules load when your task matches. Prevention during creation.
2. **Review mode** — Invoke via `/command` for full audit. Structured output.

### 8 Legendary Personas

Skills are voiced by figures whose philosophy shapes judgment calls:

| Persona | Skill | Philosophy |
|---------|-------|------------|
| **Steve Jobs** | CEO Review | Obsessive product vision, radical simplification |
| **Linus Torvalds** | Eng Review | Zero tolerance for complexity theater |
| **James Dyson** | Design Review | 5,127 prototypes — relentless iteration |
| **Bruno Sacco** | Frontend + AI Slop | Timeless, not fashionable |
| **Jack Ma** | Brainstorm | "If not now, when?" — customer obsession |
| **Lisa Su** | Performance | Every cycle counts — measure everything |
| **Atrioc** | Marketing | Kill the corporate speak — applied empathy |
| **Warren Buffett** | Reflect | Compounding lessons — honest retrospectives |

### Fix-First Code Review

- **AUTO-FIX**: dead code, unused imports, console.log, magic numbers
- **ASK**: security implications, design decisions, >20 line changes

### AI Slop Detection

10 named anti-patterns graded F through C. If your UI has these, it looks AI-generated:
- F: Inter/Roboto fonts, purple gradients, "Welcome to" heroes
- D: Cookie-cutter card grids, unstyled shadcn, generic blue buttons
- C: Stock illustrations, centered everything, flat backgrounds

### Runtime Hooks

Shell scripts that run on Claude Code events:
- **config-protect** — Warns before weakening linter configs
- **safety-check** — Warns before `rm -rf`, `DROP TABLE`, force-push
- **quality-gate** — Auto-formats files after save

### Safety Modes

| Command | Mode | Purpose |
|---------|------|---------|
| `/careful` | Warn | Warns before destructive commands |
| `/freeze <dir>` | Restrict | Blocks edits outside directory |
| `/guard <dir>` | Both | Maximum safety |
| `/unfreeze` | Clear | Remove all restrictions |

---

## Documentation

| Doc | When to Read |
|-----|-------------|
| [QUICKSTART.md](QUICKSTART.md) | First-time setup prompts |
| [SETUP.md](SETUP.md) | Step-by-step configuration |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | How the 3-layer system works |
| [docs/PROCESS.md](docs/PROCESS.md) | 7-stage pipeline details |
| [docs/HOOKS.md](docs/HOOKS.md) | Hook system + custom hooks |
| [docs/SAFETY.md](docs/SAFETY.md) | Safety modes explained |

---

## Claude 4.6 Optimized

This framework is built for **Claude Opus 4.6**. Key optimizations:

- Parallel tool calls via XML instruction block
- Anti-overengineering constraint
- Auto-compaction awareness
- Softened imperatives (avoids overtriggering)
- Adaptive thinking (replaces manual budget_tokens)

See [docs/CLAUDE_4_6_UPGRADE.md](docs/CLAUDE_4_6_UPGRADE.md) for migration details.

---

## Research Background

Built on:
- [Building Effective Agents](https://www.anthropic.com/research/building-effective-agents)
- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)

---

## License

MIT — Use this however you want.

## Contributing

Found something that could be better? PRs welcome!
