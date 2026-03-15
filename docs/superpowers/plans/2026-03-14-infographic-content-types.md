# Infographic Content Types Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add 4 new data visualization slide types (donut chart, bar chart, progress rings, funnel) to the HTML presentation system.

**Architecture:** Inline SVG + CSS hybrid approach. Donut, progress rings, and funnel use SVG `<circle>` / `<polygon>` elements with `stroke-dasharray` animations. Bar chart uses pure CSS flexbox with percentage widths. All animations trigger via existing Intersection Observer `.slide.visible .reveal` pattern.

**Tech Stack:** HTML, CSS (custom properties, clamp(), flexbox), inline SVG, vanilla JS (existing SlidePresentation class)

**Spec:** `docs/superpowers/specs/2026-03-14-infographic-content-types-design.md`

---

## Chunk 1: Documentation Updates

### Task 1: Update CONTENT_TYPES.md

**Files:**
- Modify: `CONTENT_TYPES.md`

- [ ] **Step 1: Add types 15-18 to Layout Taxonomy table**

After row 14 (Closing / Q&A), add:

```markdown
| 15 | **Donut Chart** | `chart-donut-slide` | Light | Parts-of-whole data — 2-6 segments as SVG donut ring |
| 16 | **Bar Chart** | `chart-bar-slide` | Light | Comparative quantities — 3-8 horizontal bars |
| 17 | **Progress Rings** | `chart-progress-slide` | Dark | Independent metrics — 2-4 animated circular gauges |
| 18 | **Funnel** | `funnel-slide` | Light | Pipeline/conversion — 3-5 narrowing SVG trapezoid stages |
```

- [ ] **Step 2: Add Content Type Details sections (15-18)**

After the "### 14. Closing / Q&A" section, add four new sections following the exact same format (Purpose, Structure, When to use, Markdown cue). Content from spec sections "CSS Class Reference" and "Markdown Detection Patterns":

**### 15. Donut Chart (`chart-donut-slide`)**

Purpose: Visualizing parts of a whole — percentages that sum to ~100%.

Structure:
- Two-column layout: SVG donut (left) + HTML legend (right)
- SVG `viewBox="0 0 200 200"`, circles with `stroke-dasharray`
- Legend: `.donut-legend` with `.donut-legend-item` rows (swatch + label + value)
- Optional center label via SVG `<text>`

When to use: Market share, budget allocation, survey results, any data showing composition.

Markdown cue: `## Chart: Title` followed by `- Label: N%` items (must sum to ~100%).

**### 16. Bar Chart (`chart-bar-slide`)**

Purpose: Comparing quantities across categories.

Structure:
- Vertical stack of `.bar-row` elements
- Each row: `.bar-label` (left) + `.bar-track` > `.bar-fill` (middle) + `.bar-value` (right)
- Bar widths normalized to % of max value via `--bar-width` CSS variable
- Horizontal orientation for label readability

When to use: Revenue by region, feature usage counts, survey responses, any categorical comparison.

Markdown cue: `## Bar Chart: Title` followed by `- Label: N` items (raw numbers, not percentages).

**### 17. Progress Rings (`chart-progress-slide`)**

Purpose: Showing progress toward independent goals or targets.

Structure:
- Flex row of 2-4 `.progress-ring-item` elements
- Each ring: background circle (`.progress-track`) + animated foreground (`.progress-fill`)
- Center text: percentage value via SVG `<text>`
- Label below each ring: `.progress-label`, uppercase muted
- Dark background for dramatic contrast

When to use: KPI dashboards, quarterly goal tracking, completion metrics, skill assessments.

Markdown cue: `## Progress: Title` followed by `- Label: N%` items (independent metrics, each 0-100%).

**### 18. Funnel (`funnel-slide`)**

Purpose: Visualizing a narrowing pipeline or conversion process.

Structure:
- Single SVG with `<polygon>` trapezoids, each narrower than above
- Stage labels + values via SVG `<text>` centered in each trapezoid
- Colors from chart palette (`--chart-1` through `--chart-5`)
- Stages cascade in with staggered animation

When to use: Sales pipelines, conversion funnels, recruitment processes, any narrowing flow.

Markdown cue: `## Funnel: Title` followed by `1. Label — Value` numbered items.

- [ ] **Step 3: Update decision tree**

Insert after "Does it present large metrics?" block and before "Does it show code?":

```
Does it show data as a chart or visualization?
  → Parts of a whole (% summing to 100%)? → Donut Chart
  → Quantities compared across categories? → Bar Chart
  → Progress toward independent goals? → Progress Rings
  → Narrowing pipeline or conversion stages? → Funnel
```

