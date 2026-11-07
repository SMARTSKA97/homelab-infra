# 🏛️ Core System Services (`core-system/`)

The `core-system` directory houses dedicated, independently managed services for remote zero-trust networking, self-hosted version control, continuous uptime telemetry, and password management.

---

## 📂 Subdirectory Overview

| Directory | Service | Stack Overview | Primary Ports | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| [`cloudflared/`](file:///c:/Users/Administrator/Documents/Workspaces/homelab-infra/core-system/cloudflared/README.md) | **Cloudflare Tunnel** | `cloudflare/cloudflared` | Outbound only | Zero-Trust secure remote ingress without port forwarding |
| [`forgejo/`](file:///c:/Users/Administrator/Documents/Workspaces/homelab-infra/core-system/forgejo/README.md) | **Forgejo Git Server** | `codeberg.org/forgejo/forgejo:14` + `postgres:16` | `3005`, `2222` | Self-hosted Git forge (fork of Gitea) with dedicated Postgres |
| [`uptime-kuma/`](file:///c:/Users/Administrator/Documents/Workspaces/homelab-infra/core-system/uptime-kuma/README.md) | **Uptime Kuma** | `louislam/uptime-kuma:1` | `3001` | Standalone deployment variant for status monitoring |
| [`vaultwarden/`](file:///c:/Users/Administrator/Documents/Workspaces/homelab-infra/core-system/vaultwarden/README.md) | **Vaultwarden** | `vaultwarden/server:latest` | `8081` | Lightweight, resource-efficient Bitwarden server in Rust |

---

## 🚀 Running Any Core Service

Each folder contains an independent, self-contained `docker-compose.yml`. You can deploy each service selectively:

```bash
# Example: Deploy Cloudflare Tunnel
cd core-system/cloudflared
docker compose up -d

# Example: Deploy Vaultwarden
cd core-system/vaultwarden
docker compose up -d

# Example: Deploy Forgejo Git
cd core-system/forgejo
docker compose up -d
```

