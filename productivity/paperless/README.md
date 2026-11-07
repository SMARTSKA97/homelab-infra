# 📑 Standalone Paperless-ngx Stack (`productivity/paperless`)

<p align="center">
  <img src="https://img.shields.io/badge/Paperless--ngx-007ACC?style=for-the-badge&logo=paperlessngx&logoColor=white" alt="Paperless-ngx" />
  <img src="https://img.shields.io/badge/PostgreSQL_16-4169E1?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL" />
  <img src="https://img.shields.io/badge/Redis_7-DC382D?style=for-the-badge&logo=redis&logoColor=white" alt="Redis" />
</p>

An isolated, fully self-contained deployment of [Paperless-ngx](https://github.com/paperless-ngx/paperless-ngx) featuring a dedicated PostgreSQL 16 database and a dedicated Redis 7 message broker.

---

## 📦 Services

1. **`webserver`**: Paperless-ngx web app, OCR worker, and scheduler (Port `8010`).
2. **`db`**: PostgreSQL 16 relational database for index, tags, and document metadata.
3. **`broker`**: Redis 7 message queue for Celery background tasks.

---

## 💾 Storage Pool Volumes

- Database: `/mnt/storagepool/config/paperless/db`
- Search index & data: `/mnt/storagepool/config/paperless/data`
- Original & archived PDFs: `/mnt/storagepool/config/paperless/media`
- Backup exports: `/mnt/storagepool/config/paperless/export`
- Automated ingestion folder: `/mnt/storagepool/media/documents/consume`

---

## ⚙️ Environment Variables

Create a `.env` file before launching:
```ini
POSTGRES_PASSWORD=your_secure_db_password
PAPERLESS_DBPASS=your_secure_db_password
```

---

## 🚀 Deployment

```bash
cd productivity/paperless
docker compose up -d
```

### Create Administrator Account
```bash
docker compose exec webserver python3 manage.py createsuperuser
```
Access the dashboard at `http://<HOST_IP>:8010` (or `https://paperless.ska97homelab.uk` via your reverse proxy).

