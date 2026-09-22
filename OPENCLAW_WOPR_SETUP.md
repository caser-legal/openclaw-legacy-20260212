# OpenClaw WOPR Multi-Agent Setup

## Overview

All agents are now identical **WOPR clones** - same capabilities, same model, no specialties.

## Model Chain Configuration

### Primary: NVIDIA NIM
- **Model:** `nvidia/nemotron-4-340b-instruct` (alias: `nemotron`)
- **Endpoint:** `https://integrate.api.nvidia.com/v1`
- **Limit:** 40 RPM (requests per minute) across all keys
- **Cost:** FREE (no quota, just rate limit)

### Fallback 1: Kimi (Moonshot AI)
- **Model:** `kimi-coding/k2p5` (alias: `kimi`)
- **Used when:** NVIDIA NIM hits 40 RPM limit

### Fallback 2: GLM (Z.AI)
- **Model:** `openrouter/z-ai/glm-4.7` (alias: `glm`)
- **Used when:** Both NVIDIA and Kimi are unavailable

## Agents

All agents use the same configuration:

| Agent ID | Purpose | Model |
|----------|---------|-------|
| `main` | Primary agent | NVIDIA NIM → Kimi → GLM |
| `wopr-1` | Clone #1 | NVIDIA NIM → Kimi → GLM |
| `wopr-2` | Clone #2 | NVIDIA NIM → Kimi → GLM |
| `wopr-3` | Clone #3 | NVIDIA NIM → Kimi → GLM |
| `wopr-4` | Clone #4 | NVIDIA NIM → Kimi → GLM |
| `wopr-5` | Clone #5 | NVIDIA NIM → Kimi → GLM |
| `wopr-6` | Clone #6 | NVIDIA NIM → Kimi → GLM |

## Identity

All agents share the same identity files:
- **SOUL.md** - WOPR core identity (strategic machine partner)
- **AGENTS.md** - Behavior guidelines
- **TOOLS.md** - Tool references

Each agent has its own:
- **USER.md** - User preferences
- **HEARTBEAT.md** - Periodic tasks
- **memory/** - Session memory

## Environment Variables Required

```bash
# Required for NVIDIA NIM (primary)
export NVIDIA_API_KEY="nvapi-your-key-here"

# Kimi API key (fallback 1)
export KIMI_API_KEY="your-kimi-key"

# OpenRouter API key (fallback 2 - for GLM)
export OPENROUTER_API_KEY="your-openrouter-key"
```

## Usage

### Switch models manually:
```bash
/model nemotron          # Use NVIDIA NIM
/model kimi              # Use Kimi
/model glm               # Use GLM via OpenRouter
```

### Spawn a sub-agent:
```
Spawn wopr-3 to analyze the codebase while I continue here
```

### List all agents:
```bash
openclaw agents list
```

### Cross-agent spawning enabled:
All agents can spawn sub-agents under any other agent ID.

## Rate Limiting Strategy

Since NVIDIA NIM has a 40 RPM limit:

1. **Normal usage:** Primary uses NVIDIA NIM
2. **Hit rate limit:** Automatically falls back to Kimi
3. **Both busy:** Falls back to GLM
4. **Sub-agents:** Also use the same chain

## Removed Components

- ❌ Google/Gemini (no longer used)
- ❌ Specialty agents (kira, mateo, nora, isaac, rowan, vera)
- ❌ Different agent themes/identities

## File Structure

```
~/.openclaw/
├── openclaw.json          # Main config
├── agents/
│   ├── main/              # Primary agent
│   ├── wopr-1/            # Clone 1
│   ├── wopr-2/            # Clone 2
│   ├── wopr-3/            # Clone 3
│   ├── wopr-4/            # Clone 4
│   ├── wopr-5/            # Clone 5
│   └── wopr-6/            # Clone 6
└── workspace/
    ├── AGENTS.md          # Shared
    ├── SOUL.md            # Shared (WOPR identity)
    ├── TOOLS.md           # Shared
    └── agents/
        ├── wopr-1/        # Clone 1 workspace
        ├── wopr-2/        # Clone 2 workspace
        ...
```

## Backup

Old specialty agents backed up to:
- `agents-backup-YYYYMMDD_HHMMSS.tar.gz`
- `openclaw.json.backup.YYYYMMDD_HHMMSS`

## Apply Configuration

```bash
# Set your NVIDIA API key
export NVIDIA_API_KEY="nvapi-your-key-here"

# Apply config
openclaw gateway config.apply --file ~/.openclaw/openclaw.json

# Or ask OpenClaw:
# "Apply my config and restart the gateway"
```

## Verification

```bash
# Check model status
openclaw models status

# List available models
openclaw models list

# Check agent list
openclaw agents list --bindings
```
