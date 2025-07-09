
#!/bin/bash

# Warna terminal
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RESET='\033[0m'
BLUE_LINE="\033[1;34m────────────────────────────────────────────${RESET}"

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
            echo -e "${CYAN}Enter Vikey API Key:${RESET}"
            read api_key
            echo -e "${CYAN}Enter Kuzco Worker Code:${RESET}"
            read worker_code

            echo -e "${GREEN}Installing Docker & dependencies...${RESET}"
            apt update
            apt install -y docker.io docker-compose git

            echo -e "${GREEN}Cloning installer...${RESET}"
            rm -rf ~/kuzco-installer-docker
            git clone https://github.com/direkturcrypto/kuzco-installer-docker ~/kuzco-installer-docker

            cd ~/kuzco-installer-docker/kuzco-main
            sed -i "s/YOUR_VIKEY_API_KEY/$api_key/" docker-compose.yml
            sed -i "s/YOUR_WORKER_CODE/$worker_code/" docker-compose.yml

            echo -e "${GREEN}Starting worker...${RESET}"
            docker-compose up -d --build
            read -n 1 -s -r -p "Press any key to return to menu"
            ;;
        2)
            cd ~/kuzco-installer-docker/kuzco-main || exit
            docker-compose logs -f --tail 100
            ;;
        3)
            cd ~/kuzco-installer-docker/kuzco-main || exit
            docker-compose down
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
