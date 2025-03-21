# 🧪 cPanel Trial Installer for AlmaLinux 8

Welcome to the **cPanel Trial Installer** by **System Admin | Mahfuz Reham** 👨‍💻  
This script automates the full setup of a raw cPanel server with a trial license, perfect for testing or temporary hosting environments.

---

## ⚙️ Features

- Installs `epel-release` automatically
- Checks and validates AlmaLinux 8.x environment
- Displays system specs in hacker-style
- Sets hostname and disables NetworkManager
- Installs latest cPanel version
- Automatically activates trial license
- Configures WHM with:
  - Root contact email
  - Default nameservers
- Starts necessary services (cpanel, httpd)
- Clears history and exits securely

---

## 🧾 System Requirements

- OS: **AlmaLinux 8.x**
- RAM: Minimum **2 GB**
- Root SSH access
- Fresh server recommended

---

## 🚀 How to Install (One Line)

Copy and paste the following command into your AlmaLinux 8 server as root:

```bash
yum install -y epel-release && curl -O https://raw.githubusercontent.com/mahfuzreham/server-trial-setup/main/cpanel_trial_installer.sh && chmod +x cpanel_trial_installer.sh && sudo ./cpanel_trial_installer.sh
