#!/usr/bin/env bash
# diff-scope.sh — Utility script (not a hook)
# Outputs list of changed files vs base branch.
# Used by review/QA skills for diff-aware intelligence.
#
# Usage: .claude/hooks/diff-scope.sh [base-branch]
# Default base branch: main (falls back to master)

BASE="${1:-}"

# Auto-detect base branch
if [ -z "$BASE" ]; then
  if git rev-parse --verify main &>/dev/null; then
    BASE="main"
  elif git rev-parse --verify master &>/dev/null; then
    BASE="master"
  else
    echo "ERROR: Could not detect base branch (tried main, master)" >&2
    exit 1
  fi
fi

# Get merge base
MERGE_BASE=$(git merge-base HEAD "$BASE" 2>/dev/null)

if [ -z "$MERGE_BASE" ]; then
  echo "ERROR: Could not find merge base with $BASE" >&2
  exit 1
fi

# Output changed files
git diff --name-only "$MERGE_BASE"...HEAD
