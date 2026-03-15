---
name: slides-markdown
description: Generate slide-ready markdown compatible with /slides. Takes a topic, rough notes, or existing documents and produces a properly formatted .md file with correct layout prefixes for all 14 slide types. Use when preparing content before running /slides.
---

# Slides Markdown

Generate slide-ready markdown that the `/slides` skill can turn into a polished HTML presentation.

## Core Principles

1. **Content only** — This skill produces markdown. No HTML, no CSS, no style decisions.
2. **Layout-aware formatting** — Use the correct heading prefixes so `/slides` auto-detects the right layout for every slide.
3. **Density-conscious** — Respect per-slide content limits. Split rather than cram.
4. **Preserve intent** — When restructuring existing content, keep the author's message and emphasis.

---

## Phase 0: Detect Mode

Look at what the user provided:

- **User gives a file path or pastes content** → **Restructure mode** — reshape existing material into slide-compatible markdown
- **User gives a topic or brief description** → **Generate mode** — create slide content from scratch
- **User gives a .pptx file** → Tell them to use `/slides` directly (it handles PPT conversion natively)

---

## Phase 1: Quick Questions

**Ask both questions in a single AskUserQuestion call:**

**Question 1 — Purpose** (header: "Purpose"):
What is this presentation for? Options: Pitch deck / Tutorial / Conference talk / Internal presentation

**Question 2 — Length** (header: "Length"):
Approximately how many slides? Options: Short (5-10) / Medium (10-20) / Long (20+)

Then proceed to Phase 2.

---

## Phase 2: Generate Markdown

### Formatting Rules

**Slide separation:** Use `---` (horizontal rule) between every slide.

**Heading prefixes trigger layouts.** Use these exact patterns:

| Markdown Pattern | Layout Triggered |
|---|---|
| `# Presentation Title` (first heading) | Title slide |
| `# Section: Name` or `# Part N: Name` | Section Divider |
| `## Agenda` + numbered list | Agenda / TOC |
| `## Heading` + bullet list | Content (default) |
| `## Comparison: X vs Y` + two `###` subheadings | Comparison |
| `## Timeline: Name` + dated items | Timeline / Roadmap |
| `## Process: Name` + numbered steps | Process / Flow |
| `## Stats` + metric items | Stat Highlight |
| Markdown table (`\| col \| col \|`) | Table / Matrix |
| `> "Quote text"` + `> — Attribution` | Quote |
| ` ```language ` code fence | Code |
| `![alt](path)` + text | Image |
| 3-6 items each with **bold title** + description | Feature Grid |
| `## Thank You` or `## Questions?` (last slide) | Closing / Q&A |

### Structured Bullet Pattern

Use **bold + em dash** for key-value style bullets:

```markdown
- **Label** — Description text here
```

This renders as styled key-value pairs in the HTML presentation. Use it for:
- Feature lists: `- **Grid Backgrounds** — Subtle CSS grid pattern on dark and light slides`
- Metrics: `- **94%** — Customer retention rate`
- Agenda items: `1. Introduction — Background and project scope`

### Content Density Limits

Never exceed these per slide — split into continuation slides if needed:

| Slide Type | Maximum Content |
|---|---|
| Title | 1 heading + 1 subtitle + optional tagline |
| Content | 1 heading + 4-6 bullets OR 1 heading + 2 paragraphs |
| Feature Grid | 1 heading + 6 cards max (each: bold title + 1 sentence) |
| Code | 1 heading + 8-10 lines of code |
| Quote | 1 quote (max 3 lines) + attribution |
| Image | 1 heading + 1 image reference + optional caption |
| Section Divider | 1 title + optional subtitle |
| Agenda | 1 heading + 4-6 numbered items |
| Timeline | 1 heading + 3-5 milestones |
| Comparison | 1 heading + 2 columns x 3-5 items each |
| Table | 1 heading + max 5 rows x 4 columns |
| Stats | 1-3 large numbers with labels |
| Process | 1 heading + 3-5 steps |
| Closing | 1 heading + 1 subtitle + 2-3 contact items |

### Layout Selection Logic

When deciding which layout to use for each piece of content, follow this decision tree:

```
Opening? → Title
Deck overview? → Agenda
Major section break? → Section Divider
Sequential steps? → Process (conceptual) or Timeline (date-based)
Two options side-by-side? → Comparison
3+ options with structured data? → Table
1-3 dramatic numbers? → Stats
Code snippet? → Code
Quote or testimonial? → Quote
Image with text? → Image
3-6 peer features/capabilities? → Feature Grid
Thank you / Q&A / contact? → Closing
Everything else → Content
```

### Deck Structure Template

Follow this rhythm for a well-paced deck:

```
1.  Title
2.  Agenda
3.  Section Divider
4.  Content or Stat Highlight
5.  Content or Table
6.  Section Divider
7.  Content or Feature Grid
8.  Process / Flow
9.  Comparison
10. Section Divider
11. Stat Highlight
12. Timeline / Roadmap
13. Quote or Image
14. Content (next steps / call to action)
15. Closing / Q&A
```

**Rules of thumb:**
- Use **2-4 section dividers** per deck to create rhythm
- Alternate between **data-heavy** (table, stats, grid) and **narrative** (content, quote, image) slides
- Never use the same layout type more than 3 times in a row
- Always start with Title + Agenda, always end with Closing
- Scale this template up or down to match the requested length

### Restructure Mode Rules

When reshaping existing content:
1. **Read the source material fully** before structuring
2. **Identify the narrative arc** — what's the story? what order makes sense?
3. **Map content to layouts** — use the decision tree above for each chunk
4. **Add prefixes** — rewrite headings to use `## Timeline:`, `## Comparison:`, etc.
5. **Trim to fit density limits** — cut wordiness, keep substance
6. **Add missing pieces** — if there's no clear opening/closing, create them
7. **Preserve data and quotes** — never invent statistics or misattribute quotes

### Generate Mode Rules

When creating from a topic:
1. **Research the topic** if possible (check for user-provided docs)
2. **Draft an outline** matching the deck structure template
3. **Write substantive content** — not placeholder text. Each bullet should say something real
4. **Use concrete examples** — numbers, names, dates make slides credible
5. **Vary layouts** — don't make 10 content slides in a row

---

## Phase 3: Output

1. **Ask for filename and location:**
   > "Where should I save the markdown file? (e.g., `my-talk-slides.md` in the current directory)"

2. **Write the file** to the specified location

3. **Summarize** what was generated:
   - Number of slides and their types
   - The narrative structure (sections)
   - Suggest: "Run `/slides` to generate the HTML presentation from this markdown"

---

## Reference Example

A complete slide-ready markdown file demonstrating all 14 layout types is available at `style-samples/sample-content.md` in this project. Read it before generating to calibrate formatting.
