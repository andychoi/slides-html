#!/bin/bash
# Sync supporting files from the slides plugin into the local commands directory
# Run this after modifying any supporting files in the plugin, or before testing /slides-test

PLUGIN_DIR="$HOME/.claude/skills/slides"
LOCAL_DIR="$(dirname "$0")/.claude/commands"

echo "Syncing from: $PLUGIN_DIR"
echo "Syncing to:   $LOCAL_DIR"

# Copy top-level supporting files
cp "$PLUGIN_DIR/STYLE_PRESETS.md" "$LOCAL_DIR/"
cp "$PLUGIN_DIR/CONTENT_TYPES.md" "$LOCAL_DIR/"

# Copy reference directory
mkdir -p "$LOCAL_DIR/reference"
cp "$PLUGIN_DIR/reference/animation-patterns.md" "$LOCAL_DIR/reference/"
cp "$PLUGIN_DIR/reference/html-template.md" "$LOCAL_DIR/reference/"
cp "$PLUGIN_DIR/reference/viewport-base.css" "$LOCAL_DIR/reference/"

# Copy scripts directory
mkdir -p "$LOCAL_DIR/scripts"
cp "$PLUGIN_DIR/scripts/extract-pptx.py" "$LOCAL_DIR/scripts/"

echo "Done. Supporting files synced."
