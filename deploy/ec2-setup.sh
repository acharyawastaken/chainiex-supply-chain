#!/bin/bash
# ─────────────────────────────────────────────────────────────
# ChaiNIEx — EC2 User Data (Amazon Linux 2023)
# Paste this whole file into: EC2 → Launch instance → Advanced details → User data
# Runs ONCE as root on first boot. Log: /var/log/cloud-init-output.log
# ─────────────────────────────────────────────────────────────
set -eux

REPO_URL="https://github.com/acharyawastaken/chainiex-supply-chain.git"
APP_DIR="/home/ec2-user/chainiex-supply-chain"
DB_NAME="chainex_db"
DB_PASS="ChainexDbPass123"            # change if you like
S3_BUCKET="chainex-backups-CHANGE-ME"  # <-- put your bucket name here

# 1. System packages: git, Node.js 20, PostgreSQL 16, AWS CLI
dnf update -y
dnf install -y git nodejs20 postgresql16 postgresql16-server cronie
ln -sf /usr/bin/node-20 /usr/bin/node || true
ln -sf /usr/bin/npm-20  /usr/bin/npm  || true

# 2. Initialise & start PostgreSQL
postgresql-setup --initdb
# allow password (md5) login over localhost
sed -i 's/ident/md5/g' /var/lib/pgsql/data/pg_hba.conf
systemctl enable --now postgresql
sudo -u postgres psql -c "ALTER USER postgres PASSWORD '${DB_PASS}';"
sudo -u postgres psql -c "CREATE DATABASE ${DB_NAME};"

# 3. Get the code
git clone "$REPO_URL" "$APP_DIR"
cd "$APP_DIR"

# 4. Load schema + seed data
PGPASSWORD="$DB_PASS" psql -h localhost -U postgres -d "$DB_NAME" -f db/schema.sql
PGPASSWORD="$DB_PASS" psql -h localhost -U postgres -d "$DB_NAME" -f db/seed.sql

# 5. Environment file
cat > "$APP_DIR/.env" <<EOF
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASS=${DB_PASS}
DB_NAME=${DB_NAME}
JWT_SECRET=$(openssl rand -hex 32)
PORT=4000
S3_BUCKET=${S3_BUCKET}
EOF

# 6. Install deps and run with PM2 (auto-restart + start on reboot)
cd "$APP_DIR/api"
npm install --omit=dev
npm install -g pm2
chown -R ec2-user:ec2-user "$APP_DIR"
sudo -u ec2-user pm2 start server.js --name chainex
sudo -u ec2-user pm2 save
env PATH=$PATH:/usr/bin pm2 startup systemd -u ec2-user --hp /home/ec2-user

# 7. Daily DB backup to S3 at 02:00 UTC
chmod +x "$APP_DIR/deploy/backup-to-s3.sh"
systemctl enable --now crond
echo "0 2 * * * ec2-user $APP_DIR/deploy/backup-to-s3.sh >> /var/log/chainex-backup.log 2>&1" > /etc/cron.d/chainex-backup

echo "✅ ChaiNIEx setup complete"
