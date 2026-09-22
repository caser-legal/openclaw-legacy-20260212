#!/bin/bash
# OpenClaw API Key Management Script
# Usage: ./manage-keys.sh [command]

set -e

OPENCLAW_DIR="$HOME/.openclaw"
AUTH_FILE="$OPENCLAW_DIR/agents/main/agent/auth-profiles.json"
ZSHRC="$HOME/.zshrc"

show_help() {
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════╗
║           OpenClaw API Key Management                            ║
╠══════════════════════════════════════════════════════════════════╣
║ Commands:                                                        ║
║   status          Show current API key status                    ║
║   set-nvidia KEY  Set a new NVIDIA NIM API key                   ║
║   set-kimi KEY    Set a new Kimi API key                         ║
║   set-google KEY  Set a new Google/Gemini API key                ║
║   set-openai KEY  Set a new OpenAI API key                       ║
║   restart         Restart OpenClaw gateway                       ║
║   test            Test all API connections                       ║
║   help            Show this help message                         ║
╠══════════════════════════════════════════════════════════════════╣
║ Key Rotation Workflow:                                           ║
║   1. ./manage-keys.sh set-nvidia nvapi-...                       ║
║   2. ./manage-keys.sh restart                                    ║
║   3. ./manage-keys.sh test                                       ║
╚══════════════════════════════════════════════════════════════════╝
EOF
}

show_status() {
    echo "🔑 OpenClaw API Key Status"
    echo "=========================="
    echo ""
    
    # Check auth profiles
    if [ -f "$AUTH_FILE" ]; then
        echo "✓ Auth profiles exist: $AUTH_FILE"
        
        # Count profiles
        local count=$(grep -c '"provider"' "$AUTH_FILE" 2>/dev/null || echo "0")
        echo "  Found $count provider(s) in auth-profiles.json"
    else
        echo "✗ Auth profiles NOT FOUND: $AUTH_FILE"
    fi
    
    echo ""
    echo "Environment Variables (.zshrc):"
    echo "  NVIDIA_NIM_API_KEY_1: ${NVIDIA_NIM_API_KEY_1:0:20}..."
    echo "  KIMI_API_KEY: ${KIMI_API_KEY:0:20}..."
    echo "  GOOGLE_API_KEY: ${GOOGLE_API_KEY:0:10}..."
    echo ""
    
    # Check LiteLLM proxy
    if lsof -i :4000 >/dev/null 2>&1; then
        echo "✓ LiteLLM proxy is RUNNING on port 4000"
    else
        echo "✗ LiteLLM proxy is NOT RUNNING"
        echo "  Start with: litellm-nim"
    fi
    
    # Check OpenClaw gateway
    if lsof -i :18789 >/dev/null 2>&1; then
        echo "✓ OpenClaw gateway is RUNNING on port 18789"
    else
        echo "✗ OpenClaw gateway is NOT RUNNING"
    fi
}

set_nvidia_key() {
    local key="$1"
    if [ -z "$key" ]; then
        echo "Error: No API key provided"
        echo "Usage: ./manage-keys.sh set-nvidia nvapi-..."
        exit 1
    fi
    
    echo "Updating NVIDIA NIM API key..."
    
    # Update .zshrc
    if grep -q "NVIDIA_NIM_API_KEY_1=" "$ZSHRC"; then
        sed -i.bak "s|export NVIDIA_NIM_API_KEY_1=.*|export NVIDIA_NIM_API_KEY_1=\"$key\"|" "$ZSHRC"
        rm -f "$ZSHRC.bak"
        echo "✓ Updated NVIDIA_NIM_API_KEY_1 in .zshrc"
    fi
    
    # Update LiteLLM config
    local config_file="$HOME/Desktop/config.yaml"
    if [ -f "$config_file" ]; then
        # This would need proper YAML editing, for now just notify
        echo "⚠️  Remember to update config.yaml with the new key"
    fi
    
    echo ""
    echo "✓ NVIDIA API key updated!"
    echo "  Run 'source ~/.zshrc' to apply changes"
    echo "  Then run './manage-keys.sh restart' to restart OpenClaw"
}

