# 🛠️ Utility & Productivity Stack (`utility/`)

<p align="center">
  <img src="https://img.shields.io/badge/Paperless--ngx-007ACC?style=for-the-badge&logo=paperlessngx&logoColor=white" alt="Paperless-ngx" />
  <img src="https://img.shields.io/badge/Stirling--PDF-FF0000?style=for-the-badge&logo=adobeacrobatreader&logoColor=white" alt="Stirling-PDF" />
  <img src="https://img.shields.io/badge/IT--Tools-4A90E2?style=for-the-badge&logo=visualstudiocode&logoColor=white" alt="IT-Tools" />
  <img src="https://img.shields.io/badge/qBittorrent-2F67BA?style=for-the-badge&logo=bittorrent&logoColor=white" alt="qBittorrent" />
  <img src="https://img.shields.io/badge/Dozzle-1D2935?style=for-the-badge&logo=docker&logoColor=white" alt="Dozzle" />
</p>

The **Utility Stack** gathers essential day-to-day productivity tools, document archival, developer utilities, file transfers, and container log inspection in a single cohesive Compose deployment.

---

## 📦 Services Included

| Container Name | Service | Image | Ports | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| `paperless_ngx` | **Paperless-ngx** | `ghcr.io/paperless-ngx/paperless-ngx:latest` | `8010` (mapped to `8000`) | Document archival, indexing, full-text OCR ingestion |
| `stirling_pdf` | **Stirling-PDF** | `stirlingtools/stirling-pdf:latest` | `8083` (mapped to `8080`) | Comprehensive web-based PDF manipulation & conversion suite |
| `it_tools` | **IT-Tools** | `corentinth/it-tools:latest` | `8084` (mapped to `80`) | Web client providing developer tools (JWT, regex, hashes, encoders) |
| `qbittorrent` | **qBittorrent** | `lscr.io/linuxserver/qbittorrent:latest` | `8085` (Web UI), `6881` (Torrent) | BitTorrent client with web interface and local data directory |
| `dozzle` | **Dozzle** | `amir20/dozzle:latest` | `8888` (mapped to `8080`) | Real-time browser-based Docker container log streaming engine |

---

## 🔌 Port Mapping & Volumes

```text
utility/
├── docker-compose.yml
├── .env.example
├── .env
├── paperless/
│   ├── data/                 # Search index & sqlite cache (if not using PG)
│   ├── media/                # Processed PDFs & original document files
│   ├── export/               # Backup export target
│   └── consume/              # Watch folder: drop files here for auto-ingestion
├── stirling/
│   ├── trainingData/         # Tesseract OCR language definitions
│   ├── extraConfigs/         # Custom pipeline rules
│   ├── customFiles/          # Branding, icons, or custom templates
│   └── logs/                 # Operational logs
└── qbittorrent/
    ├── config/               # Client config, torrent states, and preferences
    └── downloads/            # Incomplete and completed download targets
```

| Service | Host Port | Internal Port | Key Volumes |
| :--- | :--- | :--- | :--- |
| **Paperless-ngx** | `${PAPERLESS_PORT}` (`8010`) | `8000` | `./paperless/data`, `./paperless/media`, `./paperless/consume`, `./paperless/export` |
| **Stirling-PDF** | `${STIRLING_PORT}` (`8083`) | `8080` | `./stirling/trainingData`, `./stirling/extraConfigs`, `./stirling/customFiles` |
| **IT-Tools** | `${IT_TOOLS_PORT}` (`8084`) | `80` | Stateless (In-memory Nginx) |
| **qBittorrent** | `${QBITTORRENT_PORT}` (`8085`) | `${QBITTORRENT_PORT}` | `./qbittorrent/config`, `./qbittorrent/downloads` |
| **qBittorrent Traffic** | `${QBIT_TORRENT_PORT}` (`6881`) | `6881` TCP/UDP | — |
| **Dozzle** | `${DOZZLE_PORT}` (`8888`) | `8080` | `/var/run/docker.sock:/var/run/docker.sock` |

---

## ⚙️ Environment Configuration (`.env`)

Duplicate `.env.example` into `.env` and fill in necessary secrets:

```ini
# Global System Configurations
TZ=Asia/Kolkata
PUID=1000
PGID=1000

# Utility Exposed Application Ports
DOZZLE_PORT=8888
STIRLING_PORT=8083
IT_TOOLS_PORT=8084
QBITTORRENT_PORT=8085
PAPERLESS_PORT=8010

# Torrent Network Ports
QBIT_TORRENT_PORT=6881

# Paperless Secret Encryption Key (generate a random string!)
PAPERLESS_SECRET_KEY=generate_your_own_secret_key_here

# External Shared Data Connections
PAPERLESS_DB_HOST=postgres_db
PAPERLESS_DB_PORT=5432
PAPERLESS_DB_NAME=paperless
PAPERLESS_DB_USER=postgres
PAPERLESS_DB_PASS=your_postgres_password
PAPERLESS_REDIS_URL=redis://redis_cache:6379
```

> [!IMPORTANT]
> Paperless relies on the **Data Stack** (`data/docker-compose.yml`) for its PostgreSQL database and Redis worker cache. Start the Data stack first!

---

## 🚀 Getting Started

```bash
# 1. Ensure the shared network exists
docker network create shared-backend-tier

# 2. Start utility services
docker compose --env-file utility/.env -f utility/docker-compose.yml up -d
```

### Initial Superuser for Paperless-ngx
After Paperless is running, generate your initial admin account:
```bash
docker exec -it paperless_ngx python3 manage.py createsuperuser
```
Now access the web interface at `http://<HOST_IP>:8010`.

### Real-Time Logs with Dozzle
View real-time logs for any container running on the host without SSH:
- Open `http://<HOST_IP>:8888` in your browser.

