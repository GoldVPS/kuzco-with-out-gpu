FROM debian:stable-slim

# deps dasar
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates python3 python3-pip python3-venv git procps lsof tini \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# install CLI Inference
RUN curl -fsSL https://devnet.inference.net/install.sh | sh

# === BUAT VENV & install LiteLLM di venv (hindari PEP 668 error)
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:${PATH}"

RUN pip install --no-cache-dir "litellm[proxy]" uvicorn

# runtime files
COPY ./execute.sh /app/execute.sh
RUN chmod +x /app/execute.sh

ENTRYPOINT ["/usr/bin/tini","--"]
CMD ["/app/execute.sh"]
