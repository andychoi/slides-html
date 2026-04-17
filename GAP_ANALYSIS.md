# Gap Analysis: `/slides-test sample-content.md using white style`

## What Should Happen
User runs: `/slides-test sample-content.md using white style`
Expected: Generate HTML with all 26 layout types styled with White preset (light backgrounds, dark text, inverted color variables, Archivo Black + Nunito fonts)

---

## Critical Gaps Found

### Gap 1: NO Mode D / Fast-Path in SKILL.md + slides-test.md

**Current behavior:** 
- Phase 0 only recognizes Mode A (new), Mode B (PPT), Mode C (enhance)
- User command "content.md using white style" enters Phase 1 and asks 4 interactive questions
- Then Phase 2 asks about mood/style, creating duplicate prompts

**What's missing:**
- No parser for "using [style]" syntax in the command
- No Mode D: "Direct generation — both content file + style specified, skip to Phase 3"
- **Phase 0 should detect and handle this pattern automatically**

**How to fix:**
```markdown
## Phase 0: Detect Mode (UPDATED)

- **Mode A: New Presentation** — Create from scratch. Go to Phase 1.
- **Mode B: PPT Conversion** — Convert a .pptx file. Go to Phase 4.
- **Mode C: Enhancement** — Improve an existing HTML presentation. Go to Phase 1 (Mode C).
- **Mode D: Direct Generation** — Content file + style both specified upfront (e.g., "using [content.md] with [style] style"). Parse preset name, skip to Phase 3.

### Detecting Mode D

If user command matches pattern: `<contentfile> using <stylename> style` or `<contentfile> with <stylename> style`
- Extract `stylename`
- Validate against known presets: White, Black, Blue, Black Midnight, Red, Bold Signal
- If valid: set `--chosen-preset = stylename` and go directly to Phase 3
- If invalid: ask user to clarify style name
```

---

### Gap 2: White preset CSS not available to Phase 3 generator

**Current state:**
- STYLE_PRESETS.md now has White's "Additional variables" and "Key CSS patterns" (after my edits)
- But SKILL.md Phase 3 doesn't reference these specific CSS patterns

**What's missing:**
- No explicit instruction to read White section when White is the chosen preset
- No template for how to generate `.slide--dark` and `.slide--light` alternation pattern for White
- The skill generates CSS by reading STYLE_PRESETS, but Phase 3 needs to know: "For White, use variable inversion pattern"

**How to fix:**
Add to SKILL.md Phase 3:
```markdown
### Style Application Rules (Preset-Specific)

**White preset:**
- Color variables are INVERTED: `--black: #f8f8f8` (light), `--white: #0a0a0a` (dark)
- `.slide--dark` renders as **light background** with dark text
- `.slide--light` renders as **dark background** with light text
- This achieves alternating slides visually (light ↔ dark) while keeping structure consistent
- Quote slides (`quote-slide`) do NOT use grid background
- Grid background uses faint dark lines on light: `linear-gradient(rgba(0,0,0,0.04) 1px, ...)`

**All other presets:** (Black, Blue, etc.) follow standard pattern where `--black` is dark, `--white` is light
```

---

### Gap 3: Layout Type Alternation Pattern Unknown

**Reference sample (01-white.html) shows:**
- 26 slides, one of each layout type
- NOT simple alternating `.slide--dark` ↔ `.slide--light`
- Instead: specific layout types get specific variant assignments:
  - Light-bg layouts: `title-slide`, `section-divider`, `stat-slide`, `code-slide`, `chart-progress-slide`, `closing-slide`, `roadmap-slide`
  - Dark-bg layouts: Everything else
  - Special: `quote-slide` has NO grid background (clean, plain dark)

**What's missing:**
- CONTENT_TYPES.md lists "Dark/Light" column (e.g., "Title: Dark") but doesn't match what 01-white.html does
- When SKILL.md generates, it needs to know which layout types should get which variant for White
- The rule isn't "alternate" — it's "these specific types are light, rest are dark"

**How to fix:**
Add to CONTENT_TYPES.md or reference section:
```markdown
## White Preset Layout Assignments

