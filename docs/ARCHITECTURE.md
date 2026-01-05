# Claude Code Architecture

Understanding the Skills + Agents + Commands system.

---

## The Core Problem

Without configuration, Claude Code:
- Uses generic patterns ("AI slop" - Inter fonts, purple gradients)
- Misses security issues until review
- Doesn't know your project's specific rules
- Can't use project-specific tools effectively

This template solves these problems with a three-layer architecture.

---

## The Three Layers

### 1. Skills (Auto-Activate During Creation)

**When:** Claude is writing new code
**Purpose:** Prevent mistakes before they happen

Skills are domain knowledge that Claude loads automatically when relevant. When you ask Claude to create a UI component, the `frontend-design` skill activates and guides the output.

```
You: Create a pricing section
Claude: [Loads frontend-design skill]
        [Uses your color palette, not generic purple]
        [Applies your typography, not Inter]
        [Creates distinctive design, not AI slop]
```

**Key Insight:** Skills work during **creation**. They make the first output better.

### 2. Agents (Manual Invoke for Review)

**When:** You want to check existing code
**Purpose:** Catch issues that slipped through

Agents are specialized reviewers you invoke manually. They have detailed checklists and know what to look for.

```bash
claude /security-audit
# Agent reviews all security-critical code
# Checks for specific anti-patterns
# Reports findings with file:line references
```

**Key Insight:** Agents work during **review**. They catch what creation missed.

### 3. Commands (Human Interface)

**When:** You want to run an agent
**Purpose:** Simple way to invoke complex workflows

Commands are the `/slash-command` interface to agents. They're just triggers.

```bash
claude /code-review      # Runs code-review-agent
claude /design-review    # Runs design-review-agent
claude /security-audit   # Runs security-audit-agent
```

---

## Progressive Disclosure

Skills use 3-level loading to save tokens:

```
┌─────────────────────────────────────────────────────────────┐
│ Level 1: Metadata (~100 tokens)                              │
│ Loaded at startup for ALL skills                             │
│ Just name + description from frontmatter                     │
└─────────────────────────────────────────────────────────────┘
                              ↓
                    [Task becomes relevant]
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ Level 2: SKILL.md Body (<500 lines)                          │
│ Loaded when skill matches current task                       │
│ Core rules, quick reference, file pointers                   │
└─────────────────────────────────────────────────────────────┘
                              ↓
                    [Specific info needed]
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ Level 3: Reference Files (unlimited)                         │
│ Loaded only when Claude needs specific details               │
│ TYPOGRAPHY.md, PATTERNS.md, CHECKLIST.md, etc.              │
└─────────────────────────────────────────────────────────────┘
```

### Why This Matters

**Without progressive disclosure:**
- All skill content loaded every time
- Wastes tokens on irrelevant info
- Context window fills up quickly

**With progressive disclosure:**
- Only load what's needed
- 50-80% token savings
- More room for your actual code

---

## File Structure

```
.claude/
├── skills/                         # Domain knowledge
│   ├── frontend-design/
│   │   ├── SKILL.md               # Core rules (Level 2)
│   │   ├── TYPOGRAPHY.md          # Reference (Level 3)
│   │   ├── THEMES.md              # Reference (Level 3)
│   │   ├── MOTION.md              # Reference (Level 3)
│   │   └── EXAMPLES.md            # Reference (Level 3)
│   │
│   └── security/
│       ├── SKILL.md               # Core rules (Level 2)
│       ├── PATTERNS.md            # Reference (Level 3)
│       ├── CHECKLIST.md           # Reference (Level 3)
│       ├── FILES.md               # Reference (Level 3)
│       └── scripts/
│           └── validate.py        # Runs without loading
│
├── agents/                         # Review workflows
│   ├── security-audit-agent.md
│   ├── code-review-agent.md
│   ├── design-review-agent.md
│   ├── accessibility-agent.md
│   ├── user-flow-test-agent.md
│   └── docs-update-agent.md
│
└── commands/                       # Slash command triggers
    ├── security-audit.md
    ├── code-review.md
    ├── design-review.md
    ├── accessibility.md
    ├── user-flow-test.md
    └── docs-update.md
```

---

## SKILL.md Format

```markdown
---
name: skill-name
description: One-line description of when this skill applies
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Skill Name

Brief overview of what this skill does.

## Core Rules

The most important rules that ALWAYS apply.

## Quick Reference

| Situation | Do This |
|-----------|---------|
| Example 1 | Action 1 |
| Example 2 | Action 2 |

## Reference Files

| Need | File |
|------|------|
| Detailed patterns | [PATTERNS.md](PATTERNS.md) |
| Checklist | [CHECKLIST.md](CHECKLIST.md) |
```

**Guidelines:**
- Keep SKILL.md under 500 lines (ideally ~60)
- Put details in reference files
- Use tables for quick scanning
- Link to reference files, don't inline everything

---

## Agent File Format

```markdown
# Agent Name

## Philosophy

One-line guiding principle.

## When to Use

- Scenario 1
- Scenario 2

## Checklist

### Category 1
- [ ] Check item 1
- [ ] Check item 2

### Category 2
- [ ] Check item 3
- [ ] Check item 4

## Tools to Use

- Tool 1 for X
- Tool 2 for Y

## Output Format

How to report findings.
```

---

## Command File Format

```markdown
# /command-name

Brief description.

## Instructions

1. Read the agent config at `.claude/agents/agent-name.md`
2. Follow the checklist
3. Report findings

## Quick Check vs Full Audit

- **Quick:** Focus on changed files only
- **Full:** Review entire codebase
```

---

## When to Use What

| Situation | Use |
|-----------|-----|
| Writing new UI code | Skills auto-activate |
| Writing new API routes | Skills auto-activate |
| Before committing | `/code-review` |
| Security concerns | `/security-audit` |
| UI looks wrong | `/design-review` |
| Accessibility check | `/accessibility` |
| Testing user flows | `/user-flow-test` |
| Updating docs | `/docs-update` |

---

## Best Practices

### Skills
- Keep SKILL.md focused on rules, not examples
- Use reference files for detailed patterns
- Include a pre-completion checklist
- Update skills when you learn new patterns

### Agents
- Make checklists specific and actionable
- Include file paths to check
- Define output format clearly
- Test agents on known issues

### Commands
- Keep command files short
- Point to agent for details
- Include quick vs full options

---

## Token-Efficient File Formats

Different file formats have different token costs. Choose wisely:

```
┌─────────────────────────────────────────────────────────────┐
│ YAML     → Most efficient (schemas, configs, APIs)          │
│            Indentation-based, minimal syntax overhead        │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│ Markdown → Good for docs (headings aid navigation)          │
│            ## headings let models skip to relevant sections  │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│ XML      → Claude-optimized (constraints, rules)             │
│            Anthropic fine-tuned to recognize tags as         │
│            containers and separators                         │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│ JSON     → Least efficient (avoid for large files)          │
│            Braces and quotes add ~30% token overhead         │
└─────────────────────────────────────────────────────────────┘
```

### Recommended File Structure

```
docs/
├── CLAUDE.md          # Markdown - AI instructions
├── TODO.md            # Markdown - Task tracking
├── CHANGELOG.md       # Markdown - Version history
├── schema.yaml        # YAML - Database schema
├── api.yaml           # YAML - API specification
├── FILE_FORMATS.md    # Markdown - Format guidelines
└── templates/
    ├── schema.template.yaml
    └── api.template.yaml
```

See `docs/FILE_FORMATS.md` for detailed guidelines and conversion examples.

---

## Research Sources

- [Building Effective Agents](https://www.anthropic.com/research/building-effective-agents)
- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
