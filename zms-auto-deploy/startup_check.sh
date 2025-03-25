#!/bin/bash

# === ZMS STARTUP CHECK SCRIPT ===
# Cel: Pełna weryfikacja środowiska na RunPod

LOG_FILE="/root/startup_check_log.txt"

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}>> Start pełnej weryfikacji środowiska...${NC}" | tee -a $LOG_FILE

# 1. Sprawdzenie obecności kluczy
echo ">> Sprawdzam klucz GCS..." | tee -a $LOG_FILE
if [ -f "/root/zms-backup-project-key.json" ]; then
  echo -e "${GREEN}✓ Klucz serwisowy GCS obecny.${NC}" | tee -a $LOG_FILE
else
  echo -e "${RED}Brak klucza serwisowego GCS.${NC}" | tee -a $LOG_FILE
fi

# 2. Sprawdzenie gsutil
echo ">> Sprawdzam dostępność gsutil..." | tee -a $LOG_FILE
if command -v gsutil &> /dev/null; then
  echo -e "${GREEN}✓ gsutil zainstalowany.${NC}" | tee -a $LOG_FILE
else
  echo -e "${RED}gsutil nie jest dostępny.${NC}" | tee -a $LOG_FILE
fi

# 3. Sprawdzenie dostępu do bucketów
BUCKETS=("zms-backup-project" "zms-generated-outputs")
for BUCKET in "${BUCKETS[@]}"; do
  echo ">> Sprawdzam dostęp do: $BUCKET..." | tee -a $LOG_FILE
  if gsutil ls gs://$BUCKET &> /dev/null; then
    echo -e "${GREEN}✓ Dostęp do $BUCKET OK.${NC}" | tee -a $LOG_FILE
  else
    echo -e "${RED}Brak dostępu do $BUCKET.${NC}" | tee -a $LOG_FILE
  fi
done

# 4. Sprawdzenie Cloudflare tunelu
echo ">> Sprawdzam tunel Cloudflare..." | tee -a $LOG_FILE
if cloudflared tunnel list | grep -q stable-diffusion-pod; then
  echo -e "${GREEN}✓ Tunel Cloudflare aktywny.${NC}" | tee -a $LOG_FILE
else
  echo -e "${RED}Tunel Cloudflare nie jest uruchomiony.${NC}" | tee -a $LOG_FILE
fi

# 5. Sprawdzenie portu 7860
echo ">> Sprawdzam port 7860..." | tee -a $LOG_FILE
if lsof -Pi :7860 -sTCP:LISTEN -t &> /dev/null; then
  echo -e "${GREEN}✓ Port 7860 nasłuchuje.${NC}" | tee -a $LOG_FILE
else
  echo -e "${RED}Port 7860 nie jest aktywny.${NC}" | tee -a $LOG_FILE
fi

# 6. Test GPU
echo ">> Sprawdzam GPU..." | tee -a $LOG_FILE
if nvidia-smi &> /dev/null; then
  echo -e "${GREEN}✓ GPU działa i jest wykrywalne.${NC}" | tee -a $LOG_FILE
else
  echo -e "${RED}GPU niedostępne.${NC}" | tee -a $LOG_FILE
fi

# 7. Podsumowanie
echo -e "${GREEN}>> Weryfikacja zakończona. Sprawdź pełny log: $LOG_FILE${NC}" | tee -a $LOG_FILE