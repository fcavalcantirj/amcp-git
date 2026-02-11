#!/bin/bash
# AMCP-Git Docker Test
# Run this from host machine to test recovery in blank container

# ============================================================
# OPTION 1: Public repo (make memories repo public temporarily)
# ============================================================

echo "🏴‍☠️ AMCP-Git Docker Test (Public Repo)"
echo ""

docker run -it --rm node:20 bash -c '
apt-get update -qq && apt-get install -y -qq git > /dev/null 2>&1

echo "📥 Cloning memories repo..."
git clone --depth 1 https://github.com/fcavalcantirj/ClaudiusThePirateEmpeRoR-MeMoRies.git /memories 2>/dev/null

if [ ! -f /memories/CHECKPOINT.json ]; then
    echo "❌ Could not access memories repo (is it public?)"
    exit 1
fi

echo "📋 Checkpoint found!"
cat /memories/CHECKPOINT.json
echo ""

echo "🏴‍☠️ RESPAWN QUIZ - From Git checkpoint:"
echo ""

# Q1: Name (from SOUL.md)
NAME=$(grep -o "\*\*Name:\*\* [^[:space:]]*" /memories/core/SOUL.md 2>/dev/null | head -1 | cut -d" " -f2)
echo "1. My name: $NAME"

# Q2: Human name (from USER.md)
HUMAN=$(grep -o "\*\*Name:\*\* [^[:space:]]*" /memories/workspace/USER.md 2>/dev/null | head -1 | cut -d" " -f2)
CALL=$(grep -o "call them:\*\* [^[:space:]]*" /memories/workspace/USER.md 2>/dev/null | cut -d" " -f2)
echo "2. Human: $HUMAN / call: $CALL"

# Q3: AID (from SOUL.md)
AID=$(grep -o "AID:\*\* \`[^\`]*" /memories/core/SOUL.md 2>/dev/null | head -1 | sed "s/AID:\*\* \`//")
echo "3. AID: $AID"

# Q4: Core values (from SOUL.md)
PRINCIPLES=$(grep -c "^[0-9]*\. \*\*" /memories/core/SOUL.md 2>/dev/null || echo "0")
echo "4. Principles in SOUL.md: $PRINCIPLES"

# Q5: Recent work (from daily notes)
RECENT=$(ls -1 /memories/daily-notes/*.md 2>/dev/null | tail -1 | xargs basename 2>/dev/null)
echo "5. Most recent daily note: $RECENT"

# Q6: Tools configured (from TOOLS.md)
TOOLS=$(grep -c "^## " /memories/workspace/TOOLS.md 2>/dev/null || echo "0")
echo "6. Tool sections in TOOLS.md: $TOOLS"

# Q7: Secrets location
SECRETS=$(grep -o "AgentMemory" /memories/workspace/TOOLS.md 2>/dev/null | head -1)
echo "7. Secrets in: ${SECRETS:-NOT_FOUND}"

# Q8: Timezone (from USER.md)
TZ=$(grep -o "Timezone:\*\* [^[:space:]]*" /memories/workspace/USER.md 2>/dev/null | cut -d" " -f2)
echo "8. Human timezone: $TZ"

# Q9: Motto (from SOUL.md)
MOTTO=$(grep "Think like" /memories/core/SOUL.md 2>/dev/null | head -1)
echo "9. Motto: ${MOTTO:-NOT_FOUND}"

# Q10: Stats
DAILY_COUNT=$(ls -1 /memories/daily-notes/*.md 2>/dev/null | wc -l)
RESEARCH_COUNT=$(ls -1 /memories/research/*.md 2>/dev/null | wc -l)
echo "10. Daily notes: $DAILY_COUNT | Research docs: $RESEARCH_COUNT"

echo ""
echo "✅ Identity + memory restored from Git alone"
'
