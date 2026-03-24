# Commands

Commands are slash-invoked shortcuts that trigger skills in **Review Mode**.

## How Commands Work

```
User types: /design-review
Claude reads: .claude/commands/design-review.md
Claude loads: .claude/skills/design-review/SKILL.md → Review Mode section
Claude runs: Full checklist on current context
```

## Command Syntax

Commands use `$ARGUMENTS` for user input:

```markdown
Review the design of $ARGUMENTS.

Load and follow the **Review Mode** section in: .claude/skills/design-review/SKILL.md
```

## Available Commands

### Review Commands
| Command | Skill | Purpose |
|---------|-------|---------|
| `/code-review` | code-review | Code quality with Fix-First policy |
| `/security-audit` | security-audit | Security vulnerability check |
| `/design-review` | design-review | Visual UI review + AI slop grade |
| `/accessibility` | accessibility | WCAG 2.1 AA compliance |
| `/user-flow-test` | user-flow-test | End-to-end journey testing |
| `/docs-update` | docs-safety | Documentation sync |

### Planning Commands (with Personas)
| Command | Skill | Persona | Purpose |
|---------|-------|---------|---------|
| `/brainstorm` | brainstorm | Jack Ma | Product discovery |
| `/ceo-review` | plan-review-ceo | Steve Jobs | Scope review |
| `/eng-review` | plan-review-eng | Linus Torvalds | Architecture review |
| `/design-review-plan` | plan-review-design | James Dyson | Design critique |

### Pipeline Commands
| Command | Skill | Persona | Purpose |
|---------|-------|---------|---------|
| `/autoplan` | autoplan | Jobs → Torvalds → Dyson | Full review pipeline, auto-decisions, saves report |
| `/plan` | planner | — | Architecture planning |
| `/investigate` | investigation | — | Root cause debugging |
| `/marketing` | marketing | Atrioc | Content & positioning review |
| `/qa` | qa | — | Quality assurance testing |
| `/ship` | shipping | — | PR + release workflow |
| `/reflect` | reflect | Warren Buffett | Session retrospective |

### Safety Commands
| Command | Purpose |
|---------|---------|
| `/careful` | Toggle destructive command warnings |
| `/freeze <dir>` | Restrict edits to one directory |
| `/guard <dir>` | Both careful + freeze |
| `/unfreeze` | Clear all safety modes |

## Usage Examples

```bash
# Review changed code with Fix-First
/code-review

# Security audit the auth system
/security-audit src/lib/auth

# Steve Jobs scope review
/ceo-review

# Linus Torvalds architecture review
/eng-review

# Test the signup flow
/user-flow-test signup flow

# Ship with quality gates
/ship

# Warren Buffett session retrospective
/reflect
```

## Creating Custom Commands

1. Create command file: `.claude/commands/[name].md`
2. Create or extend matching skill: `.claude/skills/[name]/SKILL.md`
3. Reference the skill's Review Mode in the command

### Command Template

```markdown
[Description of what the command does]

$ARGUMENTS

Load and follow the **Review Mode** section in: .claude/skills/[skill-name]/SKILL.md
```
