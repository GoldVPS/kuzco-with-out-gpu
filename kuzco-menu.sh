#!/usr/bin/env bash
set -euo pipefail

# ========= Konfigurasi repo kamu =========
REPO_URL="https://github.com/GoldVPS/kuzco-with-out-gpu.git"
INSTALL_DIR="$HOME/kuzco-hyperbolic"
SUBDIR="kuzco-main"   # berisi docker-compose.yml

# ========= Warna =========
GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; RESET='\033[0m'
LGOLD='\e[1;33m'; ULINE='\e[4;33m'; NC='\e[0m'
LINE="\e[38;5;220m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"

ok(){ echo -e "${GREEN}✔ $*${RESET}"; }
warn(){ echo -e "${YELLOW}⚠ $*${RESET}"; }
err(){ echo -e "${RED}✖ $*${RESET}" >&2; }
pause(){ read -n 1 -s -r -p "Press any key to return to menu"; echo; }

need_sudo(){ command -v sudo >/dev/null 2>&1 || { err "sudo tidak tersedia."; exit 1; }; }

header(){
  clear
  echo -e "${LGOLD}"
  echo " ██████╗  ██████╗ ██╗     ██████╗ ██╗   ██╗██████╗ ███████╗"
  echo "██╔════╝ ██╔═══██╗██║     ██╔══██╗██║   ██║██╔══██╗██╔════╝"
  echo "██║  ███╗██║   ██║██║     ██║  ██║██║   ██║██████╔╝███████╗"
  echo "██║   ██║██║   ██║██║     ██║  ██║╚██╗ ██╔╝██╔═══╝ ╚════██║"
  echo "╚██████╔╝╚██████╔╝███████╗██████╔╝ ╚████╔╝ ██║     ███████║"
  echo " ╚═════╝  ╚═════╝ ╚══════╝╚═════╝   ╚═══╝  ╚═╝     ╚══════╝"
  echo -e "${NC}"
  echo -e "🚀 ${LGOLD}Kuzco Node Installer${NC} – Powered by ${LGOLD}GoldVPS Team${NC} 🚀"
  echo -e "🌐 ${ULINE}https://goldvps.net${NC} – Best VPS with Low Price"
  echo ""
}

install_docker(){
  echo -e "${YELLOW}Installing / updating Docker...${RESET}"
  if ! command -v docker >/dev/null 2>&1; then
    need_sudo
    sudo apt-get update -y
    sudo apt-get install -y ca-certificates curl gnupg git lsb-release
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor \
      -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
      | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo systemctl enable docker
    sudo systemctl start docker
  fi
  ok "Docker ready"
}

clone_repo(){
  echo -e "${YELLOW}Sync repo...${RESET}"
  rm -rf "$INSTALL_DIR"
  git clone --depth 1 "$REPO_URL" "$INSTALL_DIR" || { err "Gagal clone repo."; exit 1; }
  ok "Repo tersalin ke $INSTALL_DIR"
}

patch_compose(){
  local api_key="$1" code="$2" name="$3"
  local compose="$INSTALL_DIR/$SUBDIR/docker-compose.yml"
  [[ -f "$compose" ]] || { err "docker-compose.yml tidak ditemukan di $compose"; exit 1; }

  # Ganti placeholder (pastikan compose kamu punya placeholder ini)
  sed -i "s|YOUR_HYPERBOLIC_API_KEY|$api_key|g" "$compose" || true
  sed -i "s|YOUR_WORKER_CODE|$code|g" "$compose" || true
  sed -i "s|YOUR_WORKER_NAME|$name|g" "$compose" || true
  ok "Konfigurasi terisi"
}

compose_up(){
  ( cd "$INSTALL_DIR/$SUBDIR" && sudo docker compose up -d --build )
  ok "Worker berjalan"
  echo
  echo -e "${CYAN}Lihat log:${RESET}   cd $INSTALL_DIR/$SUBDIR && sudo docker compose logs -f --tail 200"
}

compose_logs(){
  ( cd "$INSTALL_DIR/$SUBDIR" && sudo docker compose logs -f --tail 200 )
}

compose_down(){
  ( cd "$INSTALL_DIR/$SUBDIR" && sudo docker compose down || true )
  ok "Worker stopped"
}

main_menu(){
  while true; do
    header
    echo -e "${LINE}"
    echo -e "  ${GREEN}1.${RESET} Add & Run Worker"
    echo -e "  ${GREEN}2.${RESET} View Logs"
    echo -e "  ${GREEN}3.${RESET} Stop Worker"
    echo -e "  ${GREEN}4.${RESET} Reinstall Worker"
    echo -e "  ${GREEN}5.${RESET} Exit"
    echo -e "${LINE}"
    read -p "Select an option (1–5): " opt

    case "$opt" in
      1)
        echo -ne "${CYAN}Enter Hyperbolic API Key: ${RESET}"
        read -s -r API_KEY; echo
        [[ -n "$API_KEY" ]] || { err "API key wajib diisi"; pause; continue; }

        echo -ne "${CYAN}Enter Kuzco Worker Code: ${RESET}"
        read -r CODE
        [[ -n "$CODE" ]] || { err "Worker code wajib diisi"; pause; continue; }

        DEFAULT_NAME="kuzco-$(hostname)"
        echo -ne "${CYAN}Enter Worker Name [default: $DEFAULT_NAME]: ${RESET}"
        read -r NAME
        NAME=${NAME:-$DEFAULT_NAME}

        install_docker
        clone_repo
        patch_compose "$API_KEY" "$CODE" "$NAME"
        compose_up
        pause
        ;;
      2)
        compose_logs
        ;;
      3)
        compose_down
        pause
        ;;
      4)
        compose_down
        rm -rf "$INSTALL_DIR"
        ok "Reinstall ready. Pilih menu 1 untuk install ulang."
        pause
        ;;
      5)
        echo -e "${CYAN}Bye!${RESET}"
        exit 0
        ;;
      *)
        err "Invalid option. Choose 1–5."
        sleep 1
        ;;
    esac
  done
}

main_menu
