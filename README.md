
# Kuzco Auto Installer (No GPU Version)

This project provides a quick and automated way to install
and manage a Kuzco inference worker on a VPS without using GPU.

**Need powerful VPS with NVMe + affordable prices?**
**Order now:** https://goldvps.net

Supported OS: Ubuntu 22.04 or 24.04  
Minimum RAM : 4GB

------------------------------------------------------------
## INSTALLATION OPTIONS
------------------------------------------------------------

### [Option 1] One-Line Quick Install
---------------------------------
Automatically installs Docker, prompts for Vikey API key and
Kuzco Worker Code, then launches the worker.

Run this in your VPS terminal:
```bash
  curl -O https://raw.githubusercontent.com/GoldVPS/kuzco-with-out-gpu/main/install.sh && bash install.sh
```

### [Option 2] Interactive CLI Menu
-------------------------------
Provides a simple menu to add, start, stop, or view logs of your worker.

Run this in your VPS terminal:
```bash
  curl -O https://raw.githubusercontent.com/GoldVPS/kuzco-with-out-gpu/main/kuzco-menu.sh && bash kuzco-menu.sh
```

Main features:
  - Add & Run Worker
  - View Logs
  - Stop Worker
  - Reinstall Worker
  - Exit

------------------------------------------------------------
### REQUIREMENTS
------------------------------------------------------------

- A VPS with Ubuntu 22.04 or 24.04
- At least 4GB of RAM
- API Key from https://vikey.ai  
  A minimum credit of IDR 100,000 is required to pay API
- Worker Code from https://kuzco.ai

How to get your Worker Code:
  1. Go to Kuzco dashboard
  2. Select "Worker" > "Launch Worker" > CLI Tab
  3. Example output:
     inference node start --code 5367fbca-xxxx-xxxx-xxxx-xxxxxxxx
  4. Use only the UUID part as your code

------------------------------------------------------------
### CREDITS
------------------------------------------------------------

This installer was adapted from a guide written by @a31:

"Kuzco Epoch 3 – Cara Setup Docker di Inference Kuzco Menggunakan VPS Tanpa GPU"  
Link: https://paragraph.com/@a31/kuzco-epoch-3-cara-setup-docker-di-inference-kuzco-menggunakan-vps-tanpa-gpu

Special thanks for the foundational tutorial and knowledge.

------------------------------------------------------------
## MADE BY [GOLDVPS](https://goldvps.net)
------------------------------------------------------------

Created by: https://t.me/miftaikyy

Need powerful VPS with NVMe + affordable prices?  
Order now: https://goldvps.net
