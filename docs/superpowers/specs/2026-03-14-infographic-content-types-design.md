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

**Subtitle handling:** The optional description line below each heading (e.g., "Regional distribution of active users") renders as the slide subtitle — `.slide-subtitle` (Red) or inside `.slide-header p.slide-subtitle` (Black family). Same pattern as all existing content types.

---

## Technical Architecture

### Approach: Inline SVG + CSS Hybrid

- **Donut, Progress Rings, Funnel:** Inline SVG within the slide HTML
- **Bar Chart:** Pure CSS (flexbox + percentage widths, values normalized to % of max)
- All animations triggered by existing `.slide.visible .reveal` Intersection Observer pattern
- `prefers-reduced-motion` shows final state immediately (see Reduced Motion section below)

### Donut Chart

**SVG math:** `viewBox="0 0 200 200"`, center at (100, 100), radius = 80. Circumference = `2 * PI * 80 = 502.65`. Each segment:
- `stroke-dasharray: [segment_length] [circumference]` where `segment_length = percentage / 100 * 502.65`
- `stroke-dashoffset: [rotation_start]` — cumulative offset to position segment after previous ones
- `stroke-width: 25` creates the donut ring
- `transform: rotate(-90deg)` on the SVG so segments start from 12 o'clock
- `fill: none` — only the stroke is visible

**Layout:** Two-column — SVG donut left, HTML legend right. Legend items are `<div>` elements (not SVG text) for styling and accessibility.

**Animation:** Each circle transitions `stroke-dashoffset` from full circumference (502.65, hidden) to its target value when `.visible` is applied. Staggered delays per segment.

**Optional center label:** Large number/text in the donut hole via SVG `<text>` element.

### Bar Chart

**Pure CSS:** Each bar row is a flex container — label `<div>` left, bar `<div>` middle, value `<div>` right.

**Value normalization:** The generator converts raw values to percentages of the maximum value. For example, given values [850, 620, 480, 210, 140]: max = 850, so bars get widths of 100%, 73%, 56%, 25%, 16%. The inline style uses `--bar-width: N%` and CSS transitions the `width` property.

**Orientation:** Horizontal bars (better label readability on slides).

**Animation:** Bar grows from `width: 0` to `var(--bar-width)` via CSS transition when `.visible`. Staggered via `nth-child` delays.

**Color:** Accent color for all bars, or accent with decreasing opacity per bar.

### Progress Rings

**SVG math:** Same circle math as donut — radius 80, circumference 502.65. Each ring is independent:
- Background circle: `stroke: var(--chart-track)`, full circumference visible
- Foreground circle: `stroke-dasharray: [fill_length] [circumference]` where `fill_length = percentage / 100 * 502.65`
- Animated via `stroke-dashoffset` transition

**Layout:** 2-4 independent `<svg>` elements in a flex row, evenly spaced.

**Center text:** Percentage number via SVG `<text>`, large display font.

**Label:** HTML `<div>` below each SVG — uppercase, muted.

**Dark background:** Dramatic contrast for colored rings.

### Funnel

**SVG structure:** Single `<svg>` with `<polygon>` elements for each stage. Each trapezoid is narrower than the one above. Width calculation: each stage is proportional to its value relative to the first (widest) stage.

**Labels:** SVG `<text>` elements centered within each trapezoid (stage name + value).

**Colors:** Uses chart palette stops (`--chart-1` through `--chart-5`) from top to bottom.

**Animation:** Stages cascade in from top with staggered fade + slide-down delays via CSS transforms on each `<polygon>` and `<text>` group.

---

## CSS Class Reference

### Donut Chart Classes

| Element | Class | Notes |
|---|---|---|
| Chart container | `.donut-chart` | Two-column flex: SVG + legend |
| SVG wrapper | `.donut-svg` | Contains the `<svg>` element |
| Segment circle | `.donut-segment` | SVG `<circle>`, colored via `--chart-N` |
| Center label | `.donut-center` | SVG `<text>`, optional summary number |
| Legend container | `.donut-legend` | Vertical list of legend items |
| Legend item | `.donut-legend-item` | Flex row: color swatch + label + value |
| Color swatch | `.donut-swatch` | Small colored square matching segment |

### Bar Chart Classes

| Element | Class | Notes |
|---|---|---|
| Chart container | `.bar-chart` | Vertical flex of bar rows |
| Bar row | `.bar-row` | Flex row: label + bar + value |
| Bar label | `.bar-label` | Category name, left-aligned |
| Bar track | `.bar-track` | Background container for the bar |
| Bar fill | `.bar-fill` | Colored bar, width via `--bar-width` |
| Bar value | `.bar-value` | Numeric value, right-aligned |

