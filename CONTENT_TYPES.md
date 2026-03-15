# Content Types Reference

Canonical layout types for HTML slide presentations. Use these names and CSS classes when generating slides.

---

## Layout Taxonomy

| # | Content Type | CSS Class | Dark/Light | When to Use |
|---|---|---|---|---|
| 1 | **Title** | `title-slide` | Dark | Opening slide — presentation title, subtitle, metadata |
| 2 | **Content** | `content-slide` | Light | Workhorse slide — heading + bullets, text, or key-value data |
| 3 | **Feature Grid** | `grid-slide` | Light | 3-6 features/capabilities in a numbered card grid |
| 4 | **Code** | `code-slide` | Dark | Syntax-highlighted code with tab bar |
| 5 | **Quote** | `quote-slide` | Dark | Large quotation with attribution — testimonial, inspiration |
| 6 | **Image** | `image-slide` | Light | Two-column: text + image/visual |
| 7 | **Section Divider** | `section-divider` | Dark | Transition between major sections — large number + title |
| 8 | **Agenda / TOC** | `agenda-slide` | Light | Numbered section list with active item highlighted |
| 9 | **Timeline / Roadmap** | `timeline-slide` | Light | Horizontal milestones connected by a line |
| 10 | **Comparison** | `comparison-slide` | Light | Two columns side-by-side — option A vs B |
| 11 | **Table / Matrix** | `table-slide` | Light | Rows and columns — pricing, features, SWOT |
| 12 | **Stat Highlight** | `stat-slide` | Dark | 1-3 large numbers with labels — KPIs, metrics |
| 13 | **Process / Flow** | `process-slide` | Light | Sequential steps connected by arrows |
| 14 | **Closing / Q&A** | `closing-slide` | Dark | Final slide — thank you, contact info, Q&A |
| 15 | **Donut Chart** | `chart-donut-slide` | Light | Parts-of-whole data — 2-6 segments as SVG donut ring |
| 16 | **Bar Chart** | `chart-bar-slide` | Light | Comparative quantities — 3-8 horizontal bars |
| 17 | **Progress Rings** | `chart-progress-slide` | Dark | Independent metrics — 2-4 animated circular gauges |
| 18 | **Funnel** | `funnel-slide` | Light | Pipeline/conversion — 3-5 narrowing SVG trapezoid stages |
| 19 | **Circular Process Flow** | `cycle-slide` | Light | Cyclical process — 3-6 steps around a circle with arrow arcs |
| 20 | **Converge/Diverge** | `converge-slide` | Light | Multiple inputs merging or one input splitting — SVG bezier paths |
| 21 | **Winding Road Timeline** | `roadmap-slide` | Dark | S-curve road path with milestone markers along the route |
| 22 | **Gantt Chart** | `gantt-slide` | Light | Overlapping phase bars on a time axis — CSS grid layout |
| 23 | **Split (Half & Half)** | `split-slide` | Light | 2 equal columns, each zone holds any content type |
| 24 | **Quadrant (2x2)** | `quadrant-slide` | Light | 4 boxes in a 2x2 grid, each holds any content type |
| 25 | **Third Split** | `third-slide` | Light | Asymmetric 1/3 + 2/3 split, narrow + wide zones |
| 26 | **Three Column** | `three-col-slide` | Light | 3 equal columns, each holds any content type |

---

## Content Type Details

### 1. Title (`title-slide`)

**Purpose:** First slide. Sets tone, communicates topic, presenter, date.

**Structure:**
- Title (h1) — large display font
- Subtitle — one-line description
- Optional: overline text, tag pills, date label

**When to use:** Always the first slide in any deck.

**Markdown cue:** `## [Title]` at the very start of the outline, or content tagged as cover/opening.

---

### 2. Content (`content-slide`)

**Purpose:** The default layout for presenting ideas with supporting detail.

