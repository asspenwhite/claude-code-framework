# File Format Token Efficiency Guide

Choosing the right file format for AI-readable documentation significantly impacts token usage and workflow efficiency.

---

## Format Ranking (Most to Least Efficient)

| Format | Token Efficiency | Best For |
|--------|------------------|----------|
| **YAML** | Most efficient | Schemas, configs, API specs, structured data |
| **Markdown** | Good | Documentation, guides, changelogs |
| **XML** | Claude-optimized | Constraints, rules, distinct sections |
| **JSON** | Least efficient | Avoid for large files (use for small configs only) |

---

## YAML - Use for Structured Data

YAML's indentation-based structure helps models parse information correctly with minimal syntax overhead.

**Best for:**
- Database schemas (`schema.yaml`)
- API specifications (`api.yaml`)
- Configuration files
- Security rules
- Environment settings

**Example:**
```yaml
tables:
  users:
    columns:
      id: { type: uuid, pk: true }
      email: { type: text, unique: true }
      role: { type: text, values: [admin, user] }
    rls:
      - users_read_own: Users can read own data
```

**Why it works:** No brackets, no quotes around keys, hierarchical structure matches data relationships.

---

## Markdown - Use for Documentation

Heading levels create natural navigation for AI models scanning large documents.

**Best for:**
- `CLAUDE.md` - AI instructions
- `README.md` - Project overview
- `CHANGELOG.md` - Version history
- `TODO.md` - Task tracking
- Guides and tutorials

**Example:**
```markdown
## Authentication

### JWT Tokens
- Access tokens expire in 1 hour
- Refresh tokens expire in 7 days

### Protected Routes
All `/api/*` routes require valid JWT
```

**Why it works:** `##` headings let models skip to relevant sections without reading everything.

---

## XML - Use for Claude-Specific Rules

Anthropic states Claude models are fine-tuned to recognize XML tags as containers and separators.

**Best for:**
- Constraint sections in CLAUDE.md
- Rule definitions
- Distinct policy sections
- When you need clear boundaries between concepts

**Example:**
```xml
<constraints>
  <budget>Zero-cost operation - free tiers only</budget>
  <security>No secrets in docs, use env vars</security>
  <style>No emojis unless requested</style>
</constraints>

<rules>
  <rule name="auth">Always verify JWT before mutations</rule>
  <rule name="rls">Never bypass RLS policies</rule>
</rules>
```

**Why it works:** Tags create unambiguous section boundaries. Other models prefer Markdown/YAML.

---

## JSON - Avoid for Large Files

JSON's braces, quotes, and commas add significant token overhead.

**Only use for:**
- Small config files (`tsconfig.json`, `package.json`)
- Task states and settings
- Files that must be JSON for tooling

**Avoid for:**
- Documentation
- Schemas (use YAML)
- API specs (use YAML)
- Large configuration files

**Token comparison:**
```json
{
  "tables": {
    "users": {
      "columns": {
        "id": { "type": "uuid", "pk": true }
      }
    }
  }
}
```
vs YAML equivalent (30% fewer tokens):
```yaml
tables:
  users:
    columns:
      id: { type: uuid, pk: true }
```

---

## Recommended Project Structure

```
docs/
├── CLAUDE.md          # Markdown - AI instructions with headings
├── README.md          # Markdown - Project overview
├── CHANGELOG.md       # Markdown - Version history
├── TODO.md            # Markdown - Task tracking
├── schema.yaml        # YAML - Database schema
├── api.yaml           # YAML - API specification
├── config.yaml        # YAML - Project configuration
└── DECISIONS.md       # Markdown - Architectural decisions
```

---

## Converting Existing Files

### Markdown Tables → YAML

Before (Markdown):
```markdown
| Column | Type | Description |
|--------|------|-------------|
| id | uuid | Primary key |
| email | text | User email |
```

After (YAML):
```yaml
columns:
  id: { type: uuid, description: Primary key }
  email: { type: text, description: User email }
```

### JSON → YAML

Before (JSON):
```json
{
  "endpoints": {
    "GET /users": {
      "auth": true,
      "response": { "users": "User[]" }
    }
  }
}
```

After (YAML):
```yaml
endpoints:
  GET /users:
    auth: true
    response: { users: User[] }
```

---

## Key Principles

1. **Match format to content type** - Structured data → YAML, documentation → Markdown
2. **Use XML for Claude-specific rules** - When you need clear section boundaries
3. **Avoid JSON for large files** - Token overhead adds up quickly
4. **Keep files focused** - One concern per file, easier for AI to navigate
5. **Use headings generously** - In Markdown, headings are free navigation aids

---

*Last updated: January 4, 2026*
