# Provider Guides — Third-Party Endpoints for Claude Code

Claude Code speaks the Anthropic Messages API. Any service that implements
it compatibly can serve as the model backend — and you can run several
side by side, choosing per session. These guides document the wiring,
picker mapping, and cost routing for each, distilled from daily use.

| Provider | Guide | Status |
|----------|-------|--------|
| QwenCloud | [QWENCLOUD.md](QWENCLOUD.md) | Daily driver, verified Aug 2026 |

Starting from zero — no Claude Code installed yet:
[BOOTSTRAP.md](BOOTSTRAP.md). Self-serve doc plus a paste-able setup
prompt written for any chat AI to drive the install.

Once wired, the working doctrine — what carries over from the framework,
what swaps, and what's backend-specific: [QLAUDE.md](QLAUDE.md).

---

## The Shared Doctrine

1. **A wrapper function per provider, never the global settings file.**
   Claude Code's docs usually suggest putting endpoint env vars in
   `~/.claude/settings.json`. That file is global: one provider would
   repoint every session, including your real Anthropic ones. A shell
   function per provider (`claude` = Anthropic, `qlaude` = QwenCloud, …)
   keeps them side by side with zero cross-talk.

2. **Keys stay encrypted at rest.** Decrypt at launch, pass via env var,
   never cache plaintext to disk or shell state. A ~1s decrypt per launch
   is a fair price for encrypted-at-rest.

3. **Fail fast.** If key extraction comes back empty, refuse to launch
   with a one-line diagnosis. The alternative — launching with a blank
   token — surfaces later as an opaque 401 far from the cause.

4. **Map the picker deliberately.** The `/model` picker has five
   configurable slots (four family aliases + one custom row). Point them
   at real models and relabel them so the picker shows what you're
   actually picking. Details in the provider guides.

5. **Verify with curl before trusting config.** A 1-token
   `POST $BASE/v1/messages` per model ID confirms the key, the plan, and
   the model name all line up — before you discover they don't mid-session.

6. **One ops repo per provider.** Seat/account state, key locations, and
   live wiring belong in a small dedicated repo with its own README —
   these guides stay generic by design.
