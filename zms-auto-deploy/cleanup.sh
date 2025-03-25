#!/bin/bash

# === ZMS CLEANUP SCRIPT ===
# Cel: Usuwanie zbędnych danych ze środowiska i optymalizacja miejsca

LOG_FILE="/root/cleanup_log.txt"

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}>> Start czyszczenia środowiska...${NC}" | tee -a $LOG_FILE

# 1. Czyszczenie modeli
echo ">> Usuwam modele z /workspace/stable-diffusion-webui/models..." | tee -a $LOG_FILE
find /workspace/stable-diffusion-webui/models -type f \( -iname "*.ckpt" -o -iname "*.safetensors" -o -iname "*.pt" \) -exec rm -f {} \;

# 2. Czyszczenie logów starszych niż 3 dni
echo ">> Usuwam logi starsze niż 3 dni..." | tee -a $LOG_FILE
find /root -type f -name "*.log" -mtime +3 -exec rm -f {} \;
find /workspace -type f -name "*.log" -mtime +3 -exec rm -f {} \;

# 3. Czyszczenie wygenerowanych obrazów starszych niż 3 dni
echo ">> Usuwam stare generowane obrazy..." | tee -a $LOG_FILE
find /workspace/stable-diffusion-webui/generated -type f -mtime +3 -exec rm -f {} \;

# 4. Sprawdzenie wolnego miejsca po czyszczeniu
echo ">> Sprawdzam wykorzystanie miejsca dyskowego..." | tee -a $LOG_FILE
df -h | tee -a $LOG_FILE

# 5. Podsumowanie
echo -e "${GREEN}>> Cleanup zakończony. Raport w $LOG_FILE.${NC}" | tee -a $LOG_FILE