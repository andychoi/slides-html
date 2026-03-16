#!/bin/bash
# Deploy updated skill files from this repo to ~/.claude/skills/slides
# Run this after modifying skill source files to update the deployed skill

set -e

SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST_DIR="$HOME/.claude/skills/slides"

echo "Deploying from: $SRC_DIR"
echo "Deploying to:   $DEST_DIR"
echo ""

# Ensure destination exists
mkdir -p "$DEST_DIR"

# Core skill files
cp "$SRC_DIR/SKILL.md" "$DEST_DIR/"
cp "$SRC_DIR/SKILL-markdown.md" "$DEST_DIR/"
cp "$SRC_DIR/CONTENT_TYPES.md" "$DEST_DIR/"
cp "$SRC_DIR/STYLE_PRESETS.md" "$DEST_DIR/"
cp "$SRC_DIR/README.md" "$DEST_DIR/"

# Reference docs
mkdir -p "$DEST_DIR/reference"
cp "$SRC_DIR/reference/animation-patterns.md" "$DEST_DIR/reference/"
cp "$SRC_DIR/reference/html-template.md" "$DEST_DIR/reference/"
cp "$SRC_DIR/reference/viewport-base.css" "$DEST_DIR/reference/"

# Scripts
mkdir -p "$DEST_DIR/scripts"
cp "$SRC_DIR/scripts/"* "$DEST_DIR/scripts/" 2>/dev/null || true

# Style samples
mkdir -p "$DEST_DIR/style-samples"
cp "$SRC_DIR/style-samples/"* "$DEST_DIR/style-samples/"

echo ""
echo "Done. Skill deployed to $DEST_DIR"

# Show what changed in the skill repo
cd "$DEST_DIR"
if [ -d .git ]; then
    echo ""
    echo "Changes in skill repo:"
    git status --short
fi
