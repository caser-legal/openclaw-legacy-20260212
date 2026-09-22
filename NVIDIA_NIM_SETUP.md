# NVIDIA NIM Setup for OpenClaw

## ✅ Setup Complete

NVIDIA NIM has been configured in your OpenClaw installation at `~/.openclaw/openclaw.json`.

## 🔑 Get Your API Key

1. Visit https://build.nvidia.com
2. Sign up/login with your NVIDIA account
3. Navigate to **Settings → API Keys**
4. Generate a new API key
5. Copy the key (starts with `nvapi-`)

## 🔧 Configuration Options

### Option 1: Environment Variable (Recommended)

Add to your shell profile (`~/.zshrc`, `~/.bashrc`, etc.):

```bash
export NVIDIA_API_KEY="nvapi-your-key-here"
```

Then reload:
```bash
source ~/.zshrc  # or ~/.bashrc
```

### Option 2: Direct API Key in Config

Edit `~/.openclaw/openclaw.json` and replace:
```json
"apiKey": "${env.NVIDIA_API_KEY}"
```

With:
```json
"apiKey": "nvapi-your-actual-key-here"
```

⚠️ **Security Note:** Using environment variables is more secure as it keeps keys out of config files.

## 🚀 Available Models

| Alias | Full Model ID | Context | Max Tokens | Reasoning |
|-------|--------------|---------|------------|-----------|
| `nemotron` | nvidia/nemotron-4-340b-instruct | 128K | 8192 | ✅ |
| `llama-405b` | meta/llama-3.1-405b-instruct | 128K | 4096 | ❌ |
| `llama-70b` | meta/llama-3.1-70b-instruct | 128K | 4096 | ❌ |
| `kimi-nvidia` | moonshotai/kimi-k2.5 | 256K | 8192 | ✅ |
| `deepseek-r1` | deepseek-ai/deepseek-r1 | 128K | 8192 | ✅ |

## 🎯 Usage

### Switch to a NVIDIA model:
```bash
/model nemotron
# or
openclaw models set nvidia/nvidia/nemotron-4-340b-instruct
```

### List all models:
```bash
openclaw models list
```

### Use in a specific agent:
Edit an agent's config to use a NVIDIA model as its default.

## 🔄 Apply Configuration

After setting your API key, apply the config:

```bash
openclaw gateway config.apply --file ~/.openclaw/openclaw.json
```

Or ask OpenClaw:
```
Apply my config changes and restart the gateway
```

## 🧪 Test the API

Test directly with curl:
```bash
curl https://integrate.api.nvidia.com/v1/chat/completions \
  -H "Authorization: Bearer $NVIDIA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "nvidia/nemotron-4-340b-instruct",
    "messages": [{"role": "user", "content": "Hello!"}],
    "max_tokens": 1024
  }'
```

## 📚 API Details

- **Base URL:** `https://integrate.api.nvidia.com/v1`
- **API Type:** OpenAI-compatible (`openai-completions`)
- **Endpoint:** `/v1/chat/completions`
- **Free Tier:** 1,000 credits upon signup (each credit = 1 inference call)

## 🔍 Troubleshooting

| Issue | Solution |
|-------|----------|
| "model not allowed" | Check model is in `agents.defaults.models` with correct `nvidia/model-id` format |
| "Unauthorized" | Verify your API key is set correctly in `NVIDIA_API_KEY` env var |
| 404 errors | The endpoint should be exactly `https://integrate.api.nvidia.com/v1` |
| Model not in list | Run `openclaw models list` after applying config |

## 📖 References

- [NVIDIA NIM Documentation](https://developer.nvidia.com/nim)
- [Build.nvidia.com Models](https://build.nvidia.com/models)
- [OpenClaw Custom Provider Guide](https://haimaker.ai/blog/posts/integrating-custom-llm-providers-with-clawdbot)
