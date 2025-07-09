#!/bin/bash

# Warna terminal
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
RESET='\033[0m'
BLUE_LINE="\033[1;34m────────────────────────────────────────────${RESET}"

WORKERS_DIR=~/kuzco-workers

mkdir -p "$WORKERS_DIR"

function list_workers() {
    echo -e "${CYAN}Available Workers:${RESET}"
    if [ "$(ls -A $WORKERS_DIR)" ]; then
        i=1
        for dir in "$WORKERS_DIR"/*; do
            if [ -d "$dir" ]; then
                echo "  $i) $(basename "$dir")"
                ((i++))
            fi
        done
    else
        echo -e "${RED}  No workers found.${RESET}"
    fi
}

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
            echo -e "${CYAN}Enter a unique Worker Name (no spaces):${RESET}"
            read worker_name
            worker_path="$WORKERS_DIR/$worker_name"

            if [ -d "$worker_path" ]; then
                echo -e "${RED}Worker name already exists. Choose a different name.${RESET}"
                sleep 2
                continue
            fi

            echo -e "${CYAN}Enter Vikey API Key:${RESET}"
            read api_key
            echo -e "${CYAN}Enter Kuzco Worker Code:${RESET}"
            read worker_code

            echo -e "${GREEN}Installing Docker & dependencies...${RESET}"
            apt update
            apt install -y docker.io docker-compose git

            echo -e "${GREEN}Cloning installer...${RESET}"
            git clone https://github.com/direkturcrypto/kuzco-installer-docker "$worker_path"

            cd "$worker_path/kuzco-main"
            sed -i "s/YOUR_VIKEY_API_KEY/$api_key/" docker-compose.yml
            sed -i "s/YOUR_WORKER_CODE/$worker_code/" docker-compose.yml

            echo -e "${GREEN}Starting worker '$worker_name'...${RESET}"
            docker-compose up -d --build
            read -n 1 -s -r -p "Press any key to return to menu"
            ;;
        2)
            list_workers
            echo -ne "${CYAN}Enter the number of the worker to view logs:${RESET} "
            read choice

            selected=$(ls -d $WORKERS_DIR/* | sed -n "${choice}p")

            if [ -z "$selected" ]; then
                echo -e "${RED}Invalid choice.${RESET}"
                sleep 1
                continue
            fi

            cd "$selected/kuzco-main" || exit
            docker-compose logs -f --tail 100
            ;;
        3)
            list_workers
            echo -ne "${CYAN}Enter the number of the worker to stop:${RESET} "
            read choice

            selected=$(ls -d $WORKERS_DIR/* | sed -n "${choice}p")

            if [ -z "$selected" ]; then
                echo -e "${RED}Invalid choice.${RESET}"
                sleep 1
                continue
            fi

            cd "$selected/kuzco-main" || exit
            docker-compose down
            echo -e "${GREEN}Worker stopped.${RESET}"
            sleep 1
            ;;
        4)
            list_workers
            echo -ne "${CYAN}Enter the number of the worker to reinstall:${RESET} "
            read choice

            selected=$(ls -d $WORKERS_DIR/* | sed -n "${choice}p")

            if [ -z "$selected" ]; then
                echo -e "${RED}Invalid choice.${RESET}"
                sleep 1
                continue
            fi

            rm -rf "$selected"
            echo -e "${GREEN}Worker removed. Run option 1 to reinstall.${RESET}"
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
