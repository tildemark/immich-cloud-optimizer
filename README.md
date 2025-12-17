# Immich Cloud Optimizer 🚀

**Host massive photo libraries on Oracle Cloud (OCI) Free Tier without running out of storage or bandwidth.**

This repository contains the scripts and configurations used to optimize, mirror, and sync a large (20k+) photo library to a self-hosted Immich instance running on low-resource hardware (OCI Ampere / Raspberry Pi).

## Repository Structure

```text
immich-cloud-optimizer/
├── client-side/
│   ├── windows/
│   │   ├── mirror_convert.ps1     # The "Smart Sync" PowerShell script
│   │   ├── sync_photos.bat        # The 1-click wrapper
│   │   └── cleanup_originals.ps1  # (Optional) delete original JPGs
│   └── linux/
│       ├── mirror_convert.sh      # Bash version of Smart Sync
│       └── sync_photos.sh         # Bash wrapper
├── server-side/
│   ├── docker-compose.yml         # OCI setup with NPM network
│   └── .env.example               # Template for secrets
└── README.md                      # The documentation

```
---

## 📖 The Strategy

1.  **Local "Mirror":** We do not upload heavy 10MB JPEGs. We create a local mirror of high-quality **WebP** images (approx. 500KB each).
2.  **Smart Sync:** Scripts only convert and upload new or edited photos.
3.  **Cloud Hosting:** A tuned Docker setup for OCI Always Free tier (4 OCPUs, 24GB RAM).

## 🛠 Prerequisites

### Client Side (Your PC)
* [libwebp](https://developers.google.com/speed/webp/download) installed and in PATH.
* [immich-go](https://github.com/simulot/immich-go) installed and in PATH.

### Server Side (OCI / VPS)
* Docker & Docker Compose.
* [Nginx Proxy Manager](https://nginxproxymanager.com/) (running on a network named `net`).

## 💻 Client Setup (Windows)

1.  Navigate to `client-side/windows/`.
2.  Edit `mirror_convert.ps1`: Set `$SourceRoot` and `$DestRoot`.
3.  Edit `sync_photos.bat`: Update your API Key and Server URL.
4.  **Usage:** Double-click `sync_photos.bat`.

## 🐧 Client Setup (Linux / macOS)

1.  Navigate to `client-side/linux/`.
2.  Make scripts executable: `chmod +x *.sh`
3.  Edit `mirror_convert.sh` and `sync_photos.sh` with your paths.
4.  **Usage:** Run `./sync_photos.sh`.

## ☁️ Server Setup (Docker)

1.  Navigate to `server-side/`.
2.  Copy `.env.example` to `.env`: `cp .env.example .env`
3.  Edit `.env` with your database passwords.
4.  Deploy: `docker compose up -d`

## License
MIT
