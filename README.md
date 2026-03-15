# Slides HTML

A Claude Code skill for generating professional HTML presentations from structured markdown content.

## How It Works

1. **Write a markdown file** describing your slides (see format below)
2. **Run `/slides`** in Claude Code
3. **Pick a style preset** (Default, Black, or Bold Signal)
4. **Get a single HTML file** — zero dependencies, works forever

## Preparing Your Markdown

Structure your content as a markdown file before generating slides. Claude Code uses this to select the right layout for each slide automatically.

### Markdown Format

```markdown
# Presentation Title
Subtitle or tagline here

---

## Agenda
1. Introduction — Project background and objectives
2. Market Analysis — Competitive landscape review
3. Product Strategy — Roadmap and priorities
4. Results — Key metrics and outcomes

---

# Section: Market Analysis
Understanding the competitive landscape

---

## Key Findings
- **Market Size** — $4.2B and growing at 18% CAGR
- **Competitors** — Three major players, fragmented tail
- **Opportunity** — Underserved mid-market segment

---

## Comparison: Build vs Buy
### Build In-House
- Full control over architecture
- Higher upfront investment
- Custom-tailored to workflows

### Buy / License
- Faster deployment
- Vendor dependency risk
- Predictable subscription cost

---

## Timeline: Product Roadmap
- Q1 2026: Research — User interviews and requirements
- Q2 2026: Build — Core platform development
- Q3 2026: Beta — Closed beta with partners
- Q4 2026: Launch — Public release

---

> "The details are not the details. They make the design."
> — Charles Eames

---

## Stats
- 98% — Performance Score
- 14 — Slide Layouts
- <1s — Load Time

---

## Process: Development Workflow
1. Define — Establish goals and constraints
2. Design → Create layouts and prototypes
3. Build — Develop and integrate
4. Ship — Test and deploy

---

| Feature | Starter | Professional | Enterprise |
|---------|---------|-------------|------------|
| Users   | Up to 5 | Up to 50    | Unlimited  |
| Storage | 10 GB   | 100 GB      | 1 TB+      |
| Support | Email   | Chat        | Dedicated  |
```

### Content Type Detection

Claude Code maps your markdown to the right slide layout automatically:

| Markdown Pattern | Layout Used | CSS Class |
|---|---|---|
| `# Title` (first heading) | Title slide | `title-slide` |
| `# Section: Name` or `# Part N: Name` | Section Divider | `section-divider` |
| `## Agenda` + numbered list | Agenda / TOC | `agenda-slide` |
| `## Heading` + bullets | Content | `content-slide` |
| `## Comparison: X vs Y` | Comparison | `comparison-slide` |
| `## Timeline: Name` + dated items | Timeline | `timeline-slide` |
| `## Process: Name` + numbered steps | Process / Flow | `process-slide` |
| `## Stats` + metrics | Stat Highlight | `stat-slide` |
| Markdown table (`\| col \|`) | Table / Matrix | `table-slide` |
| `> blockquote` with attribution | Quote | `quote-slide` |
| ` ```code``` ` blocks | Code | `code-slide` |
| `![image](path)` | Image | `image-slide` |
| 3-6 items with title + description | Feature Grid | `grid-slide` |

See [CONTENT_TYPES.md](CONTENT_TYPES.md) for full layout reference.

## Style Presets

| Preset | Vibe | Background | Default |
|---|---|---|---|
| **Black** | Dark-first, data-dense, professional | Alternating dark/light | Yes |
| **Blue** | Corporate, premium, navy + warm silver | Navy-tinted dark/light | |
| **Black Midnight** | Deep midnight with strategic red | Midnight blue-black | |
| **Red** | Clean, structured, bold red accent | White with red accent | |
| **Bold Signal** | Confident, high-impact, vibrant | Dark gradient with colored card | |

Preview all styles: open `style-samples/index.html` in your browser.

See [STYLE_PRESETS.md](STYLE_PRESETS.md) for full preset reference.

## 14 Slide Layouts

Every preset includes all 14 layout types:

1. **Title** — Opening slide with title, subtitle, metadata
2. **Content** — Heading + bullets or key-value data
3. **Feature Grid** — 3-6 numbered feature cards
4. **Code** — Syntax-highlighted code with tab bar
5. **Quote** — Large quotation with attribution
6. **Image** — Two-column: text + visual
7. **Section Divider** — Dramatic transition between sections
8. **Agenda / TOC** — Numbered section list with active highlight
9. **Timeline / Roadmap** — Horizontal milestones with dates
10. **Comparison** — Two-column side-by-side evaluation
11. **Table / Matrix** — Structured rows and columns
12. **Stat Highlight** — 1-3 large KPI numbers
13. **Process / Flow** — Sequential steps with arrows
14. **Closing / Q&A** — Thank you, contact info, questions

## Installation

Clone to your Claude Code skills directory:

```bash
git clone https://github.com/andychoi/slides-html.git ~/.claude/skills/slides
```

Then use `/slides` in Claude Code.

## Output

- **Single HTML file** — inline CSS + JS, no external dependencies
- **Responsive** — works on all screen sizes with `clamp()` sizing
- **Accessible** — keyboard navigation, ARIA labels, reduced-motion support
- **Scroll-snap** — full-viewport slides with smooth scrolling
- **Animations** — staggered reveal transitions triggered by scroll

## Project Structure

```
slides-html/
  README.md                 # Project overview
  SKILL.md                  # Claude Code skill entry point
  CONTENT_TYPES.md          # Layout taxonomy and selection guide
  STYLE_PRESETS.md           # Visual preset specifications
  reference/
    html-template.md         # HTML structure reference
    animation-patterns.md    # Animation reference
    viewport-base.css        # Mandatory responsive base CSS
  style-samples/
    index.html               # Style gallery
    00-red.html              # Red preset (14 layouts)
    01-bold-signal.html      # Bold Signal preset
    02-black.html            # Black preset (14 layouts)
    03-blue.html             # Blue preset (14 layouts)
    04-black-midnight.html   # Black Midnight preset (14 layouts)
  scripts/
    extract-pptx.py          # PowerPoint content extraction
```

## License

MIT
