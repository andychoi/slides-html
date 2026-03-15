# Phase 4: Composite Layouts

**Date:** 2026-03-14
**Status:** Design approved
**Scope:** Add 4 composite layout slide types where each zone can hold any content type

---

## Overview

Add a composability layer to the presentation system. Unlike existing slides (one slide = one content type), composite layouts divide a slide into 2-4 zones, each independently rendering its own content type (text, bullets, mini-chart, table, stats). This enables PowerPoint-style split and quadrant layouts.

All mini content types reuse existing CSS classes from Phase 1/2/3, scoped smaller inside `.zone` containers.

---

## New Content Types

| # | Content Type | CSS Class | Dark/Light | Layout |
|---|---|---|---|---|
| 23 | Split (Half & Half) | `split-slide` | Light | 2 equal columns |
| 24 | Quadrant (2x2) | `quadrant-slide` | Light | 4 boxes in a 2x2 grid |
| 25 | Third Split (1/3 + 2/3) | `third-slide` | Light | Asymmetric narrow + wide |
| 26 | Three Column | `three-col-slide` | Light | 3 equal columns |

### Content Limits

- Split: 2 zones, each with moderate content
- Quadrant: 4 zones, each with compact content (less per zone)
- Third: 2 zones, narrow side best for single stat/ring, wide side for list/chart/table
- Three Column: 3 zones, each with compact content

---

## Markdown Detection Patterns

| Markdown Pattern | Layout | Detection Rule |
|---|---|---|
| `## Split: Title` + `### Left` / `### Right` | Split | Prefix `Split:` + exactly 2 `###` subsections |
| `## Quadrant: Title` + `### Top-Left` / `### Top-Right` / `### Bottom-Left` / `### Bottom-Right` | Quadrant | Prefix `Quadrant:` + exactly 4 `###` subsections |
| `## Third: Title` + `### Narrow` / `### Wide` | Third Split | Prefix `Third:` + `### Narrow` + `### Wide` |
| `## Three Columns: Title` + `### Col 1` / `### Col 2` / `### Col 3` | Three Column | Prefix `Three Columns:` + exactly 3 `###` subsections |

**Subtitle handling:** Same as all other types — optional description line below heading renders as `.slide-subtitle`.

### Zone Content Detection

Each zone's content (between its `### Heading` and the next `###` or `---`) is parsed independently using the same detection rules as standalone slides:

| Zone Content Pattern | Rendered As | Technique |
|---|---|---|
| `- Label: N%` items (summing to ~100%) | Mini donut chart | SVG, smaller viewBox |
| `- Label: N` items (raw numbers) | Mini bar chart | CSS, narrower bars |
| Single `- Label: N%` item | Mini progress ring | SVG, single ring |
| `- **Label** — Value` items | Styled key-value bullets | HTML, existing bullet-item pattern |
| Pipe table (`\| col \|`) | Mini table | HTML `<table>`, smaller font |
| `N%` or `N` + label (1-2 items) | Mini stat | Large number + label |
| Plain text / bullet list | Text / bullets | Standard `<p>` or `<ul>` |

---

## Technical Architecture

### Grid CSS

```css
/* Shared grid container */
.composite-grid {
    display: grid;
    gap: clamp(0.75rem, 1.5vw, 1.5rem);
    height: 100%;
    align-items: stretch;
}

/* Split: 2 equal columns */
.split-slide .composite-grid {
    grid-template-columns: 1fr 1fr;
}

/* Quadrant: 2x2 */
.quadrant-slide .composite-grid {
    grid-template-columns: 1fr 1fr;
    grid-template-rows: 1fr 1fr;
}

/* Third: 1/3 + 2/3 */
.third-slide .composite-grid {
    grid-template-columns: 1fr 2fr;
}

/* Three Column: 3 equal */
.three-col-slide .composite-grid {
    grid-template-columns: 1fr 1fr 1fr;
}
```

### Zone Styling

