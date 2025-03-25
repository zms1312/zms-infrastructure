#!/bin/bash

echo "✅ [CLEANUP] Rozpoczynam pełne czyszczenie poda..."

# Usunięcie cloudflared i jego konfiguracji
echo "🧹 Usuwam cloudflared i konfiguracje..."
rm -rf /root/.cloudflared/
rm -rf /usr/local/etc/cloudflared/
rm -f /usr/local/bin/cloudflared

# Usunięcie repozytoriów
echo "🧹 Usuwam repozytoria..."
rm -rf /workspace/zms-infrastructure
rm -rf /workspace/zms-auto-deploy

# Usunięcie logów i starych raportów
echo "🧹 Kasuję logi i backupy..."
rm -rf /root/auto_backup_log.txt
rm -rf /root/auto_wiedza_log.txt
rm -rf /root/deploy_log.txt
rm -rf /root/wiedza.txt

# Kasowanie crontab
echo "🧹 Czyści crontab..."
crontab -r

# Kasowanie smart backupu
rm -f /workspace/smart_workspace_backup.zip

# Odświeżenie cache APT
echo "🔄 Aktualizacja i odświeżenie cache..."
apt-get clean
apt-get autoremove -y

echo "✅ [CLEANUP] Pod został wyczyszczony do zera."

# Polecenie końcowe
echo "💡 Podpowiedź: teraz możesz wykonać nowy deploy lub zresetować maszynę."

