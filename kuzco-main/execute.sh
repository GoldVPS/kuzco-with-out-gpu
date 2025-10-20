#!/usr/bin/env bash
set -euo pipefail

# ===== validasi env wajib =====
: "${CODE:?CODE is required (Worker code from Inference dashboard)}}"
: "${HYPERBOLIC_API_KEY:?HYPERBOLIC_API_KEY is required}}"
: "${BASE_URL:=https://api.hyperbolic.xyz/v1/openai}"
: "${DEFAULT_MODEL:=llama-3.2-3b-instruct}"
: "${UPSTREAM_MODEL_SLUG:=meta-llama/Llama-3.2-3B-Instruct}"

echo "[proxy] building config for LiteLLM → Hyperbolic: $BASE_URL  model=${UPSTREAM_MODEL_SLUG}"

# ===== tulis config proxy (OpenAI-compatible) =====
cat > /app/config.yaml <<YAML
model_list:
  - model_name: ${DEFAULT_MODEL}
    litellm_params:
      # gunakan provider=openai agar LiteLLM bicara dengan protokol OpenAI
      model: openai/${UPSTREAM_MODEL_SLUG}
      api_base: ${BASE_URL}
      api_key: ${HYPERBOLIC_API_KEY}
      # opsi tambahan (opsional):
      # timeout: 30
      # max_output_tokens: 128
YAML

# ===== start LiteLLM proxy di :14444 =====
echo "[proxy] starting LiteLLM on :14444 ..."
nohup litellm --port 14444 --config /app/config.yaml > /app/proxy.log 2>&1 &
sleep 1

# ===== start Kuzco node =====
echo "[kuzco] starting inference node with CODE=${CODE}"
exec inference node start --code "${CODE}"
