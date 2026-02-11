#!/bin/bash
# AMCP-Git: Recover
# Restore agent state from git repo

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/../config.sh"

# Load config
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Config not found: $CONFIG_FILE"
    echo "   Copy config.example.sh to config.sh and edit it"
    exit 1
fi
source "$CONFIG_FILE"

echo "🏴‍☠️ AMCP-Git Recover"
echo ""

# Check if memories repo exists
if [ ! -d "$MEMORIES_DIR/.git" ]; then
    echo "❌ Memories repo not found: $MEMORIES_DIR"
    echo "   Clone your memories repo first"
    exit 1
fi

# Pull latest
echo "📥 Pulling latest..."
cd "$MEMORIES_DIR"
git pull "$GIT_REMOTE" "$GIT_BRANCH" 2>&1 || echo "   (already up to date or no remote)"

# Check for checkpoint
if [ ! -f "$MEMORIES_DIR/CHECKPOINT.json" ]; then
    echo "⚠️ No checkpoint found"
    echo "   Run checkpoint.sh first to create one"
    exit 1
fi

# Show checkpoint info
echo ""
echo "📋 Checkpoint info:"
CHECKPOINT_TIME=$(cat "$MEMORIES_DIR/CHECKPOINT.json" | grep '"timestamp"' | cut -d'"' -f4)
CHECKPOINT_NOTE=$(cat "$MEMORIES_DIR/CHECKPOINT.json" | grep '"note"' | cut -d'"' -f4)
CHECKPOINT_AGENT=$(cat "$MEMORIES_DIR/CHECKPOINT.json" | grep '"name"' | cut -d'"' -f4)
echo "   Agent: $CHECKPOINT_AGENT"
echo "   Time: $CHECKPOINT_TIME"
echo "   Note: $CHECKPOINT_NOTE"
echo ""

# Restore core files
echo "📦 Restoring core identity..."
for f in "$MEMORIES_DIR/core/"*.md; do
    if [ -f "$f" ]; then
        cp -f "$f" "$WORKSPACE_DIR/"
        echo "   ✓ $(basename $f)"
    fi
done

# Restore workspace files
echo "📦 Restoring workspace config..."
for f in "$MEMORIES_DIR/workspace/"*.md; do
    if [ -f "$f" ]; then
        cp -f "$f" "$WORKSPACE_DIR/"
        echo "   ✓ $(basename $f)"
    fi
done

# Restore daily notes
echo "📦 Restoring daily notes..."
mkdir -p "$WORKSPACE_DIR/$DAILY_NOTES_DIR"
if [ -d "$MEMORIES_DIR/daily-notes" ]; then
    cp -f "$MEMORIES_DIR/daily-notes/"*.md "$WORKSPACE_DIR/$DAILY_NOTES_DIR/" 2>/dev/null || true
    cp -f "$MEMORIES_DIR/daily-notes/"*.json "$WORKSPACE_DIR/$DAILY_NOTES_DIR/" 2>/dev/null || true
    DAILY_COUNT=$(ls -1 "$WORKSPACE_DIR/$DAILY_NOTES_DIR/"*.md 2>/dev/null | wc -l)
    echo "   ✓ $DAILY_COUNT files"
fi

# Restore research
echo "📦 Restoring research..."
if [ -d "$MEMORIES_DIR/research" ]; then
    mkdir -p "$WORKSPACE_DIR/$RESEARCH_DIR"
    cp -f "$MEMORIES_DIR/research/"*.md "$WORKSPACE_DIR/$RESEARCH_DIR/" 2>/dev/null || true
    RESEARCH_COUNT=$(ls -1 "$WORKSPACE_DIR/$RESEARCH_DIR/"*.md 2>/dev/null | wc -l)
    echo "   ✓ $RESEARCH_COUNT files"
fi

echo ""
echo "✅ Recovery complete"
echo ""
echo "🏴‍☠️ I'm back. Arrr!"
