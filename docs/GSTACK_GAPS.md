# Gstack Features Not Yet in Framework

Features from gstack v0.11.14 that the framework doesn't have yet. Build these if needed.

## Missing Skills

| Gstack Skill | What It Does | Priority |
|-------------|-------------|----------|
| `browse` | Headless browser daemon — navigate, click, fill forms, take screenshots, ~100ms/cmd | High — used by qa, design-review, canary |
| `benchmark` | Performance regression detection — Core Web Vitals, page load, bundle size baselines | Medium |
| `canary` | Post-deploy monitoring — watches live app for console errors, perf regressions, screenshots | Medium |
| `codex` | OpenAI Codex CLI wrapper — independent code review, adversarial challenge mode, consult | Low |
| `cso` | Chief Security Officer — secrets archaeology, supply chain, CI/CD, OWASP, STRIDE | Medium |
| `design-consultation` | Full design system creation — brand, typography, color, layout → DESIGN.md | Medium |
| `document-release` | Post-ship docs sync — updates README/ARCHITECTURE/CONTRIBUTING after merge | Low |
| `land-and-deploy` | Merge PR → wait for CI → deploy → canary health checks | Medium |
| `office-hours` | YC-style brainstorm (similar to framework's brainstorm but with different structure) | Low — framework has brainstorm |
| `qa-only` | Report-only QA (no fixes) | Low — framework's qa could add a flag |
| `retro` | Weekly engineering retrospective with trend tracking and team breakdown | Low — framework has reflect |
| `review` | Pre-landing PR review — SQL safety, LLM trust boundaries, conditional side effects | Medium |
| `setup-browser-cookies` | Import cookies from real browser for authenticated testing | Low |
| `setup-deploy` | Configure deploy platform (Fly, Render, Vercel, etc.) for land-and-deploy | Low |

## Missing Infrastructure

| Component | What It Does |
|----------|-------------|
| `bin/gstack-update-check` | Auto-update notifications |
| `bin/gstack-slug` | Project slug generation for state files |
| `bin/gstack-diff-scope` | Changed files vs base branch (framework has `diff-scope.sh` hook) |
| `bin/gstack-review-log` | Review history tracking |
| `bin/gstack-repo-mode` | Solo/team mode detection |
| `bin/gstack-config` | Config management CLI |
| `agents/openai.yaml` | OpenAI agent for codex skill |
| `~/.gstack/projects/` | Per-project state directory |

## What the Framework Has That Gstack Doesn't

| Framework Feature | Notes |
|------------------|-------|
| Swarm deliberation (`/framework-launch`) | Genuine multi-agent isolation via Agent tool |
| Deep personas with pivotal decisions | Gstack personas are shallower |
| Teammate Mode (agent spawning) | Gstack uses single-context |
| 3-tier detection (Greenfield/WIP/Polish) | Gstack doesn't tier |
| Complaint system (Block/Push-back/Note) | Gstack is sequential, no pushback |
| AI slop detection (Bruno Sacco) | Formal anti-pattern grading F→C |
| Accessibility skill | WCAG 2.1 AA |
| TDD skill | Red→Green→Refactor |
| Performance skill (Lisa Su) | Core Web Vitals + DB patterns |
| Reflect skill (Warren Buffett) | Session retrospective with compounding |
| Incident report generation | Auto-generated on breakage |
| Hooks system | PreToolUse/PostToolUse shell scripts |
