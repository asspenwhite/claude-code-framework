---
name: accessibility
description: WCAG 2.1 AA compliance patterns. Auto-activates when building UI, forms, interactive elements, or handling visual content.
activates_when: building UI, forms, interactive elements, images, buttons, links
allowed-tools: Read, Write, Edit, Glob, Grep, mcp__playwright__browser_snapshot, mcp__playwright__browser_navigate
---

# Accessibility - WCAG 2.1 AA Compliance

"Everyone Can Use It" — build accessible interfaces by default.

## Core Rules (auto-activate)

### Color & Contrast

```
✓ Text has 4.5:1 contrast ratio minimum
✓ Large text (18px+) has 3:1 minimum
✓ UI components have 3:1 contrast
✓ Don't rely on color alone for information
✗ No color-only indicators
✗ No images of text
```

### Keyboard & Focus

```
✓ All interactive elements focusable
✓ Focus order follows visual order
✓ Focus indicators clearly visible
✓ Skip navigation link present
✗ No keyboard traps
✗ No outline:none without replacement
```

### Semantics & Screen Readers

```
✓ Semantic HTML over div soup
✓ Images have descriptive alt text
✓ Headings in correct hierarchical order (h1 → h2 → h3)
✓ Buttons have accessible names
✓ ARIA used correctly (prefer native HTML)
✗ No div-as-button patterns
```

### Forms

```
✓ Labels associated with every input
✓ Error messages announced to screen readers
✓ Required fields indicated (not just by color)
✓ Instructions clear and visible
```

### Motion

```
✓ Respects prefers-reduced-motion
✓ No auto-playing content without controls
✓ Animations can be paused
```

## Quick Fixes

```tsx
// Missing alt text
<img src="/logo.png" />                    // BAD
<img src="/logo.png" alt="Company Logo" /> // GOOD

// Missing label
<input type="email" />                     // BAD
<label>Email<input type="email" /></label> // GOOD

// Focus indicator removed
button:focus { outline: none; }            // BAD
button:focus-visible {
  outline: 2px solid currentColor;
  outline-offset: 2px;
}                                          // GOOD

// Motion respect
@media (prefers-reduced-motion: reduce) {
  * { animation-duration: 0.01ms !important; }
}
```

## Checklist

```
- [ ] Color contrast meets 4.5:1 for text
- [ ] All interactive elements keyboard accessible
- [ ] Images have alt text
- [ ] Forms have associated labels
- [ ] Semantic HTML used
- [ ] prefers-reduced-motion respected
```

---

## Review Mode (/accessibility)

Full WCAG 2.1 AA compliance audit.

### When to Invoke

- After UI changes
- Before major releases
- When adding forms or interactive elements
- During design reviews

### Audit Checklist

#### Color & Contrast
- [ ] Text has 4.5:1 contrast ratio (normal text)
- [ ] Large text has 3:1 contrast ratio
- [ ] UI components have 3:1 contrast
- [ ] Don't rely on color alone for info

#### Keyboard Navigation
- [ ] All interactive elements focusable
- [ ] Focus order is logical
- [ ] Focus indicators visible
- [ ] No keyboard traps
- [ ] Skip links present

#### Screen Readers
- [ ] Images have alt text
- [ ] Form inputs have labels
- [ ] Buttons have accessible names
- [ ] Headings in correct order
- [ ] ARIA used correctly

#### Forms
- [ ] Labels associated with inputs
- [ ] Error messages announced
- [ ] Required fields indicated
- [ ] Instructions clear

#### Motion & Animation
- [ ] Respects prefers-reduced-motion
- [ ] No auto-playing content
- [ ] Animations can be paused

### Tools

1. **Playwright MCP** — `browser_snapshot` for accessibility tree, tab through page
2. **Manual checks** — Color contrast checker, screen reader testing

### Common WCAG Violations

| Issue | WCAG | Fix |
|-------|------|-----|
| Missing alt text | 1.1.1 | Add descriptive alt attribute |
| Low contrast | 1.4.3 | Increase contrast to 4.5:1 |
| Missing labels | 1.3.1 | Associate labels with inputs |
| No focus indicator | 2.4.7 | Add visible focus styles |
| No skip link | 2.4.1 | Add "Skip to content" link |
| Auto-playing media | 1.4.2 | Add pause controls |

### Output Format

```markdown
## Accessibility Audit Results

### Page: [Page Name]

#### Critical Issues
| Issue | Element | WCAG | Fix |
|-------|---------|------|-----|

#### Warnings
| Issue | Element | WCAG | Suggestion |
|-------|---------|------|------------|

#### Passed
- [x] Items that passed

### Summary
- Critical: X (must fix) | Warnings: X (should fix) | Passed: X
```
