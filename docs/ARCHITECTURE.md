# Claude Code Architecture

How this framework configures Claude Code for better results.

---

## The Approach

Claude Code out of the box is capable but unconfigured. This framework provides:

1. **CLAUDE.md** -- project-specific rules and context
2. **docs/** -- detailed documentation Claude reads when needed
3. **Plugins** -- on-demand capabilities maintained upstream
4. **MCP servers** -- live data sources (docs, browser, knowledge base)

---

## Progressive Disclosure

Claude reads in layers to save tokens:

```
Level 1: CLAUDE.md (~100 lines)
  Project summary, constraints, rules, quick reference.
  Loaded every session.

Level 2: docs/ (unlimited)
  DECISIONS.md, CHANGELOG.md, api.yaml, schema.yaml.
  Loaded when Claude needs specific context.
```

### Why This Matters

Every line Claude reads costs context tokens. A 500-line CLAUDE.md leaves less room for your actual code. Keep CLAUDE.md short and point to docs/ for detail.

---

## Plugin-First Model

Claude Code's plugin marketplace provides maintained, on-demand capabilities:

| Need | Plugin | What It Does |
|------|--------|--------------|
| Code quality | `code-review` | TypeScript/React patterns, auto-fixes |
| Security | `security-guidance` | Auth, API, data protection checks |
| Frontend | `frontend-design` | Prevents AI slop (generic fonts, purple gradients) |
| PRs | `pr-review-toolkit` | PR review and creation workflows |
| Commits | `commit-commands` | Structured commit messages |
| Design | `figma` | Design context from real Figma files |

**Why plugins over custom skills:**
- Load on-demand (no startup cost)
- Maintained upstream (no maintenance burden)
- Community-tested (more eyes, fewer bugs)

---

## MCP Servers

MCP servers give Claude live capabilities that static files can't match:

| Server | Capability | Replaces |
|--------|-----------|----------|
| **context7** | Current library docs | Stale training data |
| **Playwright** | Browser control, visual testing | Manual testing |
| **Obsidian** | Cross-project knowledge base | Hardcoded context in CLAUDE.md |
| **Figma** | Real design data | Screenshot descriptions |

### The Principle

If a running process already provides the capability, don't duplicate it as a markdown file. MCP servers have live data. SKILL.md files have stale data.

---

## Token-Efficient File Formats

Different formats have different token costs:

| Format | Best For | Token Cost |
|--------|----------|------------|
| **YAML** | Schemas, configs, APIs | Most efficient |
| **Markdown** | Docs, instructions | Good (headings aid navigation) |
| **XML** | Constraints, rules | Claude-optimized |
| **JSON** | Settings only | Least efficient (~30% overhead) |

See `FILE_FORMATS.md` for detailed guidelines.

---

## Claude 4.6 Behavior

Key differences from older models that affect CLAUDE.md design:

| Behavior | Impact on CLAUDE.md |
|----------|-------------------|
| High proactiveness | Need `<do_not_overengineer>` block |
| Over-triggers on imperatives | Use "when relevant" not "You MUST" |
| Native parallel tool calls | Add `<parallel_tool_calls>` block |
| Auto-compaction | Add `<context_window>` block |
| No anti-laziness needed | Remove "be thorough", "think carefully" |

See `CLAUDE_4_6_UPGRADE.md` for the full migration guide.

---

## Doc Templates

The `templates/` directory provides starter docs:

| Template | Purpose |
|----------|---------|
| `CHANGELOG.template.md` | Version history |
| `TODO.template.md` | Task tracking by priority |
| `DECISIONS.template.md` | Architectural decisions with rationale |
| `LOGIC_AUDIT.template.md` | User flows and edge cases |
| `API.template.md` | API route documentation |
| `SCHEMA.template.md` | Database schema |
| `PROJECT_README.template.md` | Project overview |

Claude will customize these for your project when you ask it to set up docs.