Each zone is a contained area with subtle visual separation:

```css
.zone {
    padding: clamp(0.75rem, 1.5vw, 1.5rem);
    border-left: 3px solid var(--border-color, rgba(0,0,0,0.12));
    display: flex;
    flex-direction: column;
    gap: clamp(0.5rem, 1vw, 1rem);
    overflow: hidden;
}
.zone:first-child { border-left: none; }
/* Quadrant: top row no top border, left col no left border */
.quadrant-slide .zone:nth-child(1),
.quadrant-slide .zone:nth-child(2) { border-left: none; }
.quadrant-slide .zone:nth-child(3),
.quadrant-slide .zone:nth-child(4) { border-top: 1px solid var(--border-color, rgba(0,0,0,0.12)); }
.quadrant-slide .zone:nth-child(2),
.quadrant-slide .zone:nth-child(4) { border-left: 3px solid var(--border-color, rgba(0,0,0,0.12)); }
```

### Mini Content Scaling

Existing chart/data components are scaled smaller inside `.zone`:

```css
/* Mini donut */
.zone .donut-chart { gap: clamp(0.5rem, 1vw, 1rem); }
.zone .donut-svg { max-width: 140px; }
.zone .donut-center { font-size: 1.2rem; }
.zone .donut-legend-item { font-size: clamp(0.6rem, 1vw, 0.75rem); }
.zone .donut-swatch { width: 10px; height: 10px; }

/* Mini bar chart */
.zone .bar-chart { gap: clamp(3px, 0.5vw, 6px); }
.zone .bar-track { height: clamp(14px, 2vw, 22px); }
.zone .bar-label { flex: 0 0 clamp(50px, 10vw, 100px); font-size: clamp(0.6rem, 1vw, 0.8rem); }
.zone .bar-value { font-size: clamp(0.6rem, 1vw, 0.8rem); }

/* Mini progress ring */
.zone .progress-ring-svg { width: clamp(70px, 12vw, 120px); }
.zone .progress-value { font-size: 1.5rem; }
.zone .progress-label { font-size: clamp(0.55rem, 0.9vw, 0.75rem); }

/* Mini stat */
.zone .stat-number { font-size: clamp(1.5rem, 4vw, 3rem); }
.zone .stat-label { font-size: clamp(0.55rem, 0.9vw, 0.75rem); }

/* Mini table */
.zone table { font-size: clamp(0.6rem, 1vw, 0.8rem); }
.zone th, .zone td { padding: clamp(2px, 0.3vw, 6px) clamp(4px, 0.5vw, 8px); }

/* Zone title */
.zone-title {
    font-family: var(--font-display);
    font-size: clamp(0.75rem, 1.5vw, 1.1rem);
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: 0.02em;
    margin-bottom: clamp(0.25rem, 0.5vw, 0.5rem);
}

/* Zone text */
.zone p { font-size: var(--body-size); line-height: 1.5; }
.zone ul { font-size: var(--body-size); padding-left: 1.2em; }
.zone li { line-height: 1.4; margin-bottom: 0.2em; }
```

### Responsive

```css
@media (max-width: 600px) {
    .split-slide .composite-grid,
    .third-slide .composite-grid,
    .three-col-slide .composite-grid {
        grid-template-columns: 1fr;
    }
    .quadrant-slide .composite-grid {
        grid-template-columns: 1fr;
        grid-template-rows: auto;
    }
    .zone { border-left: none; border-top: 1px solid var(--border-color, rgba(0,0,0,0.12)); }
    .zone:first-child { border-top: none; }
}
```

### Animation

Zones fade in with stagger, same `.reveal` pattern:

```css
.zone { opacity: 0; transform: translateY(15px);
    transition: opacity 0.4s var(--ease-out-expo), transform 0.4s var(--ease-out-expo); }
.slide.visible .zone { opacity: 1; transform: translateY(0); }
.slide.visible .zone:nth-child(2) { transition-delay: 0.1s; }
.slide.visible .zone:nth-child(3) { transition-delay: 0.2s; }
.slide.visible .zone:nth-child(4) { transition-delay: 0.3s; }
```

