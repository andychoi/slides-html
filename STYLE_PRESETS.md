# Style Presets Reference

Curated visual styles for HTML slide presentations. Each preset is inspired by real design references — no generic "AI slop" aesthetics. **Abstract shapes only — no illustrations.**

**Viewport CSS:** For mandatory base styles, see [reference/viewport-base.css](reference/viewport-base.css). Include in every presentation.

## Quick View: Sample Presentations

Each preset has a reference HTML file showing all 26 layout types in action:

| Preset | Sample | File |
|--------|--------|------|
| White | [View →](style-samples/01-white.html) | `style-samples/01-white.html` |
| Black | [View →](style-samples/02-black.html) | `style-samples/02-black.html` |
| Blue | [View →](style-samples/03-blue.html) | `style-samples/03-blue.html` |
| Black Midnight | [View →](style-samples/04-black-midnight.html) | `style-samples/04-black-midnight.html` |

---

## White

**Vibe:** Clean, bright, minimal — light-first with dark text

**Layout:** Slide header with 3px top border rule. Section title top-right. Footer bar at bottom. ALL slides use white backgrounds consistently — no alternation (unlike Black preset).

**Typography:**
- Display: `Archivo Black` (900)
- Body: `Nunito` (300/400/600/700)

**Colors:**
```css
:root {
    --black: #f8f8f8;        /* Light backgrounds */
    --white: #0a0a0a;        /* Dark text */
    --gray-light: #1a1a1a;   /* Dark grays */
    --gray-mid: #404040;
    --gray-dark: #b5b5b5;    /* Light grays */
    /* Chart palette — same as Black */
    --chart-1: #3b82f6;
    --chart-2: #ef4444;
    --chart-3: #22c55e;
    --chart-4: #f59e0b;
    --chart-5: #8b5cf6;
    --chart-6: #06b6d4;
    --chart-track: rgba(128, 128, 128, 0.15);
}
```

**Additional variables (extend viewport-base.css):**
```css
:root {
    --subtitle-size: clamp(0.85rem, 1.8vw, 1.3rem);
    --label-size: clamp(0.6rem, 1vw, 0.8rem);
    --code-size: clamp(0.65rem, 1.2vw, 0.95rem);
    --dur: 0.55s;
}
```

**Key CSS patterns:**
All slides use inverted color semantics with consistent white backgrounds. `--black: #f8f8f8` (light/white) and `--white: #0a0a0a` (dark text). All slides use `.slide--dark` class to display white background with dark text.

```css
.grid-bg-dark {
    background-color: var(--black);   /* #f8f8f8 — white */
    background-image:
        linear-gradient(rgba(0,0,0,0.04) 1px, transparent 1px),
        linear-gradient(90deg, rgba(0,0,0,0.04) 1px, transparent 1px);
    background-size: clamp(40px, 5vw, 64px) clamp(40px, 5vw, 64px);
}
.slide--dark { background: var(--black); color: var(--white); }   /* white bg, dark text */
.slide--light { background: var(--white); color: var(--black); } /* reserved for future use */

.section-title {
    position: absolute;
    top: clamp(0.4rem, 1.2vw, 0.75rem);
    right: var(--slide-padding);
    font-size: var(--label-size);
    letter-spacing: 0.2em; text-transform: uppercase;
    color: rgba(0, 0, 0, 0.3);  /* dark text on white */
    opacity: 0; transition: opacity 0.3s ease 0.15s;
}
.slide.visible .section-title { opacity: 1; }

.bottom-rule {
    position: absolute; bottom: 0; left: 0; right: 0;
    height: clamp(32px, 5vh, 40px);
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 var(--slide-padding);
    border-top: 1px solid rgba(0,0,0,0.14);
    background: rgba(0,0,0,0.08);  /* subtle dark on white */
    opacity: 0;
    transition: opacity 0.3s ease 0.25s;
}
.bottom-rule span {
    font-family: var(--font-body);
    font-size: var(--label-size);
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: rgba(0, 0, 0, 0.5);
}

/* Agenda and timeline items — light borders, subtle active state */
.agenda-item {
    border: 1px solid rgba(0, 0, 0, 0.1);   /* light gray border */
}
.agenda-item.active {
    background: rgba(0, 0, 0, 0.04);        /* very subtle gray highlight */
    border-color: rgba(0, 0, 0, 0.15);      /* slightly darker for active */
}
.timeline-item {
    border: 1px solid rgba(0, 0, 0, 0.1);   /* light gray border */
}
.timeline-item.active {
    background: rgba(0, 0, 0, 0.04);
    border-color: rgba(0, 0, 0, 0.15);
}
```

