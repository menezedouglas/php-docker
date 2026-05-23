#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ENV_FILE="${1:-$REPO_ROOT/.env}"
DO_BUILD=false

if [[ "${1:-}" == "--build" ]]; then
  DO_BUILD=true
  ENV_FILE="${2:-$REPO_ROOT/.env}"
fi
COMPOSE_FILE="$REPO_ROOT/docker-compose.yml"

load_env() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    echo "Arquivo de ambiente nao encontrado: $file" >&2
    exit 1
  fi
  set -a
  # shellcheck disable=SC1090
  source "$file"
  set +a
}

load_env "$ENV_FILE"

resolve_path() {
  local path="$1"
  if [[ "$path" = /* ]]; then
    echo "$path"
  else
    echo "$REPO_ROOT/$path"
  fi
}

abs_path() {
  local path="$1"
  mkdir -p "$path"
  if command -v realpath >/dev/null 2>&1; then
    realpath "$path"
  elif command -v readlink >/dev/null 2>&1; then
    readlink -f "$path"
  else
    python - <<PY
import os,sys
print(os.path.abspath(sys.argv[1]))
PY
  fi
}

PROJECTS_ROOT="$(abs_path "$(resolve_path "$PROJECTS_ROOT")")"
APACHE_CONFIG_PATH="$(abs_path "$(resolve_path "$APACHE_CONFIG_PATH")")"
WORKER_CONFIG_PATH="$(abs_path "$(resolve_path "$WORKER_CONFIG_PATH")")"
MYSQL_DATA_PATH="$(abs_path "$(resolve_path "$MYSQL_DATA_PATH")")"

export PROJECTS_ROOT APACHE_CONFIG_PATH WORKER_CONFIG_PATH MYSQL_DATA_PATH

if [[ "$DO_BUILD" == "true" ]]; then
  docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" -p "$ENV_NAME" up -d --build
else
  docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" -p "$ENV_NAME" up -d
fi

APACHE_PORT="${APACHE_HOST_PORT:-8080}"
PMA_PORT="${PMA_HOST_PORT:-8081}"

echo "Apache: http://localhost:${APACHE_PORT}"
echo "phpMyAdmin: http://localhost:${PMA_PORT}"
