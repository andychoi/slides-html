# Diagram Content Types Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add 4 new diagram slide types (circular process flow, converge/diverge, winding road timeline, Gantt chart) to the HTML presentation system.

**Architecture:** Same as Phase 1 — inline SVG for cycle, converge, and roadmap; CSS grid for Gantt. All animations via existing `.slide.visible .reveal` Intersection Observer pattern. Reuses `--chart-*` color palette already defined in all presets.

**Tech Stack:** HTML, CSS (custom properties, grid, clamp()), inline SVG (arcs, bezier paths, markers), vanilla JS (existing SlidePresentation class)

**Spec:** `docs/superpowers/specs/2026-03-14-diagram-content-types-design.md`

---

## Chunk 1: Documentation Updates

### Task 1: Update CONTENT_TYPES.md

**Files:**
- Modify: `CONTENT_TYPES.md`

- [ ] **Step 1: Add types 19-22 to Layout Taxonomy table**

After row 18 (Funnel), add:

```markdown
| 19 | **Circular Process Flow** | `cycle-slide` | Light | Cyclical process — 3-6 steps around a circle with arrow arcs |
| 20 | **Converge/Diverge** | `converge-slide` | Light | Multiple inputs merging or one input splitting — SVG bezier paths |
| 21 | **Winding Road Timeline** | `roadmap-slide` | Dark | S-curve road path with milestone markers along the route |
| 22 | **Gantt Chart** | `gantt-slide` | Light | Overlapping phase bars on a time axis — CSS grid layout |
```

- [ ] **Step 2: Add Content Type Detail sections (19-22)**

After the "### 18. Funnel" section, add four new sections following exact same format (Purpose, Structure, When to use, Markdown cue). Content from spec.

- [ ] **Step 3: Update decision tree**

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

- [ ] **Step 4: Add CSS class entries to both Red and Black tables**

Add cycle, converge, roadmap, and gantt class entries per spec CSS Class Reference section.

- [ ] **Step 5: Commit**

```bash
git add CONTENT_TYPES.md
git commit -m "docs: add diagram content types 19-22 to CONTENT_TYPES.md"
```

---

### Task 2: Update reference/html-template.md

**Files:**
- Modify: `reference/html-template.md`

- [ ] **Step 1: Add HTML reference for all 4 new slide types**

After the "### 18. Funnel Slide" section, add sections 19-22 with complete HTML for both Red and Black presets. Copy from spec "HTML Reference" section.

- [ ] **Step 2: Commit**

```bash
git add reference/html-template.md
git commit -m "docs: add HTML reference for diagram slide types 19-22"
```

---

### Task 3: Update sample-content.md

**Files:**
- Modify: `style-samples/sample-content.md`

- [ ] **Step 1: Add 4 diagram markdown blocks**

Before the closing slide (`## Thank You`), add:

```markdown
---

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

- [ ] **Step 2: Commit**

```bash
git add style-samples/sample-content.md
git commit -m "docs: add diagram sample content for cycle, converge, roadmap, gantt"
```

---

## Chunk 2: Red Preset Reference Implementation

### Task 4: Add diagram slides to 05-red.html

**Files:**
- Modify: `style-samples/05-red.html`

- [ ] **Step 1: Read 05-red.html to find insertion points**

Find: where chart CSS ends (before RESPONSIVE OVERRIDES), where the last infographic slide is (before closing slide), current slide count.

- [ ] **Step 2: Add cycle CSS**

```css
/* ===========================================
   DIAGRAM: CIRCULAR PROCESS FLOW
   =========================================== */
.cycle-chart { max-width: min(80%, 400px); margin: 0 auto; }
.cycle-chart svg { width: 100%; height: auto; }
.cycle-step {
    opacity: 0; transform: scale(0.5);
    transition: opacity 0.5s var(--ease-out-expo), transform 0.5s var(--ease-out-expo);
}
.slide.visible .cycle-step { opacity: 1; transform: scale(1); }
.slide.visible .cycle-step:nth-child(2) { transition-delay: 0.1s; }
.slide.visible .cycle-step:nth-child(3) { transition-delay: 0.2s; }
.slide.visible .cycle-step:nth-child(4) { transition-delay: 0.3s; }
.slide.visible .cycle-step:nth-child(5) { transition-delay: 0.4s; }
.slide.visible .cycle-step:nth-child(6) { transition-delay: 0.5s; }
.cycle-node { transition: r 0.3s var(--ease-out-expo); }
.cycle-label {
    font-family: var(--font-display);
    font-size: clamp(0.5rem, 1vw, 0.75rem);
    font-weight: 800;
    fill: currentColor;
    text-transform: uppercase;
    letter-spacing: 0.04em;
}
.cycle-arrow {
    stroke-dasharray: 200;
    stroke-dashoffset: 200;
    transition: stroke-dashoffset 0.6s var(--ease-out-expo);
}
.slide.visible .cycle-arrow { stroke-dashoffset: 0; }
.slide.visible .cycle-arrow:nth-of-type(1) { transition-delay: 0.5s; }
.slide.visible .cycle-arrow:nth-of-type(2) { transition-delay: 0.6s; }
.slide.visible .cycle-arrow:nth-of-type(3) { transition-delay: 0.7s; }
.slide.visible .cycle-arrow:nth-of-type(4) { transition-delay: 0.8s; }
.slide.visible .cycle-arrow:nth-of-type(5) { transition-delay: 0.9s; }
.slide.visible .cycle-arrow:nth-of-type(6) { transition-delay: 1.0s; }
```

- [ ] **Step 3: Add converge CSS**

```css
/* ===========================================
   DIAGRAM: CONVERGE / DIVERGE
   =========================================== */
