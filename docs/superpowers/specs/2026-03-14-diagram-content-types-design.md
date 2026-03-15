# Phase 2+3: Diagram Content Types

**Date:** 2026-03-14
**Status:** Design approved
**Scope:** Add 4 new diagram/visualization slide types to the presentation system

---

## Overview

Extend the presentation system with 4 diagram-focused slide types: circular process flow, converging/diverging arrows, winding road timeline, and Gantt chart. These complement the Phase 1 data visualization types (donut, bar, progress, funnel) with process and planning visualizations.

All types use the same inline SVG + CSS architecture established in Phase 1, reusing the existing `--chart-*` color palette (defined in Phase 1, already in all preset CSS) and `.slide.visible .reveal` animation pattern. The `--chart-track` variable (also from Phase 1) is used for the roadmap road stroke.

---

## New Content Types

| # | Content Type | CSS Class | Dark/Light | Technique |
|---|---|---|---|---|
| 19 | Circular Process Flow | `cycle-slide` | Light | SVG arcs + positioned labels around circle |
| 20 | Converge/Diverge | `converge-slide` | Light | SVG bezier paths merging to/from center |
| 21 | Winding Road Timeline | `roadmap-slide` | Dark | SVG S-curve path + milestone markers |
| 22 | Gantt Chart | `gantt-slide` | Light | CSS grid with colored phase bars |

### Content Limits

- Cycle: 3-6 steps
- Converge/Diverge: 3-5 inputs → 1 output (or reverse)
- Winding road: 3-6 milestones
- Gantt: 3-7 phase bars

---

## Markdown Detection Patterns

| Markdown Pattern | Layout | Detection Rule |
|---|---|---|
| `## Cycle: Title` + bullet items | Circular Flow | Prefix `Cycle:` + `- Step` items |
| `## Converge: Title` + bullets + `→ Output` | Converge | Prefix `Converge:` + items + `→` line |
| `## Diverge: Title` + source + `→` bullets | Diverge | Prefix `Diverge:` + source + `→` items |
| `## Roadmap: Title` + dated items | Winding Road | Prefix `Roadmap:` + items with dates (Q1, Jan, etc.) |
| `## Gantt: Title` + items with date ranges | Gantt | Prefix `Gantt:` + items matching `- Label: Start — End` |

**Disambiguation — Roadmap vs existing Timeline (type 9):**
- `## Timeline:` → existing horizontal linear milestones (type 9)
- `## Roadmap:` → new winding road with S-curve path (type 21)

**Subtitle handling:** Same as Phase 1 — optional description line below heading renders as `.slide-subtitle`.

---

## Technical Architecture

### Approach

Same as Phase 1: inline SVG for cycle, converge, and roadmap. CSS grid for Gantt. All animations via `.slide.visible .reveal` Intersection Observer pattern.

### 19. Circular Process Flow

**SVG structure:** `viewBox="0 0 300 300"`, center at (150, 150), radius = 110.

