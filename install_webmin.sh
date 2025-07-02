cat <<'EOF'
# .---------------------------------------------------.
# |                                                   |
# |  __  __    _    ______     ______  _______     __ |
# | |  \/  |  / \  |  _ \ \   / /  _ \| ____\ \   / / |
# | | |\/| | / _ \ | |_) \ \ / /| | | |  _|  \ \ / /  |
# | | |  | |/ ___ \|  _ < \ V / | |_| | |___  \ V /   |
# | |_|  |_/_/   \_\_| \_\ \_/  |____/|_____|  \_/    |
# |                                                   |
# '---------------------------------------------------'
EOF

# Wait 5 sec to show the Logo and purpose of the script
sleep 5s

# Color definitions for pretty output
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

# -----------------------------------------------------------------------------
# 1. Require execution as root
# -----------------------------------------------------------------------------
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}Bitte führe dieses Skript als Root aus!${RESET}"
    exit 1
fi

# -----------------------------------------------------------------------------
# 2. Kick‑off message
# -----------------------------------------------------------------------------
echo -e "${GREEN}Webmin‑Installationsskript gestartet …${RESET}"

# -----------------------------------------------------------------------------
# 3. Check for supported operating system
# -----------------------------------------------------------------------------
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ "$ID" != "ubuntu" && "$ID" != "debian" ]]; then
        echo -e "${RED}Dieses Skript unterstützt nur Debian‑ oder Ubuntu‑basierte Systeme.${RESET}"
        exit 1
    fi
else
    echo -e "${RED}Ihre Distribution wird nicht erkannt – Abbruch.${RESET}"
    exit 1
fi

# -----------------------------------------------------------------------------
# 4. Verify Internet connectivity (simple ICMP to Cloudflare 1.1.1.1)
# -----------------------------------------------------------------------------
echo -e "${GREEN}Prüfe Internetverbindung …${RESET}"
if ping -c1 -W2 1.1.1.1 >/dev/null 2>&1; then
    echo -e "${GREEN}Internetverbindung vorhanden.${RESET}"
else
    echo -e "${RED}Keine Internetverbindung! Bitte Netzwerk prüfen und erneut versuchen.${RESET}"
    exit 1
fi

# -----------------------------------------------------------------------------
# 5. Update package lists & install prerequisites
# -----------------------------------------------------------------------------
echo -e "${GREEN}Aktualisiere Paketlisten und installiere benötigte Pakete …${RESET}"
apt update -y && \
apt install -y wget apt-transport-https software-properties-common gpg

# -----------------------------------------------------------------------------
# 6. Add Webmin repository & import GPG key
# -----------------------------------------------------------------------------
echo -e "${GREEN}Füge Webmin‑Repository hinzu und importiere GPG‑Schlüssel …${RESET}"
wget -qO - http://www.webmin.com/jcameron-key.asc | gpg --dearmor -o /usr/share/keyrings/webmin.gpg

cat > /etc/apt/sources.list.d/webmin.list <<EOF
deb [signed-by=/usr/share/keyrings/webmin.gpg] http://download.webmin.com/download/repository sarge contrib
EOF

# -----------------------------------------------------------------------------
# 7. Refresh package list
# -----------------------------------------------------------------------------
echo -e "${GREEN}Aktualisiere Paketlisten (Webmin) …${RESET}"
apt update -y

# -----------------------------------------------------------------------------
# 8. Install Webmin
# -----------------------------------------------------------------------------
echo -e "${GREEN}Installiere Webmin …${RESET}"
apt install -y webmin

# -----------------------------------------------------------------------------
# 9. Enable & start Webmin service
# -----------------------------------------------------------------------------
echo -e "${GREEN}Aktiviere und starte Webmin‑Dienst …${RESET}"
systemctl enable --now webmin

# -----------------------------------------------------------------------------
# 10. Success message
# -----------------------------------------------------------------------------
echo -e "${GREEN}Webmin is installed successfully!${RESET}"
echo -e "${GREEN}You can connect to Webmin on https://<SERVER‑IP>:10000 ${RESET}"
echo -e "${GREEN}Login with your root or admin credentials.${RESET}"
