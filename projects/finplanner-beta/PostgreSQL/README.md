# PostgreSQL + pgAdmin Docker Setup Guide

## Overview

This setup provides:

- PostgreSQL 16 running in Docker
- pgAdmin 4 running in Docker
- Persistent database storage
- Local backup mounting
- Restore support using `.backup` files
- Clean workspace organization for future scalability

---

# Project Structure

Create the following directory structure:

```text
D:\Workspace\Database
│
├── postgres
├── pgadmin
├── backups
├── compose
|   └── docker-compose.yml
├── scripts
└── docker
    └── postgres
        └── Dockerfile
```

---

# Folder Purpose

| Folder | Purpose |
|---|---|
| `postgres` | PostgreSQL persistent data storage |
| `pgadmin` | pgAdmin persistent configuration/data |
| `backups` | PostgreSQL backup files (`.backup`) |
| `compose` | Docker Compose configuration |
| `scripts` | Utility or automation scripts |
| `docker/postgres` | Custom PostgreSQL Docker image files |

---

# Recommended Dockerfile Location

Create the Dockerfile here:

```text
D:\Workspace\Database\docker\postgres\Dockerfile
```

This keeps:
- infrastructure
- compose files
- custom images
- scripts

cleanly separated.

Very useful later when:
- adding Flyway
- adding pg_cron
- creating CI/CD pipelines
- maintaining multiple DB versions

---

> Note:
>
> `pg_partman` installation differs depending on image/repository setup.
> Start simple first. Add advanced extensions later.

---

# Build Custom PostgreSQL Image

Navigate to:

```text
D:\Workspace\Database\docker\postgres
```

Run:

```powershell
docker build -t postgres-16-custom .
```

---


# Start Containers

Navigate to:

```text
D:\Workspace\Database\compose
```

Run:

```powershell
docker compose up -d
```

---

# Verify Running Containers

```powershell
docker ps
```

Expected containers:

- `postgres_db`
- `pgadmin4_container`

---

# Open pgAdmin

Open browser:

```text
http://localhost:5050
```

---

# pgAdmin Login Credentials

| Field | Value |
|---|---|
| Email | admin@admin.com |
| Password | admin@123 |

---

# Connect PostgreSQL in pgAdmin

## General Tab

| Field | Value |
|---|---|
| Name | Local PostgreSQL |

---

## Connection Tab

| Field | Value |
|---|---|
| Host | db |
| Port | 5432 |
| Username | postgres |
| Password | postgres |
| Maintenance DB | postgres |

> Important:
>
> Do NOT use `localhost` inside pgAdmin container connections.
> Use Docker service name: `db`

---

# Add Backup Files

Copy `.backup` files into:

```text
D:\Workspace\Database\backups
```

Example:

```text
D:\Workspace\Database\backups\sample_database.backup
```

---

# Verify Backup Visibility Inside Container

```powershell
docker exec -it postgres_db ls /backups
```

Expected output:

```text
sample_database.backup
```

---

# Create Database Before Restore

Run:

```powershell
docker exec -it postgres_db psql -U postgres -d postgres -c 'CREATE DATABASE "sample_database"'
```

Expected output:

```text
CREATE DATABASE
```

---

# Restore Backup

Run:

```powershell
docker exec -it postgres_db pg_restore -U postgres -d sample_database --no-owner --no-acl --clean --if-exists /backups/sample_database.backup
```

---

# Refresh pgAdmin

In pgAdmin:

```text
Databases → Right Click → Refresh
```

Your restored:
- tables
- schemas
- functions
- data

should now appear.

---

# Useful Docker Commands

## Stop Containers

```powershell
docker compose down
```

---

## Restart Containers

```powershell
docker compose restart
```

---

## View PostgreSQL Logs

```powershell
docker logs postgres_db
```

---

## View pgAdmin Logs

```powershell
docker logs pgadmin4_container
```

---

# Recommended Best Practices

- Keep backups outside container filesystem
- Use Docker service names for internal communication
- Keep compose files version-controlled
- Match PostgreSQL versions during backup/restore
- Store database data on SSD storage
- Separate dev/staging/prod environments early

---

# Future Enhancements

This setup can later support:

- Flyway migrations
- pg_partman partitioning
- pg_cron scheduled jobs
- Automated backups
- Multi-environment databases
- Monitoring stack
- Replication
- CI/CD database deployment

---

# Final Architecture

```text
Windows Host
│
├── Docker Desktop
│
├── PostgreSQL Container
│   ├── Persistent Storage
│   └── Mounted Backups
│
├── pgAdmin Container
│
└── Shared Docker Network
```

This setup is strong enough for:

- backend development
- portfolio projects
- self-hosted experimentation
- migration practice
- production-style local infrastructure
- learning real-world DevOps workflows
