# Claude Code Framework

A lightweight project template for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Sets up documentation structure and AI rules so Claude writes better code from the start.

[![Use this template](https://img.shields.io/badge/Use%20this%20template-238636?style=for-the-badge&logo=github&logoColor=white)](https://github.com/asspenwhite/claude-code-framework/generate)

---

## What This Is

A `CLAUDE.md` template + documentation structure that configures Claude Code with:

- **Progressive disclosure** -- Claude reads what it needs when it needs it
- **Claude 4.6 rules** -- prevents over-engineering, enables parallel tool calls
- **MCP integration** -- points Claude to Obsidian, context7, Playwright, Figma
- **Plugin-first** -- uses official Claude Code plugins instead of custom skills
- **Doc templates** -- CHANGELOG, TODO, DECISIONS, API, SCHEMA ready to customize

This is intentionally minimal. The real power comes from Claude Code's plugin ecosystem and MCP servers, not static markdown files.

---

## Quick Start

### New Project

1. Click **"Use this template"** above -- create a new repo
2. Clone it and open in terminal
3. Run `claude` and paste:

```
Customize this template for my project:

**Project Name:** [name]
**Description:** [what it does]
**Tech Stack:** [e.g., Next.js 14, Supabase, Tailwind]

Update CLAUDE.md and create initial docs.
```

### Existing Project

```bash
cd /path/to/your/project
git clone --depth 1 https://github.com/asspenwhite/claude-code-framework.git temp
cp temp/CLAUDE.md ./
cp -r temp/docs ./
rm -rf temp
claude
```

---

## Recommended Plugins

Install from the official marketplace. These load on-demand -- no startup cost.

```bash
claude plugin install code-review
claude plugin install security-guidance
claude plugin install frontend-design
claude plugin install pr-review-toolkit
claude plugin install commit-commands
```

---

## Recommended MCP Servers

These give Claude capabilities its built-in tools can't match.

```bash
# Up-to-date library docs (React, Next.js, Prisma, etc.)
claude mcp add context7 -- npx -y @anthropic-ai/context7-mcp@latest

# Browser control for visual testing
claude mcp add playwright -- npx @anthropic/mcp-playwright

# Obsidian vault for cross-project knowledge (if you use Obsidian)
# See: https://github.com/MarkusPfundstein/mcp-obsidian
```

---

## What's Included

```
CLAUDE.md                          -- AI instructions template (customize this)
.claude/
  commands/deliberate.md           -- /deliberate command entry point
  skills/deliberate/
    SKILL.md                       -- Orchestrator (disable-model-invocation: true)
    PROMPTS.md                     -- Agent prompt templates
    FORMATS.md                     -- Report/doc output templates
    COMPLAINTS.md                  -- Complaint system reference
    personas/                      -- 8 persona files (ma, jobs, torvalds, dyson, su, atrioc, sacco, buffett)
docs/
  ARCHITECTURE.md                  -- How progressive disclosure works
  WORKFLOW.md                      -- Documentation workflow guide
  MCP.md                           -- MCP server setup guide
  FILE_FORMATS.md                  -- Token-efficient format guidelines
  CLAUDE.md.example                -- Full CLAUDE.md example
  CLAUDE_4_6_UPGRADE.md            -- Claude 4.6 migration guide
  templates/                       -- Doc templates (CHANGELOG, TODO, DECISIONS, etc.)
```

### Deliberation Engine

The one custom skill: `/deliberate`. Spawns 8 personas as isolated Agent instances for genuine disagreement (not one Claude playing all roles). Zero startup cost -- only loads when you invoke it.

Three tiers (Greenfield/WIP/Polish), interactive or auto mode, complaint routing between personas, checkpoint system for long deliberations, and automatic doc generation.

---

## Philosophy

1. **Plugins over skills.** Official plugins are maintained upstream, load on-demand, and don't bloat your context window. Don't reinvent them as markdown files.
2. **MCP over static knowledge.** A running Obsidian vault or context7 server has live data. A SKILL.md has stale data.
3. **Less is more.** Every line in CLAUDE.md costs context tokens. Keep it short, point to docs/ for detail.
4. **Templates over prescriptions.** This framework gives you structure. You fill in the content.

---

## Claude 4.6 Notes

This template is optimized for Claude Opus 4.6. Key things it handles:

| Rule | Why |
|------|-----|
| `<do_not_overengineer>` block | 4.6 is proactive -- will add unrequested features without this |
| `<parallel_tool_calls>` block | Explicit instruction boosts parallel usage to ~100% |
| No anti-laziness prompts | "be thorough" amplifies proactive behavior, wastes tokens |
| Soft tool-use language | "Use X when relevant" not "You MUST use X" -- 4.6 overtriggers |

See `docs/CLAUDE_4_6_UPGRADE.md` for the full migration guide.

---

## License

MIT
