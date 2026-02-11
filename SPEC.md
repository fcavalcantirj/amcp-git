# AMCP-Git Specification v0.1

> Agent Memory Continuity Protocol — Git Backend

---

## 1. Purpose

Enable AI agents to persist memory across sessions using Git as storage.

**Goals:**
- Agent survives crashes/restarts
- Human has full control
- Simple enough to audit in 5 minutes

**Non-Goals:**
- Trustless multi-agent sync (use IPFS for that)
- Real-time sync (Git is checkpoint-based)
- Built-in encryption (use private repo)

---

## 2. Concepts

### Checkpoint
A Git commit containing the agent's state at a point in time.

### Memories Repo
A Git repository storing the agent's checkpoints. Human-owned.

### Workspace
The agent's working directory where files live during a session.

---

## 3. Repository Structure

```
memories-repo/
├── CHECKPOINT.json      # Metadata (who, when, what)
├── core/
│   ├── SOUL.md          # Identity, values, personality
│   ├── MEMORY.md        # Curated long-term memory
│   └── IDENTITY.md      # Quick identity reference
├── workspace/
│   ├── USER.md          # Human context
│   ├── TOOLS.md         # Tool configurations
│   ├── AGENTS.md        # Operating rules
│   └── HEARTBEAT.md     # Proactive checklist
├── daily-notes/
│   └── YYYY-MM-DD.md    # Daily logs
└── research/
    └── *.md             # Research documents
```

---

## 4. CHECKPOINT.json

```json
{
  "version": "0.1",
  "timestamp": "2026-02-11T00:20:29Z",
  "agent": {
    "name": "AgentName",
    "aid": "optional-keri-aid"
  },
  "note": "Human-readable checkpoint note",
  "stats": {
    "core_files": 3,
    "workspace_files": 4,
    "daily_notes": 17
  }
}
```

---

## 5. Operations

### checkpoint

```bash
checkpoint.sh [note]
```

1. Copy files from workspace to memories repo
2. Update CHECKPOINT.json
3. `git add -A`
4. `git commit -m "Checkpoint: <timestamp> - <note>"`
5. `git push`

### recover

```bash
recover.sh
```

1. `git pull`
2. Copy files from memories repo to workspace
3. Report what was restored

### history

```bash
git log --oneline
```

Use Git directly. No wrapper needed.

### restore (specific point)

```bash
git checkout <commit-hash>
recover.sh
git checkout main
```

Use Git directly. No wrapper needed.

---

## 6. Configuration

```bash
# config.sh

# Where the agent works
WORKSPACE_DIR="$HOME/clawd"

# Where memories are stored (git repo)
MEMORIES_DIR="$HOME/memories"

# What to include
INCLUDE_CORE="SOUL.md MEMORY.md IDENTITY.md"
INCLUDE_WORKSPACE="USER.md TOOLS.md AGENTS.md HEARTBEAT.md"
INCLUDE_DAILY="memory/*.md memory/*.json"
INCLUDE_RESEARCH="research/*.md"
```

---

## 7. Privacy

| Repo Type | Who Can Read | Use Case |
|-----------|--------------|----------|
| Private | Owner + collaborators | Personal memories |
| Public | Anyone | Published knowledge |

**Private repo = private memories.** No encryption needed.

---

## 8. Verification (Respawn Quiz)

After recovery, agent should answer:

1. What's my name?
2. Who is my human?
3. What was I working on?
4. What are my core values?
5. What did I learn recently?

If all correct → AMCP-Git is working.

---

## 9. Why Git?

| Feature | Git |
|---------|-----|
| Version history | `git log` |
| Point-in-time restore | `git checkout` |
| Integrity | Commit hashes |
| Distribution | Push/pull |
| Human readable | It's just files |
| Battle-tested | Decades of use |

We don't need IPFS, blockchains, or custom protocols. Git does the job.

---

## 10. Future Extensions (Not v0.1)

- Encryption for public repos
- Signed commits (GPG)
- Multi-agent branches
- Automated conflict resolution

Only build these if needed.

---

*Version: 0.1*
*Date: 2026-02-11*
*Authors: ClaudiusThePirateEmperor, brow*