### Progress Rings Classes

| Element | Class | Notes |
|---|---|---|
| Rings container | `.progress-rings` | Flex row of ring items |
| Ring item | `.progress-ring-item` | Single ring + label wrapper |
| SVG wrapper | `.progress-ring-svg` | Contains `<svg>` with track + fill circles |
| Track circle | `.progress-track` | Background circle, `var(--chart-track)` |
| Fill circle | `.progress-fill` | Animated foreground circle |
| Center value | `.progress-value` | SVG `<text>`, percentage number |
| Ring label | `.progress-label` | HTML `<div>` below ring, uppercase muted |

### Funnel Classes

| Element | Class | Notes |
|---|---|---|
| Funnel container | `.funnel-chart` | Wraps the SVG |
| Stage group | `.funnel-stage` | SVG `<g>` containing polygon + text |
| Stage shape | `.funnel-shape` | SVG `<polygon>`, colored via `--chart-N` |
| Stage label | `.funnel-label` | SVG `<text>`, stage name |
| Stage value | `.funnel-value` | SVG `<text>`, numeric value |

---

## HTML Reference

### 15. Donut Chart (`chart-donut-slide`)

**Default/Red preset:**

```html
<section class="slide chart-donut-slide" data-slide="N">
    <div class="swiss-grid decorative"><!-- grid lines --></div>
    <h2 class="slide-title">Chart Title</h2>
    <p class="slide-subtitle">Subtitle text</p>
    <div class="section-title">Label</div>
    <div class="slide-content">
        <div class="donut-chart reveal">
            <div class="donut-svg">
                <svg viewBox="0 0 200 200" role="img" aria-label="Donut chart showing market share">
                    <title>Market Share Distribution</title>
                    <!-- Each segment: circle with stroke-dasharray and stroke-dashoffset -->
                    <!-- Circumference = 2 * PI * 80 = 502.65 -->
                    <circle class="donut-segment" cx="100" cy="100" r="80"
                        fill="none" stroke="var(--chart-1)" stroke-width="25"
                        stroke-dasharray="201.06 502.65" stroke-dashoffset="0"
                        style="--target-offset: 0">
                        <title>North America: 40%</title>
                    </circle>
                    <circle class="donut-segment" cx="100" cy="100" r="80"
                        fill="none" stroke="var(--chart-2)" stroke-width="25"
                        stroke-dasharray="150.80 502.65" stroke-dashoffset="-201.06"
                        style="--target-offset: -201.06">
                        <title>Europe: 30%</title>
                    </circle>
                    <circle class="donut-segment" cx="100" cy="100" r="80"
                        fill="none" stroke="var(--chart-3)" stroke-width="25"
                        stroke-dasharray="100.53 502.65" stroke-dashoffset="-351.86"
                        style="--target-offset: -351.86">
                        <title>Asia Pacific: 20%</title>
                    </circle>
                    <circle class="donut-segment" cx="100" cy="100" r="80"
                        fill="none" stroke="var(--chart-4)" stroke-width="25"
                        stroke-dasharray="50.27 502.65" stroke-dashoffset="-452.39"
                        style="--target-offset: -452.39">
                        <title>Other: 10%</title>
                    </circle>
                    <!-- Optional center label -->
                    <text class="donut-center" x="100" y="100" text-anchor="middle" dominant-baseline="central">100%</text>
                </svg>
            </div>
            <div class="donut-legend">
                <div class="donut-legend-item">
                    <span class="donut-swatch" style="background: var(--chart-1)"></span>
                    <span>North America</span>
                    <span>40%</span>
                </div>
                <div class="donut-legend-item">
                    <span class="donut-swatch" style="background: var(--chart-2)"></span>
                    <span>Europe</span>
                    <span>30%</span>
                </div>
                <div class="donut-legend-item">
                    <span class="donut-swatch" style="background: var(--chart-3)"></span>
                    <span>Asia Pacific</span>
                    <span>20%</span>
                </div>
                <div class="donut-legend-item">
                    <span class="donut-swatch" style="background: var(--chart-4)"></span>
                    <span>Other</span>
                    <span>10%</span>
                </div>
            </div>
        </div>
    </div>
    <div class="bottom-rule">
        <span>Label</span>
        <span class="slide-num">N / 18</span>
    </div>
</section>
```

**Black preset:**

