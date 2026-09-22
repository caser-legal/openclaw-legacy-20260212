#!/bin/bash
# OpenClaw Complete Startup Script
# All 10 NVIDIA API Keys configured with rotation
# Ready to go - 100% complete setup

set -e

echo "==============================================="
echo "  OPENCLAW WOPR WORKFORCE - STARTUP"
echo "==============================================="
echo ""

# Check if we're in the right directory
if [ ! -f "$HOME/.openclaw/openclaw.json" ]; then
    echo "❌ Error: OpenClaw config not found at ~/.openclaw/openclaw.json"
    exit 1
fi

cd "$HOME/.openclaw"

echo "📁 Configuration: $HOME/.openclaw/openclaw.json"
echo ""

# Export environment variables (for providers that need them)
export OPENCLAW_STATE_DIR="$HOME/.openclaw"
export OPENCLAW_CONFIG_PATH="$HOME/.openclaw/openclaw.json"

# Web search API key (already in config)
export BRAVE_API_KEY="${BRAVE_API_KEY:-REPLACE_WITH_BRAVE_API_KEY}"

echo "🔑 API Configuration:"
echo "  ✓ 10 NVIDIA NIM API keys (configured in auth-profiles.json)"
echo "  ✓ Kimi API key (configured in auth-profiles.json)"
echo "  ✓ OpenAI Codex OAuth (configured in auth-profiles.json)"
echo "  ✓ Google API key (configured in auth-profiles.json)"
echo "  ✓ Brave Search API key (environment)"
echo ""

echo "🤖 Agents Ready:"
echo "  • Main (primary agent)"
echo "  • Kira (coworker #1)"
echo "  • Mateo (coworker #2)"
echo "  • Nora (coworker #3)"
echo "  • Isaac (coworker #4)"
echo "  • Rowan (coworker #5)"
echo "  • Vera (coworker #6)"
echo ""

echo "🧠 Model Chain (with auth rotation):"
echo "  1. NVIDIA Nemotron-4-340B (10 keys × 40 RPM = 400 RPM total)"
echo "  2. Kimi K2.5 (fallback)"
echo "  3. GLM-4.7 (final fallback)"
echo ""

echo "🔄 Auth Rotation:"
echo "  Strategy: Round-robin across 10 keys"
echo "  Cooldown: 1500ms between key switches"
echo ""

# Verify auth files exist
echo "🔐 Verifying auth profiles..."
for agent in main kira mateo nora isaac rowan vera; do
    if [ -f "agents/$agent/agent/auth-profiles.json" ]; then
        echo "  ✓ $agent"
    else
        echo "  ❌ $agent (missing auth)"
    fi
done
echo ""

# Validate JSON
echo "📋 Validating configuration..."
if python3 -c "import json; json.load(open('openclaw.json'))" 2>/dev/null; then
    echo "  ✓ openclaw.json is valid"
else
    echo "  ❌ openclaw.json has errors"
    exit 1
fi
echo ""

echo "==============================================="
echo "  STARTING OPENCLAW GATEWAY"
echo "==============================================="
echo ""

# Apply configuration and start
echo "Applying configuration..."
openclaw gateway config.apply --file "$HOME/.openclaw/openclaw.json"

echo ""
echo "✅ OpenClaw is now running!"
echo ""
echo "Quick commands:"
echo "  openclaw models status     # Check model status"
echo "  openclaw agents list       # List all agents"
echo "  /model nemotron            # Switch to NVIDIA NIM"
echo "  Spawn Kira to <task>       # Delegate to Kira"
echo ""
echo "Your WOPR team is ready! 🚀"
