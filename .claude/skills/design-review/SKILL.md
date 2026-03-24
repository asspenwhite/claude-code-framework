---
name: design-review
description: UI quality and consistency patterns. Auto-activates when building UI components, styling, or visual work.
activates_when: building UI, styling, components, visual work, CSS, Tailwind
allowed-tools: Read, Write, Edit, Glob, Grep, mcp__playwright__browser_snapshot, mcp__playwright__browser_navigate, mcp__playwright__browser_take_screenshot
---

# Design Review - UI Quality Patterns

"Live Environment First" — always test with real browsers, not just code review.

## Consistency

```
✓ Follow established color palette
✓ Use design tokens/CSS variables
✓ Match existing component patterns
✓ Consistent spacing (use spacing scale)
✗ Don't introduce new colors without reason
✗ Don't use magic pixel values
✗ Don't deviate from established patterns
```

## Accessibility

```
✓ Sufficient color contrast (4.5:1 for text)
✓ Focus states visible
✓ Alt text on images
✓ Semantic HTML elements
✓ Keyboard navigable
✗ No color-only indicators
✗ No images of text
```

## Responsive Design

```
✓ Mobile-first approach
✓ Test at common breakpoints
✓ Touch targets 44x44px minimum
✓ Readable text at all sizes
✗ No horizontal scroll on mobile
✗ No fixed widths that break small screens
```

## Component Patterns

```
✓ Clear visual hierarchy
✓ Consistent border radius
✓ Meaningful hover/active states
✓ Loading skeletons match content shape
✗ No orphaned elements
✗ No inconsistent button styles
```

## AI Slop Detection

Cross-reference `ai-slop-detection` skill (Bruno Sacco's blacklist) for formal anti-pattern grading. Include letter grade (A-F) in review output.

## Playwright Verification

When building UI, verify with Playwright:
```
1. browser_navigate to page
2. browser_snapshot for accessibility tree
3. Check visual consistency
4. Verify responsive behavior
5. Test interactive states
```

## Checklist

```
- [ ] Matches design system
- [ ] Accessible (contrast, focus, alt text)
- [ ] Responsive at all breakpoints
- [ ] Interactions work correctly
- [ ] Loading states present
- [ ] AI slop grade: ___
```

---

## Review Mode (/design-review)

**Philosophy:** "Live Environment First" — always test with real browsers, not just code review.

### When to Invoke

- After UI/UX changes
- Before releasing new features
- When visual issues are reported
- During design system updates

### Audit Checklist

#### Visual Consistency
- [ ] Colors match design system
- [ ] Typography follows hierarchy
- [ ] Spacing is consistent
- [ ] Icons are properly sized

#### Responsive Design
- [ ] Desktop (1920px) looks correct
- [ ] Tablet (768px) adapts properly
- [ ] Mobile (375px) is usable
- [ ] No horizontal scroll on mobile

#### Interactive Elements
- [ ] Hover states work
- [ ] Focus states visible
- [ ] Buttons look clickable
- [ ] Links are distinguishable

#### Loading States
- [ ] Skeleton loaders present
- [ ] Loading spinners appropriate
- [ ] No layout shift on load

#### Error States
- [ ] Error messages clear
- [ ] Form validation visible
- [ ] Empty states designed

#### AI Slop Grade
- [ ] Rate A-F using ai-slop-detection blacklist
- [ ] No F-tier anti-patterns (Inter font, purple gradients, "Welcome to" hero)
- [ ] No D-tier anti-patterns (cookie-cutter grids, default shadcn)

### Tools

1. **Playwright MCP** for live testing
   - `browser_navigate` — Open pages
   - `browser_resize` — Test responsive (1920, 768, 375)
   - `browser_take_screenshot` — Capture evidence
   - `browser_console_messages` — Check for errors

### Severity Levels

- **Critical:** Broken functionality, unusable
- **High:** Major visual issues, poor UX
- **Medium:** Inconsistencies, minor visual bugs
- **Low:** Nitpicks, polish items

### Output Format

```markdown
## Design Review Results

### Page: [Page Name]
**AI Slop Grade:** [A-F]

#### Desktop (1920px)
[Screenshot] — Findings

#### Mobile (375px)
[Screenshot] — Findings

### Issues
| Issue | Severity | Location | Fix |
|-------|----------|----------|-----|

### Summary
- Critical: X | High: X | Medium: X | Low: X
- AI Slop Grade: [A-F]
```
