# 📦 PostgreSQL Partition Management with `pg_partman`

`pg_partman` is a powerful extension for managing time-based and serial-based table partitioning. It automates the creation of new partitions and the removal of old ones, ensuring your large tables remain performant.

---

## 🚀 1. Installation & Configuration

### 🛠️ Step A: Update `postgresql.conf`

`pg_partman` requires a Background Worker (BGW) to handle automatic partition maintenance. Add it to your shared libraries and configure the target database.

```ini
# Edit your postgresql.conf
shared_preload_libraries = 'pg_partman_bgw,pg_cron' # Often used together
pg_partman_bgw.dbname = 'your_database_name'
pg_partman_bgw.interval = 3600 # Maintenance interval in seconds (default 3600)
```

> [!IMPORTANT]
> A server restart is required after modifying `shared_preload_libraries`.

### 🐳 Docker Installation

For Docker environments, `pg_partman` is typically included in advanced PostgreSQL images (like Bitnami or custom homelab builds). Refer to this guide for setup instructions:
🔗 [PostgreSQL Docker Setup Guide](https://github.com/SMARTSKA97/homelab-infra/blob/main/projects/finplanner-beta/PostgreSQL/README.md)

---

## 🏗️ 2. Database Setup

It is a best practice to install `pg_partman` into its own schema to avoid cluttering the public namespace.

```sql
-- Create a dedicated schema
CREATE SCHEMA partman;

-- Install the extension into that schema
CREATE EXTENSION pg_partman SCHEMA partman;
```

---

## 📅 3. Creating Partitioned Tables

### 📝 Step 1: Create a Template Table (Native Partitioning)

Create your parent table using PostgreSQL's native `PARTITION BY` syntax.

```sql
CREATE TABLE public.billing_logs (
    id SERIAL,
    log_data TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
) PARTITION BY RANGE (created_at);
```

### ➕ Step 2: Initialize Partitioning

Use `partman.create_parent` to start managing the table. This will create initial partitions based on your interval.

```sql
SELECT partman.create_parent(
    p_parent_table => 'public.billing_logs',
    p_control => 'created_at',
    p_type => 'native',
    p_interval => 'daily', -- Can be 'daily', 'weekly', 'monthly', etc.
    p_premake => 4         -- Number of future partitions to keep ready
);
```

---

## 🔍 4. Maintenance & Monitoring

### 📋 Check Partition Status

To see which tables are currently managed by `pg_partman`:

```sql
SELECT * FROM partman.part_config;
```

### 🛠️ Manual Maintenance

If the Background Worker isn't running or you need to force maintenance:

```sql
SELECT partman.run_maintenance();
```

---

## 🗑️ 5. Retention Policy (Auto-Cleanup)

To automatically drop old data, update the configuration for your table.

```sql
UPDATE partman.part_config 
SET retention = '30 days', 
    retention_keep_table = false 
WHERE parent_table = 'public.billing_logs';
```

---

> [!TIP]
> Combine `pg_partman` with **`pg_cron`** to run maintenance tasks at specific off-peak hours if you prefer more control than the default BGW interval provides. Thus `pg_partman_bgw` can be avoided for unnecessary overheads.
