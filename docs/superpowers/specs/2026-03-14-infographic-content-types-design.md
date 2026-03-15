# Phase 1: Infographic Content Types

**Date:** 2026-03-14
**Status:** Design approved
**Scope:** Add 4 new data visualization slide types to the presentation system

---

## Overview

Extend the existing 14 slide layout types with 4 infographic/data visualization types. These are the first non-text-based content types in the system, enabling charts, progress indicators, and pipeline visualizations — all using inline SVG + CSS with zero external dependencies.

**Inspiration:** Slidesgo infographic templates (teenager-behavior-infographics, strategic-plan-roadmap-infographics, process-diagrams).

---

## New Content Types

| # | Content Type | CSS Class | Dark/Light | Technique |
|---|---|---|---|---|
| 15 | Donut Chart | `chart-donut-slide` | Light | SVG circles, `stroke-dasharray` |
| 16 | Bar Chart | `chart-bar-slide` | Light | CSS flexbox, percentage widths |
| 17 | Progress Rings | `chart-progress-slide` | Dark | SVG circles, animated dash offset |
| 18 | Funnel | `funnel-slide` | Light | SVG polygons/paths |

### Content Limits

- Donut: 2-6 segments (must sum to ~100%)
- Bar: 3-8 bars
- Progress rings: 2-4 rings (independent metrics, each 0-100%)
- Funnel: 3-5 stages

---

## Markdown Detection Patterns

| Markdown Pattern | Layout | Detection Rule |
|---|---|---|
| `## Chart: Title` + items with `%` | Donut | Prefix `Chart:` + items matching `- Label: N%` |
| `## Bar Chart: Title` + items with numbers | Bar | Prefix `Bar Chart:` + items matching `- Label: N` |
| `## Progress: Title` + items with `%` | Progress Rings | Prefix `Progress:` + items matching `- Label: N%` |
| `## Funnel: Title` + numbered items with values | Funnel | Prefix `Funnel:` + items matching `N. Label — Value` |

**Disambiguation (Chart vs Progress):** Both use percentages. `## Chart:` produces a donut (parts of a whole, ~100% total). `## Progress:` produces rings (independent metrics).

---

## Technical Architecture

### Approach: Inline SVG + CSS Hybrid

- **Donut, Progress Rings, Funnel:** Inline SVG within the slide HTML
- **Bar Chart:** Pure CSS (flexbox + percentage widths)
- All animations triggered by existing `.slide.visible .reveal` Intersection Observer pattern
- `prefers-reduced-motion` shows final state immediately (no animation)

### Donut Chart

**SVG structure:** `viewBox="0 0 200 200"` with multiple `<circle>` elements sharing center (100, 100) and radius ~80. Each circle has a unique `stroke-dasharray` (segment arc length) and `stroke-dashoffset` (rotation start position). Stroke-width ~25 creates the donut ring.

**Layout:** Two-column — SVG donut left, HTML legend right. Legend items are `<div>` elements (not SVG text) for styling and accessibility.

**Animation:** Each circle transitions `stroke-dashoffset` from full circumference to its target value when `.visible` is applied. Staggered delays per segment.

**Optional center label:** Large number/text in the donut hole via SVG `<text>` element.

### Bar Chart

**Pure CSS:** Each bar row is a flex container — label `<div>` left, bar `<div>` middle (width set via inline style as percentage of max), value `<div>` right.

**Orientation:** Horizontal bars (better label readability on slides).

**Animation:** Bar grows from `width: 0` to target via CSS transition when `.visible`. Staggered via `nth-child` delays.

**Color:** Accent color for all bars, or accent with decreasing opacity per bar.

### Progress Rings

**SVG structure:** 2-4 independent `<svg>` elements in a flex row. Each contains a background circle (grey track) and foreground circle (accent, animated via `stroke-dashoffset`).

**Center text:** Percentage number via SVG `<text>`, large display font.

**Label:** HTML `<div>` below each SVG — uppercase, muted.

**Dark background:** Dramatic contrast for colored rings.

### Funnel

