# OpenClaw Setup Summary

## ✅ What Was Fixed

### 1. Missing Agent Directories (CRITICAL)
**Problem:** Agents in `openclaw.json` pointed to `agentDir` paths that didn't exist, causing:
```
Error: All models failed - No API key found for provider
```

**Solution:** Created all missing directories:
- `~/.openclaw/agents/{main,kira,mateo,nora,isaac,rowan,vera}/agent/`
- `~/.openclaw/agents/{main,kira,mateo,nora,isaac,rowan,vera}/sessions/`
- Copied `auth-profiles.json` to each agent

### 2. Missing NVIDIA/NIM Provider Configuration
**Problem:** OpenClaw didn't know about your LiteLLM proxy for NVIDIA NIM.

**Solution:** Added to `openclaw.json`:
```json
"nvidia-nim:local": {
  "provider": "nvidia-nim",
  "mode": "api_key",
  "baseUrl": "http://localhost:4000",
  "apiKey": "sk-your-key-here"
}
```

### 3. Centralized API Key Management
**Problem:** API keys were scattered and hard to rotate.

**Solution:** Added to `.zshrc`:
```bash
export NVIDIA_NIM_API_KEY_1="..."
export NVIDIA_NIM_API_KEY_2="..."
export NVIDIA_NIM_API_KEY_3="..."
export KIMI_API_KEY="..."
export GOOGLE_API_KEY="..."
```

---

## 🚀 Quick Start Commands

### Check Status
```bash
~/.openclaw/manage-keys.sh status
```

### Start LiteLLM Proxy (NVIDIA NIM)
```bash
litellm-nim
```

### Restart OpenClaw Gateway
```bash
~/.openclaw/manage-keys.sh restart
```

### Test All APIs
```bash
~/.openclaw/manage-keys.sh test
```

### Rotate API Key (Example: NVIDIA)
```bash
~/.openclaw/manage-keys.sh set-nvidia nvapi-YOUR_NEW_KEY_HERE
source ~/.zshrc
~/.openclaw/manage-keys.sh restart
```

---

## 📁 Where Everything Lives

| File/Dir | Purpose | Edit When |
|----------|---------|-----------|
| `~/.openclaw/openclaw.json` | Main config, agents, models | Adding agents/models |
| `~/.openclaw/agents/*/agent/auth-profiles.json` | API keys per agent | Rotating keys |
| `~/.zshrc` | Environment variables, API keys | Key rotation, new shells |
| `~/Desktop/config.yaml` | LiteLLM proxy config | Adding NIM models |
| `~/.openclaw/cron/jobs.json` | Scheduled agent tasks | Modifying cron jobs |
| `~/.openclaw/workspace/` | Agent workspaces, reports | Daily work |

---

## 🔄 API Key Rotation Workflow

### When a Key Expires:

1. **Update `.zshrc`** (central reference):
   ```bash
   # Edit the key
   export NVIDIA_NIM_API_KEY_1="nvapi-your-key"
   ```

2. **Reload environment**:
   ```bash
   source ~/.zshrc
   ```

3. **Update auth files** (use helper script):
   ```bash
   ~/.openclaw/manage-keys.sh set-nvidia nvapi-your-key
   ```

4. **Restart services**:
   ```bash
   litellm-stop && litellm-nim
   ~/.openclaw/manage-keys.sh restart
   ```

5. **Verify**:
   ```bash
   ~/.openclaw/manage-keys.sh test
   ```

---

## 👥 Agent Configuration

| Agent | Model | Workspace | Purpose |
|-------|-------|-----------|---------|
| main | nvidia-nim/moonshotai-kimi-k2.5 | `workspace/` | Primary agent |
| kira | kimi-coding/k2p5 | `workspace/agents/kira/` | Strategy Engineer 🧭 |
| mateo | kimi-coding/k2p5 | `workspace/agents/mateo/` | Risk Analyst 🛡️ |
| nora | google/gemini-3-flash-preview | `workspace/agents/nora/` | Systems Strategist 🧠 |
| isaac | google/gemini-3-flash-preview | `workspace/agents/isaac/` | QA Architect ✅ |
| rowan | openai-codex/gpt-5.3-codex | `workspace/agents/rowan/` | Implementation Lead 🛠️ |
| vera | openrouter/z-ai/glm-4.7 | `workspace/agents/vera/` | Code Reviewer 🔍 |

---

## 🐛 Troubleshooting

### "No API key found for provider"
```bash
# Check auth files exist
ls -la ~/.openclaw/agents/*/agent/auth-profiles.json

# If missing, copy from main
for agent in kira mateo nora isaac rowan vera; do
    cp ~/.openclaw/agents/main/agent/auth-profiles.json \
        ~/.openclaw/agents/$agent/agent/auth-profiles.json
done
```

### "Model not allowed" or similar
```bash
# Check if LiteLLM proxy is running
litellm-status

# Restart if needed
litellm-stop && litellm-nim
```

### Agents not spawning
```bash
# Check cron job errors
cat ~/.openclaw/cron/jobs.json | jq '.jobs[].state'

# Check gateway logs
tail -100 ~/.openclaw/logs/gateway.log
```

---

## 📝 Notes

### Why `.zshrc` AND `auth-profiles.json`?

- **`.zshrc`**: Central reference for YOU to easily see/change keys
- **`auth-profiles.json`**: What OpenClaw actually reads for each agent
- **Helper script** (`manage-keys.sh`): Syncs between them

### LiteLLM Proxy Architecture

```
Your Agents → OpenClaw → LiteLLM Proxy (port 4000) → NVIDIA NIM API
                ↓
            Kimi/Google/OpenAI (direct)
```

### Security

- All `auth-profiles.json` files have `chmod 600` (user-only access)
- API keys in `.zshrc` are not committed to git
- Each agent has its own auth file (can have different keys if needed)

---

## ✅ Verification Checklist

Run these to verify everything works:

```bash
# 1. Check all files exist
ls ~/.openclaw/agents/*/agent/auth-profiles.json

# 2. Check LiteLLM proxy
litellm-status

# 3. Check OpenClaw gateway  
lsof -i :18789

# 4. Run full test
~/.openclaw/manage-keys.sh test

# 5. Check cron jobs
~/.openclaw/manage-keys.sh status
```

---

## 🎯 Next Steps

1. **Source your updated `.zshrc`**:
   ```bash
   source ~/.zshrc
   ```

2. **Start LiteLLM proxy** (if not running):
   ```bash
   litellm-nim
   ```

3. **Restart OpenClaw**:
   ```bash
   ~/.openclaw/manage-keys.sh restart
   ```

4. **Wait for cron jobs to run** (every 10 and 30 minutes) or trigger manually:
   ```bash
   # Check cron runs
   ls -la ~/.openclaw/cron/runs/
   ```

5. **Verify agents work** by checking Discord for status updates!