.converge-chart { max-width: min(90%, 500px); margin: 0 auto; }
.converge-chart svg { width: 100%; height: auto; }
.converge-path {
    stroke-dasharray: 400;
    stroke-dashoffset: 400;
    transition: stroke-dashoffset 0.8s var(--ease-out-expo);
}
.slide.visible .converge-path { stroke-dashoffset: 0; }
.slide.visible .converge-path:nth-of-type(2) { transition-delay: 0.15s; }
.slide.visible .converge-path:nth-of-type(3) { transition-delay: 0.3s; }
.slide.visible .converge-path:nth-of-type(4) { transition-delay: 0.45s; }
.slide.visible .converge-path:nth-of-type(5) { transition-delay: 0.6s; }
.converge-input, .converge-output {
    opacity: 0; transform: scale(0.7);
    transition: opacity 0.5s var(--ease-out-expo), transform 0.5s var(--ease-out-expo);
}
.slide.visible .converge-input,
.slide.visible .converge-output { opacity: 1; transform: scale(1); }
.slide.visible .converge-input:nth-child(2) { transition-delay: 0.1s; }
.slide.visible .converge-input:nth-child(3) { transition-delay: 0.2s; }
.slide.visible .converge-input:nth-child(4) { transition-delay: 0.3s; }
.slide.visible .converge-input:nth-child(5) { transition-delay: 0.4s; }
.slide.visible .converge-output { transition-delay: 0.6s; }
.converge-node { transition: r 0.3s var(--ease-out-expo); }
.converge-label {
    font-family: var(--font-display);
    font-size: clamp(0.5rem, 1.1vw, 0.8rem);
    font-weight: 800;
    fill: currentColor;
    text-transform: uppercase;
    letter-spacing: 0.04em;
}
```

- [ ] **Step 4: Add winding road CSS**

```css
/* ===========================================
   DIAGRAM: WINDING ROAD TIMELINE
   =========================================== */
.roadmap-slide {
    background: var(--text-primary);
    color: var(--bg-primary);
}
.roadmap-slide .section-title { color: rgba(255, 255, 255, 0.25); }
.roadmap-slide .bottom-rule { border-color: rgba(255, 255, 255, 0.2); }
.roadmap-slide .bottom-rule span { color: rgba(255, 255, 255, 0.3); }
.roadmap-slide .bottom-rule .slide-num { color: var(--accent); }
.roadmap-chart { max-width: min(90%, 550px); margin: 0 auto; }
.roadmap-chart svg { width: 100%; height: auto; }
.roadmap-road {
    stroke-dasharray: 1000;
    stroke-dashoffset: 1000;
    transition: stroke-dashoffset 1.5s var(--ease-out-expo);
}
.slide.visible .roadmap-road { stroke-dashoffset: 0; }
.roadmap-centerline {
    stroke-dasharray: 1000;
    stroke-dashoffset: 1000;
    transition: stroke-dashoffset 1.5s var(--ease-out-expo) 0.2s;
}
.slide.visible .roadmap-centerline { stroke-dashoffset: 0; }
.roadmap-milestone {
    opacity: 0; transform: scale(0.5);
    transition: opacity 0.4s var(--ease-out-expo), transform 0.4s var(--ease-out-expo);
}
.slide.visible .roadmap-milestone { opacity: 1; transform: scale(1); }
.slide.visible .roadmap-milestone:nth-child(3) { transition-delay: 0.6s; }
.slide.visible .roadmap-milestone:nth-child(4) { transition-delay: 0.8s; }
.slide.visible .roadmap-milestone:nth-child(5) { transition-delay: 1.0s; }
.slide.visible .roadmap-milestone:nth-child(6) { transition-delay: 1.2s; }
.slide.visible .roadmap-milestone:nth-child(7) { transition-delay: 1.4s; }
.slide.visible .roadmap-milestone:nth-child(8) { transition-delay: 1.6s; }
.roadmap-marker { transition: r 0.3s var(--ease-out-expo); }
.roadmap-marker.active { r: 14; }
.roadmap-date {
    font-family: var(--font-display);
    font-size: clamp(0.5rem, 1vw, 0.7rem);
    font-weight: 800;
    fill: var(--bg-primary);
    text-transform: uppercase;
    letter-spacing: 0.05em;
}
.roadmap-title {
    font-family: var(--font-body);
    font-size: clamp(0.45rem, 0.9vw, 0.65rem);
    fill: rgba(255, 255, 255, 0.7);
}
```

- [ ] **Step 5: Add Gantt CSS**

```css
/* ===========================================
   DIAGRAM: GANTT CHART
   =========================================== */