**SVG structure:** Single `<svg>` with `<polygon>` elements for each stage. Each trapezoid is narrower than the one above. Labels positioned via SVG `<text>` or HTML overlay.

**Colors:** Gradient from accent (top/widest) to muted (bottom/narrowest), or use chart palette stops.

**Animation:** Stages cascade in from top with staggered fade + slide-down delays.

---

## Color Integration

### Chart Palette CSS Variables

Each preset defines a chart palette via CSS custom properties:

```css
:root {
    --chart-1: var(--accent);
    --chart-2: /* preset-specific */;
    --chart-3: /* preset-specific */;
    --chart-4: /* preset-specific */;
    --chart-5: /* preset-specific */;
    --chart-6: /* preset-specific */;
    --chart-track: rgba(128, 128, 128, 0.15);
}
```

**Per-preset values:**

| Preset | chart-1 | chart-2 | chart-3 | chart-4 | chart-5 |
|---|---|---|---|---|---|
| Red | `#ff3300` | `#000` | `#666` | `#999` | `#ccc` |
| Black | `#f8f8f8` | `#c0c0c0` | `#888` | `#555` | `#333` |
| Blue | `#003082` | `#4a6fa5` | `#BFBAAF` | `#60605B` | `#8a9bb5` |
| Black Midnight | `#BB162B` | `#fff` | `#9ca3af` | `#4b5563` | `#374151` |
| Bold Signal | `#FF5722` | `#fff` | `#888` | `#555` | `#333` |

---

## Preset Adaptation

Same pattern as existing slides:

- **Red preset:** `.slide-title` absolute top-left + swiss grid + chart content
- **Black/Blue/Midnight:** `.slide-header` + `slide--light`/`slide--dark` + grid background + chart content

Chart HTML structure is identical across presets — only the outer slide wrapper and header pattern differ.

---

## Responsive Scaling

- SVG `viewBox` handles scaling naturally (no clamp needed for chart internals)
- Bar chart widths use percentages (fluid)
- Labels and legend text use existing `clamp()` body-size variables
- At `max-height: 600px`: scale SVG smaller, reduce spacing
- Funnel/donut: `max-width: min(80%, 500px)` to stay proportional

---

## Accessibility

- SVG elements include `role="img"` + `aria-label` describing the data
- Each segment/bar has `<title>` elements for screen readers
- Legend is semantic HTML (not SVG text)
- All animations respect `prefers-reduced-motion`
- Color is never the only differentiator — labels always accompany segments

---

## Decision Tree Addition

```
Does it show parts of a whole (percentages summing to 100%)?
  -> Donut Chart

Does it compare quantities across categories?
  -> Bar Chart

Does it show progress toward independent goals?
  -> Progress Rings

Does it show a narrowing pipeline or conversion stages?
  -> Funnel
```

---

## Files to Modify

| File | Action | Changes |
|---|---|---|
| `CONTENT_TYPES.md` | Edit | Add types 15-18 with CSS classes, structure, markdown cues |
| `STYLE_PRESETS.md` | Edit | Add `--chart-*` CSS variables to each preset |
| `reference/html-template.md` | Edit | Add HTML reference for all 4 types (Red + Black variants) |
| `style-samples/sample-content.md` | Edit | Add 4 markdown blocks demonstrating each type |
| `style-samples/*.html` | Edit | Add 4 new slides to each of the 5 sample files |

---

## Sample Content (Markdown)

```markdown
## Chart: Market Share
Regional distribution of active users

- North America: 40%
- Europe: 30%
- Asia Pacific: 20%
- Other: 10%

---

## Bar Chart: Revenue by Region
Annual revenue in millions (USD)

- North America: 850
- Europe: 620
- Asia Pacific: 480
- Latin America: 210
- Middle East: 140

---

## Progress: Q4 Goals
Tracking against quarterly targets

- Customer Satisfaction: 92%
- Revenue Target: 78%
- User Growth: 85%

---

## Funnel: Sales Pipeline
Conversion through the sales process

1. Leads -- 10,000
2. Qualified -- 4,200
3. Proposals -- 1,800
4. Closed Won -- 620
```
