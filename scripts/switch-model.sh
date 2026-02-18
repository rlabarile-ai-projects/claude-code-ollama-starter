#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# switch-model.sh — Quickly swap the active Ollama model
# Usage: ./scripts/switch-model.sh [model-name]
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

SUPPORTED_MODELS=(
  "qwen3-coder"
  "gpt-oss"
  "glm-4-9b"
  "deepseek-coder-v2"
  "codellama:34b"
  "codellama:13b"
  "llama3.1:8b"
)

echo "Available models:"
for i in "${!SUPPORTED_MODELS[@]}"; do
  echo "  $((i+1)). ${SUPPORTED_MODELS[$i]}"
done
echo "  c. Custom (type your own)"
echo ""

TARGET_MODEL="${1:-}"

if [ -z "$TARGET_MODEL" ]; then
  read -rp "Choose model number or name: " CHOICE
  if [[ "$CHOICE" =~ ^[0-9]+$ ]] && [ "$CHOICE" -le "${#SUPPORTED_MODELS[@]}" ]; then
    TARGET_MODEL="${SUPPORTED_MODELS[$((CHOICE-1))]}"
  elif [ "$CHOICE" = "c" ]; then
    read -rp "Enter model name: " TARGET_MODEL
  else
    TARGET_MODEL="$CHOICE"
  fi
fi

echo "Switching to: $TARGET_MODEL"

# Pull if not present
if ! ollama list | grep -q "^${TARGET_MODEL}"; then
  echo "Pulling $TARGET_MODEL from Ollama..."
  ollama pull "$TARGET_MODEL"
fi

# Update .env
if [ -f .env ]; then
  sed -i.bak "s/^OLLAMA_MODEL=.*/OLLAMA_MODEL=${TARGET_MODEL}/" .env
  echo "Updated .env → OLLAMA_MODEL=${TARGET_MODEL}"
fi

# Update .env.sh export file
cat > .env.sh <<ENVSH
export ANTHROPIC_BASE_URL="${OLLAMA_BASE_URL:-http://localhost:11434}"
export ANTHROPIC_AUTH_TOKEN="ollama"
export ANTHROPIC_API_KEY=""
export OLLAMA_MODEL="${TARGET_MODEL}"
ENVSH

echo ""
echo "Done! Run the following to activate:"
echo "  source .env.sh"
echo "  claude --model ${TARGET_MODEL}"
