# OpenClaw (sanitized snapshot)

This tree is a leftover OpenClaw workspace with machine credentials, device identity, session logs, and config backups removed. It is not a runnable copy of someone else's agent.

## Set up your own OpenClaw

1. Install OpenClaw using the upstream installer. Do not reuse another machine's `identity/` or `devices/` directory.
2. Create a new config file on your machine (the gateway's `openclaw.json`). Put API keys only in that local file or in your environment.
3. Optional shell completions live in `completions/`. They are command help, not secrets.
4. Per-agent model files under `agents/*/agent/models.json` ship with `YOUR_API_KEY`. Replace that on your machine and do not commit the result.
5. `manage-keys.sh` expects your own key material. The copy in git has placeholders only.
6. Never commit `credentials/`, `identity/`, `devices/paired.json`, `memory/*.sqlite`, session JSONL, gateway logs, or config backups.

If a file asks for a Slack bot token, the value looks like a token prefix plus your own secret from Slack. Generate a new one. Do not paste a token into git.
