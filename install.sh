#!/bin/bash

GH_USER="amirhamzah0"
GH_REPO="Simple-Systemd-DNS-Changer"
BRANCH="main"
DIR="/etc/systemd/resolved.conf.d"

echo "=================================="
echo "   AUTOMATED DNS SETUP: CACHYOS   "
echo "=================================="

# 1. System Services Setup
sudo systemctl enable --now systemd-resolved
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# NetworkManager link
sudo mkdir -p /etc/NetworkManager/conf.d/
echo -e "[main]\ndns=systemd-resolved" | sudo tee /etc/NetworkManager/conf.d/dns.conf > /dev/null
sudo systemctl restart NetworkManager

# 2. Files Download
sudo mkdir -p $DIR
FILES=("mullvad.conf" "controld.conf" "cloudflare.conf")

for FILE in "${FILES[@]}"; do
    echo "Downloading $FILE..."
    sudo wget -q "https://raw.githubusercontent.com/$GH_USER/$GH_REPO/$BRANCH/$FILE" -O "$DIR/$FILE.bak"
done

# 3. Fix Script Permissions and Path
echo "Installing dns controller to /usr/local/bin..."
sudo wget -q "https://raw.githubusercontent.com/$GH_USER/$GH_REPO/$BRANCH/dns.sh" -O /usr/local/bin/dns
sudo chmod +x /usr/local/bin/dns

# 4. Alias Cleanup (Removes the old dead alias)
sed -i '/alias dns=/d' ~/.bashrc
# Adding a clean alias that points to the new location
echo "alias dns='/usr/local/bin/dns'" >> ~/.bashrc

echo "----------------------------------"
echo " INSTALLATION COMPLETE"
echo " Please run: source ~/.bashrc"
echo " Then type 'dns' to start."
echo "----------------------------------"
