# Setup Guide

Step-by-step instructions for setting up Claude Code with this template.

> **New here?** Start with the [README.md](README.md) which has the Quick Start guide.

---

## Prerequisites

1. **Node.js** - [Download here](https://nodejs.org/) (LTS version)
2. **Claude Code CLI** - Install with: `npm install -g @anthropic-ai/claude-code`
3. **Authenticate** - Run: `claude auth`

---

## Step 1: Install the Framework

### Option A: Global Install (Recommended)

Install skills and commands globally so they work in **every project**, regardless of which directory you start Claude from.

```bash
# Clone the framework (into your projects folder or wherever you keep repos)
git clone https://github.com/asspenwhite/claude-code-framework.git
cd claude-code-framework

# Install globally — copies to ~/.claude/ which works from ANY directory
cp -r .claude/skills/* ~/.claude/skills/
rm -f ~/.claude/skills/README.md

cp .claude/commands/*.md ~/.claude/commands/
rm -f ~/.claude/commands/README.md
```

Now start Claude from **any directory** — all 23 skills and 21 commands are available everywhere.

```bash
cd ~/Projects        # or wherever your projects live
claude
/framework-launch polish   # works in any project
```

**How it works:** `~/.claude/skills/` is Claude Code's **personal/global** skills directory. Skills installed here are discovered in every project, every directory. You don't need to copy skills into each project.

**Choose your own projects folder.** The framework doesn't care where your projects live. `~/Projects/`, `~/code/`, `C:\Users\You\Documents\Projects\` — whatever you use. Just clone the framework repo somewhere, run the copy commands above, and you're done. Start Claude from your projects folder and navigate to child projects from there.

**Why global over project-local?** Project-local installs mean you need to copy the framework into every project. If you have 10 projects, that's 10 copies of 23 skills. Global install: one copy, works everywhere. The framework repo stays as the source — pull updates and re-run the copy commands.

### Option B: Project-Local Install

Install into a single project only. Skills are only available in that project.

```bash
cd /path/to/your/project
git clone --depth 1 https://github.com/asspenwhite/claude-code-framework.git temp
cp -r temp/.claude temp/docs ./
rm -rf temp
```

### Option C: GitHub Template

Click "Use this template" on GitHub to create a new repo with the framework pre-installed.

---

## Step 2: Enable Hooks

Copy the example settings to activate runtime hooks:

```bash
cp .claude/settings.local.json.example .claude/settings.local.json
```

This enables:
- **config-protect** — Warns before weakening linter configs
- **safety-check** — Warns before destructive commands (`rm -rf`, `DROP TABLE`, force-push)
- **quality-gate** — Auto-formats files after save (if formatter is installed)

Make hook scripts executable:

```bash
chmod +x .claude/hooks/*.sh
```

See [docs/HOOKS.md](docs/HOOKS.md) for customization.

---

## Step 3: Create Your CLAUDE.md

The template `CLAUDE.md` is ready to customize. Edit it to include:

1. **Project Overview** — What your app does, tech stack
2. **Key Directories** — Where important files live
3. **Critical Rules** — Security patterns, coding standards
4. **Quick Reference** — Ports, URLs, stack details

Keep it under 200 lines. Detailed docs go in `docs/`.

---

## Step 4: Configure MCP Servers (Recommended)

```bash
# Playwright — Browser automation for visual testing
claude mcp add playwright -- npx @anthropic/mcp-playwright

# Context7 — Up-to-date library documentation
claude mcp add context7 -- npx -y @anthropic-ai/context7-mcp@latest

# shadcn/ui — Component library source code
claude mcp add shadcn -- npx -y @anthropic-ai/shadcn-mcp@latest
```

Project-specific:

```bash
# Supabase
claude mcp add supabase -- npx -y @anthropic-ai/supabase-mcp@latest

# Stripe
claude mcp add --transport http stripe https://mcp.stripe.com/
```

Verify: `claude /mcp`

---

## Step 5: Customize Skills

### Core Skills (customize for your domain)

| Skill | What to Customize |
|-------|-------------------|
| `frontend-design/THEMES.md` | Your brand colors and palettes |
| `frontend-design/TYPOGRAPHY.md` | Your font choices |
| `security/PATTERNS.md` | Your auth/payment patterns |
| `security/FILES.md` | Your security-critical files |

### Pipeline Skills (use as-is or extend)

The 22 skills work out of the box. Customize by:
- Adding project-specific checks to checklists
- Updating file paths for your project structure
- Adding new reference files for domain knowledge

---

## Step 6: Configure Permissions (Optional)

Create or edit `.claude/settings.local.json`:

```json
{
  "permissions": {
    "allow": [
      "Bash(npm:*)",
      "Bash(npx:*)",
      "Bash(git:*)",
      "mcp__playwright__*"
    ],
    "deny": [
      "Bash(rm -rf /)"
    ]
  },
  "hooks": {
    "PreToolUse": [
      { "matcher": "Write|Edit", "hooks": [{ "type": "command", "command": ".claude/hooks/config-protect.sh" }] },
      { "matcher": "Bash", "hooks": [{ "type": "command", "command": ".claude/hooks/safety-check.sh" }] }
    ],
    "PostToolUse": [
      { "matcher": "Write|Edit", "hooks": [{ "type": "command", "command": ".claude/hooks/quality-gate.sh" }] }
    ]
  }
}
```

---

## Step 7: Test Your Setup

### Test Skills

Start working on UI — the frontend-design skill should auto-activate:

```
You: Create a hero section for the homepage
Claude: [Should apply your theme colors, avoid generic AI patterns]
```

### Test Commands

```bash
/code-review          # Fix-First code review
/security-audit       # Security vulnerability check
/design-review        # Visual UI review + AI slop grade
/ceo-review           # Steve Jobs scope review
/framework-launch             # Swarm deliberation — each persona as an isolated agent
/ship                 # PR + release workflow
```

### Test Swarm Deliberation

```bash
/framework-launch polish      # Quick test — spawns Torvalds + Dyson as parallel agents
```

You should see two agents spawned in parallel, each returning an independent review. If one files a complaint against the other, a Round 2 rebuttal agent is spawned automatically.

### Test Hooks

If hooks are enabled, try editing an `.eslintrc` file — you should see a warning from config-protect.

---

## System Prompt Injection

The framework works by injecting instructions into Claude's system prompt through `.claude/` files. Understanding how this works helps you customize effectively.

### How Claude Code Loads Instructions

```
1. CLAUDE.md                    ← Project root instructions (always loaded)
2. ~/.claude/CLAUDE.md          ← Global instructions (always loaded)
3. .claude/skills/*/SKILL.md    ← Loaded when task matches activates_when
4. .claude/commands/*.md        ← Loaded when user types /command
5. .claude/hooks/*.sh           ← Executed on tool events (PreToolUse, PostToolUse)
```

### What This Means

Every skill, command, and hook is **injected into Claude's active context** when triggered. The framework doesn't run code — it shapes Claude's behavior by putting the right instructions in front of it at the right time.

### Progressive Disclosure Saves Tokens

Not everything loads at once:

| Level | What Loads | When | Token Cost |
|-------|-----------|------|-----------|
| **Metadata** | Name, description, `activates_when` | Always (startup) | ~100 tokens per skill |
| **SKILL.md body** | Core rules, checklists, review mode | When task matches trigger | ~500-2000 tokens |
| **Reference files** | TYPOGRAPHY.md, PATTERNS.md, etc. | When skill explicitly reads them | Unlimited |

This is why skills have an `activates_when` field — it controls when the full skill body gets injected. A well-written `activates_when` keeps your context window lean.

### Customization Tips

- **CLAUDE.md** is your highest-priority injection point. Keep it under 200 lines.
- **Skills** auto-activate based on task relevance. Add project-specific checks to existing skill checklists rather than creating new skills.
- **Hooks** run shell scripts, not prompts. They return exit codes (0=allow, 1=block, 2=warn) that Claude sees as feedback.
- **Commands** are full prompts loaded on demand. They can reference skills, include templates, and orchestrate multi-step workflows.

---

## Troubleshooting

### Skills Not Activating
- Check that `.claude/skills/*/SKILL.md` exists
- Verify SKILL.md has correct frontmatter (name, description, activates_when)
- Skills activate based on task relevance — try being more specific

### Commands Not Found
- Verify `.claude/commands/*.md` files exist
- Command name = filename without `.md`
- Restart Claude Code after adding commands

### Hooks Not Running
- Verify scripts are executable: `chmod +x .claude/hooks/*.sh`
- Check `settings.local.json` has hooks configuration
- See [docs/HOOKS.md](docs/HOOKS.md) for debugging

### MCP Servers Not Working
```bash
claude /mcp           # Check status
claude mcp auth NAME  # Re-authenticate
```

---

## Directory Structure After Setup

### Global Install (Option A)
```
~/.claude/
├── skills/                      # 23 skills — available in ALL projects
│   ├── framework-launch/SKILL.md
│   ├── plan-review-ceo/SKILL.md
│   ├── ...
└── commands/                    # 21 commands — available in ALL projects
    ├── framework-launch.md
    ├── ceo-review.md
    └── ...

~/Projects/                      # Your workspace — start claude here
├── project-a/                   # Skills available here
├── project-b/                   # Skills available here
└── project-c/                   # Skills available here
```

### Project-Local Install (Option B/C)
```
your-project/
├── CLAUDE.md                    # Main AI instructions (customized)
├── .claude/
│   ├── settings.local.json      # Permissions + hooks config
│   ├── hooks/                   # Runtime safety scripts
│   ├── skills/                  # 23 skills — this project only
│   └── commands/                # Slash command triggers
├── docs/                        # Project documentation
└── src/                         # Your code
```

---

## Next Steps

1. Read [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — understand the 3-layer system
2. Read [docs/PROCESS.md](docs/PROCESS.md) — understand the 7-stage pipeline
3. Customize skills for your domain
4. Start building!
