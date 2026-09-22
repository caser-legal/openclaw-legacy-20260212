# Complete Workflow Guide - Your AI-Powered Mac

## 🗺️ What You Have

### 1. OpenClaw (`claw`)
**What:** AI agent system that runs background tasks  
**Where:** Port 18789  
**Uses:** Automated coding, audits, reports, Discord integration  
**Runs:** Always in background (auto-starts on login)

### 2. LiteLLM Proxy (`litellm`)
**What:** Connects to NVIDIA's free AI models  
**Where:** Port 4000  
**Uses:** Powers all your AI coding and agents  
**Runs:** Always in background (auto-starts on login)

### 3. Aider (`k`, `q`, `d`, etc.)
**What:** AI coding assistant (like Cursor but terminal-based)  
**Uses:** Write, edit, refactor code with AI  
**Modes:** Terminal (interactive) or Web (browser)

---

## 🚀 Daily Startup (Already Done!)

Both services auto-start when you log in via LaunchAgent:
- OpenClaw gateway
- LiteLLM proxy

**Check status anytime:**
```bash
claw-status      # Check AI agents
litellm-status   # Check AI models
```

---

## 💻 USE CASE 1: Coding a New Feature

**Scenario:** You want to build a new iOS app feature

```bash
# Navigate to your project
cd ~/Documents/iOS/MyApp

# Option A: Terminal coding (recommended for focused work)
k                    # Starts Kimi in terminal
# ... write code with AI ...
# Ctrl+C when done (LiteLLM keeps running)

# Option B: Browser coding (good for long sessions)
kimi-web-start       # Opens browser at localhost:8080
# ... close terminal, code in browser ...
kimi-web-stop        # Stop when done
```

**Inside aider (terminal):**
- Type what you want: "Add a login screen with SwiftUI"
- AI writes the code
- Review changes: `/diff`
- Accept: `/commit`
- Undo: `/undo`

---

## 🤖 USE CASE 2: Running AI Agents (OpenClaw)

**Scenario:** You want agents to audit your codebases

```bash
# Just open the TUI
claw

# Or check what agents are doing:
ls ~/.openclaw/workspace/reports/   # See latest reports
tail ~/.openclaw/logs/gateway.log   # See recent activity
```

**How it works:**
- Agents run on cron schedule (every 10 & 30 min)
- They read your docs, write reports, update queues
- Check Discord for their status updates
- Reports saved to `~/.openclaw/workspace/reports/`

---

## 🔄 USE CASE 3: Switching AI Models

**Scenario:** Kimi isn't working well, try another model

```bash
# Available shortcuts (all auto-start LiteLLM):
k    # Kimi K2.5 (best overall)
q    # Qwen3 Coder (great for code)
d    # DeepSeek V3.2 (good reasoning)
m    # Mistral Large (most powerful)
l    # Llama 3.3 70B (Meta's model)

# Or use full names:
aider-mistral-large ./my-project
aider-llama-4-maverick ./my-project

# See all options:
a    # Shows help menu
```

---

## 🛠️ USE CASE 4: Managing Services

**Check what's running:**
```bash
# Quick status
lsof -i :4000    # LiteLLM
lsof -i :18789   # OpenClaw
lsof -i :8080    # Kimi Web (if running)
```

**Restart if needed:**
```bash
# Individual services
litellm-stop && litellm-start
claw-stop && claw-start
kimi-web-stop

# Or full reset
claw-stop
litellm-stop
claw          # Restarts everything
```

---

## 📁 Key File Locations

| What | Where | Why You Care |
|------|-------|--------------|
| **API Keys** | `~/.zshrc` (lines 8-20) | Rotate when expired |
| **Agent Reports** | `~/.openclaw/workspace/reports/` | Read agent outputs |
| **Logs** | `~/.openclaw/logs/` | Debug issues |
| **LiteLLM Config** | `~/Desktop/config.yaml` | Add new models |
| **Agent Auth** | `~/.openclaw/agents/*/agent/auth-profiles.json` | Auto-copied |

---

## 📝 Common Commands Reference

### LiteLLM (AI Models)
```bash
litellm-start     # Start proxy
litellm-stop      # Stop proxy
litellm-status    # Check status
models            # List available models
```

### Aider (Coding)
```bash
k                 # Kimi terminal
kimi-start        # Same as above explicit
kimi-web-start    # Browser mode
kimi-web-stop     # Stop browser
```

### OpenClaw (Agents)
```bash
claw              # Start everything + TUI
claw-start        # Just start gateway
claw-stop         # Stop gateway
claw-status       # Check status
```

### Quick Shortcuts
```bash
k ./project       # Code with Kimi
q ./project       # Code with Qwen
a                 # Show help
```

---

## 🎯 Real Day Example

**Morning:**
```bash
# Check what agents did overnight
ls -lt ~/.openclaw/workspace/reports/ | head -5
cat ~/.openclaw/workspace/EXECUTION-QUEUE.md
```

**Coding Session:**
```bash
cd ~/Documents/iOS/MyApp
k
# /add Sources/Feature.swift
# "Add user authentication with Firebase"
# /commit
# Ctrl+C
```

**Afternoon:**
```bash
# Switch to stronger model for complex refactor
m ./MyApp
# "Refactor networking layer to use async/await"
```

**Check Agents:**
```bash
claw-status
# Agents are running audits automatically
```

---

## ⚠️ Troubleshooting

### "No API key found"
```bash
# Keys expired - update in ~/.zshrc
nano ~/.zshrc
# Edit lines 8-20
source ~/.zshrc
~/.openclaw/manage-keys.sh restart
```

### Port already in use
```bash
# Find and kill process
lsof -i :4000       # See what's using port
kill -9 <PID>       # Force kill if needed
litellm-start       # Restart
```

### Agents not responding
```bash
# Check logs
tail -50 ~/.openclaw/logs/gateway.log

# Restart
claw-stop && claw-start
```

---

## 🔐 API Key Rotation

**When a key expires:**

1. Edit `~/.zshrc` (lines 8-20)
2. Replace old key with new one
3. Save and run: `source ~/.zshrc`
4. Run: `~/.openclaw/manage-keys.sh restart`

**Backup keys location:**
```bash
# Primary: ~/.zshrc
# Per-agent: ~/.openclaw/agents/*/agent/auth-profiles.json
# (These auto-sync from main)
```

---

## 🎓 Tips

1. **Always keep LiteLLM running** - It powers everything
2. **Use `k` for most coding** - Kimi is best overall
3. **Use `claw` for agents** - Check in once per day
4. **Read reports** - Agents write to `~/.openclaw/workspace/reports/`
5. **Terminal can close** - Background services keep running

---

## 📊 What Runs Where

```
┌─────────────────────────────────────────┐
│  Your Terminal                          │
│  - k (interactive, close = stop)        │
│  - Commands to control services         │
└─────────────────────────────────────────┘
                   │
├─────────────────────────────────────────┤
│  Background Services (survive Cmd+Q)    │
│  - LiteLLM (port 4000)                  │
│  - OpenClaw (port 18789)                │
│  - Kimi Web (port 8080, if started)     │
└─────────────────────────────────────────┘
                   │
├─────────────────────────────────────────┤
│  External APIs                          │
│  - NVIDIA NIM (free models)             │
│  - Kimi (if configured)                 │
│  - Google Gemini (if configured)        │
└─────────────────────────────────────────┘
```