- [ ] **Step 4: Add CSS Class Quick Reference entries**

Add to both Red and Black preset class tables. See spec "CSS Class Reference" section for exact class names and notes.

- [ ] **Step 5: Commit**

```bash
git add CONTENT_TYPES.md
git commit -m "docs: add infographic content types 15-18 to CONTENT_TYPES.md"
```

---

### Task 2: Update STYLE_PRESETS.md

**Files:**
- Modify: `STYLE_PRESETS.md`

- [ ] **Step 1: Add chart palette variables to each preset**

In each preset's Colors section, add after the existing CSS variables:

```css
/* Chart palette */
--chart-1: /* preset chart-1 */;
--chart-2: /* preset chart-2 */;
--chart-3: /* preset chart-3 */;
--chart-4: /* preset chart-4 */;
--chart-5: /* preset chart-5 */;
--chart-6: /* preset chart-6 */;
--chart-track: rgba(128, 128, 128, 0.15);
```

Values per preset (from spec):

| Preset | chart-1 | chart-2 | chart-3 | chart-4 | chart-5 | chart-6 |
|---|---|---|---|---|---|---|
| Red | `#ff3300` | `#000` | `#666` | `#999` | `#ccc` | `#e0e0e0` |
| Black | `#f8f8f8` | `#c0c0c0` | `#888` | `#555` | `#333` | `#1a1a1a` |
| Blue | `#003082` | `#4a6fa5` | `#BFBAAF` | `#60605B` | `#8a9bb5` | `#c4d0e0` |
| Black Midnight | `#BB162B` | `#fff` | `#9ca3af` | `#4b5563` | `#374151` | `#1f2937` |
| Bold Signal | `#FF5722` | `#fff` | `#888` | `#555` | `#333` | `#1a1a1a` |

- [ ] **Step 2: Commit**

```bash
git add STYLE_PRESETS.md
git commit -m "docs: add chart palette CSS variables to all style presets"
```

---

### Task 3: Update reference/html-template.md

**Files:**
- Modify: `reference/html-template.md`

- [ ] **Step 1: Add HTML reference for all 4 new slide types**

After the "### 14. Closing/Q&A Slide" section, add sections 15-18 with complete HTML for both Red and Black presets. Copy directly from spec "HTML Reference" section — it has the exact HTML blocks ready to paste.

- [ ] **Step 2: Commit**

```bash
git add reference/html-template.md
git commit -m "docs: add HTML reference for infographic slide types 15-18"
```

---

### Task 4: Update sample-content.md

**Files:**
- Modify: `style-samples/sample-content.md`

- [ ] **Step 1: Add 4 infographic markdown blocks**

Before the closing slide (`## Thank You`), add these 4 blocks separated by `---`:

