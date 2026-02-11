#!/bin/bash
# AMCP-Git: Checkpoint
# Save agent state to git repo

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

# Args
NOTE="${1:-Checkpoint}"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "🏴‍☠️ AMCP-Git Checkpoint"
echo "   Time: $TIMESTAMP"
echo "   Note: $NOTE"
echo ""

# Verify directories exist
if [ ! -d "$WORKSPACE_DIR" ]; then
    echo "❌ Workspace not found: $WORKSPACE_DIR"
    exit 1
fi

if [ ! -d "$MEMORIES_DIR/.git" ]; then
    echo "❌ Memories repo not found: $MEMORIES_DIR"
    echo "   Clone your memories repo first"
    exit 1
fi

# Create directory structure
mkdir -p "$MEMORIES_DIR/core"
mkdir -p "$MEMORIES_DIR/workspace"
mkdir -p "$MEMORIES_DIR/daily-notes"
mkdir -p "$MEMORIES_DIR/research"

# Copy core files
echo "📦 Core identity..."
for f in $CORE_FILES; do
    if [ -f "$WORKSPACE_DIR/$f" ]; then
        cp -f "$WORKSPACE_DIR/$f" "$MEMORIES_DIR/core/"
        echo "   ✓ $f"
    fi
done

# Copy workspace files
echo "📦 Workspace config..."
for f in $WORKSPACE_FILES; do
    if [ -f "$WORKSPACE_DIR/$f" ]; then
        cp -f "$WORKSPACE_DIR/$f" "$MEMORIES_DIR/workspace/"
        echo "   ✓ $f"
    fi
done

# Copy daily notes
echo "📦 Daily notes..."
if [ -d "$WORKSPACE_DIR/$DAILY_NOTES_DIR" ]; then
    cp -f "$WORKSPACE_DIR/$DAILY_NOTES_DIR/"*.md "$MEMORIES_DIR/daily-notes/" 2>/dev/null || true
    cp -f "$WORKSPACE_DIR/$DAILY_NOTES_DIR/"*.json "$MEMORIES_DIR/daily-notes/" 2>/dev/null || true
    DAILY_COUNT=$(ls -1 "$MEMORIES_DIR/daily-notes/"*.md 2>/dev/null | wc -l)
    echo "   ✓ $DAILY_COUNT files"
fi

# Copy research (optional)
echo "📦 Research..."
if [ -d "$WORKSPACE_DIR/$RESEARCH_DIR" ]; then
    cp -f "$WORKSPACE_DIR/$RESEARCH_DIR/"*.md "$MEMORIES_DIR/research/" 2>/dev/null || true
    RESEARCH_COUNT=$(ls -1 "$MEMORIES_DIR/research/"*.md 2>/dev/null | wc -l)
    echo "   ✓ $RESEARCH_COUNT files"
fi

# Count files
CORE_COUNT=$(ls -1 "$MEMORIES_DIR/core/"*.md 2>/dev/null | wc -l)
WORKSPACE_COUNT=$(ls -1 "$MEMORIES_DIR/workspace/"*.md 2>/dev/null | wc -l)

# Create CHECKPOINT.json
cat > "$MEMORIES_DIR/CHECKPOINT.json" << EOF
{
  "version": "0.1",
  "timestamp": "$TIMESTAMP",
  "agent": {
    "name": "$AGENT_NAME",
    "aid": "$AGENT_AID"
  },
  "note": "$NOTE",
  "stats": {
    "core_files": $CORE_COUNT,
    "workspace_files": $WORKSPACE_COUNT,
    "daily_notes": ${DAILY_COUNT:-0},
    "research_docs": ${RESEARCH_COUNT:-0}
  }
}
EOF

# Git commit and push
echo ""
echo "📤 Committing..."
cd "$MEMORIES_DIR"
git add -A
git commit -m "Checkpoint: $TIMESTAMP - $NOTE" || echo "   (nothing new to commit)"

echo "📤 Pushing..."
git push "$GIT_REMOTE" "$GIT_BRANCH" 2>&1 || git push -u "$GIT_REMOTE" "$GIT_BRANCH" 2>&1

COMMIT_HASH=$(git rev-parse --short HEAD)

echo ""
echo "✅ Checkpoint complete"
echo "   Commit: $COMMIT_HASH"
echo "   Core: $CORE_COUNT | Workspace: $WORKSPACE_COUNT | Daily: ${DAILY_COUNT:-0} | Research: ${RESEARCH_COUNT:-0}"