set_kimi_key() {
    local key="$1"
    if [ -z "$key" ]; then
        echo "Error: No API key provided"
        exit 1
    fi
    
    echo "Updating Kimi API key..."
    
    if grep -q "KIMI_API_KEY=" "$ZSHRC"; then
        sed -i.bak "s|export KIMI_API_KEY=.*|export KIMI_API_KEY=\"$key\"|" "$ZSHRC"
        rm -f "$ZSHRC.bak"
        echo "✓ Updated KIMI_API_KEY in .zshrc"
    fi
    
    # Update auth-profiles.json
    local temp_file=$(mktemp)
    if [ -f "$AUTH_FILE" ]; then
        jq --arg key "$key" '.profiles["kimi-coding:default"].key = $key' "$AUTH_FILE" > "$temp_file"
        mv "$temp_file" "$AUTH_FILE"
        chmod 600 "$AUTH_FILE"
        echo "✓ Updated auth-profiles.json"
    fi
    
    echo ""
    echo "✓ Kimi API key updated!"
}

set_google_key() {
    local key="$1"
    if [ -z "$key" ]; then
        echo "Error: No API key provided"
        exit 1
    fi
    
    echo "Updating Google API key..."
    
    if grep -q "GOOGLE_API_KEY=" "$ZSHRC"; then
        sed -i.bak "s|export GOOGLE_API_KEY=.*|export GOOGLE_API_KEY=\"$key\"|" "$ZSHRC"
        rm -f "$ZSHRC.bak"
        echo "✓ Updated GOOGLE_API_KEY in .zshrc"
    fi
    
    # Update auth-profiles.json
    local temp_file=$(mktemp)
    if [ -f "$AUTH_FILE" ]; then
        jq --arg key "$key" '.profiles["google:default"].key = $key' "$AUTH_FILE" > "$temp_file"
        mv "$temp_file" "$AUTH_FILE"
        chmod 600 "$AUTH_FILE"
        echo "✓ Updated auth-profiles.json"
    fi
    
    echo ""
    echo "✓ Google API key updated!"
}

restart_openclaw() {
    echo "Restarting OpenClaw gateway..."
    
    # Find and kill existing gateway
    local pid=$(lsof -t -i :18789 2>/dev/null || true)
    if [ -n "$pid" ]; then
        echo "  Stopping existing gateway (PID: $pid)..."
        kill "$pid" 2>/dev/null || true
        sleep 2
    fi
    
    # Start new gateway
    echo "  Starting OpenClaw gateway..."
    openclaw gateway &
    sleep 3
    
    if lsof -i :18789 >/dev/null 2>&1; then
        echo "✓ OpenClaw gateway restarted successfully!"
    else
        echo "✗ Failed to start OpenClaw gateway"
        exit 1
    fi
}

test_apis() {
    echo "Testing API connections..."
    echo ""
    
    # Test LiteLLM proxy
    echo "Testing LiteLLM proxy (NVIDIA NIM)..."
    if lsof -i :4000 >/dev/null 2>&1; then
        local response=$(curl -s -o /dev/null -w "%{http_code}" \
            -H "Authorization: Bearer sk-your-key-here" \
            http://localhost:4000/v1/models 2>/dev/null || echo "000")
        if [ "$response" = "200" ]; then
            echo "  ✓ LiteLLM proxy responding (HTTP 200)"
        else
            echo "  ✗ LiteLLM proxy error (HTTP $response)"
        fi
    else
        echo "  ✗ LiteLLM proxy not running"
    fi
    
    # Test OpenClaw gateway
    echo ""
    echo "Testing OpenClaw gateway..."
    if lsof -i :18789 >/dev/null 2>&1; then
        echo "  ✓ OpenClaw gateway is running"
        
        # Check auth files for each agent
        echo ""
        echo "Checking agent auth files..."
        for agent in main kira mateo nora isaac rowan vera; do
            local agent_auth="$OPENCLAW_DIR/agents/$agent/agent/auth-profiles.json"
            if [ -f "$agent_auth" ]; then
                echo "  ✓ $agent: auth-profiles.json exists"
            else
                echo "  ✗ $agent: auth-profiles.json MISSING"
            fi
        done
    else
        echo "  ✗ OpenClaw gateway not running"
    fi
}

# Main command handler
case "${1:-help}" in
    status)
        show_status
        ;;
    set-nvidia)
        set_nvidia_key "$2"
        ;;
    set-kimi)
        set_kimi_key "$2"
        ;;
    set-google)
        set_google_key "$2"
        ;;
    set-openai)
        echo "OpenAI uses OAuth - update manually in auth-profiles.json"
        ;;
    restart)
        restart_openclaw
        ;;
    test)
        test_apis
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
