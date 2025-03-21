#!/bin/bash

# Colors
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
CYAN="\e[36m"
NC="\e[0m"

# Step 0: Install EPEL
yum install -y epel-release

# Clear screen
clear

# Banner
echo -e "${CYAN}"
echo "┌──────────────────────────────────────────────┐"
echo "│      SYSTEM ADMIN | MAHFUZ REHAM 👨‍💻         │"
echo "│         Cpanel Trial Installer v2.0          │"
echo "└──────────────────────────────────────────────┘"
echo -e "${NC}"
sleep 2

# Step 1: Check OS
echo -e "${YELLOW}[~] Checking OS Version...${NC}"
OS=$(grep -i "^name" /etc/os-release | cut -d= -f2 | tr -d '"')
VERSION=$(grep VERSION_ID /etc/os-release | cut -d= -f2 | tr -d '"')

if [[ "$OS" == "AlmaLinux" && "$VERSION" == 8* ]]; then
    echo -e "${GREEN}[OK] Running on AlmaLinux 8.x${NC}"
else
    echo -e "${RED}[ERROR] This script is for AlmaLinux 8 only.${NC}"
    exit 1
fi

# Step 2: System Requirements Check
echo -e "${YELLOW}[~] Checking cPanel System Requirements...${NC}"
RAM=$(free -m | awk '/^Mem:/{print $2}')
CPU=$(nproc)
DISK=$(df -h / | awk 'NR==2{print $2}')
ARCH=$(uname -m)

echo -e "${CYAN}RAM          : $RAM MB"
echo "CPU Cores    : $CPU"
echo "Disk Size    : $DISK"
echo "Architecture : $ARCH${NC}"

if [ "$RAM" -lt 2048 ]; then
    echo -e "${RED}[FAIL] Minimum 2 GB RAM required.${NC}"
    exit 1
else
    echo -e "${GREEN}[OK] RAM is sufficient.${NC}"
fi

# Step 3: Set Hostname
echo -e "${YELLOW}[~] Setting hostname...${NC}"
hostnamectl set-hostname trialserver.local
echo -e "${GREEN}[OK] Hostname set.${NC}"

# Step 4: Disable NetworkManager
echo -e "${YELLOW}[~] Disabling NetworkManager...${NC}"
systemctl stop NetworkManager
systemctl disable NetworkManager
echo -e "${GREEN}[OK] NetworkManager disabled.${NC}"

# Step 5: Install cPanel
echo -e "${YELLOW}[~] Starting cPanel installation...${NC}"
cd /home && curl -o latest -L https://securedownloads.cpanel.net/latest && sh latest

# Step 6: Wait for install and activate license
echo -e "${YELLOW}[~] Waiting for install to finish...${NC}"
while [ ! -f /usr/local/cpanel/cpkeyclt ]; do sleep 10; done

echo -e "${YELLOW}[~] Activating license...${NC}"
/usr/local/cpanel/cpkeyclt && echo -e "${GREEN}[OK] License activated.${NC}" || echo -e "${RED}[FAIL] License activation failed.${NC}"

# Step 7: Set contact info
echo -e "${YELLOW}[~] Setting WHM contact email...${NC}"
/usr/local/cpanel/bin/set_contactinfo --email root@yourdomain.com
echo -e "${GREEN}[OK] Contact email set.${NC}"

# Step 8: Set nameservers
echo -e "${YELLOW}[~] Setting default nameservers...${NC}"
/usr/local/cpanel/scripts/setupnameserver --default ns1.yourdomain.com ns2.yourdomain.com
echo -e "${GREEN}[OK] Nameservers set.${NC}"

# Step 9: Enable services
echo -e "${YELLOW}[~] Enabling services...${NC}"
systemctl enable cpanel --now
systemctl enable httpd --now
echo -e "${GREEN}[OK] Services running.${NC}"

# Step 10: Done
IP=$(hostname -I | awk '{print $1}')
echo -e "${CYAN}"
echo "┌──────────────────────────────────────────────┐"
echo "│ ✅ cPanel Installed                          │"
echo "│ WHM URL   : https://$IP:2087                │"
echo "│ Username  : root                             │"
echo "│ Password  : (your server root password)      │"
echo "└──────────────────────────────────────────────┘"
echo -e "${NC}"

# Step 11: Clear history and exit
history -c
exit
