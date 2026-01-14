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
# From your existing project folder
git clone --depth 1 https://github.com/asspenwhite/claude-code-framework.git temp
cp -r temp/.claude ./
cp -r temp/docs ./
rm -rf temp
```

---

## Step 2: Create Your CLAUDE.md

Copy the example and customize:

```bash
cp claude-code-framework/docs/CLAUDE.md.example your-project/CLAUDE.md
```

Edit `CLAUDE.md` to include:

1. **Project Overview** - What your app does, tech stack
2. **Key Directories** - Where important files live
3. **Critical Rules** - Security patterns, coding standards
4. **Links to Docs** - Point to detailed documentation

Keep it under 200 lines. Move detailed docs to separate files.

---

## Step 3: Configure MCP Servers (Recommended)

MCP servers give Claude real-time access to tools and documentation.

### Essential MCP Servers

```bash
# Playwright - Browser automation for visual testing
claude mcp add playwright -- npx @anthropic/mcp-playwright

# shadcn/ui - Component library source code
claude mcp add shadcn -- npx -y @anthropic-ai/shadcn-mcp@latest

# Context7 - Up-to-date library documentation
claude mcp add context7 -- npx -y @anthropic-ai/context7-mcp@latest
```

### Project-Specific MCP Servers

```bash
# Supabase - If using Supabase
claude mcp add supabase -- npx -y @anthropic-ai/supabase-mcp@latest

# Stripe - If processing payments
claude mcp add --transport http stripe https://mcp.stripe.com/
```

### Verify Installation

```bash
claude /mcp
```

---

## Step 4: Customize Skills

### Frontend Design Skill

Located at `.claude/skills/frontend-design/`

**Files to customize:**

| File | What to Change |
|------|----------------|
| `THEMES.md` | Add your brand colors, remove unused palettes |
| `TYPOGRAPHY.md` | Add your font choices if different |
| `EXAMPLES.md` | Add project-specific before/after examples |

### Security Skill

Located at `.claude/skills/security/`

**Files to customize:**

| File | What to Change |
|------|----------------|
| `SKILL.md` | Update rules for your auth/payment system |
| `PATTERNS.md` | Add your secure code patterns |
| `FILES.md` | List your security-critical files |
| `CHECKLIST.md` | Adapt pre-commit checklist |

---

## Step 5: Customize Agents

Agents live in `.claude/agents/`. For each agent:

1. **Update file paths** - Replace `[your-path]` placeholders
2. **Add project checks** - Include your specific anti-patterns
3. **Remove irrelevant sections** - Keep only what applies

### Example: Security Audit Agent

Edit `.claude/agents/security-audit-agent.md`:

```markdown
## Files to Check

- `src/lib/auth.ts` - Your auth utilities
- `src/app/api/webhook/route.ts` - Your webhook handlers
- `src/middleware.ts` - Your middleware
```

---

## Step 6: Configure Permissions (Optional)

Create `.claude/settings.local.json` to control tool access:

```json
{
  "permissions": {
    "allow": [
      "Bash(npm:*)",
      "Bash(npx:*)",
      "Bash(git:*)",
      "mcp__playwright__*",
      "mcp__shadcn__*"
    ],
    "deny": [
      "Bash(rm -rf:*)"
    ]
  }
}
```

---

## Step 7: Test Your Setup

### Test Skills

Start working on UI - the frontend-design skill should auto-activate:

```
You: Create a hero section for the homepage
Claude: [Should apply your theme colors, avoid generic patterns]
```

### Test Agents

Run a command:

```bash
claude /security-audit
claude /code-review
claude /design-review
```

---

## Troubleshooting

### Skills Not Activating

- Check that `.claude/skills/*/SKILL.md` exists
- Verify SKILL.md has correct frontmatter format
- Skills activate based on task relevance - try being more specific

### Commands Not Found

- Verify `.claude/commands/*.md` files exist
- Command name = filename without `.md`
- Restart Claude Code after adding commands

### MCP Servers Not Working

```bash
# Check status
claude /mcp

# Re-authenticate if needed
claude mcp auth supabase
claude mcp auth stripe
```

---

## Directory Structure After Setup

```
your-project/
├── CLAUDE.md                 # Main AI instructions
├── .claude/
│   ├── settings.local.json   # Permissions (optional)
│   ├── skills/
│   │   ├── frontend-design/
│   │   └── security/
│   ├── agents/
│   └── commands/
├── docs/                     # Your project docs
│   ├── API.md
│   ├── SCHEMA.md
│   └── ...
└── src/                      # Your code
```

---

## Next Steps

1. Read [ARCHITECTURE.md](docs/ARCHITECTURE.md) to understand how everything works
2. Customize skills for your domain
3. Update agents with your file paths
4. Start coding!
