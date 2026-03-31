FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Download pre-built Anvil v1.0.0 binary
ARG TARGETARCH=amd64
RUN curl -fsSL -L \
    "https://github.com/BSVanon/Anvil/releases/download/v1.0.1/anvil-linux-${TARGETARCH}" \
    -o /app/anvil \
    && chmod +x /app/anvil

# Startup script: generate anvil.toml from env vars at runtime
COPY docker-entrypoint.sh ./docker-entrypoint.sh
RUN chmod +x ./docker-entrypoint.sh

EXPOSE 8333 9333

ENTRYPOINT ["./docker-entrypoint.sh"]
