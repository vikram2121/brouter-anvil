FROM golang:1.23-alpine AS builder
WORKDIR /src
COPY . .
RUN go build -o anvil ./cmd/anvil

FROM alpine:3.19
RUN apk add --no-cache ca-certificates
WORKDIR /app
COPY --from=builder /src/anvil ./anvil
COPY anvil.toml ./anvil.toml

# Overwrite data_dir to use Railway volume mount
RUN sed -i 's|data_dir = .*|data_dir = "/data"|' anvil.toml

EXPOSE 8333 9333

CMD ["sh", "-c", "./anvil -config anvil.toml"]
