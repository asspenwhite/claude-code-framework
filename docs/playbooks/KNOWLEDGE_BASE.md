# Playbook: Claude Code + a Knowledge Base (Obsidian Pattern)

Running a personal knowledge vault as Claude's **cross-project memory** —
the piece that makes the other playbooks compound. Tested with an Obsidian
vault served over its Local REST API via MCP, queried by Claude in every
session across 30+ projects.

---

## Why a Vault Beats a Fat CLAUDE.md

CLAUDE.md is loaded every session and must stay small. A vault is *queried* —
unlimited size, zero standing cost, always current. Project facts, infra
state, decisions, and incident history live in the vault; CLAUDE.md carries
only the rule "search the vault first."

```
Vault/
├── Home.md + *MOC.md          # dashboards + maps-of-content per domain
├── <Domain>/<Project>.md      # one HUB NOTE per project/system
├── <Domain>/_docs/<project>/  # project repo docs/ mirrored in (junction/symlink)
├── Infrastructure/            # networking, security incidents, hardware
├── Research/                  # external research, model/tool evaluations
└── Ideas/, _Inbox/, _Daily/
```

**Hub note** = one page per project: status, key decisions table, links to
the repo's docs, cross-references. It's the answer to "catch me up on X" and
the write-back target for "we just decided Y."

**Repo docs mirrored into the vault** (symlink/junction of each project's
`docs/`) means updating a repo's docs updates the vault automatically — one
write, both worlds current.

## The Operating Loop

1. **Vault-first.** Any mention of a project, system, or decision → search
   the vault *before* exploring the filesystem. One full-text search with
   surrounding context usually answers it; batch-read full notes only when
   needed.
2. **Write-back.** After significant decisions, incidents, or milestones,
   update the hub note (or add the incident note). The rule of thumb: if a
   future session would benefit from knowing it, it goes in the vault now.
3. **Reconcile, don't overwrite.** When reality diverges from an old note,
   append a dated correction/supersession block rather than silently
   rewriting — stale-but-flagged beats silently-wrong, and the history shows
   how the decision moved.
4. **Update the MOC** when adding a hub note, or it's orphaned — findable by
   search but invisible to navigation.

## CLAUDE.md Wiring (global, not per-project)

A short block in your user-level CLAUDE.md:

- vault-first search rule (and: run filesystem exploration *after*, not instead)
- write-back triggers (decision → hub note; incident → incident note; new
  research → Research/)
- guardrails: don't create notes without asking, never delete without
  confirmation, the vault is source of truth for cross-project knowledge —
  each repo's `docs/` is source of truth for itself

If the search-first rule keeps getting skipped, that's a `UserPromptSubmit`
hook candidate (`docs/HOOKS.md`) — inject a reminder, or block until a vault
search has run.

## Failure Modes (all observed)

- **The stale snapshot trusted as current.** Notes capture moments; systems
  move on. Date your snapshots; supersede explicitly (see AS-BUILT template).
- **Vault as dumping ground.** No hub notes, no MOC → search results without
  structure. Structure is what lets one query orient a session.
- **Write-back skipped under momentum.** The session that ships three big
  things and logs none of them costs you next week. This is what `Stop`-hook
  reminders are for.
- **Duplicate notes** because search-before-create was skipped. Update the
  existing note; create only when nothing covers it.
