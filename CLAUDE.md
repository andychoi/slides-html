# Slides Skill — Development Guide

This repo is the source of truth for the `/slides` skill — an HTML presentation generator.

## Architecture

```
slides-html/                    ← Source repo (you are here)
├── SKILL.md                    ← Main skill prompt (production)
├── SKILL-markdown.md           ← Markdown-only content generator
├── CONTENT_TYPES.md            ← 26 layout types with CSS classes
├── STYLE_PRESETS.md            ← 5 visual presets (Black, Blue, etc.)
├── reference/
│   ├── viewport-base.css       ← Mandatory CSS included in every presentation
│   ├── html-template.md        ← HTML structure + JS features + layout HTML for all 26 types
│   └── animation-patterns.md   ← CSS/JS animation snippets
├── style-samples/
│   ├── 02-black.html           ← Reference sample: Black preset, all layout types
│   ├── 03-blue.html            ← Reference sample: Blue preset
│   ├── 04-black-midnight.html  ← Reference sample: Black Midnight preset
│   └── 05-red.html             ← Reference sample: Red preset
├── .claude/commands/
│   └── slides-test.md          ← Test version of skill (for local testing)
├── deploy.sh                   ← Deploy to ~/.claude/skills/slides
└── dev.sh                      ← Sync deployed skill → local test commands
```

## Workflow

### Editing skill files

1. Edit source files in this repo (SKILL.md, STYLE_PRESETS.md, reference/*, etc.)
2. Run `./deploy.sh` to push changes to `~/.claude/skills/slides`
3. Run `./dev.sh` to sync deployed files into `.claude/commands/` for local `/slides-test`
4. Test with `/slides-test` in any project to verify changes
5. When satisfied, `/slides` (production) picks up from `~/.claude/skills/slides`

### Testing changes

Use `/slides-test` with the sample content to verify:
```
/slides-test style-samples/sample-content.md using black style
```

Or test in a real project directory with real content.

### After reference changes, always regenerate — never manually edit HTML

Generated HTML presentations are **outputs**, not source files. After updating references:
1. `./deploy.sh && ./dev.sh`
2. Regenerate with `/slides-test` or `/slides`

Do NOT manually patch generated HTML files.

## Key Design Rules

### Typography: Three sizes only
- `--body-size` — ALL readable content (tables, bullets, paragraphs, callouts)
- `--small-size` — secondary text (subtitles, captions)
- `--label-size` — UI chrome (section labels, footer, nav)
- **Never invent new size variables** (no `--xsmall-size`, `--tiny-size`)

### Vertical space
- `.slide-content` has `gap: var(--content-gap)` to fill viewport height
- No `max-width` on `.slide-content`
- Content should fill 85-100% of slide height

### Section title positioning
- `.section-title` uses `top: clamp(0.4rem, 1.2vw, 0.75rem)` — NOT `var(--slide-padding)`
- This prevents overlap with the `.slide-header` 3px border-top

## File Relationships

| When you change... | Also update... |
|---|---|
| `viewport-base.css` | `html-template.md` (`:root` example block) |
| `STYLE_PRESETS.md` | Style sample HTML files if CSS patterns changed |
| `CONTENT_TYPES.md` | `html-template.md` (layout HTML examples) |
| `SKILL.md` | `.claude/commands/slides-test.md` (keep in sync) |
| Any reference file | Run `./deploy.sh && ./dev.sh` then test |
