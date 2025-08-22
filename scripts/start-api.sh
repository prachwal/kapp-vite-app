#!/usr/bin/env bash
set -euo pipefail

# Start the compiled API server if not already running on PORT (default 3000).
# Usage: PORT=3000 ./scripts/start-api.sh

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PORT=${PORT:-3000}

log() { echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] $*"; }

log "Checking port $PORT"
EXIST=$(ss -ltnp 2>/dev/null | grep -E ":${PORT}\b" || true)
if [ -n "$EXIST" ]; then
  log "Port $PORT already has a listener.\n$EXIST"
  exit 0
fi

mkdir -p "$ROOT_DIR/logs"

if [ ! -f "$ROOT_DIR/api/dist/index.js" ]; then
  log "Compiled API not found at api/dist/index.js — building now"
  cd "$ROOT_DIR/api"
  npx tsc -p ./tsconfig.json
  cd "$ROOT_DIR"
fi

API_LOG="$ROOT_DIR/logs/api-server.log"
log "Starting API (PORT=$PORT), logging to $API_LOG"
nohup env PORT="$PORT" node "$ROOT_DIR/api/dist/index.js" > "$API_LOG" 2>&1 &
API_PID=$!
log "API started with PID $API_PID"
log "You can follow logs with: tail -f $API_LOG"

exit 0
