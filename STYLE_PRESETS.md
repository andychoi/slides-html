# Style Presets Reference

Curated visual styles for Frontend Slides. Each preset is inspired by real design references — no generic "AI slop" aesthetics. **Abstract shapes only — no illustrations.**

**Viewport CSS:** For mandatory base styles, see [reference/viewport-base.css](reference/viewport-base.css). Include in every presentation.

---

## Default

**Vibe:** Clean, structured, top-aligned — based on Swiss Modern

**Layout:** Slide title (h2) positioned absolute top-left via `.slide-title`, section title top-right via `.section-title` in light grey. Body top-aligned (not vertically centered). Title slide has slim barline between title and subtitle rows with equal left/right margin.

**Typography:**
- Display: `Archivo` (800)
- Body: `Nunito` (400)

**Colors:**
```css
:root {
    --bg-primary: #ffffff;
    --accent: #ff3300;
    --text-primary: #000000;
    --text-secondary: rgba(0, 0, 0, 0.5);
    --grid-color: rgba(0, 0, 0, 0.06);
    --border-color: rgba(0, 0, 0, 0.12);
}
```

**Signature Elements:**
- Top-aligned content (not vertically centered)
- Slide title absolute top-left (`.slide-title`), section title top-right (`.section-title`) in light grey
- Slim barline between title and subtitle with equal left/right margin
- Visible 6-column grid background
- Red accent dots and geometric shapes
- Same visual language as Swiss Modern, structured layout

**Key CSS patterns:**
```css
/* Slide title — absolute top-left on content slides */
.slide-title {
    position: absolute;
    top: var(--slide-padding);
    left: var(--slide-padding);
    padding-top: clamp(1rem, 2vh, 1.5rem);
}

/* Section title — top-right breadcrumb */
.section-title {
    position: absolute;
    top: var(--slide-padding);
    right: var(--slide-padding);
    color: rgba(0, 0, 0, 0.3);
}

/* Content area gets extra top padding to clear slide-title */
.content-slide .slide-content { padding-top: clamp(5rem, 12vh, 9rem); }
```

---

## Bold Signal

**Vibe:** Confident, bold, modern, high-impact

**Layout:** Colored card on dark gradient. Number bottom-right, navigation top-right, title bottom-left.

**Typography:**
- Display: `Archivo Black` (900)
- Body: `Space Grotesk` (400/500)

**Colors:**
```css
:root {
    --bg-primary: #1a1a1a;
    --bg-gradient: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 50%, #1a1a1a 100%);
    --card-bg: #FF5722;
    --text-primary: #ffffff;
    --text-on-card: #1a1a1a;
}
```

**Signature Elements:**
- Bold colored card as focal point (orange, coral, or vibrant accent)
- Large section numbers (01, 02, etc.)
- Navigation breadcrumbs with active/inactive opacity states
- Grid-based layout for precise alignment

---

## Black

**Vibe:** Dark-first, data-dense, professional — alternating light/dark slides

**Layout:** Slide header with 3px top border rule. Section title top-right (`.section-title`). Footer bar at bottom with presenter label and slide number. Alternates between `slide--dark` and `slide--light` variants.

**Typography:**
- Display: `Archivo Black` (900)
- Body: `Nunito` (300/400/600/700)

**Colors:**
```css
:root {
    --black: #0a0a0a;
    --white: #f8f8f8;
    --gray-light: #ececec;
    --gray-mid: #c0c0c0;
    --gray-dark: #4a4a4a;
}
```

**Signature Elements:**
- Alternating dark/light slides for rhythm and contrast
- CSS grid background pattern (64px squares, 4% opacity lines)
- Slide header with 3px top border rule (`.slide-header`)
- Feature tables (`.ftable` / `.frow`) for key/value data
- Property grids (`.prop-grid` / `.prop-item`) for 2-column feature cards
- Step lists (`.step-list` / `.step-item`) with large faded numbers
- Callout blocks with left border (`.callout`)
- Decorative vertical/horizontal hairlines on title slide
- Footer bar with border-top, not floating bottom-rule
- Title slide has overline text + tag pills

**Key CSS patterns:**
```css
/* Alternating slide backgrounds */
.slide--dark { background: var(--black); color: var(--white); }
.slide--light { background: var(--white); color: var(--black); }

/* Grid background pattern */
.grid-bg-dark {
    background-image:
        linear-gradient(rgba(255,255,255,0.04) 1px, transparent 1px),
        linear-gradient(90deg, rgba(255,255,255,0.04) 1px, transparent 1px);
    background-size: 64px 64px;
}

/* Slide header with top border */
.slide-header { border-top: 3px solid currentColor; padding-top: 10px; }
```

---

## Font Pairing Quick Reference

| Preset | Display Font | Body Font | Source |
|--------|--------------|-----------|--------|
| Default | Archivo | Nunito | Google |
| Black | Archivo Black | Nunito | Google |
| Bold Signal | Archivo Black | Space Grotesk | Google |

---

## DO NOT USE (Generic AI Patterns)

**Fonts:** Inter, Roboto, Arial, system fonts as display

**Colors:** `#6366f1` (generic indigo), purple gradients on white

**Layouts:** Everything centered, generic hero sections, identical card grids

**Decorations:** Realistic illustrations, gratuitous glassmorphism, drop shadows without purpose

---

## CSS Gotchas

### Negating CSS Functions

**WRONG — silently ignored by browsers (no console error):**
```css
right: -clamp(28px, 3.5vw, 44px);   /* Browser ignores this */
margin-left: -min(10vw, 100px);      /* Browser ignores this */
```

**CORRECT — wrap in `calc()`:**
```css
right: calc(-1 * clamp(28px, 3.5vw, 44px));  /* Works */
margin-left: calc(-1 * min(10vw, 100px));     /* Works */
```

CSS does not allow a leading `-` before function names. The browser silently discards the entire declaration — no error, the element just appears in the wrong position. **Always use `calc(-1 * ...)` to negate CSS function values.**
