#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# -----------------------------------------------------------------------------
# Script to update CentOS repositories, install nano and Python 3.8, and install
# necessary Python modules.
#
# This script was coded to set up all the modules for the Telegram Message Forward Bot.
#
# Author: Amir Othman
# GitHub: http://github.com/amir-othman
# -----------------------------------------------------------------------------

# Function to check if the script is running on CentOS
check_centos() {
  if ! grep -q -i "centos" /etc/os-release; then
    echo "This script is intended to be run on CentOS systems only."
    exit 1
  fi
}

# Check if the system is CentOS
check_centos

# Updating CentOS repositories to use vault.centos.org
echo "Updating CentOS repositories..."
cd /etc/yum.repos.d/
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

# Update system packages
echo "Updating system packages..."
yum update -y

# Install nano
echo "Installing nano..."
sudo dnf install epel-release -y
sudo dnf update -y
sudo dnf install nano -y

# Install Python 3.8
echo "Installing Python 3.8..."
sudo dnf install -y gcc openssl-devel bzip2-devel libffi-devel
cd /opt
sudo wget https://www.python.org/ftp/python/3.8.12/Python-3.8.12.tgz
sudo tar xvf Python-3.8.12.tgz
cd Python-3.8*/
sudo ./configure --enable-optimizations --with-ensurepip=install
sudo make altinstall

# Install Python modules
echo "Installing Python modules..."
pip3.8 install requests
pip3.8 install python-telegram-bot
pip3.8 install python-telegram-bot --pre

echo "All tasks completed successfully."