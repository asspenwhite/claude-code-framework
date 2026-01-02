# Claude Code Internals

Understanding how Claude Code stores data and how to migrate between folders.

---

## Session Storage

Claude Code stores conversation history and session data in:

```
C:\Users\Admin\.claude\                    # Windows
~/.claude/                                  # Mac/Linux
```

### Key Files and Folders

| Path | Purpose |
|------|---------|
| `.claude.json` (in user home) | Global config, project settings, MCP servers |
| `.claude/history.jsonl` | **Session index** - tracks all sessions by project path |
| `.claude/projects/` | Session transcript files organized by project path |
| `.claude/todos/` | Todo list persistence |
| `.claude/settings.json` | User preferences |

### Project History Folders

Sessions are stored in folders named after the project path with special encoding:

```
.claude/projects/
├── C--Users-Admin-Documents-Projects-my-app/     # Sessions for C:\Users\Admin\Documents\Projects\my-app
│   ├── abc123-def456-789.jsonl                   # Individual session transcript
│   ├── xyz789-abc123-456.jsonl                   # Another session
│   └── agent-a1b2c3d.jsonl                       # Sub-agent transcripts
└── C--Users-Admin-Documents-Projects/            # Sessions for parent folder
```

**Path encoding:** `C:\Users\Admin\Documents\Projects` becomes `C--Users-Admin-Documents-Projects`

---

## Migrating Projects to a New Folder

If you rename or move your project folder (e.g., `Docker` to `Projects`), Claude Code won't find your old sessions because the paths no longer match.

### Step-by-Step Migration

**1. Update `.claude.json` project paths:**

```javascript
// Run with Node.js
const fs = require('fs');
const data = JSON.parse(fs.readFileSync('C:/Users/Admin/.claude.json', 'utf8'));

// Update project keys
const newProjects = {};
for (const [path, config] of Object.entries(data.projects)) {
  const newPath = path.replace('/Documents/OldFolder', '/Documents/NewFolder');
  newProjects[newPath] = config;
}
data.projects = newProjects;

// Update GitHub repo paths if present
if (data.githubRepoPaths) {
  for (const [repo, paths] of Object.entries(data.githubRepoPaths)) {
    data.githubRepoPaths[repo] = paths.map(p =>
      p.replace('OldFolder', 'NewFolder')
    );
  }
}

fs.writeFileSync('C:/Users/Admin/.claude.json', JSON.stringify(data, null, 2));
```

**2. Update the session index (`history.jsonl`):**

This is the **critical file** that `claude --resume` uses to find sessions.

```javascript
const fs = require('fs');
const path = 'C:/Users/Admin/.claude/history.jsonl';
const content = fs.readFileSync(path, 'utf8');
const updated = content.replace(/Documents\\\\OldFolder/g, 'Documents\\\\NewFolder');
fs.writeFileSync(path, updated);
```

**3. Copy session folders (optional but recommended):**

```powershell
# Windows PowerShell
Copy-Item "C:\Users\Admin\.claude\projects\C--Users-Admin-Documents-OldFolder" `
          "C:\Users\Admin\.claude\projects\C--Users-Admin-Documents-NewFolder" -Recurse
```

**4. Verify:**

```bash
cd C:\Users\Admin\Documents\NewFolder
claude --resume
# Should now show your old sessions
```

---

## Why Copying Session Folders Alone Doesn't Work

Simply copying `.claude/projects/` folders won't make sessions appear in `--resume` because:

1. **`history.jsonl` is the index** - Claude reads this file to find sessions
2. **Project paths must match** - The `"project"` field in history.jsonl entries must match your current working directory
3. **Session files are just transcripts** - They're not indexed unless referenced in history.jsonl

---

## Common Issues

### "No conversations found to resume"

**Cause:** Running `claude --resume` from a path that doesn't match any entries in `history.jsonl`

**Fix:**
1. Check history.jsonl for the actual project paths stored
2. Update history.jsonl to use your new paths
3. Or run from a folder that matches existing paths

### Sessions from wrong project appearing

**Cause:** Multiple projects with similar names or copied session folders

**Fix:** Each project path gets its own folder in `.claude/projects/`. Make sure you're in the correct directory.

### MCP servers not loading after folder rename

**Cause:** MCP servers are configured per-project path in `.claude.json`

**Fix:** Update the project paths in `.claude.json` as shown in the migration steps above.

---

## Backup Before Major Changes

Always backup before migrating:

```powershell
# Backup .claude.json
Copy-Item "C:\Users\Admin\.claude.json" "C:\Users\Admin\.claude.json.backup"

# Backup history.jsonl
Copy-Item "C:\Users\Admin\.claude\history.jsonl" "C:\Users\Admin\.claude\history.jsonl.backup"
```

---

## Session Commands

```bash
# Resume from list
claude --resume

# Continue most recent session (any project)
claude --continue

# Start fresh
claude
```

---

## Related Files

- [MCP.md](MCP.md) - MCP server configuration
- [ARCHITECTURE.md](ARCHITECTURE.md) - Skills, agents, commands system