Charts inside zones animate after the zone appears (inherits `.slide.visible` trigger).

### Reduced Motion

```css
@media (prefers-reduced-motion: reduce) {
    .zone { transition: none !important; opacity: 1 !important; transform: none !important; }
}
```

---

## CSS Class Reference

| Element | Class | Notes |
|---|---|---|
| Grid container | `.composite-grid` | Shared wrapper, grid layout varies by slide type |
| Content zone | `.zone` | Individual content cell, flex column |
| Zone position | `.zone-left`, `.zone-right` | Split zones |
| Zone position | `.zone-top-left`, `.zone-top-right`, `.zone-bottom-left`, `.zone-bottom-right` | Quadrant zones |
| Zone position | `.zone-narrow`, `.zone-wide` | Third split zones |
| Zone position | `.zone-col-1`, `.zone-col-2`, `.zone-col-3` | Three column zones |
| Zone title | `.zone-title` | Optional `<h3>` heading within zone |

---

## HTML Reference

### 23. Split (`split-slide`)

**Default/Red preset:**

```html
<section class="slide split-slide" data-slide="N">
    <div class="swiss-grid decorative"><!-- grid lines --></div>
    <h2 class="slide-title">Split Title</h2>
    <p class="slide-subtitle">Subtitle text</p>
    <div class="section-title">Label</div>
    <div class="slide-content">
        <div class="composite-grid reveal">
            <div class="zone zone-left" role="region" aria-label="Left column">
                <h3 class="zone-title">Key Highlights</h3>
                <div class="bullet-item">
                    <div class="bullet-marker filled"></div>
                    <div>
                        <strong>Revenue</strong>
                        <span class="desc">$2.4M (+18% YoY)</span>
                    </div>
                </div>
                <div class="bullet-item">
                    <div class="bullet-marker filled"></div>
                    <div>
                        <strong>Customers</strong>
                        <span class="desc">1,200 active accounts</span>
                    </div>
                </div>
                <div class="bullet-item">
                    <div class="bullet-marker filled"></div>
                    <div>
                        <strong>NPS Score</strong>
                        <span class="desc">72 (up from 64)</span>
                    </div>
                </div>
            </div>
            <div class="zone zone-right" role="region" aria-label="Right column">
                <h3 class="zone-title">By Region</h3>
                <table class="swiss-table">
                    <thead>
                        <tr><th>Region</th><th>Revenue</th><th>Growth</th></tr>
                    </thead>
                    <tbody>
                        <tr><td>NA</td><td>$1.2M</td><td>+22%</td></tr>
                        <tr><td>EU</td><td>$680K</td><td>+15%</td></tr>
                        <tr><td>APAC</td><td>$520K</td><td>+12%</td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="bottom-rule">
        <span>Label</span>
        <span class="slide-num">N / TOTAL</span>
    </div>
</section>
```

**Black preset:**

```html
<section class="slide split-slide slide--light grid-bg-light" data-slide="N">
    <div class="section-title">Label</div>
    <div class="slide-content">
        <div class="slide-header reveal">
            <h2>Split Title</h2>
            <p class="slide-subtitle">Subtitle text</p>
        </div>
        <div class="composite-grid reveal">
            <!-- Same zone structure as Red preset -->
        </div>
    </div>
    <div class="bottom-rule">
        <span>Label</span>
        <span class="slide-num-label">N / TOTAL</span>
    </div>
</section>
```

---

### 24. Quadrant (`quadrant-slide`)

**Default/Red preset:**

