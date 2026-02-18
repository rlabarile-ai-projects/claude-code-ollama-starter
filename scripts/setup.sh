#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# setup.sh — One-shot local environment bootstrap for Claude Code + Ollama
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
RESET="\033[0m"

info()    { echo -e "${GREEN}[INFO]${RESET} $*"; }
warn()    { echo -e "${YELLOW}[WARN]${RESET} $*"; }
error()   { echo -e "${RED}[ERROR]${RESET} $*"; exit 1; }
header()  { echo -e "\n${BOLD}$*${RESET}"; }

# ── 1. Load .env ─────────────────────────────────────────────────────────────
header "1. Loading environment"

if [ ! -f .env ]; then
  cp .env.example .env
  warn ".env not found — created from .env.example. Review it before continuing."
  echo "    Edit .env now and re-run setup.sh, or press ENTER to continue with defaults."
  read -r
fi

set -o allexport
source .env
set +o allexport
info "Loaded .env (model: ${OLLAMA_MODEL})"

# ── 2. Check prerequisites ────────────────────────────────────────────────────
header "2. Checking prerequisites"

check_cmd() {
  if command -v "$1" &>/dev/null; then
    info "$1 ✓"
  else
    error "$1 is not installed. Please install it and re-run."
  fi
}

check_cmd node
check_cmd npm
check_cmd ollama
check_cmd curl

NODE_VER=$(node -e "process.exit(parseInt(process.version.slice(1)) < 18 ? 1 : 0)" 2>&1 || true)
node -e "if(parseInt(process.version.slice(1)) < 18) process.exit(1)" \
  || error "Node.js 18+ required. Current: $(node -v)"
info "Node.js $(node -v) ✓"

# ── 3. Install Claude Code ────────────────────────────────────────────────────
header "3. Installing Claude Code"

if command -v claude &>/dev/null; then
  CURRENT_VER=$(claude --version 2>/dev/null || echo "unknown")
  info "Claude Code already installed ($CURRENT_VER) — skipping."
else
  npm install -g @anthropic-ai/claude-code
  info "Claude Code installed ✓"
fi

# ── 4. Pull Ollama model ──────────────────────────────────────────────────────
header "4. Pulling Ollama model: ${OLLAMA_MODEL}"

if [ "${AUTO_PULL_MODEL:-true}" = "true" ]; then
  if ollama list | grep -q "^${OLLAMA_MODEL}"; then
    info "Model '${OLLAMA_MODEL}' already present — skipping pull."
  else
    info "Pulling ${OLLAMA_MODEL} (this may take a few minutes)..."
    ollama pull "${OLLAMA_MODEL}"
    info "Model pulled ✓"
  fi
else
  warn "AUTO_PULL_MODEL=false — skipping model pull. Make sure '${OLLAMA_MODEL}' is available."
fi

# ── 5. Verify Ollama connectivity ─────────────────────────────────────────────
header "5. Verifying Ollama connection"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "${OLLAMA_BASE_URL}/api/tags" || true)
if [ "$HTTP_CODE" = "200" ]; then
  info "Ollama is reachable at ${OLLAMA_BASE_URL} ✓"
else
  warn "Ollama didn't respond as expected (HTTP ${HTTP_CODE}). Make sure 'ollama serve' is running."
fi

# ── 6. Export env for Claude Code ─────────────────────────────────────────────
header "6. Shell environment summary"

cat <<EOF

Add these exports to your shell session (or run: source .env.sh):

  export ANTHROPIC_BASE_URL="${OLLAMA_BASE_URL}"
  export ANTHROPIC_AUTH_TOKEN="ollama"
  export ANTHROPIC_API_KEY=""

Then start Claude Code with:

  claude --model ${OLLAMA_MODEL}

EOF

# Write a convenience source file
cat > .env.sh <<ENVSH
export ANTHROPIC_BASE_URL="${OLLAMA_BASE_URL}"
export ANTHROPIC_AUTH_TOKEN="ollama"
export ANTHROPIC_API_KEY=""
export OLLAMA_MODEL="${OLLAMA_MODEL}"
ENVSH

info "Wrote .env.sh — run 'source .env.sh' then 'claude --model \${OLLAMA_MODEL}'"
echo -e "\n${GREEN}${BOLD}Setup complete!${RESET}\n"
