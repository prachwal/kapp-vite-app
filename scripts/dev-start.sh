#!/usr/bin/env bash
set -euo pipefail

# Usage: PORT=3000 ./scripts/dev-start.sh
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PORT_TO_USE="${PORT:-3000}"

log() { echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] $*"; }

log "Starting dev environment (API port $PORT_TO_USE)"

# 1) Clean up any existing listener on the port
if ss -ltnp 2>/dev/null | grep -q ":${PORT_TO_USE}\b"; then
  PIDS=$(ss -ltnp 2>/dev/null | awk -vport=":${PORT_TO_USE}" '$0~port { if(match($0,/pid=[0-9]+/)){m=substr($0,RSTART,RLENGTH); split(m,a,"="); print a[2]} }' | sort -u)
  for p in $PIDS; do
    log "Killing existing PID $p on port ${PORT_TO_USE}"
    kill "$p" || kill -9 "$p" || true
  done
  sleep 0.2
fi

# Ensure logs dir
mkdir -p "$ROOT_DIR/logs"

# 2) Build api once (emit to api/dist)
log "Building API once"
cd "$ROOT_DIR/api"
npx tsc -p ./tsconfig.json

# 3) Start tsc --watch for api in background
log "Starting tsc --watch for API (logs to logs/tsc-api-watch.log)"
nohup npx tsc -p ./tsconfig.json --watch > "$ROOT_DIR/logs/tsc-api-watch.log" 2>&1 &
TSC_PID=$!
log "tsc watch PID=$TSC_PID"

# 4) Start compiled API server in background
cd "$ROOT_DIR"
API_LOG="$ROOT_DIR/logs/api-server.log"
if [ -f "$ROOT_DIR/api/dist/index.js" ]; then
  log "Starting compiled API server (PORT=$PORT_TO_USE), logging to $API_LOG"
  nohup env PORT="$PORT_TO_USE" node "$ROOT_DIR/api/dist/index.js" > "$API_LOG" 2>&1 &
  API_PID=$!
  log "api server PID=$API_PID"
else
  log "ERROR: compiled API not found at api/dist/index.js — run a build first"
  exit 1
fi

# 5) Start vite in foreground
log "Starting vite dev (will proxy /api -> localhost:${PORT_TO_USE})"
exec vite
