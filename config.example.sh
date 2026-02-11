#!/bin/bash
# AMCP-Git Configuration
# Copy this to config.sh and edit for your setup

# ============================================================
# PATHS
# ============================================================

# Where the agent works (source of truth during session)
WORKSPACE_DIR="$HOME/clawd"

# Where memories are stored (git repo, pushed to remote)
MEMORIES_DIR="$HOME/memories"

# ============================================================
# AGENT IDENTITY
# ============================================================

AGENT_NAME="YourAgentName"
AGENT_AID=""  # Optional: KERI AID if you have one

# ============================================================
# FILES TO CHECKPOINT
# ============================================================

# Core identity files (in workspace root)
CORE_FILES="SOUL.md MEMORY.md IDENTITY.md"

# Workspace config files (in workspace root)
WORKSPACE_FILES="USER.md TOOLS.md AGENTS.md HEARTBEAT.md"

# Daily notes directory
DAILY_NOTES_DIR="memory"

# Research directory (optional)
RESEARCH_DIR="research"

# ============================================================
# GIT SETTINGS
# ============================================================

GIT_REMOTE="origin"
GIT_BRANCH="main"
