# 🦊 Forgejo Git Server (`forgejo`)

<p align="center">
  <img src="https://img.shields.io/badge/Forgejo-FB532B?style=for-the-badge&logo=forgejo&logoColor=white" alt="Forgejo" />
  <img src="https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL" />
</p>

A lightweight, self-hosted software forge (community-governed fork of Gitea) providing Git repositories, issue tracking, pull requests, container registry, and wiki.

---

## 📦 Architecture

- **`server`**: Forgejo v14 web application.
  - Web UI: Port `3005` (mapped to container port `3000`)
  - SSH Git: Port `2222` (mapped to container port `22`)
- **`db`**: Dedicated PostgreSQL 16 database instance for repository metadata.

---

## ⚙️ Environment Variables

Create a `.env` file in `core-system/forgejo/`:
```ini
DB_USER=forgejo
DB_PASS=generate_a_secure_password_here
```

---

## 💾 Storage Volumes

This deployment maps persistent data to `/mnt/storagepool/config/forgejo/`:
- `/mnt/storagepool/config/forgejo/data`: Repositories, Git LFS, attachments, SSH keys.
- `/mnt/storagepool/config/forgejo/postgres`: PostgreSQL data files.

> [!NOTE]
> Adjust host paths in `docker-compose.yml` to match your server's local storage path if `/mnt/storagepool` is not mounted.

---

## 🚀 Deployment

```bash
cd core-system/forgejo
docker compose up -d
```
Access the web UI at `http://<HOST_IP>:3005` to complete the initial setup wizard. The first user created automatically becomes an administrator.

