# Claude Code Framework

A complete AI-guided development framework for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) that makes AI-assisted coding significantly better.

[![Use this template](https://img.shields.io/badge/Use%20this%20template-238636?style=for-the-badge&logo=github&logoColor=white)](https://github.com/asspenwhite/claude-code-framework/generate)

---

## What is Claude Code?

**Claude Code** is Anthropic's official command-line tool that lets you code with Claude AI directly in your terminal. Instead of copying/pasting code from a chat window, Claude Code can:

- Read and write files in your project
- Run terminal commands
- Browse the web for documentation
- Test your app in a real browser

**This template** configures Claude Code with best practices so it writes better code and catches more issues.

---

## Prerequisites

Before using this template, you need:

### 1. Node.js (Required)

You need Node.js to install Claude Code. Download and install it first:

[Download Node.js](https://nodejs.org/) (LTS version recommended)

Verify it's installed:

```bash
node --version
npm --version
```

### 2. Claude Code CLI (Required)

Install Claude Code globally:

```bash
npm install -g @anthropic-ai/claude-code
```

Then authenticate:

```bash
claude auth
```


### 3. Git (Required)

You need Git to clone repositories. Check if you have it:

```bash
git --version
```

> Don't have Git? [Download it here](https://git-scm.com/downloads)

### 4. A Code Editor (Optional)

I built this entire framework using just Claude Code in the terminal - no editor needed. But if you prefer one: VS Code, Cursor, Sublime, etc. all work.

---

## What This Framework Provides

Instead of basic Claude Code, this framework provides:

| Feature | What It Does |
|---------|--------------|
| **Skills** | Auto-activate when relevant to prevent common mistakes (bad UI patterns, security issues) |
| **Agents** | Manual review workflows that catch issues before you ship |
| **Commands** | Simple `/slash-commands` to run agents (like `/security-audit`) |
| **Docs Workflow** | Auto-maintains CHANGELOG, TODO, and architecture docs |

---

## Quick Start

### Option A: New Project (Recommended)

**Step 1:** Click the green **"Use this template"** button at the top of this page → **"Create a new repository"**

> This creates a new repo in YOUR GitHub account with all the template files already copied.

**Step 2:** Name your repository (e.g., `my-awesome-app`) and click **"Create repository"**

**Step 3:** Clone YOUR new repository to your computer:

```bash
# Replace YOUR-USERNAME and your-repo-name with your actual values
git clone https://github.com/YOUR-USERNAME/your-repo-name.git

# Example:
git clone https://github.com/johndoe/my-awesome-app.git
```

**Step 4:** Open a terminal IN your project folder:

```bash
cd my-awesome-app    # <- Use YOUR folder name
```

**Step 5:** Start Claude Code:

```bash
claude
```

**Step 6:** Paste this prompt (fill in your details):

```
Customize this template for my project:

**Project Name:** [Your app name]
**Description:** [What it does in 1-2 sentences]
**Tech Stack:** [e.g., Next.js 14, Supabase, Stripe, Tailwind]
**Key Features:**
1. [Feature 1]
2. [Feature 2]
3. [Feature 3]

Update CLAUDE.md, customize the skills and agents for my project, and create initial docs.
```

Claude reads the template files and customizes everything for your project.

---

### Option B: Add to Existing Project

If you already have a project and want to add the Claude Code configuration:

```bash
# Navigate to your existing project
cd /path/to/your/existing-project

# Download just the .claude folder and docs
git clone --depth 1 https://github.com/asspenwhite/claude-code-framework.git temp-template
cp -r temp-template/.claude ./
cp -r temp-template/docs ./
cp temp-template/QUICKSTART.md ./
rm -rf temp-template

# Start Claude Code
claude
```

Then paste the customization prompt above.

---

### After Setup: Install MCP Servers (Optional but Recommended)

**What are MCP Servers?** They're plugins that give Claude Code extra abilities - like controlling a browser, accessing component libraries, or reading documentation.

Run these in your project folder:

```bash
# Playwright - Lets Claude control a browser to test your app visually
claude mcp add playwright -- npx @anthropic/mcp-playwright

# shadcn/ui - Gives Claude access to the shadcn component library
claude mcp add shadcn -- npx -y @anthropic-ai/shadcn-mcp@latest

# Context7 - Gives Claude up-to-date docs for popular libraries
claude mcp add context7 -- npx -y @anthropic-ai/context7-mcp@latest
```

---

See [QUICKSTART.md](QUICKSTART.md) for more example prompts.

---

## What's Included

```
.claude/
├── skills/                    # Auto-activate during creation
│   ├── frontend-design/       # Prevents "AI slop" (generic fonts, purple gradients)
│   └── security/              # Enforces secure patterns
│
├── agents/                    # Manual review workflows
│   ├── design-review-agent.md
│   ├── security-audit-agent.md
│   ├── code-review-agent.md
│   ├── accessibility-agent.md
│   ├── user-flow-test-agent.md
│   └── docs-update-agent.md
│
└── commands/                  # Human-readable agent triggers
    └── [matching .md files]

docs/
├── ARCHITECTURE.md            # How Skills/Agents/Commands work
├── WORKFLOW.md                # Documentation workflow guide
├── MCP.md                     # MCP server setup guide
├── CLAUDE_CODE_INTERNALS.md   # Session storage, folder migration
├── CLAUDE.md.example          # Template for main instructions
└── templates/                 # Documentation templates
    ├── CHANGELOG.template.md      # Version history
    ├── TODO.template.md           # Task tracking
    ├── DECISIONS.template.md      # Architectural decisions
    ├── LOGIC_AUDIT.template.md    # User flows & edge cases
    ├── API.template.md            # API documentation
    ├── SCHEMA.template.md         # Database schema
    └── PROJECT_README.template.md # Project overview
```

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                        CLAUDE.md                             │
│                   (Project-specific rules)                   │
└─────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        ▼                     ▼                     ▼
┌──────────────┐      ┌──────────────┐      ┌──────────────┐
│    Skills    │      │    Agents    │      │   Commands   │
│ (Auto-load)  │      │   (Manual)   │      │   (Manual)   │
│              │      │              │      │              │
│ Prevents     │      │ Catches      │      │ /security    │
│ mistakes     │      │ issues       │      │ /code-review │
│ during       │      │ during       │      │ /design      │
│ creation     │      │ review       │      │              │
└──────────────┘      └──────────────┘      └──────────────┘
```

### Progressive Disclosure

Skills use 3-level loading to save tokens:

1. **Level 1:** Metadata only (~100 tokens) - loaded at startup
2. **Level 2:** SKILL.md body (<500 lines) - when task is relevant
3. **Level 3:** Reference files - only when specifically needed

---

## Customizing for Your Project

### Skills

Edit the skills to match your domain:

- `frontend-design/` - Already universal, customize color palettes in THEMES.md
- `security/` - Adapt patterns for your auth/payment system

### Agents

Modify agents for your workflows:

- Update file paths to match your project structure
- Add project-specific checks to checklists
- Remove irrelevant sections

### CLAUDE.md

This is your main configuration. Include:

- Project overview and tech stack
- Key directories and file locations
- Critical rules (security, patterns to follow)
- Links to detailed docs

---

## Documentation Workflow

This template includes a complete **docs-as-code** workflow with templates for every doc your project needs:

| Document | Purpose | When to Update |
|----------|---------|----------------|
| **CHANGELOG.md** | Version history | After every change |
| **TODO.md** | Tasks by priority with file paths | When adding/completing tasks |
| **DECISIONS.md** | Architectural decisions with context | When making tech choices |
| **LOGIC_AUDIT.md** | User states, page logic, edge cases | When changing user flows |
| **API.md** | Routes, requests, responses | When changing API |
| **SCHEMA.md** | Database tables, RLS, queries | When changing database |

All templates are in `docs/templates/` - Claude will customize them for your project.

### How It Works

1. **Claude updates docs automatically** - Every code change updates CHANGELOG
2. **Decisions are logged** - Tech choices are documented with reasoning
3. **TODOs stay current** - Tasks marked complete as work finishes
4. **Run `/docs-update`** - Syncs all docs after a coding session

See [docs/WORKFLOW.md](docs/WORKFLOW.md) for the full guide.

---

## Session Management

Claude Code stores your conversation history locally. Key things to know:

| Command | Purpose |
|---------|---------|
| `claude --resume` | Pick from recent sessions for current folder |
| `claude --continue` | Continue most recent session (any project) |
| `claude` | Start fresh session |

**Moving or renaming project folders?** Your session history won't automatically follow. See [docs/CLAUDE_CODE_INTERNALS.md](docs/CLAUDE_CODE_INTERNALS.md) for how to migrate sessions to a new folder path.

---

## Research Background

This framework builds on research from:

- [Building Effective Agents](https://www.anthropic.com/research/building-effective-agents)
- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)

Key insight: **Skills prevent mistakes during creation**, while **Agents catch issues during review**. Using both together produces the best results.

---

## Built With

This framework was built using [Claude Code](https://www.npmjs.com/package/@anthropic-ai/claude-code), Anthropic's official CLI for AI-assisted development.

```bash
npm install -g @anthropic-ai/claude-code
```

---

## License

MIT - Use this however you want.

---

## Contributing

Found something that could be better? PRs welcome!
