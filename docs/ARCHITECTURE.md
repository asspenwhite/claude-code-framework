# Claude Code Architecture

How this framework configures Claude Code for better results.

---

## The Approach

Claude Code out of the box is capable but unconfigured. This framework provides:

1. **CLAUDE.md** -- project-specific rules and context
2. **docs/** -- detailed documentation Claude reads when needed
3. **Hooks** -- deterministic guarantees for rules that must always hold (see `HOOKS.md`)
4. **Plugins** -- on-demand capabilities maintained upstream
5. **MCP servers** -- live data sources (docs, browser, knowledge base)

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

## Model-Era Behavior (Claude 5 / Opus 4.8)

Current-model traits that affect CLAUDE.md design:

| Behavior | Impact on CLAUDE.md |
|----------|-------------------|
| High proactiveness | Keep the `<do_not_overengineer>` block |
| Over-triggers on imperatives | Use "when relevant" not "You MUST" |
| Parallel tool calls + compaction are native | `<parallel_tool_calls>` / `<context_window>` blocks retired — redundant |
| No anti-laziness needed | Remove "be thorough", "think carefully" |
| Advisory adherence is ~80%, not 100% | Must-hold rules become hooks (`HOOKS.md`), not louder prose |

See `MODEL_NOTES.md` for the full era notes and v1.6 migration checklist.

---

## Deliberation Engine

The one exception to "plugins over skills." No plugin replicates swarm deliberation with isolated agents.

```
~/.claude/skills/deliberate/
  SKILL.md                            -- orchestrator + /deliberate entry point (disable-model-invocation: true)
  PROMPTS.md                          -- agent prompt templates
  FORMATS.md                          -- output format templates
  COMPLAINTS.md                       -- complaint system reference
  personas/                           -- 8 persona files
```

**How it works:** Each persona runs as a separate `Agent` tool invocation with its own context window. No persona sees another's output until the team lead (main conversation) routes it. This produces genuine disagreement instead of polite consensus.

**Why `disable-model-invocation: true`:** Without this flag, Claude reads all skill files at startup. The deliberation engine is ~1,000 lines across 15 files — that's wasted context on every session. The flag makes it invisible until `/deliberate` is typed.

**Ships project-local** in this repo's `.claude/`. Copy `skills/deliberate/` to `~/.claude/skills/` to make `/deliberate` available from any project directory.

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
| `INCIDENT.template.md` | Outage/failure reports — severity, timeline, root cause, lessons |
| `AS-BUILT.template.md` | Live-state reference for operated systems (vs DRAFT plans) |
| `RUNBOOK.template.md` | Operational procedures, write-safety rules, gotchas |

Claude will customize these for your project when you ask it to set up docs.
The three ops templates are the backbone of the role playbooks in `playbooks/`.
