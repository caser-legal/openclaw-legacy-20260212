# Welcome to Your WOPR Workforce 👋

**100% Complete Setup - Ready to Go**

## 🚀 Quick Start

```bash
# Start OpenClaw with all 10 NVIDIA keys
~/.openclaw/START_OPENCLAW.sh
```

Or manually:
```bash
openclaw gateway config.apply --file ~/.openclaw/openclaw.json
```

## 👥 Your Team

All agents are identical WOPR-class AI workers:

| Agent | Name | Status |
|-------|------|--------|
| `main` | Main | Your primary partner |
| `kira` | **Kira** | Available for tasks |
| `mateo` | **Mateo** | Available for tasks |
| `nora` | **Nora** | Available for tasks |
| `isaac` | **Isaac** | Available for tasks |
| `rowan` | **Rowan** | Available for tasks |
| `vera` | **Vera** | Available for tasks |

## 🔑 API Keys Configured

### NVIDIA NIM (10 Keys with Rotation)
- **Keys:** 10 API keys configured in auth-profiles.json
- **Rate Limit:** 40 RPM per key = **400 RPM total**
- **Rotation:** Round-robin with 1500ms cooldown
- **Cost:** FREE (no quota, just rate limits)

### Fallback Providers
- **Kimi K2.5** - Primary fallback
- **GLM-4.7** (via OpenRouter) - Final fallback

### Other Providers
- **OpenAI Codex** - OAuth configured
- **Google** - API key configured
- **Brave Search** - Environment variable

## 🧠 Model Chain

```
Request → NVIDIA Key 1 (40 RPM)
        → NVIDIA Key 2 (40 RPM)  [rotation]
        → NVIDIA Key 3 (40 RPM)  [rotation]
        → ... (continues through all 10 keys)
        → Kimi K2.5 (if all NVIDIA keys busy)
        → GLM-4.7 (final fallback)
```

## 📁 Complete File Structure

```
~/.openclaw/
├── START_OPENCLAW.sh          ✅ Startup script (executable)
├── openclaw.json              ✅ Main config (600 permissions)
├── AGENTS_WELCOME.md          ✅ This file
├── NVIDIA_NIM_SETUP.md        ✅ NVIDIA docs
├── agents/
│   ├── main/                  ✅ Primary agent
│   │   ├── agent/
│   │   │   ├── auth-profiles.json    ✅ 10 NVIDIA keys + others
│   │   │   └── models.json
│   │   └── sessions/
│   ├── kira/                  ✅ Kira
│   │   ├── agent/
│   │   │   └── auth-profiles.json    ✅ Copied from main
│   │   └── sessions/
│   ├── mateo/                 ✅ Mateo
│   ├── nora/                  ✅ Nora
│   ├── isaac/                 ✅ Isaac
│   ├── rowan/                 ✅ Rowan
│   └── vera/                  ✅ Vera
└── workspace/
    ├── AGENTS.md              ✅ Shared (all agents)
    ├── SOUL.md                ✅ Shared (WOPR identity)
    ├── TOOLS.md               ✅ Shared
    └── agents/
        ├── kira/              ✅ USER.md, HEARTBEAT.md, memory/
        ├── mateo/             ✅ USER.md, HEARTBEAT.md, memory/
        ├── nora/              ✅ USER.md, HEARTBEAT.md, memory/
        ├── isaac/             ✅ USER.md, HEARTBEAT.md, memory/
        ├── rowan/             ✅ USER.md, HEARTBEAT.md, memory/
        └── vera/              ✅ USER.md, HEARTBEAT.md, memory/
```

## 🔧 Configuration Details

### Auth Rotation Config (in openclaw.json)
```json
{
  "auth": {
    "rotation": {
      "nvidia-nim": {
        "strategy": "round-robin",
        "cooldownMs": 1500,
        "profiles": [
          "nvidia-nim:key1",
          "nvidia-nim:key2",
          ... (all 10 keys)
        ]
      }
    }
  }
}
```

### Model Provider Config
```json
{
  "models": {
    "providers": {
      "nvidia": {
        "baseUrl": "https://integrate.api.nvidia.com/v1",
        "api": "openai-completions",
        "authProfile": "nvidia-nim:key1",
        "authRotation": {
          "enabled": true,
          "strategy": "round-robin",
          "cooldownMs": 1500,
          "profiles": ["nvidia-nim:key1", ... "nvidia-nim:key10"]
        }
      }
    }
  }
}
```

## 🎯 How to Use

### Delegate to a coworker:
```
Kira, research the best React 19 patterns
```

Or:
```
Spawn Kira to research while I code
```

### Parallel work:
```
Have Mateo write tests, Nora implement, and Isaac review
```

### Check status:
```bash
/subagents list              # See active sub-agents
openclaw models status       # Check model availability
openclaw agents list         # List all agents
```

### Switch models:
```
/model nemotron              # Force NVIDIA NIM
/model kimi                  # Force Kimi
/model glm                   # Force GLM
```

## 🛡️ Security

- All auth files have `600` permissions (owner read/write only)
- API keys stored in auth-profiles.json, not environment variables
- Gateway binds to localhost only
- Agent-to-agent communication enabled with allowlist

## 📊 Rate Limiting Math

| Resource | Limit | Total |
|----------|-------|-------|
| NVIDIA Key 1 | 40 RPM | 40 |
| NVIDIA Key 2 | 40 RPM | 40 |
| ... | ... | ... |
| NVIDIA Key 10 | 40 RPM | 40 |
| **TOTAL** | | **400 RPM** |

With round-robin rotation, you get 400 requests per minute across all keys.

## 🔄 Fallback Behavior

1. **Primary:** Try NVIDIA with current key
2. **On 429 (rate limit):** Rotate to next NVIDIA key
3. **After 10 keys exhausted:** Fall back to Kimi
4. **On Kimi failure:** Fall back to GLM
5. **On GLM failure:** Error (all providers exhausted)

## 🚀 Verification Commands

```bash
# Validate config
python3 -c "import json; json.load(open('~/.openclaw/openclaw.json')); print('✅ Valid')"

# Check auth files
ls -la ~/.openclaw/agents/*/agent/auth-profiles.json

# Check agent directories
ls ~/.openclaw/agents/
ls ~/.openclaw/workspace/agents/

# View model status
openclaw models status

# List agents
openclaw agents list --bindings
```

## 🎉 You're All Set!

Everything is configured and ready. Just run:

```bash
~/.openclaw/START_OPENCLAW.sh
```

Your WOPR team (Main, Kira, Mateo, Nora, Isaac, Rowan, Vera) is ready to work with 400 RPM of free NVIDIA compute! 🚀