```html
<section class="slide quadrant-slide" data-slide="N">
    <div class="swiss-grid decorative"><!-- grid lines --></div>
    <h2 class="slide-title">Dashboard Title</h2>
    <p class="slide-subtitle">Subtitle text</p>
    <div class="section-title">Label</div>
    <div class="slide-content">
        <div class="composite-grid reveal">
            <div class="zone zone-top-left" role="region" aria-label="Top left">
                <h3 class="zone-title">Satisfaction</h3>
                <div class="progress-ring-item">
                    <div class="progress-ring-svg">
                        <svg viewBox="0 0 200 200" role="img" aria-label="92%">
                            <circle class="progress-track" cx="100" cy="100" r="80"
                                fill="none" stroke="var(--chart-track)" stroke-width="20"/>
                            <circle class="progress-fill" cx="100" cy="100" r="80"
                                fill="none" stroke="var(--chart-1)" stroke-width="20"
                                stroke-dasharray="462.44 502.65" stroke-linecap="round"
                                style="--target-offset: 0"/>
                            <text class="progress-value" x="100" y="100"
                                text-anchor="middle" dominant-baseline="central">92%</text>
                        </svg>
                    </div>
                </div>
            </div>
            <div class="zone zone-top-right" role="region" aria-label="Top right">
                <h3 class="zone-title">Market Share</h3>
                <div class="donut-chart">
                    <div class="donut-svg">
                        <svg viewBox="0 0 200 200" role="img" aria-label="Market share">
                            <circle class="donut-segment" cx="100" cy="100" r="80"
                                fill="none" stroke="var(--chart-1)" stroke-width="25"
                                stroke-dasharray="226.19 502.65" stroke-dashoffset="0"
                                style="--target-offset: 0"/>
                            <circle class="donut-segment" cx="100" cy="100" r="80"
                                fill="none" stroke="var(--chart-2)" stroke-width="25"
                                stroke-dasharray="175.93 502.65" stroke-dashoffset="-226.19"
                                style="--target-offset: -226.19"/>
                            <circle class="donut-segment" cx="100" cy="100" r="80"
                                fill="none" stroke="var(--chart-3)" stroke-width="25"
                                stroke-dasharray="100.53 502.65" stroke-dashoffset="-402.12"
                                style="--target-offset: -402.12"/>
                        </svg>
                    </div>
                    <div class="donut-legend">
                        <div class="donut-legend-item">
                            <span class="donut-swatch" style="background: var(--chart-1)"></span>
                            <span>Mobile</span><span>45%</span>
                        </div>
                        <div class="donut-legend-item">
                            <span class="donut-swatch" style="background: var(--chart-2)"></span>
                            <span>Desktop</span><span>35%</span>
                        </div>
                        <div class="donut-legend-item">
                            <span class="donut-swatch" style="background: var(--chart-3)"></span>
                            <span>Tablet</span><span>20%</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="zone zone-bottom-left" role="region" aria-label="Bottom left">
                <h3 class="zone-title">Key Wins</h3>
                <ul>
                    <li>Launched v2.0 platform</li>
                    <li>Closed enterprise deal</li>
                    <li>Expanded to 3 new markets</li>
                </ul>
            </div>
            <div class="zone zone-bottom-right" role="region" aria-label="Bottom right">
                <h3 class="zone-title">Metrics</h3>
                <table class="swiss-table">
                    <thead>
                        <tr><th>Metric</th><th>Target</th><th>Actual</th></tr>
                    </thead>
                    <tbody>
                        <tr><td>Revenue</td><td>$2M</td><td>$2.4M</td></tr>
                        <tr><td>Users</td><td>1K</td><td>1.2K</td></tr>
                        <tr><td>NPS</td><td>65</td><td>72</td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="bottom-rule">
        <span>Label</span>
        <span class="slide-num">N / TOTAL</span>
    </div>
</section>
```

**Black preset:**

