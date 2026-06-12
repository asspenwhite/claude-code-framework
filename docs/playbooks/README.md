# Playbooks — Claude Code Beyond Coding

These playbooks document running Claude Code as the **primary operator** of
real systems — not just a code assistant. Each one is distilled from months
of daily production use (a UniFi network, a Proxmox virtualization host,
a revenue SaaS, a personal knowledge base), with the specifics genericized.

| Playbook | Role | Core pattern |
|----------|------|--------------|
| [NETWORK_ADMIN.md](NETWORK_ADMIN.md) | Network administrator | Read-only by default, AS-BUILT + audit CHANGELOG, incident reports |
| [VIRTUALIZATION_ADMIN.md](VIRTUALIZATION_ADMIN.md) | Proxmox / hypervisor admin | Infra-as-a-repo, phase-gated migrations, docs before action |
| [SAAS_OPERATOR.md](SAAS_OPERATOR.md) | Website / SaaS operator | Sprint loop with adversarial review, ADRs, launch gates |
| [KNOWLEDGE_BASE.md](KNOWLEDGE_BASE.md) | Knowledge-base maintainer | Vault-first context, hub notes, write-back discipline |

## The Shared Doctrine

Every playbook is the same five ideas wearing different clothes:

1. **A repo per system.** Even a network or a hypervisor gets a git repo:
   `CLAUDE.md` + `docs/` + `scripts/`. If Claude administers it, Claude needs
   a home with rules, state docs, and history.
2. **Docs describe what IS, plans describe what MIGHT BE.** Keep an
   `AS-BUILT.md` (live state, snapshot-dated) strictly separate from DRAFT
   plan docs. Most ops mistakes trace to acting on a plan as if it were
   reality, or vice versa.
3. **Append-only audit trail.** Every change gets a CHANGELOG entry: the
   instruction, the action taken, and the rollback. Every outage gets an
   incident report the same day.
4. **Read-only by default.** Mutating actions are confirmed, snapshotted
   first, and logged. The asymmetry is the point: reads are free, writes are
   ceremonies.
5. **Lessons compound into the system.** Incident lessons land in the
   runbook's gotchas. Repeated-violation rules become hooks. Decisions become
   ADRs. The setup gets harder to break every month.

## Adapting These

Start from the framework root (`CLAUDE.md` + `docs/templates/`), pick the
playbook nearest your role, and let Claude do the adaptation:

```
Read docs/playbooks/NETWORK_ADMIN.md. Set this workspace up the same way
for my [system]. Start read-only: snapshot current state and write the
initial AS-BUILT before proposing any changes.
```
