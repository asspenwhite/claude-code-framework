# Claude Code Framework

A lightweight configuration template that gets the most out of [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Prompting rules, MCP integration, documentation structure, and one custom skill (deliberation engine).

[![Use this template](https://img.shields.io/badge/Use%20this%20template-238636?style=for-the-badge&logo=github&logoColor=white)](https://github.com/asspenwhite/claude-code-framework/generate)

---

## Apply to a project

Open Claude Code in any project and say:

```
Apply the claude-code-framework from https://github.com/asspenwhite/claude-code-framework to this project.
```

Claude will:
1. Clone the framework
2. Copy `CLAUDE.md` and `docs/` templates into your project
3. Customize for your stack (you'll be asked project name, description, tech stack)
4. Ask if you want to update your home-level `~/.claude/CLAUDE.md` with the prompting rules too

### Manual setup

```bash
cd /path/to/your/project
git clone --depth 1 https://github.com/asspenwhite/claude-code-framework.git temp
cp temp/CLAUDE.md ./
cp -r temp/docs ./
rm -rf temp
claude  # Claude will read CLAUDE.md and follow the rules
```

---

## What it does

### Prompting rules (why this matters)

Claude Code is powerful but needs guardrails. Without them, it over-engineers, adds unrequested features, serializes tool calls, and sometimes stops mid-task. This framework configures Claude via `CLAUDE.md` with:

| Rule | What it prevents |
|------|-----------------|
| `<do_not_overengineer>` | Claude adding features, refactoring code, or "improving" things you didn't ask for |
| `<parallel_tool_calls>` | Serialized tool execution — with this, parallel usage approaches 100% |
| `<context_window>` | Claude stopping mid-task saying "running low on context" |
| No `<default_to_action>` | Claude acting on ambiguous intent without confirming first |
| No anti-laziness prompts | "be thorough" / "think carefully" waste tokens and amplify over-action |

Full reference: [`docs/PROMPTING.md`](docs/PROMPTING.md)

### MCP integration

Points Claude to external tools that extend its capabilities beyond built-in:

| Server | What it gives Claude |
|--------|---------------------|
| **context7** | Current library/framework docs (React, Next.js, Prisma, etc.) |
| **Playwright** | Browser control for visual testing and E2E flows |
| **Obsidian** | Cross-project knowledge from your vault |
| **Figma** | Design context from real Figma files |

### Documentation structure

Templates for common project docs that Claude reads before acting:

```
docs/
├── templates/
│   ├── CHANGELOG.template.md
│   ├── DECISIONS.template.md
│   ├── TODO.template.md
│   ├── API.template.md
│   ├── SCHEMA.template.md
│   └── LOGIC_AUDIT.template.md
├── PROMPTING.md           — XML blocks, effort levels, anti-patterns
├── MIGRATION_4_7.md       — Cleanup checklist for Opus 4.6 → 4.7
├── ARCHITECTURE.md        — How progressive disclosure works
├── WORKFLOW.md            — Documentation workflow guide
├── MCP.md                 — MCP server setup guide
└── FILE_FORMATS.md        — Token-efficient format guidelines
```

### Deliberation engine (`/deliberate`)

The one custom skill. Spawns 8 personas as isolated Agent instances for genuine disagreement — not one Claude playing all roles. Three tiers (Greenfield / WIP / Polish), interactive or auto mode, checkpoint system for long deliberations.

---

## Recommended setup

### Plugins (official marketplace)

```bash
claude plugin install code-review
claude plugin install security-guidance
claude plugin install frontend-design
claude plugin install pr-review-toolkit
claude plugin install commit-commands
```

### MCP servers

```bash
# Up-to-date library docs
claude mcp add context7 -- npx -y @anthropic-ai/context7-mcp@latest

# Browser control for visual testing
claude mcp add playwright -- npx @anthropic/mcp-playwright

# Obsidian vault (if you use it)
# See: https://github.com/MarkusPfundstein/mcp-obsidian
```

---

## Migrating from 4.6

If you previously applied the adaptive thinking workaround (cli.js patching, `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` env var), see [`docs/MIGRATION_4_7.md`](docs/MIGRATION_4_7.md) for the cleanup checklist. Opus 4.7 no longer needs it.

---

## Current model

**Claude Opus 4.7** (`claude-opus-4-7`) — 1M context, 128k max output.

For API reference: [docs.anthropic.com](https://docs.anthropic.com/en/docs/about-claude/models)

---

## Philosophy

1. **Less is more.** Every line in CLAUDE.md costs context tokens. Keep it short, point to docs/ for detail.
2. **Plugins over skills.** Official plugins are maintained upstream and load on-demand. Don't reinvent them.
3. **MCP over static knowledge.** A running context7 or Obsidian server has live data. A markdown file has stale data.
4. **Templates over prescriptions.** This framework gives structure. You fill in the content.

---

## License

MIT