**Step positioning math:** For N steps, each step is placed at angle `(i * 360/N) - 90` degrees (starting from 12 o'clock). Position formula:
- `x = 150 + 110 * cos(angle_rad)`
- `y = 150 + 110 * sin(angle_rad)`

**Elements:**
- Step nodes: `<circle>` at calculated positions, radius ~18, filled with `--chart-N`
- Step labels: `<text>` positioned outside the circle (offset further from center)
- Arrow arcs: `<path>` elements using SVG arc commands between adjacent nodes
- Arrowheads: `<marker>` definition with `<polygon>` triangle, referenced via `marker-end`

**Layout:** SVG centered in slide content. Full-width, `max-width: min(80%, 400px)`.

**Animation:** Steps fade in sequentially around the circle (staggered `opacity` + `transform: scale`), then arrows draw via `stroke-dashoffset` transition.

### 20. Converge/Diverge

**SVG structure:** `viewBox="0 0 500 300"`.

**Converge layout:**
- 3-5 input nodes vertically distributed on the left (x ≈ 60)
- 1 output node on the right (x ≈ 440)
- Cubic bezier `<path>` curves from each input to the output
- Input node `y` positions: evenly spaced from ~40 to ~260
- Output node `y` position: centered at 150

**Path formula:** `M [input_x],[input_y] C [input_x+120],[input_y] [output_x-120],[output_y] [output_x],[output_y]`

**Diverge variant:** Mirror of converge — 1 input node on left, 3-5 output nodes on right. Same path formula reversed.

**Elements:**
- Input nodes: `<circle>` radius ~15, filled with `--chart-N`
- Output node: `<circle>` radius ~22, filled with accent or `--chart-1`
- Labels: `<text>` next to each node
- Paths: `<path>` with `stroke: var(--chart-N)`, `stroke-width: 2`, `fill: none`

**Animation:** Paths draw via `stroke-dashoffset`, then nodes + labels fade in. Staggered per input.

### 21. Winding Road Timeline

**SVG structure:** `viewBox="0 0 600 300"`.

**Road path:** A thick `<path>` with cubic bezier S-curves. The road weaves left-to-right across the viewBox:
```
M 50,250 C 150,250 150,50 300,50 S 450,250 550,250
```
(Exact control points adjusted based on milestone count to create natural S-curves.)

**Road styling:** `stroke-width: 30`, `stroke: var(--chart-track)`, `stroke-linecap: round`, `fill: none`. Optionally a lighter center line (`stroke-width: 2`, dashed).

**Milestones:** Positioned at calculated points along the path. For N milestones, distribute evenly along the path length:
- Each milestone: colored `<circle>` on the path + `<text>` for date and title
- Active milestone: larger radius, accent color, filled
- Labels alternate above/below the road to avoid overlap

**Dark background:** Dramatic effect — road appears as a lit path on dark surface.

**Animation:** Road draws itself via `stroke-dashoffset` transition (long duration, 1.5s), then milestones pop in sequentially with scale + opacity.

### 22. Gantt Chart

**Pure CSS:** CSS grid layout, similar approach to bar chart.

**Structure:**
- Container is a CSS grid: `display: grid; grid-template-columns: clamp(60px, 12vw, 120px) repeat(N, 1fr)` where N = number of time units
- Rows: one per phase + one for axis
- Left column: phase labels (fixed width)
- Grid area: colored bars positioned via CSS custom properties
- Bottom row: time axis labels

**CSS grid mapping:** Each `.gantt-bar` uses inline CSS custom properties `--gantt-start` and `--gantt-end` mapped to grid columns:
```css
.gantt-bar {
    grid-column: calc(var(--gantt-start) + 1) / calc(var(--gantt-end) + 1);
    /* +1 offset because column 1 is the label column */
}
```

**Time normalization:** The generator maps date ranges to grid column positions. For example, if the time range is Jan-Oct (10 months), each month = 1 column. A phase spanning "Apr — Aug" maps to `--gantt-start: 4; --gantt-end: 9`.

**Bar sizing:** Each `.gantt-bar` uses inline styles for positioning and color. Color cycles through `--chart-N`.

**Animation:** Bars grow from `transform: scaleX(0)` to `scaleX(1)` with `transform-origin: left`, staggered per row.

---

## CSS Class Reference

### Circular Process Flow Classes

| Element | Class | Notes |
|---|---|---|
| Container | `.cycle-chart` | Centers the SVG |
| Step group | `.cycle-step` | SVG `<g>` with node + label |
| Step node | `.cycle-node` | SVG `<circle>`, colored via `--chart-N` |
| Step label | `.cycle-label` | SVG `<text>`, positioned outside circle |
| Arrow path | `.cycle-arrow` | SVG `<path>` arc with arrowhead marker |

### Converge/Diverge Classes

| Element | Class | Notes |
|---|---|---|
| Container | `.converge-chart` | Centers the SVG |
| Input group | `.converge-input` | SVG `<g>` with node + label |
| Output group | `.converge-output` | SVG `<g>` with node + label |
| Flow path | `.converge-path` | SVG `<path>` bezier, colored via `--chart-N` |
| Node circle | `.converge-node` | SVG `<circle>` |
| Node label | `.converge-label` | SVG `<text>` |

### Winding Road Classes

| Element | Class | Notes |
|---|---|---|
| Container | `.roadmap-chart` | Centers the SVG |
| Road path | `.roadmap-road` | Thick SVG `<path>`, `--chart-track` stroke |
| Center line | `.roadmap-centerline` | Optional thin dashed line on road |
| Milestone group | `.roadmap-milestone` | SVG `<g>` with marker + labels |
| Milestone marker | `.roadmap-marker` | SVG `<circle>`, `.active` = accent filled |
| Milestone date | `.roadmap-date` | SVG `<text>`, date/period |
| Milestone title | `.roadmap-title` | SVG `<text>`, milestone name |

### Gantt Classes

| Element | Class | Notes |
|---|---|---|
| Container | `.gantt-chart` | CSS grid layout |
| Phase row | `.gantt-row` | Grid row with label + bar |
| Phase label | `.gantt-label` | Left-aligned phase name |
| Phase bar | `.gantt-bar` | Colored bar, `grid-column` positioning |
| Time axis | `.gantt-axis` | Bottom row with time labels |
| Axis tick | `.gantt-tick` | Individual time marker label |

---

## HTML Reference

### 19. Circular Process Flow (`cycle-slide`)

**Default/Red preset:**

```html
<section class="slide cycle-slide" data-slide="N">
    <div class="swiss-grid decorative"><!-- grid lines --></div>
    <h2 class="slide-title">Cycle Title</h2>
    <p class="slide-subtitle">Subtitle text</p>
    <div class="section-title">Label</div>
    <div class="slide-content">
        <div class="cycle-chart reveal">
            <svg viewBox="0 0 300 300" role="img" aria-label="Circular process flow">
                <title>Product Development Cycle</title>
                <!-- Arrowhead marker — ID must be unique per slide (use slide number) -->
                <defs>
                    <marker id="arrow-N" markerWidth="8" markerHeight="6"
                        refX="8" refY="3" orient="auto">
                        <polygon points="0,0 8,3 0,6" fill="currentColor"/>
                    </marker>
                </defs>
                <!-- 5 steps positioned around circle (r=110, center 150,150) -->
                <!-- Step 1: top (150, 40) — angle -90deg -->
                <g class="cycle-step">
                    <circle class="cycle-node" cx="150" cy="40" r="18"
                        fill="var(--chart-1)"/>
                    <text class="cycle-label" x="150" y="15"
                        text-anchor="middle">Research</text>
                </g>
                <!-- Step 2: top-right (254.6, 84.5) — angle -18deg -->
                <g class="cycle-step">
                    <circle class="cycle-node" cx="254.6" cy="84.5" r="18"
                        fill="var(--chart-2)"/>
                    <text class="cycle-label" x="280" y="80"
                        text-anchor="start">Design</text>
                </g>
                <!-- Step 3: bottom-right (214.7, 239) — angle 54deg -->
                <g class="cycle-step">
                    <circle class="cycle-node" cx="214.7" cy="239" r="18"
                        fill="var(--chart-3)"/>
                    <text class="cycle-label" x="240" y="258"
                        text-anchor="start">Build</text>
                </g>
                <!-- Step 4: bottom-left (85.3, 239) — angle 126deg -->
                <g class="cycle-step">
                    <circle class="cycle-node" cx="85.3" cy="239" r="18"
                        fill="var(--chart-4)"/>
                    <text class="cycle-label" x="60" y="258"
                        text-anchor="end">Test</text>
                </g>
                <!-- Step 5: top-left (45.4, 84.5) — angle 198deg -->
                <g class="cycle-step">
                    <circle class="cycle-node" cx="45.4" cy="84.5" r="18"
                        fill="var(--chart-5)"/>
                    <text class="cycle-label" x="20" y="80"
                        text-anchor="end">Launch</text>
                </g>
                <!-- Arrow arcs between steps -->
                <path class="cycle-arrow" d="M 166,44 A 110,110 0 0,1 250,70"
                    fill="none" stroke="var(--chart-1)" stroke-width="2"
                    marker-end="url(#arrow-N)"/>
                <path class="cycle-arrow" d="M 262,100 A 110,110 0 0,1 224,224"
                    fill="none" stroke="var(--chart-2)" stroke-width="2"
                    marker-end="url(#arrow-N)"/>
                <path class="cycle-arrow" d="M 200,248 A 110,110 0 0,1 100,248"
                    fill="none" stroke="var(--chart-3)" stroke-width="2"
                    marker-end="url(#arrow-N)"/>
                <path class="cycle-arrow" d="M 76,224 A 110,110 0 0,1 38,100"
                    fill="none" stroke="var(--chart-4)" stroke-width="2"
                    marker-end="url(#arrow-N)"/>
                <path class="cycle-arrow" d="M 50,70 A 110,110 0 0,1 134,44"
                    fill="none" stroke="var(--chart-5)" stroke-width="2"
                    marker-end="url(#arrow-N)"/>
            </svg>
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
<section class="slide cycle-slide slide--light grid-bg-light" data-slide="N">
    <div class="section-title">Label</div>
    <div class="slide-content">
        <div class="slide-header reveal">
            <h2>Cycle Title</h2>
            <p class="slide-subtitle">Subtitle text</p>
        </div>
        <div class="cycle-chart reveal">
            <!-- Same SVG structure as Red preset -->
        </div>
    </div>
    <div class="bottom-rule">
        <span>Label</span>
        <span class="slide-num-label">N / TOTAL</span>
    </div>
</section>
```

---

### 20. Converge/Diverge (`converge-slide`)

**Default/Red preset (converge):**

```html
<section class="slide converge-slide" data-slide="N">
    <div class="swiss-grid decorative"><!-- grid lines --></div>
    <h2 class="slide-title">Converge Title</h2>
    <p class="slide-subtitle">Subtitle text</p>
    <div class="section-title">Label</div>
    <div class="slide-content">
        <div class="converge-chart reveal">
            <svg viewBox="0 0 500 300" role="img" aria-label="Converging diagram showing platform integration">
                <title>Platform Integration</title>
                <!-- Arrowhead marker — ID must be unique per slide -->
                <defs>
                    <marker id="conv-arrow-N" markerWidth="8" markerHeight="6"
                        refX="8" refY="3" orient="auto">
                        <polygon points="0,0 8,3 0,6" fill="currentColor"/>
                    </marker>
                </defs>
                <!-- Input nodes (left side, evenly spaced) -->
                <g class="converge-input">
                    <circle class="converge-node" cx="60" cy="60" r="15"
                        fill="var(--chart-1)"/>
                    <text class="converge-label" x="60" y="30"
                        text-anchor="middle">API Gateway</text>
                </g>
                <g class="converge-input">
                    <circle class="converge-node" cx="60" cy="150" r="15"
                        fill="var(--chart-2)"/>
                    <text class="converge-label" x="60" y="120"
                        text-anchor="middle">Auth Service</text>
                </g>
                <g class="converge-input">
                    <circle class="converge-node" cx="60" cy="240" r="15"
                        fill="var(--chart-3)"/>
                    <text class="converge-label" x="60" y="210"
                        text-anchor="middle">Data Pipeline</text>
                </g>
                <!-- Output node (right side, centered) -->
                <g class="converge-output">
                    <circle class="converge-node" cx="440" cy="150" r="22"
                        fill="var(--chart-1)"/>
                    <text class="converge-label" x="440" y="190"
                        text-anchor="middle">Unified Platform</text>
                </g>
                <!-- Bezier paths from inputs to output — with arrowheads -->
                <path class="converge-path"
                    d="M 75,60 C 195,60 320,150 418,150"
                    fill="none" stroke="var(--chart-1)" stroke-width="2"
                    marker-end="url(#conv-arrow-N)"/>
                <path class="converge-path"
                    d="M 75,150 C 195,150 320,150 418,150"
                    fill="none" stroke="var(--chart-2)" stroke-width="2"
                    marker-end="url(#conv-arrow-N)"/>
                <path class="converge-path"
                    d="M 75,240 C 195,240 320,150 418,150"
                    fill="none" stroke="var(--chart-3)" stroke-width="2"
                    marker-end="url(#conv-arrow-N)"/>
            </svg>
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
<section class="slide converge-slide slide--light grid-bg-light" data-slide="N">
    <div class="section-title">Label</div>
    <div class="slide-content">
        <div class="slide-header reveal">
            <h2>Converge Title</h2>
            <p class="slide-subtitle">Subtitle text</p>
        </div>
        <div class="converge-chart reveal">
            <!-- Same SVG structure as Red preset -->
        </div>
    </div>
    <div class="bottom-rule">
        <span>Label</span>
        <span class="slide-num-label">N / TOTAL</span>
    </div>
</section>
```

**Diverge variant:** Uses the same `converge-slide` class and `converge-chart` container. Nodes and paths are mirrored — 1 input on the left, 3-5 outputs on the right. Replace `converge-input`/`converge-output` roles (single node gets `converge-input`, multiple nodes get `converge-output`). Paths flow left → right with bezier curves fanning out.

---

### 21. Winding Road Timeline (`roadmap-slide`)

**Dark-background slide pattern:** Like Phase 1's progress rings, this slide uses a dark background in all presets. In the Red preset, this means overriding the default white bg with dark colors and omitting the `swiss-grid` decorative element (not visible on dark). In Black-family presets, use `slide--dark grid-bg-dark`.

**Default/Red preset:**

```html
<section class="slide roadmap-slide" data-slide="N">
    <!-- No swiss-grid: dark background slide (same pattern as chart-progress-slide) -->
    <div class="section-title">Label</div>
    <div class="slide-content">
        <div class="red-bar-h reveal"></div>
        <h2 class="slide-title" style="position: relative; color: var(--bg-primary)">Roadmap Title</h2>
        <div class="roadmap-chart reveal">
            <svg viewBox="0 0 600 280" role="img" aria-label="Product roadmap with milestones">
                <title>2026 Product Milestones</title>
                <!-- Road path: thick S-curve -->
                <path class="roadmap-road"
                    d="M 30,220 C 130,220 130,60 300,60 S 470,220 570,220"
                    fill="none" stroke="var(--chart-track)" stroke-width="30"
                    stroke-linecap="round"/>
                <!-- Optional center dashed line -->
                <path class="roadmap-centerline"
                    d="M 30,220 C 130,220 130,60 300,60 S 470,220 570,220"
                    fill="none" stroke="rgba(255,255,255,0.3)" stroke-width="2"
                    stroke-dasharray="8,6"/>
                <!-- Milestone 1 (leftmost on path) -->
                <g class="roadmap-milestone">
                    <circle class="roadmap-marker active" cx="80" cy="200" r="10"
                        fill="var(--chart-1)"/>
                    <text class="roadmap-date" x="80" y="240"
                        text-anchor="middle">Q1 2026</text>
                    <text class="roadmap-title" x="80" y="256"
                        text-anchor="middle">Research</text>
                </g>
                <!-- Milestone 2 -->
                <g class="roadmap-milestone">
                    <circle class="roadmap-marker" cx="210" cy="100" r="10"
                        fill="var(--chart-2)"/>
                    <text class="roadmap-date" x="210" y="80"
                        text-anchor="middle">Q2 2026</text>
                    <text class="roadmap-title" x="210" y="66"
                        text-anchor="middle">Build</text>
                </g>
                <!-- Milestone 3 -->
                <g class="roadmap-milestone">
                    <circle class="roadmap-marker" cx="390" cy="100" r="10"
                        fill="var(--chart-3)"/>
                    <text class="roadmap-date" x="390" y="80"
                        text-anchor="middle">Q3 2026</text>
                    <text class="roadmap-title" x="390" y="66"
                        text-anchor="middle">Beta</text>
                </g>
                <!-- Milestone 4 (rightmost on path) -->
                <g class="roadmap-milestone">
                    <circle class="roadmap-marker" cx="520" cy="200" r="10"
                        fill="var(--chart-4)"/>
                    <text class="roadmap-date" x="520" y="240"
                        text-anchor="middle">Q4 2026</text>
                    <text class="roadmap-title" x="520" y="256"
                        text-anchor="middle">Launch</text>
                </g>
            </svg>
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
<section class="slide roadmap-slide slide--dark grid-bg-dark" data-slide="N">
    <div class="section-title">Label</div>
    <div class="slide-content">
        <div class="slide-header reveal">
            <h2>Roadmap Title</h2>
            <p class="slide-subtitle">Subtitle text</p>
        </div>
        <div class="roadmap-chart reveal">
            <!-- Same SVG structure as Red preset -->
        </div>
    </div>
    <div class="bottom-rule">
        <span>Label</span>
        <span class="slide-num-label">N / TOTAL</span>
    </div>
</section>
```

---

### 22. Gantt Chart (`gantt-slide`)

**Default/Red preset:**

```html
<section class="slide gantt-slide" data-slide="N">
    <div class="swiss-grid decorative"><!-- grid lines --></div>
    <h2 class="slide-title">Gantt Title</h2>
    <p class="slide-subtitle">Subtitle text</p>
    <div class="section-title">Label</div>
    <div class="slide-content">
        <div class="gantt-chart reveal" role="img" aria-label="Gantt chart showing project timeline">
            <!-- Phase rows -->
            <div class="gantt-row">
                <span class="gantt-label">Research</span>
                <div class="gantt-bar" style="--gantt-start: 1; --gantt-end: 4; background: var(--chart-1)">
                    <span>Jan — Mar</span>
                </div>
            </div>
            <div class="gantt-row">
                <span class="gantt-label">Design</span>
                <div class="gantt-bar" style="--gantt-start: 2; --gantt-end: 5; background: var(--chart-2)">
                    <span>Feb — Apr</span>
                </div>
            </div>
            <div class="gantt-row">
                <span class="gantt-label">Development</span>
                <div class="gantt-bar" style="--gantt-start: 4; --gantt-end: 9; background: var(--chart-3)">
                    <span>Apr — Aug</span>
                </div>
            </div>
            <div class="gantt-row">
                <span class="gantt-label">Testing</span>
                <div class="gantt-bar" style="--gantt-start: 7; --gantt-end: 10; background: var(--chart-4)">
                    <span>Jul — Sep</span>
                </div>
            </div>
            <div class="gantt-row">
                <span class="gantt-label">Launch</span>
                <div class="gantt-bar" style="--gantt-start: 9; --gantt-end: 11; background: var(--chart-5)">
                    <span>Sep — Oct</span>
                </div>
            </div>
            <!-- Time axis -->
            <div class="gantt-axis">
                <span class="gantt-tick">Jan</span>
                <span class="gantt-tick">Feb</span>
                <span class="gantt-tick">Mar</span>
                <span class="gantt-tick">Apr</span>
                <span class="gantt-tick">May</span>
                <span class="gantt-tick">Jun</span>
                <span class="gantt-tick">Jul</span>
                <span class="gantt-tick">Aug</span>
                <span class="gantt-tick">Sep</span>
                <span class="gantt-tick">Oct</span>
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
<section class="slide gantt-slide slide--light grid-bg-light" data-slide="N">
    <div class="section-title">Label</div>
    <div class="slide-content">
        <div class="slide-header reveal">
            <h2>Gantt Title</h2>
            <p class="slide-subtitle">Subtitle text</p>
        </div>
        <div class="gantt-chart reveal" role="img" aria-label="Gantt chart showing project timeline">
            <!-- Same gantt-row structure as Red preset -->
        </div>
    </div>
    <div class="bottom-rule">
        <span>Label</span>
        <span class="slide-num-label">N / TOTAL</span>
    </div>
</section>
```

---

## Preset Adaptation

Same pattern as Phase 1:

- **Red preset:** `.slide-title` absolute top-left + swiss grid + chart content in `.slide-content`
- **Black/Blue/Midnight:** `.slide-header` + `slide--light`/`slide--dark` + grid background + chart content in `.slide-content`
- **Bold Signal:** Charts render on the dark gradient background. Chart colors use `--chart-*` variables set for dark backgrounds.

Roadmap uses dark background (`slide--dark` / dark bg override). Cycle, converge, and Gantt use light background.

---

## Responsive Scaling

- SVG `viewBox` handles scaling for cycle, converge, roadmap
- Gantt chart uses CSS grid with `fr` units — fluid by default
- Labels use existing `clamp()` body-size variables
- At `max-height: 600px`: scale SVG smaller, reduce spacing
- Cycle/converge: `max-width: min(80%, 400px)`
- Roadmap: `max-width: min(90%, 550px)`
- Gantt label column: `flex: 0 0 clamp(60px, 12vw, 120px)`

---

## Accessibility

- SVG elements include `role="img"` + `aria-label`
- Nodes and paths include `<title>` elements
- Gantt bars include text content for screen readers
- All animations respect `prefers-reduced-motion`

### Reduced Motion

```css
@media (prefers-reduced-motion: reduce) {
    .cycle-step, .cycle-arrow { transition: none !important; opacity: 1 !important; transform: none !important; }
    .converge-input, .converge-output, .converge-path { transition: none !important; opacity: 1 !important; }
    .roadmap-road { transition: none !important; stroke-dashoffset: 0 !important; }
    .roadmap-milestone { transition: none !important; opacity: 1 !important; transform: none !important; }
    .gantt-bar { transition: none !important; transform: scaleX(1) !important; }
}
```

---

## Decision Tree Addition

Insert after the Phase 1 chart visualization block and before "Does it show code?":

```
Does it show a cyclical/repeating process?
  → Circular Process Flow

Does it show multiple inputs merging or one input splitting?
  → Converge/Diverge

Does it show a journey/roadmap with milestones along a path?
  → Winding Road Timeline (visual S-curve path)
  → Timeline (type 9 — horizontal linear milestones)

Does it show overlapping phases on a time axis?
  → Gantt Chart
```

---

## Color Usage

Reuses existing `--chart-1` through `--chart-6` palette from Phase 1. No new color variables needed.

- Cycle: each step node/arrow uses `--chart-N`
- Converge: each input path/node uses `--chart-N`, output uses `--chart-1`
- Roadmap: each milestone marker uses `--chart-N`, road uses `--chart-track` (thick)
- Gantt: each phase bar uses `--chart-N`
- SVG text on light slides: `fill: currentColor` (inherits from slide)
- SVG text on dark slides (roadmap): `fill: var(--bg-primary)` or white

---

## Files to Modify

| File | Action | Changes |
|---|---|---|
| `CONTENT_TYPES.md` | Edit | Add types 19-22 with CSS classes, structure, markdown cues, decision tree |
| `reference/html-template.md` | Edit | Add HTML reference for all 4 types (Red + Black variants) |
| `style-samples/sample-content.md` | Edit | Add 4 markdown blocks demonstrating each type |
| `style-samples/*.html` | Edit | Add 4 new slides to each of the 5 sample files |

---

## Sample Content (Markdown)

```markdown
## Cycle: Product Development
Continuous improvement loop

- Research
- Design
- Build
- Test
- Launch

---

## Converge: Platform Integration
Bringing services together into a unified system

- API Gateway
- Auth Service
- Data Pipeline
→ Unified Platform

---

## Roadmap: 2026 Product Milestones
Key delivery dates and strategic targets

- Q1 2026: Research & Discovery
- Q2 2026: Core Platform Build
- Q3 2026: Beta Launch
- Q4 2026: General Availability

---

## Gantt: Project Timeline
Phase overlap and delivery schedule

- Research: Jan — Mar
- Design: Feb — Apr
- Development: Apr — Aug
- Testing: Jul — Sep
- Launch: Sep — Oct
```