```html
<section class="slide quadrant-slide slide--light grid-bg-light" data-slide="N">
    <div class="section-title">Label</div>
    <div class="slide-content">
        <div class="slide-header reveal">
            <h2>Dashboard Title</h2>
            <p class="slide-subtitle">Subtitle text</p>
        </div>
        <div class="composite-grid reveal">
            <!-- Same zone structure as Red preset, using data-table instead of swiss-table -->
        </div>
    </div>
    <div class="bottom-rule">
        <span>Label</span>
        <span class="slide-num-label">N / TOTAL</span>
    </div>
</section>
```

---

### 25. Third Split (`third-slide`)

**Default/Red preset:**

```html
<section class="slide third-slide" data-slide="N">
    <div class="swiss-grid decorative"><!-- grid lines --></div>
    <h2 class="slide-title">Third Title</h2>
    <p class="slide-subtitle">Subtitle text</p>
    <div class="section-title">Label</div>
    <div class="slide-content">
        <div class="composite-grid reveal">
            <div class="zone zone-narrow" role="region" aria-label="Key metric">
                <div class="progress-ring-item">
                    <div class="progress-ring-svg">
                        <svg viewBox="0 0 200 200" role="img" aria-label="Market Share: 85%">
                            <circle class="progress-track" cx="100" cy="100" r="80"
                                fill="none" stroke="var(--chart-track)" stroke-width="20"/>
                            <circle class="progress-fill" cx="100" cy="100" r="80"
                                fill="none" stroke="var(--chart-1)" stroke-width="20"
                                stroke-dasharray="427.25 502.65" stroke-linecap="round"
                                style="--target-offset: 0"/>
                            <text class="progress-value" x="100" y="100"
                                text-anchor="middle" dominant-baseline="central">85%</text>
                        </svg>
                    </div>
                    <div class="progress-label">Market Share</div>
                </div>
            </div>
            <div class="zone zone-wide" role="region" aria-label="Revenue breakdown">
                <h3 class="zone-title">Revenue by Segment</h3>
                <div class="bar-chart" role="img" aria-label="Revenue by segment">
                    <div class="bar-row">
                        <span class="bar-label">Enterprise</span>
                        <div class="bar-track">
                            <div class="bar-fill" style="--bar-width: 100%"></div>
                        </div>
                        <span class="bar-value">540</span>
                    </div>
                    <div class="bar-row">
                        <span class="bar-label">Mid-Market</span>
                        <div class="bar-track">
                            <div class="bar-fill" style="--bar-width: 59%"></div>
                        </div>
                        <span class="bar-value">320</span>
                    </div>
                    <div class="bar-row">
                        <span class="bar-label">SMB</span>
                        <div class="bar-track">
                            <div class="bar-fill" style="--bar-width: 33%"></div>
                        </div>
                        <span class="bar-value">180</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="bottom-rule">
        <span>Label</span>
        <span class="slide-num">N / TOTAL</span>
    </div>
</section>
```

**Black preset:** Same structure with `slide--light grid-bg-light` + `slide-header`.

---

### 26. Three Column (`three-col-slide`)

**Default/Red preset:**

```html
<section class="slide three-col-slide" data-slide="N">
    <div class="swiss-grid decorative"><!-- grid lines --></div>
    <h2 class="slide-title">Three Columns Title</h2>
    <p class="slide-subtitle">Subtitle text</p>
    <div class="section-title">Label</div>
    <div class="slide-content">
        <div class="composite-grid reveal">
            <div class="zone zone-col-1" role="region" aria-label="Column 1">
                <h3 class="zone-title">Engineering</h3>
                <ul>
                    <li>24 engineers</li>
                    <li>4 tech leads</li>
                    <li>2 architects</li>
                </ul>
            </div>
            <div class="zone zone-col-2" role="region" aria-label="Column 2">
                <h3 class="zone-title">Design</h3>
                <ul>
                    <li>8 designers</li>
                    <li>2 UX researchers</li>
                    <li>1 design lead</li>
                </ul>
            </div>
            <div class="zone zone-col-3" role="region" aria-label="Column 3">
                <h3 class="zone-title">Product</h3>
                <ul>
                    <li>6 PMs</li>
                    <li>2 analysts</li>
                    <li>1 VP Product</li>
                </ul>
            </div>
        </div>
    </div>
    <div class="bottom-rule">
        <span>Label</span>
        <span class="slide-num">N / TOTAL</span>
    </div>
</section>
```

