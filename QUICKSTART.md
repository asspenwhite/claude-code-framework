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
4. Update all agent files with my file paths
5. Create initial docs (README, TODO, CHANGELOG, DECISIONS)
6. Set up the folder structure for my tech stack

Start by reading the template files in .claude/ and docs/, then customize everything for my project.
```

---

## Example: Recipe App

```
I'm starting a new project using the Claude Code framework. Here's what I'm building:

**Project Name:** MealPrep Pro
**Description:** A meal planning app where users can save recipes, generate weekly meal plans, and create shopping lists automatically.
**Tech Stack:** Next.js 14, Supabase, Tailwind, shadcn/ui
**Target Users:** Home cooks, busy families, health-conscious individuals
**Key Features:**
1. Recipe management with nutritional info
2. Weekly meal planner with drag-and-drop
3. Auto-generated shopping lists
4. User accounts with saved favorites

Please customize the template for my project...
```

---

## Example: SaaS App

```
I'm starting a new project using the Claude Code framework. Here's what I'm building:

**Project Name:** TaskFlow
**Description:** A project management tool for small teams with Kanban boards, time tracking, and client invoicing.
**Tech Stack:** Next.js 14, Supabase, Stripe subscriptions, Tailwind
**Target Users:** Freelancers, small agencies, consultants
**Key Features:**
1. Kanban board with drag-and-drop
2. Time tracking per task
3. Client portal for approvals
4. Automated invoicing via Stripe

Please customize the template for my project...
```

---

## Example: E-commerce

```
I'm starting a new project using the Claude Code framework. Here's what I'm building:

**Project Name:** Artisan Market
**Description:** A marketplace for handmade goods where artisans can set up shops and sell directly to customers.
**Tech Stack:** Next.js 14, Supabase, Stripe Connect (multi-vendor), Tailwind
**Target Users:** Craft makers, handmade goods buyers
**Key Features:**
1. Multi-vendor marketplace
2. Seller dashboard with analytics
3. Review and rating system
4. Secure checkout with Stripe Connect

Please customize the template for my project...
```

---

## What Claude Will Do

After you provide your project details, Claude will:

### 1. Customize CLAUDE.md
- Add your project name and description
- Set up your tech stack specifics
- Define your key directories
- Add your critical rules

### 2. Adapt Skills
- **frontend-design**: Pick colors/themes that match your brand
- **security**: Configure for your auth and payment patterns

### 3. Update Agents
- Replace placeholder paths with your actual file structure
- Add project-specific checks
- Remove irrelevant sections

### 4. Create Documentation
- `docs/README.md` - Your project overview
- `docs/TODO.md` - Initial task list based on features
- `docs/CHANGELOG.md` - Ready for tracking
- `docs/DECISIONS.md` - Ready for logging
- `docs/API.md` - Template for your endpoints
- `docs/SCHEMA.md` - Template for your database

### 5. Initialize Project Structure
- Create folders for your tech stack
- Set up initial config files
- Add placeholder components

---

## After Initialization

Once Claude customizes the template:

1. **Review the changes** - Make sure everything looks right
2. **Install dependencies** - `npm install` or equivalent
3. **Set up services** - Supabase, Stripe, etc.
4. **Start building** - The template is now tailored to your project

---

## Tips

- **Be specific** about your features - more detail = better customization
- **Mention your brand** if you have colors/style preferences
- **List your pages** if you know them - helps structure agents
- **Include auth requirements** - affects security skill significantly