.gantt-chart {
    display: grid;
    grid-template-columns: clamp(60px, 12vw, 120px) repeat(var(--gantt-cols, 10), 1fr);
    gap: clamp(4px, 0.5vw, 8px);
    width: 100%;
    align-items: center;
}
.gantt-row {
    display: contents;
}
.gantt-label {
    font-size: var(--body-size);
    font-weight: 600;
    text-align: right;
    padding-right: clamp(4px, 0.5vw, 8px);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.gantt-bar {
    height: clamp(20px, 3vw, 32px);
    border-radius: 4px;
    display: flex;
    align-items: center;
    padding: 0 clamp(4px, 0.5vw, 8px);
    font-size: clamp(0.55rem, 0.9vw, 0.7rem);
    color: #fff;
    font-weight: 600;
    transform: scaleX(0);
    transform-origin: left;
    transition: transform 0.6s var(--ease-out-expo);
    grid-column: calc(var(--gantt-start) + 1) / calc(var(--gantt-end) + 1);
    paint-order: stroke;
}
.slide.visible .gantt-bar { transform: scaleX(1); }
.gantt-row:nth-child(2) .gantt-bar { transition-delay: 0.1s; }
.gantt-row:nth-child(3) .gantt-bar { transition-delay: 0.2s; }
.gantt-row:nth-child(4) .gantt-bar { transition-delay: 0.3s; }
.gantt-row:nth-child(5) .gantt-bar { transition-delay: 0.4s; }
.gantt-row:nth-child(6) .gantt-bar { transition-delay: 0.5s; }
.gantt-row:nth-child(7) .gantt-bar { transition-delay: 0.6s; }
.gantt-axis {
    grid-column: 2 / -1;
    display: flex;
    justify-content: space-between;
    border-top: 1px solid var(--border-color, rgba(0,0,0,0.12));
    padding-top: clamp(4px, 0.5vw, 8px);
}
.gantt-tick {
    font-size: clamp(0.5rem, 0.8vw, 0.65rem);
    color: var(--text-secondary, rgba(0,0,0,0.5));
    text-transform: uppercase;
    letter-spacing: 0.05em;
}
```

- [ ] **Step 6: Add reduced motion overrides for diagrams**

Add to the existing `prefers-reduced-motion` block:

```css
.cycle-step, .cycle-arrow { transition: none !important; opacity: 1 !important; transform: none !important; stroke-dashoffset: 0 !important; }
.converge-input, .converge-output, .converge-path { transition: none !important; opacity: 1 !important; transform: none !important; stroke-dashoffset: 0 !important; }
.roadmap-road, .roadmap-centerline { transition: none !important; stroke-dashoffset: 0 !important; }
.roadmap-milestone { transition: none !important; opacity: 1 !important; transform: none !important; }
.gantt-bar { transition: none !important; transform: scaleX(1) !important; }
```

- [ ] **Step 7: Add 4 slide HTML sections before closing slide**

Add cycle, converge, roadmap, and Gantt slides using Red preset structure (swiss-grid, slide-title absolute, etc). Roadmap uses dark-bg pattern (no swiss-grid, override colors). Use unique marker IDs per slide number.

Use the sample data from spec:
- Cycle: Research → Design → Build → Test → Launch
- Converge: API Gateway + Auth Service + Data Pipeline → Unified Platform
- Roadmap: Q1-Q4 2026 milestones
- Gantt: Research/Design/Development/Testing/Launch with overlapping date ranges

Set `style="--gantt-cols: 10"` on the gantt-chart container for 10 month columns.

- [ ] **Step 8: Update slide counts and numbers**

Update all `/ N` totals and renumber the closing slide.

- [ ] **Step 9: Update `updateDotColors` in JS**

Add `roadmap-slide` to the dark slide list (like `chart-progress-slide`).

- [ ] **Step 10: Open and verify**

```bash
open style-samples/05-red.html
```

Check: cycle steps appear around circle with arrows, converge paths draw with arrowheads, road draws then milestones pop in, Gantt bars grow from left. All colors use red preset chart palette.

- [ ] **Step 11: Commit**

```bash
git add style-samples/05-red.html
git commit -m "feat: add diagram slides (cycle, converge, roadmap, gantt) to red preset"
```

---

## Chunk 3: Other Preset Samples

### Task 5: Add diagram slides to 02-black.html

**Files:**
- Modify: `style-samples/02-black.html`

- [ ] **Step 1: Read file, find insertion points**
- [ ] **Step 2: Add all diagram CSS (same as red, plus dark-slide overrides for roadmap)**

For Black preset, roadmap uses `slide--dark grid-bg-dark` instead of the Red preset's bg override. Add:
```css
.roadmap-slide.slide--dark { background: var(--black); color: var(--white); }
.roadmap-slide .roadmap-date { fill: var(--white); }
.roadmap-slide .roadmap-title { fill: var(--gray-mid); }
```

- [ ] **Step 3: Add 4 slide sections using Black preset HTML pattern**

Cycle, converge, Gantt: `slide--light grid-bg-light` + `slide-header`
Roadmap: `slide--dark grid-bg-dark` + `slide-header`

- [ ] **Step 4: Update slide counts, `updateDotColors`, verify, commit**

```bash
git add style-samples/02-black.html
git commit -m "feat: add diagram slides to black preset sample"
```

---

### Task 6: Add diagram slides to 03-blue.html

**Files:**
- Modify: `style-samples/03-blue.html`

- [ ] **Step 1: Copy diagram CSS from black, add Blue roadmap overrides**
- [ ] **Step 2: Add 4 slide sections, update counts, verify, commit**

```bash
git add style-samples/03-blue.html
git commit -m "feat: add diagram slides to blue preset sample"
```

---

### Task 7: Add diagram slides to 04-black-midnight.html

**Files:**
- Modify: `style-samples/04-black-midnight.html`

- [ ] **Step 1: Copy diagram CSS from black, add Black Midnight roadmap overrides**
- [ ] **Step 2: Add 4 slide sections, update counts, verify, commit**

```bash
git add style-samples/04-black-midnight.html
git commit -m "feat: add diagram slides to black midnight preset sample"
```

---

### Task 8: Add diagram slides to 01-bold-signal.html

**Files:**
- Modify: `style-samples/01-bold-signal.html`

- [ ] **Step 1: Read file to understand Bold Signal's layout**

All slides on dark bg. Charts/diagrams render on the dark gradient.

- [ ] **Step 2: Add diagram CSS with Bold Signal dark-bg overrides**

All text fills need to be light:
```css
.cycle-label { fill: var(--text-primary); }
.converge-label { fill: var(--text-primary); }
.roadmap-slide { background: var(--bg-primary); }
.roadmap-date { fill: var(--text-primary); }
.roadmap-title { fill: rgba(255,255,255,0.7); }
.gantt-label { color: var(--text-primary); }
.gantt-tick { color: rgba(255,255,255,0.5); }
.gantt-axis { border-color: rgba(255,255,255,0.15); }
```

- [ ] **Step 3: Add 4 slide sections following Bold Signal pattern**
- [ ] **Step 4: Update counts, verify, commit**

```bash
git add style-samples/01-bold-signal.html
git commit -m "feat: add diagram slides to bold signal preset sample"
```

---

## Chunk 4: Final Verification

### Task 9: Cross-preset verification

- [ ] **Step 1: Open all 5 samples**

```bash
open style-samples/05-red.html style-samples/01-bold-signal.html style-samples/02-black.html style-samples/03-blue.html style-samples/04-black-midnight.html
```

Verify for each:
- Cycle: steps appear around circle, arrows draw between them
- Converge: paths draw with arrowheads, nodes fade in
- Roadmap: road draws S-curve, milestones pop in sequentially
- Gantt: bars grow from left with staggered timing
- All colors visible and match preset identity
- No overflow — content fits within 100vh
- SVG text readable (check label contrast)

- [ ] **Step 2: Test reduced motion**

Enable `prefers-reduced-motion: reduce` in DevTools. Verify all diagrams show final state with no animation.

- [ ] **Step 3: Fix any issues and commit**

```bash
git add -A style-samples/
git commit -m "fix: visual adjustments to diagram slides across presets"
```
