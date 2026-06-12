# Playbook: Claude Code as Network Administrator

Running Claude Code as the operator of a real network (tested on a UniFi
site: gateway, switches, APs, VLAN segmentation, firewall policy — managed
through the controller's REST API).

---

## Workspace Shape

```
network-admin/
├── CLAUDE.md                 # role, constraints, doc index
├── docs/
│   ├── AS-BUILT.md           # ★ live state — devices, VLANs, SSIDs, firewall, clients
│   ├── RUNBOOK.md            # API access, write-safety rules, gotchas
│   ├── CHANGELOG.md          # append-only audit log — EVERY change
│   ├── SECURITY-EVALUATION.md# graded posture + best-practice gaps
│   ├── NETWORK-TOPOLOGY.md   # WAN/LAN/VLANs/IP map
│   ├── DEVICE-TOPOLOGY.md    # physical tree, models, firmware, ports
│   ├── *-PLAN.md             # DRAFT designs (segmentation, wifi, monitoring…)
│   └── INCIDENT-*.md         # one per outage, same-day
├── scripts/                  # API snapshot + fetch tooling
└── data/raw/                 # raw API JSON snapshots (gitignored)
```

## The Operating Contract (CLAUDE.md essentials)

1. **Read-only by default.** Any write call — config change, port edit,
   restart, adopt — is confirmed with the operator first.
2. **Snapshot before mutate.** Save the raw API object to `data/raw/` before
   any PUT/POST, so every change carries its own restore point.
3. **Audit everything.** Every change appends a CHANGELOG entry:
   instruction → action → rollback procedure. Tag read-only sessions
   `[READ-ONLY]` so the log shows scope at a glance.
4. **Plans are DRAFTs until executed.** A segmentation plan is not the
   network. When a phase executes, AS-BUILT is updated and the plan marked
   superseded.

## Bootstrap Sequence (first session)

1. Claude reads the controller API docs, writes a snapshot script that GETs
   every endpoint into `data/raw/`.
2. From the snapshots, it writes DEVICE-TOPOLOGY, NETWORK-TOPOLOGY, and the
   first AS-BUILT — your network, fully documented, before anything changes.
3. Then a SECURITY-EVALUATION: graded posture, gaps, prioritized fixes.
4. Only then: plans. Segmentation, WiFi tuning, firewall policy — each as a
   DRAFT doc with an implementation order and rollback notes.

This sequence matters. Weeks of correct, confident changes come from making
Claude *earn* its model of the network before it touches anything.

## Hard-Won Gotchas (each cost an outage or a scare)

- **PUT semantics replace, not merge.** Controller APIs often replace an
  entire array (e.g. switch port overrides) with whatever you send.
  Read-modify-write the *full* object — and know that a staged-but-unapplied
  change in that array gets re-asserted by your unrelated edit. That exact
  mechanism took down a management uplink mid-migration.
- **Never migrate the port you manage through.** Map your own management
  path (and its VLAN) before VLAN work. Keep an out-of-band path (second
  uplink, WiFi on a different segment) up before touching trunk/uplink ports.
- **Dual-homed machines mask breakage.** A box with wired + WiFi keeps
  "working" while its wired path is dead — you discover the damage hours
  later. Verify each path independently after changes.
- **Static-IP devices strand silently** when moved to a new VLAN — nothing
  errors, the device just vanishes from its old subnet. Inventory static
  addressing before any segmentation move.

## Incident Discipline

Every outage gets `docs/INCIDENT-YYYY-MM-DD-slug.md` the same day (template:
`docs/templates/INCIDENT.template.md`): severity, timeline including the
wrong turns, root cause as mechanism, and lessons that land back in the
RUNBOOK's gotchas. Six months in, the incident directory is the most valuable
training data your CLAUDE.md never had to carry — Claude reads it on demand.

## Hook Candidates

- `Stop` gate: block session end if mutating API calls ran but CHANGELOG.md
  wasn't updated (audit-trail enforcement — see `docs/HOOKS.md`).
- `PreToolUse` on Bash: deny calls to the controller's destructive endpoints
  unless a snapshot file from this session exists.
