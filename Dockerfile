FROM alpine:3.19
RUN apk add --no-cache ca-certificates curl bash sudo

WORKDIR /app

# Download pre-built Anvil v1.0.0 binary
ARG TARGETARCH=amd64
RUN curl -fsSL -L \
    "https://github.com/BSVanon/Anvil/releases/download/v1.0.0/anvil-linux-${TARGETARCH}" \
    -o /usr/local/bin/anvil \
    && chmod +x /usr/local/bin/anvil

# Startup script: generate anvil.toml from env vars at runtime
COPY docker-entrypoint.sh ./docker-entrypoint.sh
RUN chmod +x ./docker-entrypoint.sh

EXPOSE 8333 9333

ENTRYPOINT ["./docker-entrypoint.sh"]
