#!/bin/bash

# === ZMS DEPLOY SCRIPT — final production version ===
# Cel: pełna automatyzacja startu środowiska na podecie z auto-instalacją narzędzi

LOG_FILE="/root/deploy_log.txt"

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}>> Start procesu deploy...${NC}" | tee -a $LOG_FILE

# 0. Instalacja podstawowych narzędzi
echo ">> Instaluję podstawowe narzędzia (nano, vim, htop, cloudflared)..." | tee -a $LOG_FILE
apt update && apt install -y nano vim htop cloudflared

# 1. Sprawdzenie obecności plików kluczy i env
echo ">> Sprawdzam obecność plików konfiguracyjnych..." | tee -a $LOG_FILE

REQUIRED_FILES=("/root/zms-backup-project-key.json" "/root/.cloudflared/config.yml" "../config/.env")

for FILE in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "$FILE" ]; then
    echo -e "${RED}Brak pliku: $FILE. Przerwanie deploy.${NC}" | tee -a $LOG_FILE
    exit 1
  else
    echo -e "${GREEN}✓ Znaleziono $FILE${NC}" | tee -a $LOG_FILE
  fi
done

# 2. Synchronizacja presetów
echo ">> Synchronizuję presety..." | tee -a $LOG_FILE
cd /workspace/extensions/sd-dynamic-prompts/prompts || exit 1
git pull origin main | tee -a $LOG_FILE
cd -

# 3. Start tunelu Cloudflare
echo ">> Uruchamiam tunel Cloudflare..." | tee -a $LOG_FILE
cloudflared tunnel run stable-diffusion-pod &
sleep 5

# 4. Start środowiska
echo ">> Startuję środowisko..." | tee -a $LOG_FILE
bash /workspace/start.sh | tee -a $LOG_FILE

# 5. Dodanie crona
echo ">> Rejestruję crontab..." | tee -a $LOG_FILE
crontab ../cron/crontab_template

# 6. Dodanie aliasów
echo ">> Dodaję aliasy do ~/.bashrc..." | tee -a $LOG_FILE
cat ../zms-auto-deploy/aliases.sh >> ~/.bashrc

# 7. Zakończenie
echo -e "${GREEN}>> Deploy zakończony pomyślnie.${NC}" | tee -a $LOG_FILE
echo ">> Wykonaj test: bash /root/startup_check.sh" | tee -a $LOG_FILE
