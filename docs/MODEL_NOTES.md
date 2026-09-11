# Model-Era Notes — Claude 5 / Opus 5

What changed since this framework's last tuning pass (Opus 4.8, June 2026),
and what it means for your CLAUDE.md and workflow.

---

## Current Lineup (September 2026)

| Model | ID | Notes |
|-------|----|----|
| **Claude Opus 5** | `claude-opus-5` | **Default Opus in Claude Code** since 2026-07-22. 1M context. Supports **fast mode** (`/fast`). |
| Claude Sonnet 5 | `claude-sonnet-5` | Default for Pro / Team Standard / Enterprise seats since 2026-07-01. 1M native context, adaptive thinking on by default. |
| Claude Fable 5.1 | `claude-fable-5-1` | Top capability tier, above Opus. Thinking always on; priced above Opus. |
| Claude Opus 4.8 | `claude-opus-4-8` | Previous default. Still supports fast mode. |
| Claude Haiku 4.5 | `claude-haiku-4-5-20251001` | Cheap/fast tier, good for subagents. |

**Fast mode** (`/fast`) applies to **Opus 5 and Opus 4.8 only** — support was removed
from Opus 4.7. Same model, up to 2.5x output speed, premium pricing.

### Effort is the knob this doc used to be missing

`xhigh` is the recommended effort for most coding and agentic work, and is the
Claude Code default. Dial it with the interactive `/effort` slider. Opus 4.8 and
later run at **high effort by default**, so raising to `xhigh` is a deliberate
step up for hard tasks, and `low` is right for subagents and routine edits.

Hooks can read the active level via `effort.level` and `$CLAUDE_EFFORT` — gate
expensive checks on high-effort turns only. See `docs/HOOKS.md`.

---

## Retired: the 4.6 "adaptive thinking fix"

Earlier versions of this framework (v1.6) shipped a three-layer client patch
(`docs/CLAUDE_4_6_UPGRADE.md`, now deleted — see git history) to force
adaptive thinking on Opus 4.6. **Do not apply it anymore.** Current Claude
Code handles thinking natively and correctly. If you patched `cli.js` on a
machine back then, reinstall/update Claude Code to clear it.

This is a recurring lesson worth keeping: **client workarounds rot fast.**
Prefer waiting one release over patching the binary, unless the regression is
blocking daily work — and if you do patch, write down the removal condition.

## What's New in Claude Code Since 4.6

| Change | What to do about it |
|--------|---------------------|
| **Skills and slash commands unified** | Every skill gets a `/name` command automatically. `.claude/commands/` still works but is legacy — define everything as a skill in `.claude/skills/<name>/SKILL.md`. |
| **Hooks matured into a full lifecycle system** | ~30 events, blockable gates, JSON control output. The advisory-vs-deterministic split is now the core config decision — see `docs/HOOKS.md`. |
| **Plan mode** | Explore → plan → implement → commit as an explicit workflow; Claude reads but doesn't change anything until you approve the plan. Use for multi-file or unfamiliar changes; skip it when you could describe the diff in one sentence. |
| **Auto permission mode** | A classifier reviews commands and blocks only risky ones — replaces hand-maintained allowlists for many flows. `claude --permission-mode auto`. |
| **Subagents & agent teams** | Custom subagents in `.claude/agents/*.md` (own context, own tools, own model). Use them for investigation so exploration doesn't pollute the main context, and for fresh-context adversarial review. |
| **Checkpoints / rewind** | Every prompt checkpoints code + conversation; `Esc Esc` or `/rewind` restores either. Makes "try the risky approach" cheap. |
| **`.claude/rules/*.md`** | Modular rule files loaded alongside CLAUDE.md — a middle ground between one fat CLAUDE.md and skills. |

## CLAUDE.md Guidance, Current Era

The 4.6-era advice mostly held up. Updates:

| v1.6 rule | Status now |
|-----------|-----------|
| `<do_not_overengineer>` block | **Keep.** Current models are still proactive; this is still the highest-value block. |
| `<parallel_tool_calls>` block | **Dropped from the template.** Parallel tool dispatch is native and prompted by the harness itself now — the block is redundant tokens. |
| `<context_window>` block | **Dropped.** Auto-compaction is announced by the harness; the instruction is built in. |
| No anti-laziness prompts ("be thorough") | **Keep.** Still true, still wastes tokens. |
| Soft tool language ("when relevant", not "You MUST") | **Keep.** Over-triggering on imperatives is still real. |

The test for every line (from the official best-practices guide): *"Would
removing this cause Claude to make mistakes?"* If not, cut it. A bloated
CLAUDE.md doesn't just waste tokens — it buries the rules that matter.

And the structural rule that supersedes all phrasing advice: **if a rule must
hold 100% of the time, it isn't a CLAUDE.md rule — it's a hook**
(`docs/HOOKS.md`).

## Proactiveness Controls

Current models default to acting. Two opposing XML blocks let you shift that
default per project — use **at most one**, and only when the default is wrong
for the work:

```xml
<default_to_action>
Implement changes rather than only suggesting them. If the user's intent is
unclear, infer the most useful likely action and proceed, using tools to
discover missing details instead of asking.
</default_to_action>
```

```xml
<do_not_act_before_instructions>
Do not implement changes unless clearly instructed. When intent is ambiguous,
default to providing information and recommendations rather than taking action.
</do_not_act_before_instructions>
```

The conservative block earns its keep in **operational repos** (the network
and virtualization playbooks assume confirm-before-mutate) and review/docs
agents. The action block suits unattended build pipelines. For interactive
coding, ship neither — the default is already balanced.

## Keep Personal Preferences Out of the Template

Per-person behavior tuning — e.g. "confirm-then-act on ambiguous intent
rather than defaulting to action" — belongs in your user-level
`~/.claude/CLAUDE.md` or a gitignored `CLAUDE.local.md`, not in a shared
project template where every downstream user inherits it. v1.6 carried one
such block in the template; v1.7 moved it out.

## Migrating a v1.6 Project

1. Delete `docs/CLAUDE_4_6_UPGRADE.md`; un-patch any patched client (just update Claude Code). Verify clean: `grep -c 'CLAUDE_CODE_THINKING_BUDGET' "$(readlink -f "$(command -v claude)")"` should find nothing, and remove `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` from `~/.claude/settings.json` if present.
2. Remove `<parallel_tool_calls>` and `<context_window>` blocks from CLAUDE.md. Keep `<do_not_overengineer>`.
3. If you have `.claude/commands/*.md`, fold each into a skill (`.claude/skills/<name>/SKILL.md` with `name` + `description` frontmatter).
4. Pick your one or two highest-violation CLAUDE.md rules and convert them to hooks.
5. Re-run the line-by-line "would removing this cause mistakes?" prune.
