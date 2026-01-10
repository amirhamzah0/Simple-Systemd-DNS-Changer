#!/bin/bash

# Configuration - Hardcoded for your repo
GH_USER="amirhamzah0"
GH_REPO="Simple-Systemd-DNS-Changer"
BRANCH="main"
DIR="/etc/systemd/resolved.conf.d"

echo "=================================="
echo "   AUTOMATED DNS SETUP: CACHYOS   "
echo "=================================="

# 1. System Services Setup
echo "Configuring systemd-resolved..."
sudo systemctl enable --now systemd-resolved

# Link the resolv.conf to the systemd-resolved stub
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# Ensure NetworkManager uses systemd-resolved
sudo mkdir -p /etc/NetworkManager/conf.d/
echo -e "[main]\ndns=systemd-resolved" | sudo tee /etc/NetworkManager/conf.d/dns.conf > /dev/null
sudo systemctl restart NetworkManager

# 2. Directory & Files
sudo mkdir -p $DIR

# Files to download (using the names in your repo)
FILES=("mullvad.conf" "controld.conf" "cloudflare.conf")

for FILE in "${FILES[@]}"; do
    echo "Downloading $FILE as backup..."
    # Download as .bak so they are disabled by default
    sudo wget -q "https://raw.githubusercontent.com/$GH_USER/$GH_REPO/$BRANCH/$FILE" -O "$DIR/$FILE.bak"
done

# 3. The Management Script
echo "Downloading dns controller..."
# Download the script to /usr/local/bin so it's available everywhere without an alias
sudo wget -q "https://raw.githubusercontent.com/$GH_USER/$GH_REPO/$BRANCH/dns.sh" -O /usr/local/bin/dns
sudo chmod +x /usr/local/bin/dns

echo "----------------------------------"
echo " INSTALLATION COMPLETE"
echo " Just type 'dns' to start."
echo "----------------------------------"