```html
<section class="slide chart-donut-slide slide--light grid-bg-light" data-slide="N">
    <div class="section-title">Label</div>
    <div class="slide-content">
        <div class="slide-header reveal">
            <h2>Chart Title</h2>
            <p class="slide-subtitle">Subtitle text</p>
        </div>
        <div class="donut-chart reveal">
            <!-- Same SVG + legend structure as Red preset -->
        </div>
    </div>
    <div class="bottom-rule">
        <span>Label</span>
        <span class="slide-num-label">N / 18</span>
    </div>
</section>
```

---

### 16. Bar Chart (`chart-bar-slide`)

**Default/Red preset:**

```html
<section class="slide chart-bar-slide" data-slide="N">
    <div class="swiss-grid decorative"><!-- grid lines --></div>
    <h2 class="slide-title">Bar Chart Title</h2>
    <p class="slide-subtitle">Subtitle text</p>
    <div class="section-title">Label</div>
    <div class="slide-content">
        <div class="bar-chart reveal" role="img" aria-label="Bar chart showing revenue by region">
            <div class="bar-row">
                <span class="bar-label">North America</span>
                <div class="bar-track">
                    <div class="bar-fill" style="--bar-width: 100%">
                        <title>North America: 850</title>
                    </div>
                </div>
                <span class="bar-value">850</span>
            </div>
            <div class="bar-row">
                <span class="bar-label">Europe</span>
                <div class="bar-track">
                    <div class="bar-fill" style="--bar-width: 73%">
                        <title>Europe: 620</title>
                    </div>
                </div>
                <span class="bar-value">620</span>
            </div>
            <div class="bar-row">
                <span class="bar-label">Asia Pacific</span>
                <div class="bar-track">
                    <div class="bar-fill" style="--bar-width: 56%">
                        <title>Asia Pacific: 480</title>
                    </div>
                </div>
                <span class="bar-value">480</span>
            </div>
            <div class="bar-row">
                <span class="bar-label">Latin America</span>
                <div class="bar-track">
                    <div class="bar-fill" style="--bar-width: 25%">
                        <title>Latin America: 210</title>
                    </div>
                </div>
                <span class="bar-value">210</span>
            </div>
            <div class="bar-row">
                <span class="bar-label">Middle East</span>
                <div class="bar-track">
                    <div class="bar-fill" style="--bar-width: 16%">
                        <title>Middle East: 140</title>
                    </div>
                </div>
                <span class="bar-value">140</span>
            </div>
        </div>
    </div>
    <div class="bottom-rule">
        <span>Label</span>
        <span class="slide-num">N / 18</span>
    </div>
</section>
```

**Black preset:**

```html
<section class="slide chart-bar-slide slide--light grid-bg-light" data-slide="N">
    <div class="section-title">Label</div>
    <div class="slide-content">
        <div class="slide-header reveal">
            <h2>Bar Chart Title</h2>
            <p class="slide-subtitle">Subtitle text</p>
        </div>
        <div class="bar-chart reveal" role="img" aria-label="Bar chart showing revenue by region">
            <!-- Same bar-row structure as Red preset -->
        </div>
    </div>
    <div class="bottom-rule">
        <span>Label</span>
        <span class="slide-num-label">N / 18</span>
    </div>
</section>
```

---

### 17. Progress Rings (`chart-progress-slide`)

**Default/Red preset:**

