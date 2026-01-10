#!/bin/bash

# Configuration
DIR="/etc/systemd/resolved.conf.d"
MULLVAD="mullvad.conf"
CONTROLD="controld.conf"
CLOUDFLARE="cloudflare.conf"

clear
echo "=================================="
echo "      SYSTEM DNS CONTROLLER       "
echo "=================================="
echo "  1) Default (ISP/Router)"
echo "  2) Mullvad"
echo "  3) ControlD"
echo "  4) Cloudflare"
echo "----------------------------------"
read -p "  Selection [1-4]: " choice

# Disable all custom configurations first
[ -f "$DIR/$MULLVAD" ] && sudo mv "$DIR/$MULLVAD" "$DIR/$MULLVAD.bak"
[ -f "$DIR/$CONTROLD" ] && sudo mv "$DIR/$CONTROLD" "$DIR/$CONTROLD.bak"
[ -f "$DIR/$CLOUDFLARE" ] && sudo mv "$DIR/$CLOUDFLARE" "$DIR/$CLOUDFLARE.bak"

case $choice in
    1)
        PROFILE="Default (ISP)"
        ;;
    2)
        if [ -f "$DIR/$MULLVAD.bak" ]; then
            sudo mv "$DIR/$MULLVAD.bak" "$DIR/$MULLVAD"
            PROFILE="Mullvad DNS"
        else
            echo "Error: Mullvad configuration not found."
            exit 1
        fi
        ;;
    3)
        if [ -f "$DIR/$CONTROLD.bak" ]; then
            sudo mv "$DIR/$CONTROLD.bak" "$DIR/$CONTROLD"
            PROFILE="ControlD DNS"
        else
            echo "Error: ControlD configuration not found."
            exit 1
        fi
        ;;
    4)
        if [ -f "$DIR/$CLOUDFLARE.bak" ]; then
            sudo mv "$DIR/$CLOUDFLARE.bak" "$DIR/$CLOUDFLARE"
            PROFILE="Cloudflare DNS"
        else
            echo "Error: Cloudflare configuration not found."
            exit 1
        fi
        ;;
    *)
        echo "Invalid selection."
        exit 1
        ;;
esac

# Restart the service
sudo systemctl restart systemd-resolved

# Progress Feedback
echo ""
echo "Updating system resolver..."
sleep 1.5

# Enhanced Status Detection
# Grabs the DNS server specifically from the Global section
ACTIVE_DNS=$(resolvectl status | sed -n '/Global/,/Link/p' | grep "DNS Servers" | awk '{print $NF}')

# Fallback: if Global is empty, check the active Link
if [ -z "$ACTIVE_DNS" ]; then
    ACTIVE_DNS=$(resolvectl status | grep "Current DNS Server" | head -n 1 | awk '{print $NF}')
fi

echo "----------------------------------"
echo " STATUS REPORT"
echo "----------------------------------"
echo " Profile: $PROFILE"
echo " Address: $ACTIVE_DNS"
echo "----------------------------------"
