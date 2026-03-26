# TODO

## High Priority

- [ ] Submit to awesome-claude-code (hesreallyhim/awesome-claude-code) — zero visibility currently
- [ ] Apply for Anthropic official plugin marketplace listing
- [ ] Test Step 8.5 checkpoint on a real Greenfield run — verify Steps 9-11 execute after compaction
- [ ] Test design deliverables — run /framework-launch on DuranArt, verify Dyson produces component specs and Sacco produces design tokens
- [ ] Verify incremental mode compounds — run /framework-launch incremental, check that living docs (DECISIONS.md, TODO.md) update between runs

## Medium Priority

- [ ] Add `docs/MARKET.md` template for Ma's demand validation output
- [ ] Write blog post / thread showing deliberation in action (competitive visibility)
- [ ] Add GitHub topics for discoverability (claude-code, framework, ai-coding, multi-agent)
- [ ] Consider git worktree isolation for agents that need to read large codebases
- [ ] Evaluate cross-model deliberation (Agent Tower approach — Claude + Codex + Gemini)

## Low Priority

- [ ] Explore Anthropic plugin marketplace format requirements
- [ ] Consider SuperGemini-style variant for Gemini CLI
- [ ] Add deploy pipeline skill (gstack has land-and-deploy + canary — we stop at /ship)
- [ ] Add autonomous loop mode (Ralph-style — run until done)
- [ ] Document the complaint system resolution patterns for new users

## Completed

- [x] Replace hardcoded interview questions with dynamic Question Philosophy — v3.1.0
- [x] Add /update-framework command — v3.1.0
- [x] Rewrite README install guide — v3.1.0
- [x] Add context checkpoint (Step 8.5) — v3.1.1
- [x] Make Step 9 mandatory with disk reads — v3.1.1
- [x] Add docs scaffolding (Step 0.5) — v3.1.1
- [x] Upgrade Dyson to produce component specs — v3.1.1
- [x] Upgrade Sacco to produce design tokens — v3.1.1
- [x] Create framework DECISIONS.md (dogfooding) — v3.1.1
- [x] Create framework TODO.md (dogfooding) — v3.1.1
- [x] Write incident report (2026-03-25-framework-audit) — v3.1.1