**Light-background layouts (`.slide--light`):**
- Title slide — white bg establishes light-first identity
- Section dividers — high visual contrast for section breaks
- Code slides — light bg for code readability
- Stat slides — data emphasis on clean background
- Timeline/Roadmap — horizontal flow on light
- Chart Progress — metric visualization on light
- Closing slides — light ending mirrors light opening

**Dark-background layouts (`.slide--dark`):**
- All other types: Content, Feature Grid, Comparison, Table, Image, Process, Funnel, Cycle, Converge, Gantt, Split, Quadrant, Third-split, Three-column, chart-donut, chart-bar

**Exception:**
- Quote slides: Dark background, NO grid pattern (`.grid-bg-dark` omitted)
```

---

### Gap 4: sample-content.md Not Optimized for White Preset

**Current sample-content.md:**
- Designed to showcase **Black preset** (title says "Dark Theme, Data-Heavy")
- Contains layout types that work well for Black (lots of data tables, content)
- No explicit guidance for which preset to use

**What's missing:**
- sample-content.md has no metadata or structure to indicate it's Black-preset specific
- When user runs `/slides-test sample-content.md using white style`, skill will generate correct CSS but content description is misleading

**How to fix:**
- Keep sample-content.md generic (works with any preset)
- OR create `sample-content-white.md` variant optimized for White preset
- Add to sample-content.md top: `<!-- Preset: Black (works with any style) -->`

---

### Gap 5: SKILL.md / slides-test.md Preset Comparison Table Incomplete

**Current mood table (after my edits):**
```
| Mood | Suggested Presets |
|------|-------------------|
| Corporate/Professional | White, Black, Blue |
| Impressed/Confident | Black Midnight, Blue |
| Excited/Energized | Black Midnight, Bold Signal |
| Calm/Focused | White, Black, Red |
| Inspired/Moved | Black Midnight, Red |
```

**What's still missing:**
- "Calm/Focused" suggests "White, Black, Red" but doesn't explain why White fits
- Red preset description in STYLE_PRESETS.md (lines 262-312) says "top-aligned, swiss grid, bold red accent" — more bold than calm
- Recommendation mapping doesn't align with preset vibrations

**How to fix:**
Update mood table alignment:
```
| Calm/Focused | White, Black |  (remove Red — it's too bold/accent-heavy)
```

---

## Summary: What Will Fail When User Runs Command

```
/slides-test style-samples/sample-content.md using white style
```

1. ❌ **Skill won't recognize "using white style" syntax** → enters Phase 1 instead of Mode D
2. ❌ **User gets asked 4 interactive questions** about purpose, length, content, editing (should skip)
3. ❌ **Then Phase 2 asks about mood** → another 2-3 questions (should skip)
4. ❌ **Finally Phase 3 generates** with correct CSS (because White is now in presets)
5. ⚠️ **Result:** Correct HTML but terrible UX due to unnecessary questions

---

## Implementation Priority

| Priority | Fix | File | Impact |
|----------|-----|------|--------|
| **CRITICAL** | Add Mode D parser to detect "using [style]" syntax | SKILL.md + slides-test.md | Skips Phase 1/2 entirely |
| **HIGH** | Document White alternation pattern (layout → variant mapping) | CONTENT_TYPES.md | Ensures correct light/dark assignment |
| **HIGH** | Add preset-specific CSS generation rules to Phase 3 | SKILL.md | Explains variable inversion for White |
| **MEDIUM** | Update mood→preset recommendations | SKILL.md + slides-test.md | Consistency (Red doesn't fit "Calm") |
| **LOW** | Update sample-content.md title/comment | sample-content.md | Documentation only |

---

## Expected Output After Fixes

When user runs: `/slides-test style-samples/sample-content.md using white style`

1. ✅ Mode D detected → skips Phase 1 and Phase 2
2. ✅ Phase 3 reads STYLE_PRESETS.md White section
3. ✅ Generates 26-slide HTML with:
   - White color preset applied
   - Correct `.slide--dark` (light bg) / `.slide--light` (dark bg) assignment per layout type
   - Grid backgrounds with subtle dark lines on light
   - Archivo Black + Nunito fonts
   - Matches structure and styles from `style-samples/01-white.html`
