
# ZMS Infrastructure

## Instrukcja deploy:

1. Sklonuj repo:
   ```bash
   git clone https://github.com/zmscompany/zms-infrastructure.git
   ```

2. Skopiuj plik:
   ```bash
   cp config/env_template config/.env
   ```
   i uzupełnij tokeny.

3. Uruchom deploy:
   ```bash
   cd zms-auto-deploy && bash deploy.sh
   ```

4. Test środowiska:
   ```bash
   bash /root/startup_check.sh
   ```

5. Sprawdź status GPU:
   ```bash
   watch -n 1 nvidia-smi
   ```

6. Sprawdź logi:
   ```bash
   tail -f /root/auto_backup_log.txt
   ```

7. Sprawdź DNS:
   ```bash
   nslookup stable-diffusion-pod.zmscompany.org 1.1.1.1
   ```
