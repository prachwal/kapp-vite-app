#!/usr/bin/env bash
set -euo pipefail

# Kills processes listening on PORT (env) or 3000 by default.
# Usage: PORT=3000 ./scripts/kill-api.sh

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PORT=${PORT:-3000}

log() { echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] $*"; }

log "Checking for processes listening on port $PORT"

PIDS=$(ss -ltnp 2>/dev/null | awk -vport=":$PORT" '$0~port { if(match($0,/pid=[0-9]+/)){m=substr($0,RSTART,RLENGTH); split(m,a,"="); print a[2]} }' | sort -u)

if [ -z "$PIDS" ]; then
  log "No process found listening on port $PORT"
  exit 0
fi

log "Found process(es) on port $PORT: $PIDS"

for pid in $PIDS; do
  # show process info
  if ps -p "$pid" -o pid,cmd >/dev/null 2>&1; then
    ps -p "$pid" -o pid,cmd | sed -n '1,1p' >/dev/null 2>&1 || true
    log "Killing PID $pid"
    kill "$pid" 2>/dev/null || {
      log "SIGTERM failed for $pid, trying SIGKILL"
      kill -9 "$pid" 2>/dev/null || true
    }
  else
    log "PID $pid no longer exists"
  fi
done

sleep 0.25

POST=$(ss -ltnp 2>/dev/null | grep -E ":$PORT\\b" || true)
if [ -z "$POST" ]; then
  log "Port $PORT is now free"
else
  log "Port $PORT still has listeners:"; echo "$POST"
fi

exit 0
