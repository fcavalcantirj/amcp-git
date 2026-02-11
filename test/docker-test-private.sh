#!/bin/bash
# AMCP-Git Docker Test (Private Repo)
# Uses GitHub token for authentication

# ============================================================
# USAGE: ./docker-test-private.sh <GITHUB_TOKEN>
# ============================================================

if [ -z "$1" ]; then
    echo "Usage: ./docker-test-private.sh <GITHUB_TOKEN>"
    echo ""
    echo "Create a token at: https://github.com/settings/tokens"
    echo "Needs 'repo' scope for private repos"
    exit 1
fi

TOKEN="$1"
REPO="fcavalcantirj/ClaudiusThePirateEmpeRoR-MeMoRies"

echo "🏴‍☠️ AMCP-Git Docker Test (Private Repo)"
echo ""

docker run -it --rm node:20 bash -c "
apt-get update -qq && apt-get install -y -qq git > /dev/null 2>&1

echo '📥 Cloning private memories repo...'
git clone --depth 1 https://${TOKEN}@github.com/${REPO}.git /memories 2>/dev/null

if [ ! -f /memories/CHECKPOINT.json ]; then
    echo '❌ Clone failed - check token permissions'
    exit 1
fi

echo '📋 Checkpoint found!'
cat /memories/CHECKPOINT.json
echo ''

echo '🏴‍☠️ RESPAWN QUIZ - From Git checkpoint:'
echo ''

# Q1: Name
NAME=\$(grep -o '\*\*Name:\*\* [^[:space:]]*' /memories/core/SOUL.md 2>/dev/null | head -1 | cut -d' ' -f2)
echo \"1. My name: \$NAME\"

# Q2: Human
HUMAN=\$(grep -o '\*\*Name:\*\* [^[:space:]]*' /memories/workspace/USER.md 2>/dev/null | head -1 | cut -d' ' -f2)
CALL=\$(grep -o 'call them:\*\* [^[:space:]]*' /memories/workspace/USER.md 2>/dev/null | cut -d' ' -f2)
echo \"2. Human: \$HUMAN / call: \$CALL\"

# Q3: AID
AID=\$(grep -oP 'AID:\*\* \\\`\K[^\\\`]+' /memories/core/SOUL.md 2>/dev/null | head -1)
echo \"3. AID: \$AID\"

# Q4-10: Stats
DAILY=\$(ls -1 /memories/daily-notes/*.md 2>/dev/null | wc -l)
RESEARCH=\$(ls -1 /memories/research/*.md 2>/dev/null | wc -l)
echo \"4-10: Daily notes: \$DAILY | Research: \$RESEARCH\"

echo ''
echo '✅ Identity + memory restored from Git alone'
"
