#!/usr/bin/env bash
set -euo pipefail

# Advanced build wrapper for project
# - cleans prior artifacts
# - logs each step to timestamped logfile
# - runs api api TS build then vite build
# - runs quality checks after build

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LOG_DIR="$ROOT_DIR/logs"
TS="$(date -u +%Y%m%dT%H%M%SZ)"
LOG_FILE="$LOG_DIR/build-$TS.log"

mkdir -p "$LOG_DIR"

log() {
  local msg="$1"
  echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] $msg" | tee -a "$LOG_FILE"
}

fail() {
  local rc=$1
  shift
  log "ERROR: $* (exit $rc)"
  log "Full log: $LOG_FILE"
  exit $rc
}

step() {
  local name="$1"
  shift
  log "--- START: $name ---"
  {
    "$@"
  } 2>&1 | tee -a "$LOG_FILE" || fail $? "Step failed: $name"
  log "--- DONE: $name ---"
}

log "Build wrapper starting"
log "Project root: $ROOT_DIR"

# 1) Clean
step "clean" rm -rf "$ROOT_DIR/api/dist" "$ROOT_DIR/.svelte-kit" "$ROOT_DIR/.cache" || true

# 2) Ensure node_modules exists
if [ ! -d "$ROOT_DIR/node_modules" ]; then
  log "node_modules not found — running npm ci"
  step "npm ci" npm ci
fi

# 3) Build API v2 (TypeScript)
step "build:api:v2" npm run api:v2:build

# 4) Vite build
step "build:vite" vite build

# 5) Quality checks
log "Running quality checks (npm run check)"
if npm run check 2>&1 | tee -a "$LOG_FILE"; then
  log "Quality checks passed"
else
  fail 1 "Quality checks failed"
fi

# 6) Post-build verification
if [ -f "$ROOT_DIR/api/dist/index.js" ]; then
  log "Verification: api dist/index.js exists"
else
  fail 2 "Verification failed: api/dist/index.js missing"
fi

log "Build wrapper finished successfully"
log "Full log: $LOG_FILE"

exit 0
