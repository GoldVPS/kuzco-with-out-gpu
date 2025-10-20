FROM debian:stable-slim

# ---- deps dasar
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates python3 python3-pip git procps lsof tini \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# ---- install CLI Inference (Kuzco)
# (script resmi devnet inference)
RUN curl -fsSL https://devnet.inference.net/install.sh | sh

# ---- install LiteLLM (proxy OpenAI-compatible)
RUN pip3 install --no-cache-dir "litellm[proxy]" uvicorn

# ---- file runtime
COPY ./execute.sh /app/execute.sh
RUN chmod +x /app/execute.sh

# ---- default command
ENTRYPOINT ["/usr/bin/tini","--"]
CMD ["/app/execute.sh"]
