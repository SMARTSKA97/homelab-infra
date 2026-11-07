# 📈 Standalone Uptime Kuma (`uptime-kuma`)

<p align="center">
  <img src="https://img.shields.io/badge/Uptime_Kuma-67C23A?style=for-the-badge&logo=uptimekuma&logoColor=white" alt="Uptime Kuma" />
</p>

An isolated, self-contained deployment of [Uptime Kuma](https://github.com/louislam/uptime-kuma) with volume persistence pointing to `/mnt/storagepool/config/uptime_kuma`.

---

## 🔌 Port Mapping & Volumes

- **Web UI & Dashboard**: Port `3001`
- **Data Volume**: `/mnt/storagepool/config/uptime_kuma:/app/data` (stores SQLite database, monitor definitions, notification webhooks, and status history).

---

## 🚀 Deployment

```bash
cd core-system/uptime-kuma
docker compose up -d
```
Visit `http://<HOST_IP>:3001` in your browser to configure your admin account.

> [!NOTE]
> If you are already running Uptime Kuma via the primary `infra/docker-compose.yml` stack, you do not need this standalone instance.

