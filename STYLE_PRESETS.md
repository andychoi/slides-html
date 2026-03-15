# Style Presets Reference

Curated visual styles for HTML slide presentations. Each preset is inspired by real design references — no generic "AI slop" aesthetics. **Abstract shapes only — no illustrations.**

**Viewport CSS:** For mandatory base styles, see [reference/viewport-base.css](reference/viewport-base.css). Include in every presentation.

---

## Red

**Vibe:** Clean, structured, top-aligned with bold red accent

**Layout:** Slide title (h2) positioned absolute top-left via `.slide-title`, section title top-right via `.section-title` in light grey. Body top-aligned (not vertically centered). Title slide has slim barline between title and subtitle rows.

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
- Slide title absolute top-left (`.slide-title`) with red bar `::after`
- Section title top-right (`.section-title`) in light grey
- Visible 6-column grid background (`.swiss-grid`)
- Red accent geometric shapes and markers

**Key CSS patterns:**
```css
.slide-title {
    position: absolute;
    top: var(--slide-padding);
    left: var(--slide-padding);
}
.slide-title::after {
    content: ''; display: block;
    width: 100%; height: 4px;
    background: var(--accent);
}
.content-slide .slide-content { padding-top: clamp(5rem, 12vh, 9rem); }
```

---

## Black

**Vibe:** Dark-first, data-dense, professional — alternating light/dark slides

**Layout:** Slide header with 3px top border rule. Section title top-right. Footer bar at bottom. Alternates between `slide--dark` and `slide--light` variants.

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
- Callout blocks with left border (`.callout`)
- Title slide has overline text + tag pills

**Key CSS patterns:**
```css
.slide--dark { background: var(--black); color: var(--white); }
.slide--light { background: var(--white); color: var(--black); }
.grid-bg-dark {
    background-image:
        linear-gradient(rgba(255,255,255,0.04) 1px, transparent 1px),
        linear-gradient(90deg, rgba(255,255,255,0.04) 1px, transparent 1px);
    background-size: 64px 64px;
}
.slide-header { border-top: 3px solid currentColor; padding-top: 10px; }
```

---

## Blue

**Vibe:** Corporate, premium, warm silver tones with deep navy blue

**Layout:** Same structure as Black preset — alternating `slide--dark`/`slide--light`, slide headers with top border, footer bar. Navy-tinted dark backgrounds.

**Typography:**
- Display: `Archivo Black` (900)
- Body: `Nunito` (300/400/600/700)

**Colors:**
```css
:root {
    --navy: #003082;
    --black: #001845;
    --white: #f8f8f8;
    --gray-light: #e8e6e2;
    --gray-mid: #BFBAAF;
    --gray-dark: #60605B;
}
```

**Signature Elements:**
- Deep navy dark backgrounds (`#001845`) — visibly blue, not black
- Strong Navy Blue (`#003082`) for headers, active states, progress bar
- Warm silver/grey tones (`#BFBAAF` Tide, `#60605B` Zombie Gray) for a premium feel
- Blue-tinted grid lines, borders, and decorative elements throughout
- Code containers have navy-tinted backgrounds with blue borders
- No bright accent — the navy itself is the identity color

---

## Black Midnight

**Vibe:** Deep midnight blue-black with strategic red accent

**Layout:** Same structure as Black preset — alternating slides, slide headers, footer bar. Midnight-tinted dark backgrounds.

**Typography:**
- Display: `Archivo Black` (900)
- Body: `Nunito` (300/400/600/700)

**Colors:**
```css
:root {
    --black: #05141F;
    --white: #FFFFFF;
    --gray-light: #f0f0f0;
    --gray-mid: #9ca3af;
    --gray-dark: #4b5563;
    --accent: #BB162B;
}
```

**Signature Elements:**
- Midnight blue-black backgrounds (`#05141F`) with slight blue undertone
- Red accent (`#BB162B`) used **strategically** — active states, stat numbers, progress bar
- Red NOT used for general UI chrome (headers, borders stay white/grey)
- Cool grey palette for a sharp, modern feel

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

## Font Pairing Quick Reference

| Preset | Display Font | Body Font | Source |
|--------|--------------|-----------|--------|
| Red | Archivo | Nunito | Google |
| Black | Archivo Black | Nunito | Google |
| Blue | Archivo Black | Nunito | Google |
| Black Midnight | Archivo Black | Nunito | Google |
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
