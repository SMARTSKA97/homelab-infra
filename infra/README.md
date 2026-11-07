# 🛡️ Infrastructure & Edge Tier (`infra/`)

<p align="center">
  <img src="https://img.shields.io/badge/Nginx_Proxy_Manager-21B099?style=for-the-badge&logo=nginxproxymanager&logoColor=white" alt="Nginx Proxy Manager" />
  <img src="https://img.shields.io/badge/Homepage-FF5A00?style=for-the-badge&logo=homepage&logoColor=white" alt="Homepage" />
  <img src="https://img.shields.io/badge/Uptime_Kuma-67C23A?style=for-the-badge&logo=uptimekuma&logoColor=white" alt="Uptime Kuma" />
  <img src="https://img.shields.io/badge/Watchtower-0052CC?style=for-the-badge&logo=docker&logoColor=white" alt="Watchtower" />
</p>

The **Infrastructure Tier** provides the ingress gateway, reverse proxying, SSL automation, central dashboard, uptime monitoring, and automatic container updates for the homelab.

---

## 📦 Services Included

| Container Name | Service | Image | Ports | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| `nginx_proxy_manager` | **Nginx Proxy Manager** | `jc21/nginx-proxy-manager:latest` | `80`, `443`, `81` | Web-based reverse proxy & automated Let's Encrypt SSL certificates |
| `homepage` | **Homepage** | `ghcr.io/gethomepage/homepage:latest` | `3000` | Customizable self-hosted application dashboard |
| `uptime_kuma` | **Uptime Kuma** | `louislam/uptime-kuma:latest` | `3001` | Service monitoring, health checks, & alerting |
| `watchtower` | **Watchtower** | `nickfedor/watchtower:latest` | — | Automated Docker container image updates (every 300s) |

---

## 🔌 Port Mapping & Volumes

```text
infra/
├── docker-compose.yml
├── .env.example
├── .env
├── npm/
│   ├── data/                 # NPM configuration & SQLite database
│   └── letsencrypt/          # SSL certificates from Let's Encrypt
├── homepage/
│   └── config/               # Homepage YAML definitions (settings, services, widgets)
└── uptime_kuma_data/         # Uptime Kuma SQLite database & settings
```

| Service | Host Port | Container Port | Volume Mount |
| :--- | :--- | :--- | :--- |
| **NPM HTTP** | `${NGINX_HTTP_PORT}` (`80`) | `80` | `./npm/data:/data` |
| **NPM HTTPS** | `${NGINX_HTTPS_PORT}` (`443`) | `443` | `./npm/letsencrypt:/etc/letsencrypt` |
| **NPM Admin UI** | `81` | `81` | — |
| **Homepage** | `${HOMEPAGE_PORT}` (`3000`) | `3000` | `./homepage/config:/app/config`, `/var/run/docker.sock:/var/run/docker.sock:ro` |
| **Uptime Kuma** | `${UPTIME_KUMA_PORT}` (`3001`) | `3001` | `./uptime_kuma_data:/app/data` |
| **Watchtower** | — | — | `/var/run/docker.sock:/var/run/docker.sock` |

---

## ⚙️ Environment Variables (`.env`)

Duplicate `.env.example` into `.env` before starting:

```ini
# Global Timezone
TZ=Asia/Kolkata

# Core Routing Ports
NGINX_HTTP_PORT=80
NGINX_HTTPS_PORT=443

# Dashboard Ports
HOMEPAGE_PORT=3000
UPTIME_KUMA_PORT=3001

# Watchtower Settings (in seconds)
WATCHTOWER_POLL_INTERVAL=300
```

---

## 🚀 Getting Started

### 1. Ensure Shared Network Exists
```bash
docker network create shared-backend-tier
```

### 2. Start Infrastructure
```bash
# From workspace root
docker compose --env-file infra/.env -f infra/docker-compose.yml up -d

# Or inside infra/ directory
cd infra
docker compose up -d
```

### 3. Initial Configuration

#### Nginx Proxy Manager (`http://<HOST_IP>:81`)
- **Default Email**: `admin@example.com`
- **Default Password**: `changeme`
- *Action*: Prompted to update email and password on first login. You can then route subdomains (e.g., `kuma.local` &rarr; `uptime_kuma:3001` over `shared-backend-tier`).

#### Homepage Dashboard (`http://<HOST_IP>:3000`)
- Configured via YAML files in `./homepage/config`:
  - `services.yaml`: List of services and status icons.
  - `widgets.yaml`: Weather, resources, hardware stats.
  - `bookmarks.yaml`: Useful bookmarks.

#### Uptime Kuma (`http://<HOST_IP>:3001`)
- Create an initial administrator account.
- Add HTTP/TCP/Ping health checks for any container on `shared-backend-tier` by using its container name (e.g. `http://paperless_ngx:8000`).

---

## 🔄 Watchtower Details

Watchtower is configured with `WATCHTOWER_CLEANUP=true` and checks for newer image releases every 300 seconds (5 minutes). Old image layers are removed automatically upon successful restart.

