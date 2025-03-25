#!/bin/bash

# deploy.sh — finalna wersja z fallbackiem cloudflared i gotowcem do wklejenia
echo "✅ Start deploymentu..."

# Update i podstawowe pakiety
apt update && apt install -y wget unzip htop git

# Instalacja cloudflared — fallback jeśli nie znaleziono
if ! command -v cloudflared &> /dev/null
then
  echo "📥 Pobieram cloudflared..."
  wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
  dpkg -i cloudflared-linux-amd64.deb
else
  echo "✅ cloudflared już zainstalowane."
fi

# Klon repo (jeśli nie istnieje)
if [ ! -d "/workspace/zms-infrastructure" ]; then
  echo "📥 Klonuję repo..."
  git clone https://github.com/zms1312/zms-infrastructure.git /workspace/zms-infrastructure
else
  echo "✅ Repo już istnieje."
fi

# Informacja końcowa
echo "✅ Deployment zakończony. Odpal teraz: bash /workspace/zms-infrastructure/zms-auto-deploy/startup_check.sh"

# Log
log_date=$(date '+%Y-%m-%d %H:%M:%S')
echo "[$log_date] Deployment zakończony." >> /root/deploy_log.txt
