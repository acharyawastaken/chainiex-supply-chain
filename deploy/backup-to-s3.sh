#!/bin/bash
# ─────────────────────────────────────────────
# ChaiNIEx — Backup PostgreSQL DB to S3
# Uses the EC2 IAM Role (no access keys stored on the server).
# Run manually:  ~/chainiex-supply-chain/deploy/backup-to-s3.sh
# ─────────────────────────────────────────────
set -euo pipefail

APP_DIR="$(cd "$(dirname "$0")/.." && pwd)"
set -a; source "$APP_DIR/.env"; set +a

STAMP=$(date -u +%Y-%m-%dT%H-%M-%SZ)
FILE="/tmp/chainex-${STAMP}.sql.gz"

PGPASSWORD="$DB_PASS" pg_dump -h "$DB_HOST" -U "$DB_USER" "$DB_NAME" | gzip > "$FILE"
aws s3 cp "$FILE" "s3://${S3_BUCKET}/backups/$(basename "$FILE")" --region us-west-2
rm -f "$FILE"

echo "✅ Backup uploaded: s3://${S3_BUCKET}/backups/$(basename "$FILE")"
