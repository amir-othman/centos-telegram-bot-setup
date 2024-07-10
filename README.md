# Telegram Message Forward Bot Setup Script 📜🤖

Welcome to the Telegram Message Forward Bot setup script repository! This script is designed to automate the installation of necessary dependencies for setting up a Telegram Message Forward Bot on CentOS systems.

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Author](#author)
- [License](#license)

## Introduction

This script will:
1. Update CentOS repositories to use `vault.centos.org` 🏗️
2. Install `nano` editor ✍️
3. Install Python 3.8 🐍
4. Install necessary Python modules for the Telegram Message Forward Bot, including `requests` and `python-telegram-bot` 📦

## Prerequisites

Before running the script, ensure that you:
- Are using a CentOS system 🖥️
- Have superuser (sudo) privileges 🔐

## Usage

1. Clone the repository to your local machine:
    ```bash
    git clone https://github.com/amir-othman/telegram-message-forward-bot-setup.git
    cd telegram-message-forward-bot-setup
    ```

2. Make the script executable:
    ```bash
    chmod +x setup.sh
    ```

3. Run the script with sudo:
    ```bash
    sudo ./setup.sh
    ```

## Author

- **Amir Othman** - [GitHub](http://github.com/amir-othman)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

This script was coded to set up all the modules for the Telegram Message Forward Bot. If you encounter any issues or have suggestions for improvements, feel free to open an issue or submit a pull request. Enjoy! 🎉
