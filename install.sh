#!/bin/bash

GH_USER="amirhamzah0"
GH_REPO="Simple-Systemd-DNS-Changer"
BRANCH="main"
CONF_DIR="/etc/systemd/resolved.conf.d"

echo "=================================="
echo "   AUTOMATED DNS SETUP: CACHYOS   "
echo "=================================="

# --- 1. DOWNLOAD FILES FIRST (While internet is up) ---
echo "Fetching configuration files..."
sudo mkdir -p $CONF_DIR
FILES=("mullvad.conf" "controld.conf" "cloudflare.conf")

for FILE in "${FILES[@]}"; do
    echo "Downloading $FILE..."
    sudo wget -q "https://raw.githubusercontent.com/$GH_USER/$GH_REPO/$BRANCH/$FILE" -O "$CONF_DIR/$FILE.bak"
done

echo "Downloading dns controller..."
sudo wget -q "https://raw.githubusercontent.com/$GH_USER/$GH_REPO/$BRANCH/dns.sh" -O /usr/local/bin/dns
sudo chmod +x /usr/local/bin/dns

# --- 2. CLEANUP OLD ALIASES ---
# This ensures that if you have an old 'dns' alias, it gets removed
if [ "$SUDO_USER" ]; then
    USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
    sed -i '/alias dns=/d' "$USER_HOME/.bashrc"
fi

# --- 3. SYSTEM SERVICES SETUP ---
echo "Configuring systemd-resolved..."
sudo systemctl enable --now systemd-resolved
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# NetworkManager link
sudo mkdir -p /etc/NetworkManager/conf.d/
echo -e "[main]\ndns=systemd-resolved" | sudo tee /etc/NetworkManager/conf.d/dns.conf > /dev/null

echo "Restarting NetworkManager..."
sudo systemctl restart NetworkManager

echo "----------------------------------"
echo " INSTALLATION COMPLETE!"
echo " Just type 'dns' to start."
echo "----------------------------------"
