# Setup Guide

Step-by-step instructions for setting up Claude Code with this template.

> **New here?** Start with the [README.md](README.md) which has the Quick Start guide.

---

## Prerequisites

1. **Node.js** - [Download here](https://nodejs.org/) (LTS version)
2. **Claude Code CLI** - Install with: `npm install -g @anthropic-ai/claude-code`
3. **Authenticate** - Run: `claude auth`

---

## Step 1: Get the Template

**Option A: Use GitHub's Template Feature (Recommended)**

Click "Use this template" on GitHub to create your own copy.

**Option B: Clone Directly**

```bash
git clone https://github.com/asspenwhite/claude-code-framework.git my-project
cd my-project
```

**Option C: Add to Existing Project**

```bash
cd /path/to/your/existing-project
git clone --depth 1 https://github.com/asspenwhite/claude-code-framework.git temp
cp -r temp/.claude temp/docs ./
rm -rf temp
```

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

```
your-project/
├── CLAUDE.md                    # Main AI instructions (customized)
├── .claude/
│   ├── settings.local.json      # Permissions + hooks config
│   ├── hooks/                   # Runtime safety scripts
│   ├── skills/                  # 22 unified skills
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
