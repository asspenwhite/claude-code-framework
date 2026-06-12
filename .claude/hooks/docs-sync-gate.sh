#!/usr/bin/env bash
# Stop hook (opt-in — see docs/HOOKS.md "Shipped Hooks" to enable) — blocks
# the turn from ending while tracked files have uncommitted changes that
# docs/CHANGELOG.md doesn't reflect. Makes "every change gets logged" a
# property of the system instead of a request.
#
# Self-disables when: not a git repo, no docs/CHANGELOG.md (workflow not
# adopted), nothing changed, or the changelog WAS touched.
# Caveat: in a repo that was already dirty before the session, this will ask
# for a changelog entry covering that pre-existing drift once. Claude Code
# force-ends the turn after 8 consecutive blocks, so it cannot loop forever.
command -v git >/dev/null 2>&1 || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
[ -f docs/CHANGELOG.md ] || exit 0

CHANGED=$(git status --porcelain 2>/dev/null | grep -v '^??' | awk '{print $NF}')
[ -z "$CHANGED" ] && exit 0
printf '%s\n' "$CHANGED" | grep -q '^docs/CHANGELOG.md$' && exit 0

NON_LOG=$(printf '%s\n' "$CHANGED" | grep -v '^docs/CHANGELOG.md$' | head -10 | tr '\n' ' ')
echo "Changed without a changelog entry: ${NON_LOG}. Add an entry to docs/CHANGELOG.md under [Unreleased] describing these changes (one line each is fine), then finish." >&2
exit 2