**Black preset:** Same structure with `slide--light grid-bg-light` + `slide-header`.

---

## Preset Adaptation

Same pattern as all previous phases:

- **Red preset:** `.slide-title` absolute top-left + swiss grid + `.composite-grid` in `.slide-content`
- **Black/Blue/Midnight:** `.slide-header` + `slide--light grid-bg-light` + `.composite-grid` in `.slide-content`
- **Bold Signal:** dark gradient bg, composite grid as focal content

All composite types use light backgrounds.

### Zone border adaptation

- **Red:** `border-color: rgba(0, 0, 0, 0.12)` (light subtle)
- **Black family:** `border-color: rgba(0, 0, 0, 0.12)` on light slides
- **Bold Signal:** `border-color: rgba(255, 255, 255, 0.15)` on dark bg

---

## Responsive Scaling

- At `max-width: 600px`: all grids → single column
- Zone internal charts scale via existing `clamp()` values
- Quadrant collapses to vertical stack (4 rows)
- Zone padding reduces at smaller heights

---

## Accessibility

- Each zone: `role="region"` + `aria-label`
- Internal content follows existing patterns (SVG titles, table headers, etc.)
- Animations respect `prefers-reduced-motion`

---

## Decision Tree Addition

Insert after the Phase 2+3 diagram block:

```
Does it need to show multiple different content types on one slide?
  → 2 equal sections? → Split
  → 4 sections (dashboard)? → Quadrant
  → 1 small + 1 large section? → Third Split
  → 3 equal sections? → Three Column
```

---

## Color Usage

Reuses existing `--chart-*` palette for any mini-charts within zones. No new color variables.

---

## Files to Modify

| File | Action | Changes |
|---|---|---|
| `CONTENT_TYPES.md` | Edit | Add types 23-26 with CSS classes, structure, markdown cues, decision tree |
| `reference/html-template.md` | Edit | Add HTML reference for all 4 types (Red + Black variants) |
| `style-samples/sample-content.md` | Edit | Add 4 markdown blocks demonstrating each type |
| `style-samples/*.html` | Edit | Add 4 new slides to each of the 5 sample files |

---

## Sample Content (Markdown)

```markdown
## Split: Revenue Overview
Key highlights alongside regional breakdown

### Left
- **Revenue** — $2.4M (+18% YoY)
- **Customers** — 1,200 active accounts
- **NPS Score** — 72 (up from 64)

### Right
| Region | Revenue | Growth |
|--------|---------|--------|
| NA | $1.2M | +22% |
| EU | $680K | +15% |
| APAC | $520K | +12% |

---

## Quadrant: Q4 Dashboard
Performance overview across key metrics

### Top-Left
- Customer Satisfaction: 92%

### Top-Right
- Mobile: 45%
- Desktop: 35%
- Tablet: 20%

### Bottom-Left
**Key Wins**
- Launched v2.0 platform
- Closed enterprise deal
- Expanded to 3 new markets

### Bottom-Right
| Metric | Target | Actual |
|--------|--------|--------|
| Revenue | $2M | $2.4M |
| Users | 1K | 1.2K |
| NPS | 65 | 72 |

---

## Third: Market Analysis
Key metric with supporting data

### Narrow
- Market Share: 85%

### Wide
Revenue breakdown by segment
- Enterprise: 540
- Mid-Market: 320
- SMB: 180

---

## Three Columns: Team Structure
Organization across departments

### Col 1
**Engineering**
- 24 engineers
- 4 tech leads
- 2 architects

### Col 2
**Design**
- 8 designers
- 2 UX researchers
- 1 design lead

### Col 3
**Product**
- 6 PMs
- 2 analysts
- 1 VP Product
```
