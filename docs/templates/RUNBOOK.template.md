# Runbook — [System Name]

> **Read this before any operational work on [system].** Connection details,
> safety rules, common operations, and the gotchas that have already bitten.

---

## Access

| Item | Value |
|------|-------|
| Endpoint / console | [URL, host, or CLI entry point] |
| Auth | [where the credential lives — e.g. encrypted env file, secret manager. Never the credential itself.] |
| Snapshot tooling | [script that dumps current state, e.g. `scripts/snapshot.sh`] |

## Safety Rules

1. **Read-only by default.** Any write/mutating call (config change, restart,
   delete, adopt, migrate) is confirmed with the operator first.
2. **Snapshot before mutate.** Save the raw current object/config before any
   write, so every change has a known-good restore point.
3. **Know your management path.** Never change the port/interface/route you
   are managing the system through. If unavoidable, have an out-of-band path
   and a rollback ready *before* you start.
4. **Log every change** in `CHANGELOG.md`: what, why, how to roll back.

## Common Operations

### [Operation name]

```bash
# exact commands, in order
```

**Verify:** [how to confirm it worked]
**Rollback:** [how to undo it]

## Gotchas

The hard-won list. Each entry should say what happens, why, and what to do
instead. Link the incident report that produced it.

- **[API/tool behavior]** — [e.g. "PUT on this endpoint replaces the entire
  array, not just the field you sent — read-modify-write the full object."]
  (See `INCIDENT-YYYY-MM-DD-….md`)

## Emergency Procedures

### [Failure scenario, e.g. "management unreachable"]

1. [Step]
2. [Step]

---

*Keep this current: every incident's "Lessons Learned" should land here as a
gotcha or a new emergency procedure.*
