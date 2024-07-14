#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# -----------------------------------------------------------------------------
# Script to update CentOS repositories, install nano, git, and Python 3.8, and install
# necessary Python modules.
#
# This script was coded to set up all the modules for the Telegram Message Forward Bot.
#
# Author: Amir Othman
# GitHub: http://github.com/amir-othman
# -----------------------------------------------------------------------------

# Determine the directory of the script
SCRIPT_DIR=$(dirname "$0")

# Function to check if the script is running on CentOS
check_centos() {
  if ! grep -q -i "centos" /etc/os-release; then
    echo "This script is intended to be run on CentOS systems only."
    exit 1
  fi
}

# Function to set Google DNS
set_dns() {
  echo "Setting Google DNS..."
  sudo tee /etc/resolv.conf > /dev/null <<EOL
nameserver 8.8.8.8
nameserver 8.8.4.4
EOL
}

# Function to check network connectivity
check_network() {
  echo "Checking network connectivity..."
  if ! ping -c 3 8.8.8.8; then
    echo "Network connectivity issue. Please check your network settings."
    exit 1
  fi
}

# Check if the system is CentOS
check_centos

# Set Google DNS
set_dns

# Check network connectivity
check_network

# Updating CentOS repositories to use the CentOS Vault repository
echo "Updating CentOS repositories..."
cd /etc/yum.repos.d/
sudo sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-*
sudo sed -i 's|^#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
sudo sed -i 's|^baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

# Update system packages
echo "Updating system packages..."
sudo yum clean all
sudo yum update -y

# Install nano and git
echo "Installing nano and git..."
sudo dnf install epel-release -y
sudo dnf update -y
sudo dnf install nano git -y

# Install Python 3.8
echo "Installing Python 3.8..."
sudo dnf install -y gcc openssl-devel bzip2-devel libffi-devel
cd /opt
sudo wget https://www.python.org/ftp/python/3.8.12/Python-3.8.12.tgz
sudo tar xvf Python-3.8.12.tgz
cd Python-3.8*/
sudo ./configure --enable-optimizations --with-ensurepip=install
sudo make altinstall

# Ensure pip for Python 3.8 is installed
echo "Installing pip for Python 3.8..."
sudo /usr/local/bin/python3.8 -m ensurepip
sudo /usr/local/bin/python3.8 -m pip install --upgrade pip

# Install Python modules using the correct pip
echo "Installing Python modules..."
sudo /usr/local/bin/pip3.8 install requests
sudo /usr/local/bin/pip3.8 install python-telegram-bot
sudo /usr/local/bin/pip3.8 install python-telegram-bot --pre
sudo /usr/local/bin/pip3.8 install python-dotenv

# Create necessary files
echo "Creating necessary files..."
touch "$SCRIPT_DIR/toks.txt" "$SCRIPT_DIR/bhy.txt" "$SCRIPT_DIR/forwarded_messages.csv"

# Change ownership and permissions of the created files
sudo chown $(whoami):$(whoami) "$SCRIPT_DIR/toks.txt" "$SCRIPT_DIR/bhy.txt" "$SCRIPT_DIR/forwarded_messages.csv"
chmod 664 "$SCRIPT_DIR/toks.txt" "$SCRIPT_DIR/bhy.txt" "$SCRIPT_DIR/forwarded_messages.csv"

# Prompt for environment variables
read -p "Enter BOT_TOKEN_MENU: " BOT_TOKEN_MENU
read -p "Enter BOT_TOKEN_DEBUG: " BOT_TOKEN_DEBUG
read -p "Enter BOT_TOKEN_FORWARD: " BOT_TOKEN_FORWARD
read -p "Enter ADMIN_ID: " ADMIN_ID
read -p "Enter GROUP_ID: " GROUP_ID

# Create .env file with environment variables
echo "Creating .env file..."
cat <<EOL > "$SCRIPT_DIR/.env"
# .env file
BOT_TOKEN_MENU="$BOT_TOKEN_MENU"
BOT_TOKEN_DEBUG="$BOT_TOKEN_DEBUG"
BOT_TOKEN_FORWARD="$BOT_TOKEN_FORWARD"
ADMIN_ID="$ADMIN_ID"
GROUP_ID="$GROUP_ID"
VIDEO_PATH="mda.mp4"
ACTIVTOKENS="toks.txt"
LIST_STARTED="bhy.txt"
PASTEBIN_API_KEY="4b84668d7764e73d76feefe2ad5defdd"
CSV_FILE="forwarded_messages.csv"
EOL

# Change ownership and permissions of the .env file
sudo chown $(whoami):$(whoami) "$SCRIPT_DIR/.env"
chmod 664 "$SCRIPT_DIR/.env"

# Create pictures folder
echo "Creating pictures folder..."
mkdir -p ~/pictures

# Change ownership and permissions of the created folder
sudo chown $(whoami):$(whoami) ~/pictures
chmod 775 ~/pictures

# Prompt for Personal Access Token
read -p "Enter your GitLab Personal Access Token: " personal_access_token

# Clone the Git repository securely using PAT
echo "Cloning the Git repository..."
git clone https://aron-tn:$personal_access_token@gitlab.com/aron-tn1/centos-telegram-bot.git

# Move Python files from the cloned repository to the script directory
echo "Moving Python files from the cloned repository..."
mv centos-telegram-bot/*.py "$SCRIPT_DIR/"

# Change ownership and permissions of the moved files
echo "Changing ownership and permissions of the moved files..."
sudo chown $(whoami):$(whoami) "$SCRIPT_DIR"/*.py
chmod 664 "$SCRIPT_DIR"/*.py

# Remove the cloned repository folder
echo "Removing the cloned repository folder..."
rm -rf centos-telegram-bot

echo "All tasks completed successfully."
