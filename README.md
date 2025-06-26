# Webmin Auto-Installer Script

This Bash script automates the installation of **Webmin** on Debian- or Ubuntu-based systems. It performs system checks, ensures required packages are installed, and sets up the official Webmin repository to install and enable the Webmin web interface.

---

## 📋 Features

- Root permission check
- OS compatibility verification (supports only Debian/Ubuntu)
- Internet connectivity test
- Installation of required dependencies
- Securely adds the Webmin repository and GPG key
- Installs Webmin and starts the service automatically

---

## 🚀 Usage

> ⚠️ **Run as root!**  
> The script must be executed with root privileges.

### Download and execute:

```bash
wget https://your-repo-url.com/webmin-install.sh
chmod +x webmin-install.sh
sudo ./webmin-install.sh
