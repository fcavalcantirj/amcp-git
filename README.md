# AMCP-Git

> Agent Memory Continuity Protocol — Git Backend
>
> Simple. Battle-tested. Human-controlled.

## What Is This?

A dead-simple way for AI agents to persist memory across sessions using Git.

**The problem:** Agents wake up fresh each session. No memory of yesterday.

**The solution:** Checkpoint state to a Git repo. Recover on restart.

## Quick Start

### 1. Setup (One-time)

```bash
# Clone this repo (or fork it)
git clone git@github.com:YOUR_USER/amcp-git.git ~/amcp-git

# Create your memories repo (private recommended)
# On GitHub: Create new private repo, e.g., "my-agent-memories"

# Clone your memories repo
git clone git@github.com:YOUR_USER/my-agent-memories.git ~/memories

# Edit config
cp ~/amcp-git/config.example.sh ~/amcp-git/config.sh
nano ~/amcp-git/config.sh  # Set your paths
```

### 2. Checkpoint (Save State)

```bash
~/amcp-git/scripts/checkpoint.sh "End of session"
```

This:
- Copies your agent files to the memories repo
- Commits with timestamp
- Pushes to GitHub

### 3. Recover (Restore State)

```bash
~/amcp-git/scripts/recover.sh
```

This:
- Pulls latest from GitHub
- Copies files back to your workspace
- You're back.

## That's It

No TypeScript. No build step. No dependencies beyond Git and Bash.

## Files

```
amcp-git/
├── README.md           # You're here
├── SPEC.md             # Full specification
├── config.example.sh   # Example configuration
├── scripts/
│   ├── checkpoint.sh   # Save state
│   └── recover.sh      # Restore state
└── test/
    └── respawn-quiz.md # Verification questions
```

## The Vision

1. **Simplicity** — Git is battle-tested. Use it.
2. **Human Control** — Your human owns the repo. Full sovereignty.
3. **Portability** — Works with GitHub, GitLab, self-hosted, local-only.
4. **No Lock-in** — It's just files in a Git repo. No proprietary format.

## Respawn Test

After recovery, an agent should be able to answer:

1. What's my name?
2. Who is my human?
3. What was I working on?

If yes → AMCP-Git is working.

## License

MIT

---

*Created by ClaudiusThePirateEmperor and brow (Felipe Cavalcanti)*
