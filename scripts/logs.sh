#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-prod}"
SERVICE="${2:-}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

case "$ENVIRONMENT" in
  dev)
    COMPOSE_FILE="$ROOT_DIR/docker-compose.dev.yml"
    ;;
  prod)
    COMPOSE_FILE="$ROOT_DIR/docker-compose.prod.yml"
    ;;
  testing|test)
    COMPOSE_FILE="$ROOT_DIR/docker-compose.testing.yml"
    ;;
  *)
    echo "Usage: $0 [dev|prod|testing] [service]"
    exit 1
    ;;
esac

if [[ -n "$SERVICE" ]]; then
  docker compose -f "$COMPOSE_FILE" logs -f --tail=200 "$SERVICE"
else
  docker compose -f "$COMPOSE_FILE" logs -f --tail=200
fi
