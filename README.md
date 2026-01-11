# Simple Systemd DNS Changer

A lightweight, high-performance DNS switcher for Linux (Fedora, CachyOS, Arch) using `systemd-resolved`. Switch between Mullvad, ControlD, and Cloudflare with a single command.

## 🚀 One-Line Installation

Run this command to automatically configure `systemd-resolved` and install the `dns` utility:

```bash
curl -sSL https://raw.githubusercontent.com/amirhamzah0/Simple-Systemd-DNS-Changer/main/install.sh | sudo bash
```
<br><br>
🛠 Usage<br>
Once installed, simply type dns in your terminal:

```bash 
dns
```
<br><br>
Options:
Default: Reverts to your ISP or Router's DNS.

Mullvad: Secure, privacy-focused DNS.

ControlD: High-performance DNS with filtering.

Cloudflare: Industry-standard fast DNS (1.1.1.1).

<img width="666" height="481" alt="Screenshot_20260110_222903" src="https://github.com/user-attachments/assets/44bed044-cb17-4894-9539-ca3b4e91014b" />
<br>
<br>

📁 Features
Zero Resource Usage: Changes are made at the system level; no background processes stay running.

DNS-over-TLS Ready: Configured to work with systemd's secure resolution.

Version Check: Notifies you if you have updated your configs on GitHub.

Smart Switcher: Automatically handles .bak file swapping to keep /etc/ clean
