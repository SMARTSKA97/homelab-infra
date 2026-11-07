# 💾 Data & Persistence Tier (`data/`)

<p align="center">
  <img src="https://img.shields.io/badge/PostgreSQL_18-4169E1?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL" />
  <img src="https://img.shields.io/badge/Redis_8-DC382D?style=for-the-badge&logo=redis&logoColor=white" alt="Redis" />
  <img src="https://img.shields.io/badge/RabbitMQ_4-FF6600?style=for-the-badge&logo=rabbitmq&logoColor=white" alt="RabbitMQ" />
</p>

The **Data Tier** provides shared backend storage, in-memory caching, and message broker services for application stacks across the homelab (such as `utility/`, `projects/`, and other external services).

---

## 📦 Services Included

| Container Name | Service | Image | Ports | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| `postgres_db` | **PostgreSQL 18** | `postgres:18` | `5432` | Primary relational database server |
| `redis_cache` | **Redis 8** | `redis:8` | `6379` | High-performance in-memory cache & key-value store (AOF enabled) |
| `rabbitmq_broker` | **RabbitMQ 4** | `rabbitmq:4-management` | `5672`, `15672` | AMQP message broker with built-in web management console |

---

## 🔌 Port Mapping & Volumes

```text
data/
├── docker-compose.yml
├── .env.example
├── .env
├── init-multiple-dbs.sql      # Multi-database bootstrap script for Postgres
└── [Docker Volumes]
    ├── postgres_data          # Persisted PGDATA directory (/var/lib/postgresql)
    ├── redis_data             # Persisted Redis append-only file (/data)
    └── rabbitmq_data          # Persisted RabbitMQ state (/var/lib/rabbitmq)
```

| Service | Host Port | Container Port | Volume Mount |
| :--- | :--- | :--- | :--- |
| **PostgreSQL** | `${POSTGRES_PORT}` (`5432`) | `5432` | `postgres_data:/var/lib/postgresql`, `./init-multiple-dbs.sql:/docker-entrypoint-initdb.d/init-multiple-dbs.sql` |
| **Redis** | `${REDIS_PORT}` (`6379`) | `6379` | `redis_data:/data` |
| **RabbitMQ App** | `${RABBITMQ_APP_PORT}` (`5672`) | `5672` | `rabbitmq_data:/var/lib/rabbitmq` |
| **RabbitMQ Web** | `${RABBITMQ_MGMT_PORT}` (`15672`)| `15672` | `rabbitmq_data:/var/lib/rabbitmq` |

---

## ⚙️ Environment Variables (`.env`)

Duplicate `.env.example` into `.env` before booting:

```ini
# Host Exposed Ports
POSTGRES_PORT=5432
REDIS_PORT=6379
RABBITMQ_APP_PORT=5672
RABBITMQ_MGMT_PORT=15672

# PostgreSQL Configurations
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_secured_password
POSTGRES_DB=postgres

# RabbitMQ Configurations
RABBITMQ_DEFAULT_USER=admin
RABBITMQ_DEFAULT_PASS=your_secured_password
```

---

## 🚀 Getting Started

### 1. Ensure Shared Network Exists
```bash
docker network create shared-backend-tier
```

### 2. Boot Data Services
```bash
# From workspace root
docker compose --env-file data/.env -f data/docker-compose.yml up -d

# Or inside data/ directory
cd data
docker compose up -d
```

### 3. Verification
```bash
# Verify all three containers are healthy
docker compose -f data/docker-compose.yml ps

# Connect to Postgres
docker exec -it postgres_db psql -U postgres

# Check Redis ping
docker exec -it redis_cache redis-cli ping

# Access RabbitMQ Management Console in browser
http://<HOST_IP>:15672
```

---

## 🗄️ Database Initialization (`init-multiple-dbs.sql`)

PostgreSQL natively creates only one default database from `POSTGRES_DB` during initial initialization. 

The mounted [`init-multiple-dbs.sql`](file:///c:/Users/Administrator/Documents/Workspaces/homelab-infra/data/init-multiple-dbs.sql) script runs automatically on the first container start, ensuring additional databases needed by downstream stacks (such as `paperless` for the Paperless-ngx utility stack) are automatically created:

```sql
SELECT 'CREATE DATABASE paperless'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'paperless')\gexec
GRANT ALL PRIVILEGES ON DATABASE paperless TO postgres;
```

---

## 💾 Backups & Maintenance

### Creating a Full Database Dump:
```bash
docker exec -t postgres_db pg_dumpall -c -U postgres > "postgres_backup_$(date +%Y%m%d).sql"
```

### Restoring a Dump:
```bash
cat backup.sql | docker exec -i postgres_db psql -U postgres
```

