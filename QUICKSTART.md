# Quick Start: Initialize Your Project

After cloning the template (see README.md), open your terminal in the project folder and run:

```bash
claude
```

This opens an interactive chat with Claude. **Paste the prompt below** and Claude will customize everything for your project:

---

## The Prompt

```
I'm starting a new project using the Claude Code framework. Here's what I'm building:

**Project Name:** [Your project name]
**Description:** [One paragraph about what it does]
**Tech Stack:** [e.g., Next.js 14, Supabase, Stripe, Tailwind]
**Target Users:** [Who uses this?]
**Key Features:**
1. [Feature 1]
2. [Feature 2]
3. [Feature 3]

Please customize the template for my project:

1. Update CLAUDE.md with my project specifics
2. Customize the frontend-design skill with appropriate themes/colors for my brand
3. Adapt the security skill for my auth/payment patterns
4. Create initial docs (README, TODO, CHANGELOG, DECISIONS)
5. Set up the folder structure for my tech stack
6. Enable hooks in settings.local.json

Start by reading the template files in .claude/ and docs/, then customize everything for my project.
```

---

## Example: Recipe App

```
**Project Name:** MealPrep Pro
**Description:** A meal planning app where users can save recipes, generate weekly meal plans, and create shopping lists automatically.
**Tech Stack:** Next.js 14, Supabase, Tailwind, shadcn/ui
**Target Users:** Home cooks, busy families, health-conscious individuals
**Key Features:**
1. Recipe management with nutritional info
2. Weekly meal planner with drag-and-drop
3. Auto-generated shopping lists
4. User accounts with saved favorites
```

---

## Example: SaaS App

```
**Project Name:** TaskFlow
**Description:** A project management tool for small teams with Kanban boards, time tracking, and client invoicing.
**Tech Stack:** Next.js 14, Supabase, Stripe subscriptions, Tailwind
**Target Users:** Freelancers, small agencies, consultants
**Key Features:**
1. Kanban board with drag-and-drop
2. Time tracking per task
3. Client portal for approvals
4. Automated invoicing via Stripe
```

---

## What Claude Will Do

### 1. Customize CLAUDE.md
- Add your project name, description, stack
- Set up key directories and quick reference
- Configure pipeline and hooks sections

### 2. Adapt Skills
- **frontend-design**: Pick colors/themes matching your brand
- **security**: Configure for your auth and payment patterns
- **code-review**: Add project-specific patterns

### 3. Create Documentation
- `docs/README.md` — Project overview
- `docs/TODO.md` — Initial task list
- `docs/CHANGELOG.md` — Ready for tracking
- `docs/DECISIONS.md` — Ready for logging

### 4. Enable Hooks
- Copy `settings.local.json.example` → `settings.local.json`
- Configure safety, config protection, and auto-formatting

### 5. Initialize Project Structure
- Create folders for your tech stack
- Set up initial config files

---

## Pipeline Commands

Once set up, use the pipeline for features:

```bash
# Brainstorm a new feature (Jack Ma)
/brainstorm

# Review the plan (Steve Jobs → Linus Torvalds → James Dyson)
/ceo-review
/eng-review
/design-review-plan

# Debug a problem
/investigate

# Review copy and positioning (Atrioc)
/marketing

# Test and QA
/qa

# Ship it
/ship

# What did we learn? (Warren Buffett)
/reflect
```

---

## Tips

- **Be specific** about your features — more detail = better customization
- **Mention your brand** if you have colors/style preferences
- **List your pages** if you know them — helps structure skills
- **Include auth requirements** — affects security skill significantly
- **Enable hooks** for runtime safety from day one
