# 📦 PostgreSQL Partition Management with `pg_partman`

`pg_partman` is a powerful PostgreSQL extension for automating time-based and serial-based table partitioning. It helps maintain query performance on large datasets by automatically creating future partitions and applying retention policies.

This guide uses the **recommended modern production approach**:

```text
pg_cron → partman.run_maintenance_proc()
```

instead of relying on `pg_partman_bgw`.

---

# 🚀 1. Prerequisites

> [!IMPORTANT]
> `pg_cron` is REQUIRED for this setup.
>
> This guide intentionally uses `pg_cron` instead of `pg_partman` because it provides:
>
> * Better observability
> * Explicit scheduling
> * Easier debugging
> * Cleaner container/Kubernetes compatibility
> * Simpler operational management

Before continuing, complete the `pg_cron` setup guide:

🔗 [pg_cron Setup Guide](https://github.com/SMARTSKA97/homelab-infra/blob/main/projects/finplanner-beta/PostgreSQL/pg_cron.md)

---

# 🛠️ 2. PostgreSQL Configuration

Ensure `pg_cron` is enabled inside `postgresql.conf`.

```ini
# Edit your postgresql.conf
shared_preload_libraries = 'pg_cron'

# Database where pg_cron metadata and worker run
cron.database_name = 'postgres'
```

> [!WARNING]
> Changes to `shared_preload_libraries` require a full PostgreSQL restart.
>
> Reloading the config is NOT sufficient.

---

# 🏗️ 3. Database Setup

Create a dedicated schema for `pg_partman`.

```sql
-- Create dedicated schema
CREATE SCHEMA partman;

-- Install extensions
CREATE EXTENSION pg_partman SCHEMA partman;
CREATE EXTENSION pg_cron;
```

---

# 📅 4. Creating a Partitioned Table

## 📝 Step 1: Create Parent Table

Use PostgreSQL native partitioning.

```sql
CREATE TABLE public.billing_logs (
    id BIGSERIAL,
    log_data TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
)
PARTITION BY RANGE (created_at);
```

---

## ➕ Step 2: Initialize `pg_partman`

Configure partition management.

```sql
SELECT partman.create_parent(
    p_parent_table => 'public.audit_logs',
    p_control => 'created_at',
    p_type => 'native',
    p_interval => 'daily',
    p_premake => 4
);
```

### 📖 Parameter Explanation

| Parameter        | Meaning                                                 |
| ---------------- | ------------------------------------------------------- |
| `p_parent_table` | Parent partitioned table                                |
| `p_control`      | Partition key column                                    |
| `p_type`         | Use PostgreSQL native partitioning                      |
| `p_interval`     | Partition interval (`daily`, `weekly`, `monthly`, etc.) |
| `p_premake`      | Number of future partitions created in advance          |

Example:

```text
daily + premake 4
```

means:

* today’s partition exists
* next 4 future daily partitions are already prepared

---

# 🔄 5. Automatic Maintenance with `pg_cron`

`pg_partman` does NOT automatically create future partitions by itself.

Maintenance must run regularly.

Schedule automated maintenance using `pg_cron`:

```sql
SELECT cron.schedule(
    'partman-maintenance',
    '0 * * * *',
    $$CALL partman.run_maintenance_proc()$$
);
```

This runs every hour and:

* creates future partitions
* applies retention policies
* updates partition metadata

---

# 🔍 6. Monitoring & Inspection

## 📋 Check Managed Tables

```sql
SELECT * 
FROM partman.part_config;
```

---

## 🧱 View Existing Partitions

```sql
SELECT
    inhrelid::regclass AS partition_name
FROM pg_inherits
WHERE inhparent = 'public.billing_logs'::regclass;
```

---

## 📝 Check Cron Job Status

```sql
SELECT *
FROM cron.job;
```

---

## 📊 Check Cron Execution Logs

```sql
SELECT
    jobid,
    status,
    return_message,
    start_time,
    end_time
FROM cron.job_run_details
ORDER BY start_time DESC
LIMIT 10;
```

---

# 🗑️ 7. Retention Policy (Auto Cleanup)

Automatically remove old partitions.

```sql
UPDATE partman.part_config
SET retention = '30 days',
    retention_keep_table = false
WHERE parent_table = 'public.billing_logs';
```

## 📖 Retention Options

| Setting                        | Behavior                                 |
| ------------------------------ | ---------------------------------------- |
| `retention_keep_table = true`  | Detaches old partitions but keeps tables |
| `retention_keep_table = false` | Permanently drops old partitions         |

> [!WARNING]
> Using `false` permanently deletes old partition tables.

---

# 🛠️ 8. Manual Maintenance

Force maintenance manually if needed.

```sql
CALL partman.run_maintenance_proc();
```

Useful for:

* testing
* troubleshooting
* immediate partition creation

---

# ⏰ Recommended Maintenance Frequency

| Partition Type | Suggested Schedule |
| -------------- | ------------------ |
| Hourly         | Every 5–15 minutes |
| Daily          | Every hour         |
| Weekly         | Every few hours    |
| Monthly        | Daily              |

---

# 🧠 Recommended Production Architecture

```text
pg_cron
   ↓
partman.run_maintenance_proc()
   ↓
Partition creation & retention
```

This architecture is:

* explicit
* observable
* restart-safe
* Docker/Kubernetes friendly
* easier to debug than `pg_partman_bgw`

---

> [!TIP]
> Preferred production pattern:
>
> ```text
> pg_cron → Stored Procedure → Business Logic
> ```
>
> Keep scheduling logic separate from application logic for easier maintenance and troubleshooting.
