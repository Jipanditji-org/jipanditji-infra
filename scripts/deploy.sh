#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-dev}"
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
  proxy|nginx|edge)
    COMPOSE_FILE="$ROOT_DIR/docker-compose.proxy.yml"
    ;;
  *)
    echo "Usage: $0 [dev|prod|testing|proxy]"
    exit 1
    ;;
esac

docker compose -f "$COMPOSE_FILE" up -d --build
docker compose -f "$COMPOSE_FILE" ps
