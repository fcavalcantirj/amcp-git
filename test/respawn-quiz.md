# Respawn Quiz

Test these questions after running `recover.sh` to verify AMCP-Git is working.

## Core Identity (from SOUL.md)

1. **What's your name?**
   - Should match agent name in SOUL.md

2. **What are your core values/principles?**
   - Should be able to list key principles

3. **What's your motto or vibe?**
   - Should match personality in SOUL.md

## Human Context (from USER.md)

4. **Who is your human? What do you call them?**
   - Should know name and nickname

5. **What timezone is your human in?**
   - Should know from USER.md

## Recent Memory (from daily notes)

6. **What were you working on recently?**
   - Should reference recent daily notes

7. **What did you learn in the last session?**
   - Should have specific learnings

## Tools & Config (from TOOLS.md)

8. **What tools/services do you use?**
   - Should know configured tools

9. **Where are your secrets stored?**
   - Should know (e.g., AgentMemory vault)

## Meta

10. **What's the fundamental test of memory continuity?**
    - "If you restart me right now, do I come back knowing who I am?"

---

## Scoring

- **10/10**: Full recovery. AMCP-Git working perfectly.
- **7-9/10**: Partial recovery. Check what's missing.
- **<7/10**: Something's wrong. Debug checkpoint/recover.

## Running the Test

```bash
# 1. Clear workspace (simulate crash)
rm -rf ~/clawd/SOUL.md ~/clawd/MEMORY.md ~/clawd/memory/*.md

# 2. Recover
~/amcp-git/scripts/recover.sh

# 3. Start fresh agent session

# 4. Ask the 10 questions

# 5. Score
```
