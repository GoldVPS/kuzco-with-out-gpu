#!/bin/bash

# === Warna terminal ===
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RESET='\033[0m'
BLUE_LINE="\e[38;5;220m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"

# === Tampilkan Header ===
function show_header() {
    clear
    echo -e "\e[38;5;220m"
    echo " ██████╗  ██████╗ ██╗     ██████╗ ██╗   ██╗██████╗ ███████╗"
    echo "██╔════╝ ██╔═══██╗██║     ██╔══██╗██║   ██║██╔══██╗██╔════╝"
    echo "██║  ███╗██║   ██║██║     ██║  ██║██║   ██║██████╔╝███████╗"
    echo "██║   ██║██║   ██║██║     ██║  ██║╚██╗ ██╔╝██╔═══╝ ╚════██║"
    echo "╚██████╔╝╚██████╔╝███████╗██████╔╝ ╚████╔╝ ██║     ███████║"
    echo " ╚═════╝  ╚═════╝ ╚══════╝╚═════╝   ╚═══╝  ╚═╝     ╚══════╝"
    echo -e "\e[0m"
    echo -e "🚀 \e[1;33mKuzco Node Installer\e[0m - Powered by \e[1;33mGoldVPS Team\e[0m 🚀"
    echo -e "🌐 \e[4;33mhttps://goldvps.net\e[0m - Best VPS with Low Price"
    echo ""
}

# === Install Docker dengan cara resmi ===
function install_docker() {
    echo -e "${YELLOW}Installing Docker (official)...${RESET}"
    apt remove docker docker.io containerd runc -y
    apt update
    apt install -y ca-certificates curl gnupg git lsb-release

    mkdir -m 0755 -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
      > /etc/apt/sources.list.d/docker.list

    apt update
    apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    
    function install_docker() {
    echo -e "${YELLOW}Installing Docker (official)...${RESET}"
    apt remove docker docker.io containerd runc -y
    apt update
    apt install -y ca-certificates curl gnupg git lsb-release

    mkdir -m 0755 -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
      > /etc/apt/sources.list.d/docker.list

    apt update
    apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    # ⬇️ Tambahan penting
    systemctl enable docker
    systemctl start docker
}

# === MAIN MENU ===
while true; do
    show_header
    echo -e "${BLUE_LINE}"
    echo -e "  ${GREEN}1.${RESET} Add & Run Worker"
    echo -e "  ${GREEN}2.${RESET} View Logs"
    echo -e "  ${GREEN}3.${RESET} Stop Worker"
    echo -e "  ${GREEN}4.${RESET} Reinstall Worker"
    echo -e "  ${GREEN}5.${RESET} Exit"
    echo -e "${BLUE_LINE}"
    read -p "Select an option (1–5): " option

    case $option in
        1)
            echo -e "${CYAN}Enter Vikey API Key:${RESET}"
            read api_key
            echo -e "${CYAN}Enter Kuzco Worker Code:${RESET}"
            read worker_code

            install_docker

            echo -e "${GREEN}Cloning installer...${RESET}"
            rm -rf ~/kuzco-installer-docker
            git clone https://github.com/direkturcrypto/kuzco-installer-docker ~/kuzco-installer-docker

            cd ~/kuzco-installer-docker/kuzco-main
            sed -i "s/YOUR_VIKEY_API_KEY/$api_key/" docker-compose.yml
            sed -i "s/YOUR_WORKER_CODE/$worker_code/" docker-compose.yml

            echo -e "${GREEN}Starting worker...${RESET}"
            docker compose up -d --build
            read -n 1 -s -r -p "Press any key to return to menu"
            ;;
        2)
            cd ~/kuzco-installer-docker/kuzco-main || exit
            docker compose logs -f --tail 100
            ;;
        3)
            cd ~/kuzco-installer-docker/kuzco-main || exit
            docker compose down
            echo -e "${GREEN}Worker stopped.${RESET}"
            sleep 1
            ;;
        4)
            echo -e "${GREEN}Reinstalling worker...${RESET}"
            rm -rf ~/kuzco-installer-docker
            echo -e "${CYAN}Worker removed. Run option 1 to reinstall.${RESET}"
            sleep 1
            ;;
        5)
            echo -e "${CYAN}Exiting...${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please choose 1–5.${RESET}"
            sleep 1
            ;;
    esac
done
