#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-dev}"
BACKUP_DIR="${BACKUP_DIR:-./backups}"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

mkdir -p "$BACKUP_DIR"

case "$ENVIRONMENT" in
  dev)
    CONTAINER="jipanditji-mysql-dev"
    DATABASE="jipanditji_dev"
    USERNAME="root"
    PASSWORD="root_dev_password"
    ;;
  testing|test)
    CONTAINER="jipanditji-mysql-testing"
    DATABASE="jipanditji_test"
    USERNAME="root"
    PASSWORD="root_test_password"
    ;;
  *)
    echo "This script supports local dev/testing MySQL containers."
    echo "For production, set a secure managed-database backup process."
    exit 1
    ;;
esac

docker exec "$CONTAINER" mysqldump -u"$USERNAME" -p"$PASSWORD" "$DATABASE" > "$BACKUP_DIR/$DATABASE-$TIMESTAMP.sql"
echo "Backup written to $BACKUP_DIR/$DATABASE-$TIMESTAMP.sql"