**Signature Elements:**
- **All white backgrounds** — 100% consistent white throughout (no alternation)
- CSS grid background pattern (64px squares, subtle dark lines on white)
- Slide header with 3px top border rule (`.slide-header`)
- Feature tables (`.ftable` / `.frow`) for key/value data
- Property grids (`.prop-grid` / `.prop-item`) for 2-column feature cards
- Callout blocks with left border (`.callout`)
- Title slide has overline text + tag pills
- Dark text on white ensures high readability

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
    /* Chart palette */
    --chart-1: #3b82f6;
    --chart-2: #ef4444;
    --chart-3: #22c55e;
    --chart-4: #f59e0b;
    --chart-5: #8b5cf6;
    --chart-6: #06b6d4;
    --chart-track: rgba(128, 128, 128, 0.15);
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

**Additional variables (extend viewport-base.css):**
```css
:root {
    --subtitle-size: clamp(0.85rem, 1.8vw, 1.3rem);
    --dur: 0.55s;
}
```

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
.slide-header { border-top: 3px solid currentColor; padding-top: clamp(0.4rem, 1vh, 0.75rem); margin-bottom: clamp(0.75rem, 2vh, 1.25rem); }
/* Bottom rule is position: absolute at slide bottom */
.bottom-rule {
    position: absolute; bottom: 0; left: 0; right: 0;
    height: clamp(32px, 5vh, 40px);
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 var(--slide-padding);
    border-top: 1px solid rgba(255,255,255,0.14);
    background: rgba(0,0,0,0.35);
    opacity: 0;
    transition: opacity 0.3s ease 0.25s;
}
.bottom-rule span {
    font-family: var(--font-body);
    font-size: var(--label-size);
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: rgba(255,255,255,0.55);
}
.slide--light .bottom-rule {
    border-top-color: rgba(0,0,0,0.12);
    background: rgba(255,255,255,0.8);
}
/* Section title — sits ABOVE slide-header border.
   Uses smaller top than --slide-padding so it doesn't overlap the 3px border-top.
   CRITICAL: do NOT use top: var(--slide-padding) — that overlaps the header. */
.section-title {
    position: absolute;
    top: clamp(0.4rem, 1.2vw, 0.75rem);
    right: var(--slide-padding);
    font-size: var(--label-size);
    letter-spacing: 0.2em; text-transform: uppercase;
    opacity: 0; transition: opacity 0.3s ease 0.15s;
}
.slide.visible .section-title { opacity: 1; }
.slide--light .section-title { color: rgba(0,0,0,0.3); }
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
    /* Chart palette */
    --chart-1: #4a90d9;
    --chart-2: #e8853d;
    --chart-3: #5bb378;
    --chart-4: #d4596e;
    --chart-5: #8e7cc3;
    --chart-6: #64748b;
    --chart-track: rgba(128, 128, 128, 0.15);
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
    /* Chart palette */
    --chart-1: #BB162B;
    --chart-2: #3b82f6;
    --chart-3: #10b981;
    --chart-4: #f59e0b;
    --chart-5: #8b5cf6;
    --chart-6: #64748b;
    --chart-track: rgba(128, 128, 128, 0.15);
}
```

**Signature Elements:**
- Midnight blue-black backgrounds (`#05141F`) with slight blue undertone
- Red accent (`#BB162B`) used **strategically** — active states, stat numbers, progress bar
- Red NOT used for general UI chrome (headers, borders stay white/grey)
- Cool grey palette for a sharp, modern feel

---

## Font Pairing Quick Reference

| Preset | Display Font | Body Font | Source |
|--------|--------------|-----------|--------|
| White | Archivo Black | Nunito | Google |
| Black | Archivo Black | Nunito | Google |
| Blue | Archivo Black | Nunito | Google |
| Black Midnight | Archivo Black | Nunito | Google |

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