```markdown
---

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

- [ ] **Step 2: Commit**

```bash
git add style-samples/sample-content.md
git commit -m "docs: add infographic sample content for donut, bar, progress, funnel"
```

---

## Chunk 2: Red Preset Sample HTML

### Task 5: Add infographic slides to 00-red.html

**Files:**
- Modify: `style-samples/00-red.html`

This is the reference implementation — build all 4 chart types here first, then adapt for other presets.

- [ ] **Step 1: Read existing 00-red.html to understand CSS structure**

Read the file to find:
- Where `:root` CSS variables are defined (to add `--chart-*` variables)
- Where the last slide's CSS ends (to add new chart CSS)
- Where the last `<section>` element is (to add new slides before closing)
- The exact animation/reveal pattern used

- [ ] **Step 2: Add chart CSS variables to `:root`**

Add after existing variables in the `:root` block:

```css
/* Chart palette */
--chart-1: #ff3300;
--chart-2: #000;
--chart-3: #666;
--chart-4: #999;
--chart-5: #ccc;
--chart-6: #e0e0e0;
--chart-track: rgba(128, 128, 128, 0.15);
```

- [ ] **Step 3: Add donut chart CSS**

Add CSS for `.chart-donut-slide`, `.donut-chart`, `.donut-svg`, `.donut-segment`, `.donut-center`, `.donut-legend`, `.donut-legend-item`, `.donut-swatch`. Key patterns:

```css
.donut-chart {
    display: flex;
    align-items: center;
    gap: clamp(1.5rem, 3vw, 3rem);
}
.donut-svg { flex: 0 0 auto; max-width: min(50%, 280px); }
.donut-svg svg { width: 100%; height: auto; transform: rotate(-90deg); }
.donut-segment {
    transition: stroke-dashoffset 1s var(--ease-out-expo);
    stroke-dashoffset: 502.65; /* starts hidden */
}
.slide.visible .donut-segment {
    stroke-dashoffset: var(--target-offset, 0);
}
.donut-segment:nth-child(2) { transition-delay: 0.15s; }
.donut-segment:nth-child(3) { transition-delay: 0.3s; }
.donut-segment:nth-child(4) { transition-delay: 0.45s; }
.donut-segment:nth-child(5) { transition-delay: 0.6s; }
.donut-segment:nth-child(6) { transition-delay: 0.75s; }
.donut-center {
    font-family: var(--font-display, 'Archivo', sans-serif);
    font-size: 2rem; font-weight: 800;
    fill: var(--text-primary, #000);
    transform: rotate(90deg); transform-origin: center;
}
.donut-legend { display: flex; flex-direction: column; gap: clamp(0.5rem, 1vw, 1rem); }
.donut-legend-item {
    display: flex; align-items: center;
    gap: clamp(0.5rem, 1vw, 0.75rem);
    font-size: var(--body-size, clamp(0.875rem, 1.5vw, 1.5rem));
}
.donut-swatch {
    width: clamp(12px, 1.5vw, 18px); height: clamp(12px, 1.5vw, 18px);
    border-radius: 2px; flex-shrink: 0;
}
```

- [ ] **Step 4: Add bar chart CSS**

```css
.bar-chart {
    display: flex; flex-direction: column;
    gap: clamp(0.5rem, 1.2vw, 1rem);
    width: 100%;
}
.bar-row {
    display: flex; align-items: center;
    gap: clamp(0.5rem, 1vw, 1rem);
}
.bar-label {
    flex: 0 0 clamp(80px, 15vw, 160px);
    font-size: var(--body-size, clamp(0.875rem, 1.5vw, 1.5rem));
    text-align: right; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
}
.bar-track {
    flex: 1; height: clamp(20px, 3vw, 36px);
    background: var(--chart-track);
    border-radius: 2px; overflow: hidden;
}
.bar-fill {
    height: 100%; width: 0;
    background: var(--chart-1);
    border-radius: 2px;
    transition: width 0.8s var(--ease-out-expo);
}
.slide.visible .bar-fill { width: var(--bar-width); }
.bar-row:nth-child(2) .bar-fill { transition-delay: 0.1s; }
.bar-row:nth-child(3) .bar-fill { transition-delay: 0.2s; }
.bar-row:nth-child(4) .bar-fill { transition-delay: 0.3s; }
.bar-row:nth-child(5) .bar-fill { transition-delay: 0.4s; }
.bar-row:nth-child(6) .bar-fill { transition-delay: 0.5s; }
.bar-row:nth-child(7) .bar-fill { transition-delay: 0.6s; }
.bar-row:nth-child(8) .bar-fill { transition-delay: 0.7s; }
.bar-value {
    flex: 0 0 clamp(40px, 6vw, 70px);
    font-family: var(--font-display, 'Archivo', sans-serif);
    font-weight: 800;
    font-size: var(--body-size, clamp(0.875rem, 1.5vw, 1.5rem));
}
```

- [ ] **Step 5: Add progress rings CSS**

```css
.progress-rings {
    display: flex; justify-content: center;
    gap: clamp(1.5rem, 4vw, 4rem);
    flex-wrap: wrap;
}
.progress-ring-item {
    display: flex; flex-direction: column; align-items: center;
    gap: clamp(0.5rem, 1vw, 1rem);
}
.progress-ring-svg { width: clamp(100px, 18vw, 180px); height: auto; }
.progress-ring-svg svg { width: 100%; height: auto; transform: rotate(-90deg); }
.progress-track { opacity: 1; }
.progress-fill {
    transition: stroke-dashoffset 1.2s var(--ease-out-expo);
    stroke-dashoffset: 502.65;
}
.slide.visible .progress-fill { stroke-dashoffset: var(--target-offset, 0); }
.progress-ring-item:nth-child(2) .progress-fill { transition-delay: 0.2s; }
.progress-ring-item:nth-child(3) .progress-fill { transition-delay: 0.4s; }
.progress-ring-item:nth-child(4) .progress-fill { transition-delay: 0.6s; }
.progress-value {
    font-family: var(--font-display, 'Archivo', sans-serif);
    font-size: 2.2rem; font-weight: 800;
    fill: currentColor;
    transform: rotate(90deg); transform-origin: center;
}
.progress-label {
    font-size: clamp(0.65rem, 1.2vw, 0.9rem);
    text-transform: uppercase; letter-spacing: 0.08em;
    opacity: 0.6; text-align: center;
}
```

- [ ] **Step 6: Add funnel CSS**

```css
.funnel-chart { max-width: min(80%, 500px); margin: 0 auto; }
.funnel-chart svg { width: 100%; height: auto; }
.funnel-stage {
    opacity: 0; transform: translateY(20px);
    transition: opacity 0.6s var(--ease-out-expo), transform 0.6s var(--ease-out-expo);
}
.slide.visible .funnel-stage { opacity: 1; transform: translateY(0); }
.slide.visible .funnel-stage:nth-child(2) { transition-delay: 0.15s; }
.slide.visible .funnel-stage:nth-child(3) { transition-delay: 0.3s; }
.slide.visible .funnel-stage:nth-child(4) { transition-delay: 0.45s; }
.slide.visible .funnel-stage:nth-child(5) { transition-delay: 0.6s; }
.funnel-label {
    font-family: var(--font-display, 'Archivo', sans-serif);
    font-size: 0.85rem; font-weight: 800;
    fill: #fff; text-transform: uppercase; letter-spacing: 0.05em;
}
.funnel-value {
    font-family: var(--font-body, 'Nunito', sans-serif);
    font-size: 0.75rem; fill: rgba(255,255,255,0.8);
}
```

- [ ] **Step 7: Add reduced motion overrides**

```css
@media (prefers-reduced-motion: reduce) {
    .donut-segment, .progress-fill { transition: none !important; stroke-dashoffset: var(--target-offset, 0) !important; }
    .bar-fill { transition: none !important; width: var(--bar-width) !important; }
    .funnel-stage { transition: none !important; opacity: 1 !important; transform: none !important; }
}
```

- [ ] **Step 8: Add 4 new slide `<section>` elements**

Insert before the closing slide. Use the exact HTML from the spec's "HTML Reference" section for the Red preset (sections 15-18). Update `data-slide` numbers and slide count in all footer `N / 18` references.

- [ ] **Step 9: Update total slide count**

Update all existing `N / 14` references in the footer to `N / 18` and renumber slides.

- [ ] **Step 10: Open in browser and visually verify**

```bash
open style-samples/00-red.html
```

Check: donut segments sweep in, bars grow, progress rings fill, funnel stages cascade. All colors use red preset palette. Reduced motion works (toggle in OS settings or DevTools).

- [ ] **Step 11: Commit**

```bash
git add style-samples/00-red.html
git commit -m "feat: add infographic slides (donut, bar, progress, funnel) to red preset"
```

---

## Chunk 3: Black Family Preset Samples

### Task 6: Add infographic slides to 02-black.html

**Files:**
- Modify: `style-samples/02-black.html`

- [ ] **Step 1: Read 02-black.html to find insertion points**

Find `:root` for chart variables, last CSS section, last `<section>` before closing slide.

- [ ] **Step 2: Add `--chart-*` variables for Black preset**

```css
--chart-1: #f8f8f8;
--chart-2: #c0c0c0;
--chart-3: #888;
--chart-4: #555;
--chart-5: #333;
--chart-6: #1a1a1a;
--chart-track: rgba(128, 128, 128, 0.15);
```

- [ ] **Step 3: Add chart CSS (same as Red but check for dark/light adaptations)**

Same CSS as Red. The dark/light adaptation happens via the slide wrapper classes (`slide--light`, `slide--dark`, `grid-bg-*`). Donut/bar/funnel use `slide--light` wrapper. Progress rings use `slide--dark` wrapper. Adjust `fill: currentColor` and text colors to work with both dark and light backgrounds.

Additional overrides for Black preset:

```css
.chart-donut-slide .donut-center { fill: var(--black); }
.chart-progress-slide .progress-value { fill: var(--white); }
.chart-progress-slide .progress-label { color: var(--gray-mid); }
.funnel-label { fill: var(--white); }
.funnel-value { fill: rgba(255,255,255,0.7); }
```

- [ ] **Step 4: Add 4 slide sections using Black preset HTML pattern**

Use `slide--light grid-bg-light` for donut, bar, funnel. Use `slide--dark grid-bg-dark` for progress. Use `.slide-header` wrapper instead of absolute `.slide-title`. Follow Black preset HTML from the spec.

- [ ] **Step 5: Update slide counts and numbers**

- [ ] **Step 6: Open and verify**

```bash
open style-samples/02-black.html
```

- [ ] **Step 7: Commit**

```bash
git add style-samples/02-black.html
git commit -m "feat: add infographic slides to black preset sample"
```

---

### Task 7: Add infographic slides to 03-blue.html

**Files:**
- Modify: `style-samples/03-blue.html`

- [ ] **Step 1: Read file, add Blue chart variables**

```css
--chart-1: #003082;
--chart-2: #4a6fa5;
--chart-3: #BFBAAF;
--chart-4: #60605B;
--chart-5: #8a9bb5;
--chart-6: #c4d0e0;
--chart-track: rgba(128, 128, 128, 0.15);
```

- [ ] **Step 2: Add chart CSS + slide sections (same structure as Black)**

Blue uses same layout structure as Black (slide-header, slide--dark/light, grid-bg). Copy chart CSS and HTML sections from 02-black.html, only the `--chart-*` values differ.

- [ ] **Step 3: Update slide counts, verify in browser, commit**

```bash
open style-samples/03-blue.html
git add style-samples/03-blue.html
git commit -m "feat: add infographic slides to blue preset sample"
```

---

### Task 8: Add infographic slides to 04-black-midnight.html

**Files:**
- Modify: `style-samples/04-black-midnight.html`

- [ ] **Step 1: Read file, add Black Midnight chart variables**

```css
--chart-1: #BB162B;
--chart-2: #fff;
--chart-3: #9ca3af;
--chart-4: #4b5563;
--chart-5: #374151;
--chart-6: #1f2937;
--chart-track: rgba(128, 128, 128, 0.15);
```

- [ ] **Step 2: Add chart CSS + slide sections (same structure as Black)**

Same Black family layout pattern. Copy from 02-black.html, update chart palette.

- [ ] **Step 3: Update slide counts, verify in browser, commit**

```bash
open style-samples/04-black-midnight.html
git add style-samples/04-black-midnight.html
git commit -m "feat: add infographic slides to black midnight preset sample"
```

---

### Task 9: Add infographic slides to 01-bold-signal.html

**Files:**
- Modify: `style-samples/01-bold-signal.html`

- [ ] **Step 1: Read file to understand Bold Signal's unique layout**

Bold Signal uses a fundamentally different layout (colored card on dark gradient). Read the file to understand how charts should integrate — charts render on the dark background, not inside the colored card.

- [ ] **Step 2: Add Bold Signal chart variables**

```css
--chart-1: #FF5722;
--chart-2: #fff;
--chart-3: #888;
--chart-4: #555;
--chart-5: #333;
--chart-6: #1a1a1a;
--chart-track: rgba(255, 255, 255, 0.1);
```

Note: `--chart-track` uses white-based alpha since Bold Signal has dark backgrounds.

- [ ] **Step 3: Add chart CSS with Bold Signal adaptations**

Charts on dark background means: text and SVG fills should be light. Adapt donut-center, progress-value, bar-label, bar-value, funnel-label to use light colors. May need `.bold-signal` scope or direct variable references.

- [ ] **Step 4: Add 4 slide sections following Bold Signal's layout pattern**

Adapt the slide wrapper to match Bold Signal's structure (dark gradient bg, title bottom-left, section number bottom-right, navigation breadcrumbs).

- [ ] **Step 5: Update slide counts, verify in browser, commit**

```bash
open style-samples/01-bold-signal.html
git add style-samples/01-bold-signal.html
git commit -m "feat: add infographic slides to bold signal preset sample"
```

---

## Chunk 4: Final Verification

### Task 10: Cross-preset visual verification and cleanup

- [ ] **Step 1: Open all 5 samples side-by-side**

```bash
open style-samples/00-red.html style-samples/01-bold-signal.html style-samples/02-black.html style-samples/03-blue.html style-samples/04-black-midnight.html
```

Verify for each preset:
- All 4 chart types render correctly
- Animations trigger on scroll (segments sweep, bars grow, rings fill, funnel cascades)
- Colors match the preset's identity
- Responsive at different viewport widths (try browser resize)
- No overflow — all content fits within `100vh`

- [ ] **Step 2: Test reduced motion**

In browser DevTools, enable `prefers-reduced-motion: reduce`. Verify all charts show their final state with no animation.

- [ ] **Step 3: Update style-samples/index.html if needed**

If the gallery page references slide counts or type lists, update it to mention 18 types.

- [ ] **Step 4: Final commit if any fixes needed**

```bash
git add -A style-samples/
git commit -m "fix: visual adjustments to infographic slides across presets"
```
