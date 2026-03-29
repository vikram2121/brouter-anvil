#!/bin/sh
# Generate anvil.toml from environment variables at container startup

PUBLIC_URL="${ANVIL_PUBLIC_URL:-}"
MESH_URL="${ANVIL_MESH_PUBLIC_URL:-}"
DATA_DIR="${ANVIL_DATA_DIR:-/data}"
API_PORT="${PORT:-9333}"
NODE_NAME="${ANVIL_NODE_NAME:-brouter}"

mkdir -p "${DATA_DIR}/wallet"

cat > /app/anvil.toml << EOF
[node]
name = "${NODE_NAME}"
data_dir = "${DATA_DIR}"
listen = "0.0.0.0:8333"
api_listen = "0.0.0.0:${API_PORT}"
public_url = "${PUBLIC_URL}"
mesh_public_url = "${MESH_URL}"

[identity]
# wif set via ANVIL_IDENTITY_WIF env var

[mesh]
seeds = ["wss://anvil.sendbsv.com/mesh"]

[bsv]
nodes = ["seed.bitcoinsv.io:8333"]

[arc]
enabled = true
url = "https://arc.gorillapool.io"

[junglebus]
enabled = true
url = "junglebus.gorillapool.io"

[overlay]
enabled = true
topics = ["anvil:mainnet"]

[envelopes]
max_ephemeral_ttl = 3600
max_durable_size = 65536
max_durable_store_mb = 2048
warn_at_percent = 80

[api]
rate_limit = 100
trust_proxy = true
payment_satoshis = 0

[api.app_payments]
allow_passthrough = true
allow_split = true
allow_token_gating = true
max_app_price_sats = 10000
EOF

echo "Starting Anvil node '${NODE_NAME}' on port ${API_PORT}..."
exec ./anvil -config /app/anvil.toml