**Structure:**
- **Red preset:** Slide title top-left + red bar, subtitle below, two-column grid (description left, bullet list right)
- **Black preset:** Slide header with top border, feature table (key/value rows) or bullet content

**When to use:** Any slide with a heading and 2-6 supporting points. The most common slide type.

**Markdown cue:** A heading followed by bullet points or paragraphs.

---

### 3. Feature Grid (`grid-slide`)

**Purpose:** Showcasing 3-6 features, capabilities, or values in a structured grid.

**Structure:**
- **Red preset:** 3-column bordered grid, each cell has number + title + description
- **Black preset:** 2-column property cards with title + description, optional full-width item

**When to use:** When listing capabilities, features, values, or pillars that are peers (no hierarchy).

**Markdown cue:** 3-6 items that each have a short title and 1-sentence description.

---

### 4. Code (`code-slide`)

**Purpose:** Displaying code snippets with syntax highlighting.

**Structure:**
- Slide header/title
- Code container with tab bar (file names)
- Syntax-highlighted `<pre>` block

**Syntax span classes:** `.kw` (keyword), `.str` (string), `.fn` (function/property), `.cm` (comment), `.num` (number)

**When to use:** Technical presentations, developer content, configuration examples.

**Markdown cue:** Fenced code blocks (``` ```language ```).

---

### 5. Quote (`quote-slide`)

**Purpose:** Highlighting an impactful statement, testimonial, or inspiration.

**Structure:**
- Large blockquote text (display font)
- Attribution line (name, role)
- Optional decorative element

**When to use:** Customer testimonials, expert quotes, motivational statements, key insights worth pausing on.

**Markdown cue:** `> blockquote` syntax, or text prefixed with attribution like `— Author Name`.

---

### 6. Image (`image-slide`)

**Purpose:** Presenting a visual with supporting text.

**Structure:**
- Two-column: text (title + description) on one side, image on the other
- Image placeholder with aspect ratio 4:3

**When to use:** Product screenshots, diagrams, photos, visual evidence.

**Markdown cue:** `![alt](image.png)` with surrounding descriptive text.

---

### 7. Section Divider (`section-divider`)

**Purpose:** Transition slide between major sections. Gives audience a mental reset.

**Structure:**
- Large faded section number (background element)
- Section title (large, display font)
- Optional subtitle
- Vertically centered (exception to top-aligned rule)

**When to use:** Before each major section in a 10+ slide deck. Use between 2-5 times per deck.

**Markdown cue:** `# Section: Name` prefix (e.g., `# Section: Market Analysis`), or `# Part N: Name`. Do NOT treat bare `---` or plain `#` headings as section dividers — `---` is a standard slide separator.

---

### 8. Agenda / TOC (`agenda-slide`)

**Purpose:** Outlines the deck structure. Can be reused with different active items to show progress.

**Structure:**
- 4-6 numbered section items
- Each item: number + section name + brief description
- Active/current section highlighted (dark bg or accent bg)

**When to use:** After the title slide. Optionally repeated before each section with the current section highlighted.

**Markdown cue:** Numbered list of section titles, or content explicitly labeled "agenda" or "outline."

---

### 9. Timeline / Roadmap (`timeline-slide`)

**Purpose:** Showing chronological progression — milestones, phases, history.

**Structure:**
- Horizontal track with connecting line
- 3-5 milestone points: date/period + title + description
- Active milestone highlighted (filled marker)

**When to use:** Project plans, product roadmaps, historical overviews, implementation phases.

**Markdown cue:** Dated items in chronological order (e.g., "Q1 2026: Research phase").

---

### 10. Comparison (`comparison-slide`)

**Purpose:** Side-by-side evaluation of two options, approaches, or states.

**Structure:**
- Two equal columns with distinct headers
- Left column: primary option (accent-styled header)
- Right column: alternative (bordered header)
- 3-5 items per column

**When to use:** Before/after, pros/cons, build vs buy, old vs new, option A vs B.

**Markdown cue:** Two parallel lists or content structured as "X vs Y."

---

### 11. Table / Matrix (`table-slide`)

**Purpose:** Structured data in rows and columns.

**Structure:**
- Full HTML `<table>` with `<thead>` and `<tbody>`
- Header row: light grey background, display font
- Leading column (first `<td>`): light grey background, bold
- 4-6 data rows recommended

**When to use:** Feature comparison matrices, pricing tiers, SWOT analysis, capability breakdowns.

**Markdown cue:** Markdown table syntax (`| Col1 | Col2 | Col3 |`).

---

### 12. Stat Highlight (`stat-slide`)

**Purpose:** Dramatic display of 1-3 key metrics or KPIs.

**Structure:**
- 1-3 large numbers (display font, accent color or white)
- Label below each number (uppercase, muted)
- Optional context line at bottom
- Dark background for dramatic contrast

**When to use:** Opening a section with impact data, quarterly results, achievement highlights, before/after metrics.

**Markdown cue:** Large numbers with labels (e.g., "98% — Customer Satisfaction"). Content with 1-3 standalone metrics.

---

### 13. Process / Flow (`process-slide`)

**Purpose:** Illustrating a sequential workflow or methodology.

**Structure:**
- 3-5 horizontal steps connected by arrows
- Each step: number + title + description
- Active step highlighted (inverted colors)
- Responsive: collapses to vertical on mobile

**When to use:** Workflows, methodologies, pipelines, onboarding flows, deployment processes.

**Markdown cue:** Numbered steps describing a sequential process (e.g., "Step 1: Define → Step 2: Design → ...").

---

### 14. Closing / Q&A (`closing-slide`)

**Purpose:** Final slide. Stays on screen during Q&A and as audience leaves.

**Structure:**
- Red horizontal bar (accent)
- Large "Thank You" or "Questions?" text (display font)
- Subtitle (muted, one line)
- Contact info: 2-3 items (email, website, social)
- Dark background for dramatic close

**When to use:** Always the last slide in any deck. Can combine thank-you with Q&A prompt and contact info.

**Markdown cue:** Content containing "Thank You", "Questions?", "Q&A", or contact information at the end of the outline.

---

### 15. Donut Chart (`chart-donut-slide`)

**Purpose:** Visualizing parts of a whole — percentages that sum to ~100%.

**Structure:**
- Two-column layout: SVG donut (left) + HTML legend (right)
- SVG `viewBox="0 0 200 200"`, circles with `stroke-dasharray`
- Legend: `.donut-legend` with `.donut-legend-item` rows (swatch + label + value)
- Optional center label via SVG `<text>`

**When to use:** Market share, budget allocation, survey results, any data showing composition.

**Markdown cue:** `## Chart: Title` followed by `- Label: N%` items (must sum to ~100%).

---

### 16. Bar Chart (`chart-bar-slide`)

**Purpose:** Comparing quantities across categories with horizontal bars.

**Structure:**
- Vertical stack of `.bar-row` elements (3-8 bars)
- Each row: `.bar-label` (left) + `.bar-track` > `.bar-fill` (middle) + `.bar-value` (right)
- Bar widths normalized to percentage of max value via `--bar-width` CSS variable
- Horizontal orientation for label readability

**When to use:** Revenue by region, feature usage counts, survey responses, any categorical comparison.

**Markdown cue:** `## Bar Chart: Title` followed by `- Label: N` items (raw numbers, not percentages).

---

### 17. Progress Rings (`chart-progress-slide`)

**Purpose:** Showing progress toward independent goals or targets.

**Structure:**
- Flex row of 2-4 `.progress-ring-item` elements
- Each ring: background circle (`.progress-track`) + animated foreground (`.progress-fill`)
- Center text: percentage value via SVG `<text>`
- Label below each ring: `.progress-label`, uppercase muted
- Dark background for dramatic contrast

**When to use:** KPI dashboards, quarterly goal tracking, completion metrics, skill assessments.

**Markdown cue:** `## Progress: Title` followed by `- Label: N%` items (independent metrics, each 0-100%).

---

### 18. Funnel (`funnel-slide`)

**Purpose:** Visualizing a narrowing pipeline or conversion process.

**Structure:**
- Single SVG with `<polygon>` trapezoids, each narrower than above
- Stage labels + values via SVG `<text>` centered in each trapezoid
- Colors from chart palette (`--chart-1` through `--chart-5`)
- Stages cascade in with staggered animation

**When to use:** Sales pipelines, conversion funnels, recruitment processes, any narrowing flow.

**Markdown cue:** `## Funnel: Title` followed by `1. Label — Value` numbered items.

---

### 19. Circular Process Flow (`cycle-slide`)

**Purpose:** Visualizing cyclical or repeating processes.

**Structure:**
- SVG circle with 3-6 step nodes positioned around it, connected by arrow arcs
- Each node is a colored circle with a label
- Arrowhead markers show flow direction

**When to use:** Product development cycles, iterative processes, continuous improvement loops, seasonal patterns.

**Markdown cue:** `## Cycle: Title` followed by `- Step` bullet items.

---

### 20. Converge/Diverge (`converge-slide`)

**Purpose:** Showing multiple inputs merging into one output (converge) or one input splitting into many (diverge).

**Structure:**
- SVG with input nodes on one side, output node(s) on the other, connected by curved bezier paths with arrowheads
- Colors from chart palette

**When to use:** System integration, data pipelines, resource allocation, team structures, platform convergence.

**Markdown cue:** `## Converge: Title` followed by `- Input` items and `→ Output` line. `## Diverge: Title` for the reverse.

---

### 21. Winding Road Timeline (`roadmap-slide`)

**Purpose:** Showing a journey or roadmap with milestones along a visual path.

**Structure:**
- SVG S-curve road path (thick stroke) with colored milestone markers positioned along it
- Labels alternate above/below the road
- Dark background for dramatic effect

**When to use:** Product roadmaps, strategic plans, journey visualizations, multi-phase projects where the path metaphor adds meaning.

**Markdown cue:** `## Roadmap: Title` followed by `- Q1 2026: Milestone` dated items.

---

### 22. Gantt Chart (`gantt-slide`)

**Purpose:** Showing overlapping project phases on a time axis.

**Structure:**
- CSS grid with phase labels on the left and colored horizontal bars spanning their date ranges
- Time axis at the bottom
- Bars grow from left with staggered animation

**When to use:** Project schedules, sprint planning, resource allocation timelines, release planning.

**Markdown cue:** `## Gantt: Title` followed by `- Phase: Start — End` items.

---

### 23. Split (`split-slide`)

**Purpose:** Two equal columns where each zone independently holds any content type (bullets, table, chart, stats).

**Structure:**
- `.composite-grid` with two `.zone` children (`.zone-left`, `.zone-right`)
- Each zone has optional `.zone-title` heading
- Zone content parsed independently — can be bullets, table, mini-chart, stats, or plain text

**When to use:** When a single slide needs to present two distinct but related content blocks side by side — e.g., key highlights + regional breakdown, text + table, bullets + chart.

**Markdown cue:** `## Split: Title` followed by `### Left` and `### Right` subsections.

---

### 24. Quadrant (`quadrant-slide`)

**Purpose:** Four boxes in a 2x2 grid, each holding any content type — ideal for dashboards.

**Structure:**
- `.composite-grid` with four `.zone` children (`.zone-top-left`, `.zone-top-right`, `.zone-bottom-left`, `.zone-bottom-right`)
- Each zone has optional `.zone-title` heading
- Zone content parsed independently

**When to use:** Dashboard-style slides combining 4 different metrics, charts, or content blocks. Each quadrant stays compact.

**Markdown cue:** `## Quadrant: Title` followed by `### Top-Left`, `### Top-Right`, `### Bottom-Left`, `### Bottom-Right` subsections.

---

### 25. Third Split (`third-slide`)

**Purpose:** Asymmetric 1/3 + 2/3 split — narrow zone for a single stat or ring, wide zone for a list, chart, or table.

**Structure:**
- `.composite-grid` with two `.zone` children (`.zone-narrow`, `.zone-wide`)
- Narrow zone best for single metric (progress ring, stat number)
- Wide zone for richer content (bar chart, table, bullet list)

**When to use:** When one piece of content is a focal metric and the other provides supporting detail — e.g., a progress ring + bar chart breakdown.

**Markdown cue:** `## Third: Title` followed by `### Narrow` and `### Wide` subsections.

---

### 26. Three Column (`three-col-slide`)

**Purpose:** Three equal columns, each holding any content type.

**Structure:**
- `.composite-grid` with three `.zone` children (`.zone-col-1`, `.zone-col-2`, `.zone-col-3`)
- Each zone has optional `.zone-title` heading
- Zone content parsed independently

**When to use:** Comparing three departments, categories, or options side by side — e.g., team structure across Engineering / Design / Product.

**Markdown cue:** `## Three Columns: Title` followed by `### Col 1`, `### Col 2`, `### Col 3` subsections.

---

## Choosing the Right Layout

```
Is it the opening slide?
  → Title

Is it a section break?
  → Section Divider

Is it an overview of the deck structure?
  → Agenda / TOC

Does it show a sequential process?
  → Process / Flow (if conceptual steps)
  → Timeline (if date-based milestones)

Does it compare things?
  → Comparison (exactly 2 options, qualitative pros/cons)
  → Table (3+ options, or structured multi-column data)

Does it present large metrics?
  → Stat Highlight (1-3 numbers, dramatic)

Does it show data as a chart or visualization?
  → Parts of a whole (% summing to 100%)? → Donut Chart
  → Quantities compared across categories? → Bar Chart
  → Progress toward independent goals? → Progress Rings
  → Narrowing pipeline or conversion? → Funnel

Does it show a cyclical/repeating process?
  → Circular Process Flow

Does it show multiple inputs merging or one input splitting?
  → Converge/Diverge

Does it show a journey/roadmap with milestones along a path?
  → Winding Road Timeline (visual S-curve path)
  → Timeline (type 9 — horizontal linear milestones)

Does it show overlapping phases on a time axis?
  → Gantt Chart

Does it need to show multiple different content types on one slide?
  → 2 equal sections? → Split
  → 4 sections (dashboard)? → Quadrant
  → 1 small + 1 large section? → Third Split
  → 3 equal sections? → Three Column

Does it show code?
  → Code

Does it feature a quote or testimonial?
  → Quote

Does it feature an image or visual?
  → Image

Does it list features or capabilities?
  → Feature Grid (3-6 peer items)
  → Content (if hierarchical with supporting detail)

Is it the last slide (thank you / Q&A / contact)?
  → Closing

Default fallback:
  → Content
```

---

## Deck Structure Best Practices

A well-structured 15-slide deck typically follows this pattern:

```
1.  Title
2.  Agenda
3.  Section Divider — "Context"
4.  Content or Stat Highlight
5.  Content or Table
6.  Section Divider — "Solution"
7.  Content or Feature Grid
8.  Process / Flow
9.  Comparison
10. Section Divider — "Results"
11. Stat Highlight
12. Timeline / Roadmap
13. Quote or Image
14. Content (next steps / CTA)
15. Closing / Q&A
```

**Rules of thumb:**
- Use **2-4 section dividers** per deck to create rhythm
- Alternate between **data-heavy** (table, stats, grid) and **narrative** (content, quote, image) slides
- Never use the same layout type more than 3 times in a row
- Every section should open with a section divider or agenda slide
- Always end with a **Closing / Q&A** slide

---

## CSS Class Quick Reference

### Red Preset Classes

| Element | Class | Notes |
|---|---|---|
| Slide title | `.slide-title` | Absolute top-left, single line, `::after` red bar |
| Slide subtitle | `.slide-subtitle` | Absolute below title, Nunito 400, muted |
| Section label | `.section-title` | Absolute top-right, light grey |
| Footer | `.bottom-rule` | Bottom bar with label + slide number |
| Slide number | `.slide-num` | Inside `.bottom-rule`, accent color |
| Grid background | `.swiss-grid` | 6-column DOM grid lines |
| Bullet marker | `.bullet-marker` | Variants: `.circle`, `.filled` |
| Table | `.swiss-table` | 2px outer border, grey header/lead column |
| Section divider number | `.section-number` | Huge faded accent number |
| Section divider title | `.section-divider-title` | Large display font |
| Agenda item | `.agenda-item` | Row with `.agenda-num` + `.agenda-text` |
| Timeline marker | `.timeline-marker` | Square marker, `.active` fills red |
| Comparison column | `.comparison-col` | `.col-left` (red bar) / `.col-right` (black border) |
| Stat number | `.stat-number` | Large accent-colored number |
| Stat label | `.stat-label` | Uppercase muted label below number |
| Process step | `.process-step` | Bordered box with number/title/desc |
| Process arrow | `.process-arrow` | CSS triangle between steps |
| Closing heading | `.closing-heading` | Large "Thank You" text |
| Closing contact | `.closing-contact` | Flex row of contact items |
| Donut container | `.donut-chart` | Two-column flex: SVG + legend |
| Donut segment | `.donut-segment` | SVG `<circle>`, `stroke-dasharray` animation |
| Donut legend | `.donut-legend` | Vertical list of legend items |
| Donut swatch | `.donut-swatch` | Small colored square matching segment |
| Bar container | `.bar-chart` | Vertical stack of bar rows |
| Bar row | `.bar-row` | Flex row: label + bar + value |
| Bar fill | `.bar-fill` | Animated width via `--bar-width` |
| Progress rings | `.progress-rings` | Flex row of ring items |
| Progress fill | `.progress-fill` | SVG circle, animated `stroke-dashoffset` |
| Progress label | `.progress-label` | Uppercase muted label below ring |
| Funnel container | `.funnel-chart` | Wraps the SVG funnel |
| Funnel stage | `.funnel-stage` | SVG `<g>` with polygon + text |
| Funnel shape | `.funnel-shape` | SVG `<polygon>`, colored via `--chart-N` |
| Cycle container | `.cycle-chart` | Centers SVG |
| Cycle step | `.cycle-step` | SVG `<g>` with node + label |
| Cycle arrow | `.cycle-arrow` | SVG `<path>` arc with arrowhead |
| Converge container | `.converge-chart` | Centers SVG |
| Converge path | `.converge-path` | SVG `<path>` bezier with arrowhead |
| Converge node | `.converge-node` | SVG `<circle>` |
| Roadmap container | `.roadmap-chart` | Centers SVG |
| Roadmap road | `.roadmap-road` | Thick SVG `<path>` S-curve |
| Roadmap milestone | `.roadmap-milestone` | SVG `<g>` with marker + labels |
| Roadmap marker | `.roadmap-marker` | SVG `<circle>`, `.active` = accent |
| Gantt container | `.gantt-chart` | CSS grid layout |
| Gantt bar | `.gantt-bar` | Colored bar, `grid-column` positioning |
| Gantt axis | `.gantt-axis` | Bottom row time labels |
| Composite grid | `.composite-grid` | Shared grid container for composite layouts |
| Content zone | `.zone` | Individual content cell within composite grid |
| Zone title | `.zone-title` | Optional `<h3>` heading within zone |

### Black Preset Classes (also used by Blue, Black Midnight)

| Element | Class | Notes |
|---|---|---|
| Slide header | `.slide-header` | 3px top border + h2 + `.slide-subtitle` |
| Section label | `.section-title` | Absolute top-right, adapts to dark/light |
| Footer | `.bottom-rule` | Bottom bar, adapts to dark/light |
| Slide number | `.slide-num-label` | Inside `.bottom-rule` |
| Grid background | `.grid-bg-dark` / `.grid-bg-light` | CSS background-image pattern |
| Slide variant | `.slide--dark` / `.slide--light` | Controls colors per slide |
| Feature table | `.ftable` / `.frow` | Key/value data rows |
| Property grid | `.prop-grid` / `.prop-item` | 2-column feature cards |
| Data table | `.data-table` | Header bg `rgba(0,0,0,0.06)`, lead col `rgba(0,0,0,0.04)` |
| Callout | `.callout` | Left-bordered emphasis block |
| Divider number | `.divider-number` | Large faded number on section divider |
| Divider title | `.divider-title` | Section title text |
| Agenda item | `.agenda-item` | Row with `.agenda-num` + `.agenda-label` + `.agenda-desc` |
| Timeline dot | `.timeline-dot` | Circle marker, `.active` fills dark |
| Timeline track | `.timeline-track` | Horizontal connected milestones |
| Comparison grid | `.comparison-grid` | Two-column layout |
| Comparison header | `.comparison-col-header` | Column header (first dark bg, second bordered) |
| Stat number | `.stat-number` | Large number (white or accent) |
| Stat label | `.stat-label` | Uppercase muted label |
| Process track | `.process-track` | Horizontal steps container |
| Process step | `.process-step` | Step box with `.process-step-num`/`-title`/`-desc` |
| Closing title | `.closing-title` | Large "Thank You" text |
| Closing contact | `.closing-contact` | Flex row of bordered contact items |
| Donut container | `.donut-chart` | Two-column flex: SVG + legend |
| Donut segment | `.donut-segment` | SVG `<circle>`, `stroke-dasharray` animation |
| Donut legend | `.donut-legend` | Vertical list of legend items |
| Donut swatch | `.donut-swatch` | Small colored square matching segment |
| Bar container | `.bar-chart` | Vertical stack of bar rows |
| Bar row | `.bar-row` | Flex row: label + bar + value |
| Bar fill | `.bar-fill` | Animated width via `--bar-width` |
| Progress rings | `.progress-rings` | Flex row of ring items |
| Progress fill | `.progress-fill` | SVG circle, animated `stroke-dashoffset` |
| Progress label | `.progress-label` | Uppercase muted label below ring |
| Funnel container | `.funnel-chart` | Wraps the SVG funnel |
| Funnel stage | `.funnel-stage` | SVG `<g>` with polygon + text |
| Funnel shape | `.funnel-shape` | SVG `<polygon>`, colored via `--chart-N` |
| Cycle container | `.cycle-chart` | Centers SVG |
| Cycle step | `.cycle-step` | SVG `<g>` with node + label |
| Cycle arrow | `.cycle-arrow` | SVG `<path>` arc with arrowhead |
| Converge container | `.converge-chart` | Centers SVG |
| Converge path | `.converge-path` | SVG `<path>` bezier with arrowhead |
| Converge node | `.converge-node` | SVG `<circle>` |
| Roadmap container | `.roadmap-chart` | Centers SVG |
| Roadmap road | `.roadmap-road` | Thick SVG `<path>` S-curve |
| Roadmap milestone | `.roadmap-milestone` | SVG `<g>` with marker + labels |
| Roadmap marker | `.roadmap-marker` | SVG `<circle>`, `.active` = accent |
| Gantt container | `.gantt-chart` | CSS grid layout |
| Gantt bar | `.gantt-bar` | Colored bar, `grid-column` positioning |
| Gantt axis | `.gantt-axis` | Bottom row time labels |
| Composite grid | `.composite-grid` | Shared grid container for composite layouts |
| Content zone | `.zone` | Individual content cell within composite grid |
| Zone title | `.zone-title` | Optional `<h3>` heading within zone |
