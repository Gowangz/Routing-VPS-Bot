#!/bin/bash

set -e

REPO_URL="https://github.com/Gowangz/Routing-VPS-Bot.git"  # Ganti dengan repo kamu
INSTALL_DIR="/opt/routing-vps-bot"
SERVICE_NAME="routing-telegram"
BOT_DIR="$INSTALL_DIR/bot"
PYTHON=$(command -v python3)

echo "🚀 Menginstall dependensi..."
apt update -y
apt install -y python3-pip git curl dnsutils

echo "📁 Cloning repository..."
rm -rf "$INSTALL_DIR"
git clone "$REPO_URL" "$INSTALL_DIR"

echo "📦 Menginstall Python packages..."
pip3 install -r "$INSTALL_DIR/requirements.txt"

echo "🗂️ Mengatur file konfigurasi..."
cp "$BOT_DIR/.env.example" "$BOT_DIR/.env"
echo "➡️ Silakan isi TOKEN bot dan OWNER_ID ke file: $BOT_DIR/.env"
read -p "Tekan ENTER jika sudah mengedit file .env..."

echo "🛠️ Membuat systemd service..."
cp "$INSTALL_DIR/systemd/$SERVICE_NAME.service" /etc/systemd/system/
systemctl daemon-reload
systemctl enable "$SERVICE_NAME"
systemctl start "$SERVICE_NAME"

echo "🔄 Menambahkan auto-update via crontab..."
crontab -l 2>/dev/null | grep -v "$INSTALL_DIR" > /tmp/crontab_routing || true
echo "0 4 * * * cd $INSTALL_DIR && git pull && systemctl restart $SERVICE_NAME" >> /tmp/crontab_routing
crontab /tmp/crontab_routing
rm /tmp/crontab_routing

echo ""
echo "✅ DONE: Bot Telegram Routing berhasil diinstal!"
echo "🔁 Service: $SERVICE_NAME"
echo "📡 Jalankan: systemctl status $SERVICE_NAME"
