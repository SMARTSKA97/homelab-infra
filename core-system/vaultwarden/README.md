# 🔐 Vaultwarden Password Manager (`vaultwarden`)

<p align="center">
  <img src="https://img.shields.io/badge/Vaultwarden-175DDC?style=for-the-badge&logo=bitwarden&logoColor=white" alt="Vaultwarden" />
</p>

An alternative, lightweight implementation of the Bitwarden sync API written in Rust. Compatible with official Bitwarden clients (mobile apps, browser extensions, desktop apps, CLI).

---

## ⚙️ Configuration

- **Host Port**: `8081` (mapped to internal HTTP port `80`)
- **WebSocket Notifications**: `WEBSOCKET_ENABLED=true` (allows real-time syncing across mobile and browser clients)
- **Data Directory**: `/mnt/storagepool/config/vaultwarden:/data`

---

## 🔒 Security Best Practices

> [!IMPORTANT]
> Bitwarden and Vaultwarden **require HTTPS / SSL** for Web Crypto APIs in browsers to function properly.
> Use **Nginx Proxy Manager** (`infra/`) or **Cloudflare Tunnel** (`core-system/cloudflared/`) in front of port `8081` to provide SSL termination.

### Disabling Public Registration
Once your own account is registered, protect your vault by disabling new account registrations. Add this to your environment:
```yaml
environment:
  - SIGNUPS_ALLOWED=false
```

---

## 🚀 Deployment

```bash
cd core-system/vaultwarden
docker compose up -d
```
Access the vault at `http://<HOST_IP>:8081` (or via your configured HTTPS domain).