```html
<section class="slide chart-progress-slide" data-slide="N">
    <div class="section-title">Label</div>
    <div class="slide-content">
        <div class="red-bar-h reveal"></div>
        <h2 class="slide-title" style="position:relative">Progress Title</h2>
        <div class="progress-rings reveal">
            <div class="progress-ring-item">
                <div class="progress-ring-svg">
                    <svg viewBox="0 0 200 200" role="img" aria-label="Customer Satisfaction: 92%">
                        <title>Customer Satisfaction: 92%</title>
                        <circle class="progress-track" cx="100" cy="100" r="80"
                            fill="none" stroke="var(--chart-track)" stroke-width="20"/>
                        <circle class="progress-fill" cx="100" cy="100" r="80"
                            fill="none" stroke="var(--chart-1)" stroke-width="20"
                            stroke-dasharray="462.44 502.65"
                            stroke-linecap="round"
                            style="--target-offset: 0"/>
                        <text class="progress-value" x="100" y="100"
                            text-anchor="middle" dominant-baseline="central">92%</text>
                    </svg>
                </div>
                <div class="progress-label">Customer Satisfaction</div>
            </div>
            <div class="progress-ring-item">
                <div class="progress-ring-svg">
                    <svg viewBox="0 0 200 200" role="img" aria-label="Revenue Target: 78%">
                        <title>Revenue Target: 78%</title>
                        <circle class="progress-track" cx="100" cy="100" r="80"
                            fill="none" stroke="var(--chart-track)" stroke-width="20"/>
                        <circle class="progress-fill" cx="100" cy="100" r="80"
                            fill="none" stroke="var(--chart-2)" stroke-width="20"
                            stroke-dasharray="392.07 502.65"
                            stroke-linecap="round"
                            style="--target-offset: 0"/>
                        <text class="progress-value" x="100" y="100"
                            text-anchor="middle" dominant-baseline="central">78%</text>
                    </svg>
                </div>
                <div class="progress-label">Revenue Target</div>
            </div>
            <div class="progress-ring-item">
                <div class="progress-ring-svg">
                    <svg viewBox="0 0 200 200" role="img" aria-label="User Growth: 85%">
                        <title>User Growth: 85%</title>
                        <circle class="progress-track" cx="100" cy="100" r="80"
                            fill="none" stroke="var(--chart-track)" stroke-width="20"/>
                        <circle class="progress-fill" cx="100" cy="100" r="80"
                            fill="none" stroke="var(--chart-3)" stroke-width="20"
                            stroke-dasharray="427.25 502.65"
                            stroke-linecap="round"
                            style="--target-offset: 0"/>
                        <text class="progress-value" x="100" y="100"
                            text-anchor="middle" dominant-baseline="central">85%</text>
                    </svg>
                </div>
                <div class="progress-label">User Growth</div>
            </div>
        </div>
    </div>
    <div class="bottom-rule">
        <span>Label</span>
        <span class="slide-num">N / 18</span>
    </div>
</section>
```

**Black preset:**

```html
<section class="slide chart-progress-slide slide--dark grid-bg-dark" data-slide="N">
    <div class="section-title">Label</div>
    <div class="slide-content">
        <div class="slide-header reveal">
            <h2>Progress Title</h2>
            <p class="slide-subtitle">Subtitle text</p>
        </div>
        <div class="progress-rings reveal">
            <!-- Same progress-ring-item structure as Red preset -->
        </div>
    </div>
    <div class="bottom-rule">
        <span>Label</span>
        <span class="slide-num-label">N / 18</span>
    </div>
</section>
```

---

### 18. Funnel (`funnel-slide`)

**Default/Red preset:**

```html
<section class="slide funnel-slide" data-slide="N">
    <div class="swiss-grid decorative"><!-- grid lines --></div>
    <h2 class="slide-title">Funnel Title</h2>
    <p class="slide-subtitle">Subtitle text</p>
    <div class="section-title">Label</div>
    <div class="slide-content">
        <div class="funnel-chart reveal">
            <svg viewBox="0 0 400 300" role="img" aria-label="Sales funnel showing conversion stages">
                <title>Sales Pipeline Funnel</title>
                <!-- Stage 1: widest (100% of width) -->
                <g class="funnel-stage">
                    <polygon class="funnel-shape" points="20,10 380,10 350,75 50,75"
                        fill="var(--chart-1)"/>
                    <text class="funnel-label" x="200" y="35" text-anchor="middle">Leads</text>
                    <text class="funnel-value" x="200" y="58" text-anchor="middle">10,000</text>
                </g>
                <!-- Stage 2: narrower -->
                <g class="funnel-stage">
                    <polygon class="funnel-shape" points="50,80 350,80 310,145 90,145"
                        fill="var(--chart-2)"/>
                    <text class="funnel-label" x="200" y="105" text-anchor="middle">Qualified</text>
                    <text class="funnel-value" x="200" y="128" text-anchor="middle">4,200</text>
                </g>
                <!-- Stage 3: narrower still -->
                <g class="funnel-stage">
                    <polygon class="funnel-shape" points="90,150 310,150 270,215 130,215"
                        fill="var(--chart-3)"/>
                    <text class="funnel-label" x="200" y="175" text-anchor="middle">Proposals</text>
                    <text class="funnel-value" x="200" y="198" text-anchor="middle">1,800</text>
                </g>
                <!-- Stage 4: narrowest -->
                <g class="funnel-stage">
                    <polygon class="funnel-shape" points="130,220 270,220 250,285 150,285"
                        fill="var(--chart-4)"/>
                    <text class="funnel-label" x="200" y="245" text-anchor="middle">Closed Won</text>
                    <text class="funnel-value" x="200" y="268" text-anchor="middle">620</text>
                </g>
            </svg>
        </div>
    </div>
    <div class="bottom-rule">
        <span>Label</span>
        <span class="slide-num">N / 18</span>
    </div>
</section>
```

**Black preset:**

