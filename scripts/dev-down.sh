#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ENV_FILE="${1:-$REPO_ROOT/.env}"
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

docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" -p "$ENV_NAME" down --remove-orphans
