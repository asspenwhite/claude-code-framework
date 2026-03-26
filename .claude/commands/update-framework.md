Update the Claude Code Framework from the source repo.

$ARGUMENTS

## How It Works

The framework has two parts:
1. **Source repo** — the `claude-code-framework/` folder where updates are developed and pushed to GitHub
2. **Global install** — `~/.claude/skills/` and `~/.claude/commands/` where Claude actually reads them

`/update-framework` syncs the global install from the source repo (or from GitHub if no local repo exists).

## Process

### 1. Find the Source Repo

Check for a local clone of the framework:

```bash
# Common locations (check in order)
# 1. Current directory IS the framework repo
# 2. Sibling directory: ../claude-code-framework/
# 3. User's home: ~/claude-code-framework/
# Look for .claude/skills/framework-launch/SKILL.md as the fingerprint
```

- **Found locally** → use it as source (fastest, works offline)
- **Not found locally** → clone from GitHub into a temp directory:
  ```bash
  TEMP_DIR=$(mktemp -d)
  git clone --depth 1 https://github.com/asspenwhite/claude-code-framework.git "$TEMP_DIR"
  ```

If using a local repo, `git pull` first to make sure it's current.

### 2. Show What Changed

Compare the source against the current global install (`~/.claude/`):

- Diff skills: `diff -rq SOURCE/.claude/skills/ ~/.claude/skills/` (excluding README.md)
- Diff commands: `diff -rq SOURCE/.claude/commands/ ~/.claude/commands/` (excluding README.md)
- List: new files, modified files, deleted files
- Read `CHANGELOG.md` from source for release notes

Show the user a summary BEFORE applying.

### 3. Copy to Global

```bash
cp -r SOURCE/.claude/skills/* ~/.claude/skills/
cp SOURCE/.claude/commands/*.md ~/.claude/commands/
cp -r SOURCE/.claude/hooks/* ~/.claude/hooks/ 2>/dev/null
rm -f ~/.claude/skills/README.md ~/.claude/commands/README.md
```

### 4. Also Update Project-Local (if applicable)

If the CURRENT working directory (not the framework repo) has `.claude/skills/framework-launch/`:
- This project has a local install too — sync skills and commands here as well
- **Never overwrite CLAUDE.md** — show diff, let user decide
- **Never overwrite project docs** (DECISIONS.md, TODO.md, etc.)

### 5. Clean Up

If a temp directory was created, delete it.

### 6. Report

Show:
- Source: local repo or GitHub clone
- Files updated (count + list)
- New skills/commands added (if any)
- Version: old → new (from CHANGELOG.md)
- Any manual steps needed

## Flags

- `--dry-run` in `$ARGUMENTS` → show what would change, don't apply
- `--force` in `$ARGUMENTS` → skip confirmation, just copy
- `--github` in `$ARGUMENTS` → force clone from GitHub even if local repo exists

## Rules

- Always show changes before applying (unless `--force`)
- Never overwrite CLAUDE.md without asking
- Never touch project-specific docs (DECISIONS.md, TODO.md, ARCHITECTURE.md, etc.)
- If the local repo has uncommitted changes, warn the user before pulling