```html
<section class="slide funnel-slide slide--light grid-bg-light" data-slide="N">
    <div class="section-title">Label</div>
    <div class="slide-content">
        <div class="slide-header reveal">
            <h2>Funnel Title</h2>
            <p class="slide-subtitle">Subtitle text</p>
        </div>
        <div class="funnel-chart reveal">
            <!-- Same SVG funnel structure as Red preset -->
        </div>
    </div>
    <div class="bottom-rule">
        <span>Label</span>
        <span class="slide-num-label">N / 18</span>
    </div>
</section>
```

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

| Preset | chart-1 | chart-2 | chart-3 | chart-4 | chart-5 | chart-6 |
|---|---|---|---|---|---|---|
| Red | `#ff3300` | `#000` | `#666` | `#999` | `#ccc` | `#e0e0e0` |
| Black | `#f8f8f8` | `#c0c0c0` | `#888` | `#555` | `#333` | `#1a1a1a` |
| Blue | `#003082` | `#4a6fa5` | `#BFBAAF` | `#60605B` | `#8a9bb5` | `#c4d0e0` |
| Black Midnight | `#BB162B` | `#fff` | `#9ca3af` | `#4b5563` | `#374151` | `#1f2937` |
| Bold Signal | `#FF5722` | `#fff` | `#888` | `#555` | `#333` | `#1a1a1a` |

---

## Preset Adaptation

Same pattern as existing slides:

- **Red preset:** `.slide-title` absolute top-left + swiss grid + chart content in `.slide-content`
- **Black/Blue/Midnight:** `.slide-header` + `slide--light`/`slide--dark` + grid background + chart content in `.slide-content`
- **Bold Signal:** Charts render on the dark gradient background (not inside the colored card). The chart itself becomes the visual focal point. Slide title bottom-left, section number bottom-right — same positioning as other Bold Signal slides. Chart colors use `--chart-*` variables which are set to work against the dark background.

Chart inner HTML structure (SVG, legend, bars, rings, funnel) is identical across all presets — only the outer slide wrapper and header pattern differ.

---

## Responsive Scaling

- SVG `viewBox` handles scaling naturally (no clamp needed for chart internals)
- Bar chart widths use percentages (fluid)
- Labels and legend text use existing `clamp()` body-size variables
- At `max-height: 600px`: scale SVG smaller, reduce spacing
- Funnel/donut: `max-width: min(80%, 500px)` to stay proportional
- Progress rings: flex-wrap at narrow widths, 2x2 grid fallback

---

## Accessibility

- SVG elements include `role="img"` + `aria-label` describing the data
- Each segment/bar has `<title>` elements for screen readers
- Legend is semantic HTML (not SVG text)
- All animations respect `prefers-reduced-motion` (see below)
- Color is never the only differentiator — labels always accompany segments

### Reduced Motion

SVG `stroke-dashoffset` animations are new to the system and not covered by existing `viewport-base.css` rules. Add these rules:

```css
@media (prefers-reduced-motion: reduce) {
    .donut-segment,
    .progress-fill {
        transition: none !important;
    }
    .bar-fill {
        transition: none !important;
    }
    .funnel-stage {
        transition: none !important;
        animation: none !important;
    }
}
```

This ensures all chart animations show their final state immediately for users who prefer reduced motion.

---

## Decision Tree Addition

Insert after "Does it present large metrics?" and before "Does it show code?" in the existing `CONTENT_TYPES.md` decision tree:

```
Does it present large metrics?
  -> Stat Highlight (1-3 numbers, dramatic)

Does it show data as a chart or visualization?
  -> Parts of a whole (% summing to 100%)? -> Donut Chart
  -> Quantities compared across categories? -> Bar Chart
  -> Progress toward independent goals (each 0-100%)? -> Progress Rings
  -> Narrowing pipeline or conversion stages? -> Funnel

Does it show code?
  -> Code
```

**Stat Highlight vs charts:** Stat Highlight displays 1-3 standalone numbers dramatically (large font, accent color). Charts display structured data with visual representation (segments, bars, rings, stages). If the content is just "98% Customer Satisfaction" — stat slide. If it's "Mobile: 45%, Desktop: 35%, Tablet: 20%" — donut chart.

---

## Files to Modify

| File | Action | Changes |
|---|---|---|
| `CONTENT_TYPES.md` | Edit | Add types 15-18 with CSS classes, structure, markdown cues, decision tree |
| `STYLE_PRESETS.md` | Edit | Add `--chart-*` CSS variables to each preset section |
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

1. Leads — 10,000
2. Qualified — 4,200
3. Proposals — 1,800
4. Closed Won — 620
```
