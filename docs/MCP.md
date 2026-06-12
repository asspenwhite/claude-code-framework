# MCP Server Configuration

Model Context Protocol (MCP) servers extend Claude's capabilities with real-time access to external tools and services.

---

## Recommended MCP Servers

### Playwright (Visual Testing)

Browser automation for testing UI changes.

```bash
claude mcp add playwright -- npx @playwright/mcp@latest
```

**Tools:**
| Tool | Purpose |
|------|---------|
| `browser_navigate` | Navigate to URL |
| `browser_click` | Click elements |
| `browser_type` | Type into inputs |
| `browser_snapshot` | Get accessibility tree |
| `browser_take_screenshot` | Capture visual evidence |
| `browser_resize` | Test responsive layouts |

**Usage:**
```
Claude: Let me check the homepage layout
[Uses browser_navigate to open site]
[Uses browser_snapshot to see structure]
[Uses browser_take_screenshot for visual evidence]
```

---

### Context7 (Library Documentation)

Get up-to-date documentation for any library.

```bash
claude mcp add context7 -- npx -y @upstash/context7-mcp
```

**Tools:**
| Tool | Purpose |
|------|---------|
| `resolve-library-id` | Find the library's docs ID |
| `query-docs` / `get-library-docs` | Fetch current docs for a library |

**Usage:**
```
Claude: How do I use the new Next.js features?
[Resolves library, fetches latest Next.js docs]
[Provides accurate, current information]
```

---

### Obsidian (Cross-Project Knowledge)

Your vault as Claude's queryable long-term memory. Requires the **Local REST
API** community plugin in Obsidian, then an MCP bridge such as
[mcp-obsidian](https://github.com/MarkusPfundstein/mcp-obsidian):

```bash
claude mcp add obsidian -- uvx mcp-obsidian
# (reads OBSIDIAN_API_KEY / OBSIDIAN_HOST from its environment — keep the key
#  in an encrypted env file, not in shell history or committed config)
```

**Tools:**
| Tool | Purpose |
|------|---------|
| `obsidian_simple_search` | Full-text search with surrounding context — use first |
| `obsidian_batch_get_file_contents` | Read multiple notes in ONE call |
| `obsidian_get_file_contents` | Read a single note |
| `obsidian_patch_content` / `obsidian_append_content` | Write back to the vault |

See `docs/playbooks/KNOWLEDGE_BASE.md` for the full vault pattern.

---

### Supabase (Database)

Direct database access for queries and migrations (hosted HTTP server, OAuth on first use):

```bash
claude mcp add --transport http supabase https://mcp.supabase.com/mcp
```

**Tools:**
| Tool | Purpose |
|------|---------|
| `execute_sql` | Run SQL queries |
| `apply_migration` | Apply schema changes |
| `list_tables` | View database structure |
| `get_logs` | View service logs |

---

### Stripe (Payments)

Payment management and webhook monitoring.

```bash
claude mcp add --transport http stripe https://mcp.stripe.com/
```

---

## Managing MCP Servers

```bash
claude mcp list               # list configured servers
claude mcp add <name> -- <command>
claude mcp remove <name>
/mcp                          # in-session: status + authenticate
```

---

## Permissions

Control MCP access in `.claude/settings.local.json`:

```json
{
  "permissions": {
    "allow": [
      "mcp__playwright__*",
      "mcp__context7__*",
      "mcp__obsidian__obsidian_simple_search"
    ]
  }
}
```

Allowlist read-only tools freely; leave write tools (vault patch, SQL
execution) behind prompts unless you've decided otherwise deliberately.

---

## Best Practices

1. **Use MCP instead of guessing** - Don't ask user to check things manually
2. **Playwright for visual verification** - Take screenshots to confirm UI changes
3. **Context7 for docs** - Always get current library documentation
4. **Obsidian first for cross-project questions** - search the vault before exploring the filesystem
5. **Verify package names against the server's own README** - MCP install commands rot fast; two of the four in this file's previous revision were already wrong by mid-2026
