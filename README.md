# Slides HTML

A Claude Code skill for generating professional HTML presentations from structured markdown content.

## Quick Start

### 1. Prepare Your Content

You can provide content in three ways:

| Input | How | Example |
|-------|-----|---------|
| **Markdown file** | Write a `.md` file with slide content (see format below) | `slides my-talk.md` |
| **PowerPoint file** | Provide a `.pptx` file for conversion | `slides deck.pptx` |
| **Topic only** | Just describe what you want — Claude generates content | `slides` → "A pitch deck about AI safety" |

### 2. Run the Skill

**Two-step workflow (recommended):**
```
/slides-markdown    →  generates a slide-ready .md file (content + structure)
/slides             →  generates the HTML presentation (design + animation)
```

**One-step workflow:**
```
/slides             →  does everything in one pass (content + design)
```

Use `/slides-markdown` first when you want to **review and edit the content** before committing to a visual style. It produces a properly formatted markdown file with the correct heading prefixes for all 14 layout types.

### 3. Provide Context for Better Results

When running `/slides`, tell Claude:

- **Purpose** — _"This is a conference talk for developers"_ or _"Internal quarterly review for leadership"_
- **Audience** — _"Technical PMs who know the product but not the code"_
- **Source documents** — Attach or reference files: _"Use the notes in `research.md` and data from `metrics.csv`"_
- **Images** — Point to a folder: _"Use images from `./assets/`"_ — Claude will review each image and design slides around them

**Example prompt:**
> `/slides` — Create a 15-slide pitch deck for Series A investors. Use content from `pitch-notes.md` and our logo in `assets/logo.png`. Tone: confident and data-driven.

---

## Writing Effective Markdown

Structure your content as a markdown file before generating slides. Claude Code uses this to select the right layout for each slide automatically.

### Key Rules

1. **Separate slides with `---`** (horizontal rule)
2. **Use specific prefixes** to trigger layouts — `## Comparison:`, `## Timeline:`, `## Process:`, `## Stats`, `# Section:`
3. **Keep content concise** — 4-6 bullets per slide max. If content overflows, split into multiple slides
4. **Use bold + dash** for structured bullets — `- **Label** — Description` renders as styled key-value pairs

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

## Using Source Documents

You can feed Claude any combination of source material when running `/slides`:

| Source Type | What Claude Does |
|-------------|------------------|
| **Markdown file** (`.md`) | Uses as slide content directly — layout detection via heading patterns |
| **PowerPoint** (`.pptx`) | Extracts text, images, speaker notes; rebuilds as HTML |
| **Text/notes** (`.txt`, `.md`) | Distills key points into slide-appropriate content |
| **Data files** (`.csv`, `.json`) | Pulls stats, comparisons, timelines from structured data |
| **Images folder** | Reviews each image, selects usable ones, designs slides around them |
| **PDF** (`.pdf`) | Reads content and restructures for presentation format |

### Tips for Best Results

- **Be specific about purpose and audience** — _"investor pitch"_ produces very different output than _"team standup"_
- **Provide more content than you need** — Claude will curate and cut. It's easier to trim than to invent
- **Name your markdown headings with prefixes** — `## Timeline: Roadmap` is much better than `## Our Plan` for layout detection
- **Use the bold-dash pattern** for structured content — `- **$4.2B** — Total addressable market` renders as styled stat cards
- **Include a logo** — If you provide one, it appears in style previews and the final deck
- **Don't worry about design** — Focus on content; Claude handles typography, color, animation, and responsive layout

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

## Development & Testing

To test changes to the slides skill locally without modifying the installed plugin:

### Setup

A local test command (`/slides-test`) is available at `.claude/commands/slides-test.md`. It mirrors the plugin's `SKILL.md` but lives in the project so you can iterate safely.

### Workflow

```bash
# 1. Sync supporting files from the plugin into .claude/commands/
./dev.sh

# 2. Edit the local skill
#    .claude/commands/slides-test.md

# 3. Start a new Claude Code conversation and run:
#    /slides-test

# 4. Compare output with /slides (original plugin)

# 5. When satisfied, copy changes back to the plugin:
#    cp .claude/commands/slides-test.md ~/.claude/skills/slides/SKILL.md
```

### File Layout

```
slides-html/
  dev.sh                          # Syncs plugin supporting files → .claude/commands/
  .claude/commands/
    slides-test.md                 # Local test version of the skill (tracked in git)
    STYLE_PRESETS.md               # ← synced from plugin (gitignored)
    CONTENT_TYPES.md               # ← synced from plugin (gitignored)
    reference/                     # ← synced from plugin (gitignored)
    scripts/                       # ← synced from plugin (gitignored)
```

> **Note:** Run `./dev.sh` after modifying any supporting files in `~/.claude/skills/slides/` to keep the local copies in sync. The synced files are gitignored — only `slides-test.md` and `dev.sh` are tracked.

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
  SKILL.md                  # /slides — HTML presentation generator
  SKILL-markdown.md         # /slides-markdown — markdown content generator
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
