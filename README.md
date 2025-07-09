
Kuzco Auto Installer (No GPU)

This repository provides an automated and interactive way to install and manage a Kuzco inference worker on a VPS without GPU.

Supports:
- Ubuntu 22.04 / 24.04
- RAM ≥ 4GB
- CPU-only VPS (no GPU required)

---

Installation Methods

You can choose either one-command auto install, or use an interactive CLI menu.

1. One-Line Auto Installer (Simple)

Runs a one-time installer that:
- Installs Docker & dependencies
- Asks for your Vikey API key and Kuzco Worker code
- Automatically launches the worker

curl -O https://raw.githubusercontent.com/GoldVPS/kuzco-with-out-gpu/main/install.sh && bash install.sh

2. Interactive CLI Menu

If you prefer a menu-based interface to add/start/stop/view workers:

curl -O https://raw.githubusercontent.com/GoldVPS/kuzco-with-out-gpu/main/kuzco-menu.sh && bash kuzco-menu.sh

Menu features:
- Add & Run worker
- View logs (live)
- Stop worker
- Reinstall
- Exit

---

Requirements

- A VPS with Ubuntu 22.04 or 24.04
- Minimum 4GB RAM
- API Key from https://vikey.ai
- Worker Code from https://kuzco.ai

You can get your worker code from the Kuzco dashboard under:
Worker > Launch Worker > CLI tab.

Example:
inference node start --code 5367fbca-xxxx-xxxx-xxxx-xxxxxxxx
Use only the code part (5367fbca-xxxx-...) in the script.

---

Credits

This script was heavily inspired and adapted from the tutorial originally written by a31:

Kuzco Epoch 3 – Cara Setup Docker di Inference Kuzco Menggunakan VPS Tanpa GPU:
https://paragraph.com/@a31/kuzco-epoch-3-cara-setup-docker-di-inference-kuzco-menggunakan-vps-tanpa-gpu

Thanks to the author for sharing the foundational steps and explanation.

---

Created by GOLDVPS (https://t.me/GoldVPSBot)

Need fast, reliable VPS with NVMe & affordable pricing?
Visit: https://goldvps.net
