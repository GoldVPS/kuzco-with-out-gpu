#!/bin/bash

# Warna Terminal
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
RESET='\033[0m'
BLUE_LINE="\033[1;34m────────────────────────────────────────────${RESET}"

# Folder dasar
BASE_DIR=~/kuzco-workers
mkdir -p "$BASE_DIR"

while true; do
    clear
    echo -e "${BLUE_LINE}"
    echo -e "${CYAN}            Kuzco Worker Manager           ${RESET}"
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
            echo -e "${CYAN}Enter Worker Name (e.g. worker1):${RESET}"
            read worker_name
            echo -e "${CYAN}Enter Vikey API Key:${RESET}"
            read api_key
            echo -e "${CYAN}Enter Kuzco Worker Code:${RESET}"
            read worker_code

            worker_dir="${BASE_DIR}/${worker_name}"
            mkdir -p "$worker_dir"

            echo -e "${GREEN}Installing Docker & dependencies...${RESET}"
            apt update -y
            apt install -y docker.io docker-compose git

            echo -e "${GREEN}Cloning installer...${RESET}"
            git clone https://github.com/GoldVPS/kuzco-with-out-gpu.git "$worker_dir" >/dev/null 2>&1

            cd "$worker_dir" || exit
            sed -i "s/YOUR_VIKEY_API_KEY/${api_key}/" docker-compose.yml
            sed -i "s/YOUR_WORKER_CODE/${worker_code}/" docker-compose.yml

            echo -e "${GREEN}Starting worker ${worker_name}...${RESET}"
            docker-compose up -d --build
            read -n 1 -s -r -p "Press any key to return to menu"
            ;;
        2)
            echo -e "${CYAN}Available Workers:${RESET}"
            ls "$BASE_DIR"
            echo -e "${CYAN}Enter Worker Name to view logs:${RESET}"
            read worker_name
            cd "$BASE_DIR/$worker_name" || { echo -e "${RED}Worker not found.${RESET}"; sleep 2; continue; }
            docker-compose logs -f --tail 100
            ;;
        3)
            echo -e "${CYAN}Available Workers:${RESET}"
            ls "$BASE_DIR"
            echo -e "${CYAN}Enter Worker Name to stop:${RESET}"
            read worker_name
            cd "$BASE_DIR/$worker_name" || { echo -e "${RED}Worker not found.${RESET}"; sleep 2; continue; }
            docker-compose down
            echo -e "${GREEN}Worker ${worker_name} stopped.${RESET}"
            sleep 1
            ;;
        4)
            echo -e "${CYAN}Available Workers:${RESET}"
            ls "$BASE_DIR"
            echo -e "${CYAN}Enter Worker Name to reinstall:${RESET}"
            read worker_name
            rm -rf "$BASE_DIR/$worker_name"
            echo -e "${CYAN}Worker ${worker_name} removed. Use option 1 to reinstall.${RESET}"
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
