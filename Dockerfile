FROM alpine:3.19
RUN apk add --no-cache ca-certificates curl

WORKDIR /app

# Download pre-built Anvil v1.0.0 binary (amd64)
RUN curl -fsSL https://github.com/BSVanon/Anvil/releases/download/v1.0.0/anvil-linux-amd64 -o anvil \
    && chmod +x anvil

# Startup script: generate anvil.toml from env vars at runtime
COPY docker-entrypoint.sh ./docker-entrypoint.sh
RUN chmod +x ./docker-entrypoint.sh

EXPOSE 8333 9333

ENTRYPOINT ["./docker-entrypoint.sh"]
