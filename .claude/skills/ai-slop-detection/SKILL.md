---
name: ai-slop-detection
description: Formal AI design anti-pattern blacklist with letter grades. Auto-activates when building UI alongside frontend-design skill. Bruno Sacco persona.
activates_when: building UI, reviewing designs, frontend work, styling
allowed-tools: Read, Write, Edit, Glob, Grep, mcp__playwright__browser_navigate, mcp__playwright__browser_take_screenshot
---

# AI Slop Detection - Anti-Pattern Blacklist

*Bruno Sacco persona: "A design must be timeless, not fashionable."*

The Mercedes-Benz chief designer (1975-1999) who believed in restraint, proportion, and elegance that ages gracefully. He designed the W124 E-Class — a car that still looks beautiful 30+ years later. The opposite of disposable design.

## The Blacklist

10 named anti-patterns. If your UI has these, it looks AI-generated.

### F-Tier (Obvious AI Slop)

**F1: Generic Sans-Serif Default**
Using Inter, Roboto, or system fonts as the primary typeface with no thought. Every AI-generated site uses these.
→ **Fix:** Choose a distinctive typeface that reinforces your brand's personality.

**F2: Purple Gradient Syndrome**
Purple-to-blue gradients (#8B5CF6 spectrum) on white backgrounds. The unofficial color of "AI made this."
→ **Fix:** Develop a custom color palette with meaning. Colors should tell your brand's story.

**F3: "Welcome to" Hero Copy**
"Welcome to [Product Name]" as the hero headline. Zero personality, zero value proposition.
→ **Fix:** Lead with what the user gets, not a greeting. One sentence that makes someone care.

### D-Tier (Noticeable AI)

**D1: Cookie-Cutter Card Grid**
Three identical cards in a row with icon + title + description. No variation in size, emphasis, or layout.
→ **Fix:** Create visual hierarchy. One card can be featured. Vary the layout. Break the grid.

**D2: Zero-Customization Component Library**
Default shadcn/ui, Material UI, or Chakra with no customization. Looks like a template.
→ **Fix:** Customize at minimum: colors, border radius, font, spacing. Make it yours.

**D3: Generic Blue Buttons**
Default blue (#3B82F6) buttons everywhere. No personality.
→ **Fix:** Button colors should reflect your brand. Consider shape, padding, hover states.

### C-Tier (Generic)

**C1: Stock Illustration Style**
Flat vector illustrations with no consistent style. Mix of illustration styles.
→ **Fix:** Commit to one illustration style or use photography. Consistency over variety.

**C2: Centered Everything**
Every section centered, no asymmetry, no editorial layouts. Feels like a template.
→ **Fix:** Use asymmetric layouts. Left-align text. Create visual tension and flow.

**C3: Flat Background**
Pure white or pure black backgrounds with no depth, texture, or visual interest.
→ **Fix:** Add subtle gradients, noise textures, border treatments, or background patterns.

**C4: No Micro-Interactions**
Static UI with no hover effects, transitions, or feedback. Feels lifeless.
→ **Fix:** Add meaningful transitions. Button hover effects. Smooth page transitions. Loading states.

## Rating System

| Grade | Meaning |
|-------|---------|
| **A** | Distinctive, timeless design. Would pass the Bruno Sacco test. |
| **B** | Competent, customized. Has personality but room for refinement. |
| **C** | Generic. Functional but forgettable. Some AI patterns present. |
| **D** | Noticeable AI generation. Multiple anti-patterns. Needs work. |
| **F** | Obvious AI slop. Would immediately be recognized as AI-generated. |

## The Bruno Sacco Test

Ask yourself: **"Will this design still look beautiful in 20 years?"**

If the answer relies on current trends (gradients, glassmorphism, specific illustration styles), it's fashionable, not timeless. Timeless design comes from proportion, restraint, and functional elegance.

## Checklist

```
- [ ] No F-tier anti-patterns
- [ ] No D-tier anti-patterns
- [ ] C-tier items addressed or justified
- [ ] Overall grade: ___
- [ ] Passes the Bruno Sacco test
```
