#!/bin/bash

# deploy.sh — aktualizacja z automatycznym fallbackiem cloudflared
echo "✅ Start deploymentu..."

# Update i podstawowe pakiety
apt update && apt install -y wget unzip htop git

# Instalacja cloudflared
if ! command -v cloudflared &> /dev/null
then
  echo "📥 Pobieram cloudflared z oficjalnego repo..."
  wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
  dpkg -i cloudflared-linux-amd64.deb
else
  echo "✅ cloudflared już zainstalowane."
fi

# Klonowanie repo (jeśli nie istnieje)
if [ ! -d "/workspace/zms-infrastructure" ]; then
  echo "📥 Klonuję repozytorium..."
  git clone https://github.com/zms1312/zms-infrastructure.git /workspace/zms-infrastructure
else
  echo "✅ Repozytorium już istnieje."
fi

# Finalna informacja
echo "✅ Deployment zakończony. Pamiętaj, aby uruchomić: bash /workspace/zms-infrastructure/zms-auto-deploy/startup_check.sh"

# Logowanie
log_date=$(date '+%Y-%m-%d %H:%M:%S')
echo "[$log_date] Deployment zakończony." >> /root/deploy_log.txt
