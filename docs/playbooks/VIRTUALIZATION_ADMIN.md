# Playbook: Claude Code as Virtualization / Homelab Admin

Running Claude Code as the operator of a hypervisor estate (tested on a
Proxmox host with GPU-passthrough VMs, a 30+ container Docker stack, tunnel
ingress, and encrypted secrets — administered almost entirely by Claude).

---

## The Infra-as-a-Repo Pattern

One git repo is the source of truth for the whole estate, **cloned onto every
host** (hypervisor + each working VM), so any Claude session on any machine
has the same context:

```
infra/
├── CLAUDE.md                  # estate overview, where things live, AI rules
├── docs/
│   ├── vms/<vm-name>/         # per-VM state + migration logs
│   ├── procedures/            # runbooks: secrets, backups, GPU, tunnels
│   ├── INCIDENTS/             # one report per failure, dated
│   └── HARDWARE.md            # the physical truth (slots, lanes, quirks)
└── scripts/
```

A multi-host estate without this turns every session into re-discovery. With
it, "check the docs before acting" is a one-line CLAUDE.md rule that works.

## Operating Rules That Earn Their Keep

1. **When unsure about infra state, check `docs/` before acting.** The repo
   remembers what the model cannot — which VM owns the GPUs right now, which
   workaround is load-bearing, why that PCIe link is pinned to Gen3.
2. **Secrets never enter the repo or the context.** Encrypted-at-rest files
   (SOPS+age works well — decryptable non-interactively, no TTY prompts that
   break inside an agent's shell) with documented decrypt one-liners.
   Agent-blocking auth (GPG pinentry, interactive prompts) is itself worth an
   incident report the first time it strands a session.
3. **Phase-gated migrations with execution logs.** Big moves (host migration,
   GPU re-passthrough, storage swap) are split into lettered phases, each
   with verify steps; the log records what *actually* happened, including the
   crashes. The phase log is what makes resuming after a failure trivial.
4. **Record exact versions when hardware is involved.** Driver, kernel,
   firmware, BIOS flags. "nvidia driver broke after kernel update" is
   un-debuggable without the before/after pair; with it, it's a 10-minute
   incident report and a pin.

## Lessons From Real Failures

- **VM CPU masking bites late and weirdly.** A guest exposed a generic CPU
  model (no AVX) and a database started crashing with illegal-instruction
  signals — months after setup, only on specific code paths. If a binary
  SIGILLs in a VM, check guest CPU flags before blaming the software.
  (Fix: pass the host CPU type through.)
- **Containerize the CUDA userspace; keep only the driver on the host.**
  Host-installed CUDA toolkits drift against driver updates. The
  container-toolkit injection pattern survives upgrades; host CUDA rarely does.
- **`restart: unless-stopped` + documented external networks** = the whole
  stack survives a host reboot without a human. Test by actually rebooting,
  not by asserting.
- **Diagnose before iterating.** On the first failure, read the actual log
  (`docker logs`, `journalctl`, dmesg) and find the mechanism. The
  alternative — trial-and-error config mutation — once burned 100+ tool calls
  on what one grep of the error output would have shown.

## Incident Discipline

Same as the network playbook: every crash, every outage, every
agent-workflow failure (yes, those too — "the agent couldn't decrypt secrets
non-interactively" is an incident) gets a dated report in `docs/INCIDENTS/`.
The incident corpus becomes the estate's institutional memory, and Claude
cites it when you're about to repeat a mistake.

## Hook Candidates

- `SessionStart`: inject `git status` of the infra repo + quick health check
  (VMs up, containers healthy) so every session opens already oriented.
- `PreToolUse` on Bash: require confirmation phrasing for `qm stop`,
  `qm set`, volume deletes, and anything touching passthrough config.
