# AS-BUILT — [System Name]

> **Live-state reference.** This document describes what exists *right now* —
> not what was planned, not what is proposed. Plans live in their own DRAFT
> docs; when a plan is executed, this file is updated and the plan doc is
> marked superseded.

**Snapshot date:** YYYY-MM-DD
**Verified against:** [live API query / console export / `scripts/snapshot` output]

---

## Inventory

| Component | Model / Version | Location / ID | Notes |
|-----------|-----------------|---------------|-------|
| [device or service] | [model, firmware, image tag] | [where it lives] | |

## Topology

[Diagram or table: how the components connect. For networks: VLANs, subnets,
SSIDs, uplinks. For services: containers, ports, reverse-proxy routes. For
VMs: host → VM → passthrough devices.]

| Segment / Zone | Purpose | Range / Address | Notes |
|----------------|---------|-----------------|-------|

## Configuration of Record

The non-default settings that matter. Anything someone would need to rebuild
this system from scratch — and anything that would surprise the next operator.

| Setting | Value | Why |
|---------|-------|-----|

## Known Deviations

Differences between this build and the original plan or vendor defaults,
with the reason. This section prevents "helpful" future cleanup from
reverting deliberate choices.

- [deviation] — [reason, link to DECISIONS.md entry or incident]

## Update Rules

1. **Update this file in the same session as the change.** An AS-BUILT that
   lags reality is worse than none — it gets trusted and it's wrong.
2. Every change here gets a paired entry in `CHANGELOG.md` (the audit log).
3. If the change came out of an incident, link the incident report.
4. Re-verify against live state on a fixed cadence (monthly works) and bump
   the snapshot date even when nothing changed — the date is the trust signal.
