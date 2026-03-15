# Style Presets Reference

Curated visual styles for Frontend Slides. Each preset is inspired by real design references — no generic "AI slop" aesthetics. **Abstract shapes only — no illustrations.**

**Viewport CSS:** For mandatory base styles, see [viewport-base.css](viewport-base.css). Include in every presentation.

---

## Default

**Vibe:** Clean, structured, top-aligned — based on Swiss Modern

**Layout:** Content title top-left, body top-aligned (not vertically centered). Title slide has slim barline between title and subtitle rows with equal left/right margin.

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
- Slim barline between title and subtitle with equal left/right margin
- Visible 6-column grid background
- Red accent dots and geometric shapes
- Same visual language as Swiss Modern, structured layout

**Key CSS differences from Swiss Modern:**
```css
/* Content slides: top-aligned instead of centered */
.content-slide .slide-content { align-items: start; }
.grid-slide .slide-content { justify-content: flex-start; }
.code-slide .slide-content { justify-content: flex-start; }

/* Title barline between title and subtitle */
.title-barline {
    height: 2px;
    background: var(--border-color);
    margin-left: clamp(0.5rem, 1.5vw, 1.5rem);
    margin-right: clamp(0.5rem, 1.5vw, 1.5rem);
}
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

## Swiss Modern

**Vibe:** Clean, precise, Bauhaus-inspired

**Typography:** `Archivo` (800) + `Nunito` (400)

**Colors:** Pure white, pure black, red accent (#ff3300)

**Signature:** Visible grid, asymmetric layouts, geometric shapes, vertically centered content

---

## Font Pairing Quick Reference

| Preset | Display Font | Body Font | Source |
|--------|--------------|-----------|--------|
| Default | Archivo | Nunito | Google |
| Bold Signal | Archivo Black | Space Grotesk | Google |
| Swiss Modern | Archivo | Nunito | Google |

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
