---
name: performance
description: Performance optimization patterns. Auto-activates when working on performance, bundle size, page load, or Core Web Vitals.
activates_when: performance optimization, bundle size, page load, Core Web Vitals, lazy loading, caching
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, mcp__playwright__browser_navigate, mcp__playwright__browser_evaluate
---

# Performance - Optimization Patterns

*Lisa Su persona: "Every cycle counts."*

AMD's CEO who turned a failing company into a performance leader. Measure everything. Optimize what matters. Never guess — profile first.

## Core Rules (auto-activate)

### Lisa's Laws

```
✓ Measure before optimizing — no premature optimization
✓ Profile the bottleneck, don't guess
✓ Optimize the hot path, ignore the cold path
✓ Performance per byte: minimize payload, maximize impact
✗ Don't optimize without a baseline measurement
✗ Don't optimize code that runs once
✗ Don't add complexity for marginal gains
```

### Core Web Vitals Targets

| Metric | Target | What it measures |
|--------|--------|-----------------|
| LCP | < 2.5s | Largest Contentful Paint — loading |
| FID/INP | < 100ms | Interaction to Next Paint — responsiveness |
| CLS | < 0.1 | Cumulative Layout Shift — visual stability |

### Common Optimizations

```
✓ Lazy load below-the-fold content
✓ Optimize images (WebP/AVIF, proper sizing, srcset)
✓ Tree-shake unused imports
✓ Code-split routes and heavy components
✓ Use CDN for static assets
✓ Minimize main thread blocking
✗ No unoptimized images (raw PNGs, oversized JPEGs)
✗ No render-blocking resources
✗ No layout shifts from dynamic content
✗ No synchronous operations that could be async
```

### Database Performance

```
✓ Index frequently queried columns
✓ Use pagination for large result sets
✓ Batch operations where possible
✓ Select only needed columns
✗ No N+1 queries
✗ No full table scans on large tables
✗ No unbounded queries (always LIMIT)
```

## Checklist

```
- [ ] Baseline measured before changes
- [ ] Bottleneck identified with profiling
- [ ] Optimization targeted at hot path
- [ ] Improvement verified with measurements
- [ ] No regressions in other metrics
```
