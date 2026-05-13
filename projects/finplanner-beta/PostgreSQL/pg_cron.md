# 🕒 PostgreSQL Job Scheduling with `pg_cron`

A comprehensive guide to installing, configuring, and managing background jobs in PostgreSQL using the `pg_cron` extension.

---

## 🚀 1. Installation & Configuration

Before enabling the extension, `pg_cron` must be loaded into the PostgreSQL server's shared memory.

### 🛠️ Step A: Update `postgresql.conf`

Ensure `pg_cron` is added to `shared_preload_libraries`. You also need to specify which database the background worker should connect to (default is `postgres`).

```ini
# Edit your postgresql.conf
shared_preload_libraries = 'pg_cron'
cron.database_name = 'your_database_name'
```

> [!IMPORTANT]
> A server restart is required after modifying `shared_preload_libraries`.

### 🐳 Docker Installation

If you are using Docker, refer to this specialized guide for setting up `pg_cron` within a containerized environment:
🔗 [PostgreSQL Docker Setup Guide](https://github.com/SMARTSKA97/homelab-infra/blob/main/projects/finplanner-beta/PostgreSQL/README.md)

---

## 🏗️ 2. Database Setup

Once the library is loaded, enable the extension in your target database.

```sql
-- Connect to your database and run:
CREATE EXTENSION pg_cron;
```

---

## 📅 3. Managing Cron Jobs

### ⏰ Cron Format

```text
┌──────── minute (0 - 59)
│ ┌────── hour (0 - 23)
│ │ ┌──── day of month (1 - 31)
│ │ │ ┌── month (1 - 12)
│ │ │ │ ┌ day of week (0 - 6)
│ │ │ │ │
* * * * *
```

| Schedule      | Meaning               |
| ------------- | --------------------- |
| `* * * * *`   | Every minute          |
| `0 * * * *`   | Every hour            |
| `0 0 * * *`   | Every day at midnight |
| `*/5 * * * *` | Every 5 minutes       |

### ➕ Scheduling a Job

The `cron.schedule` function allows you to define a task. You can optionally provide a name for easier management.

```sql
SELECT cron.unschedule('dummy-cron-test');

SELECT cron.schedule(
    'dummy-cron-test',  -- Unique Job Name (Optional)
    '* * * * *',        -- Cron Schedule (Standard format)
    $$                  -- SQL Operation to execute
    INSERT INTO cron_test (message, executed_at)
    VALUES ('Cron executed successfully', NOW());
    $$
);
```

### 📋 Viewing Scheduled Jobs

To see a list of all active jobs and their configurations:

```sql
SELECT * FROM cron.job;
```

---

## 🔍 4. Monitoring & Logs

It's critical to track whether your jobs are running successfully or failing.

### 📝 Check Execution History

`pg_cron` maintains a log of job executions in the `cron.job_run_details` table.

```sql
-- View the last 10 executions
SELECT *
FROM cron.job_run_details
ORDER BY start_time DESC
LIMIT 10;
```

---

## 🗑️ 5. Maintenance

### ❌ Removing a Job

To stop a job from running, use its name or Job ID.

```sql
-- Remove by Name
SELECT cron.unschedule('dummy-cron-test');

-- Remove by Job ID
SELECT cron.unschedule(1);
```

### 🔄 Updating a Job

To change a job's schedule or SQL, you can use `cron.schedule` again with the same name; it will update the existing entry.

---

> [!TIP]
> For complex operations, it is recommended to wrap your logic in a **Stored Procedure** and call that procedure from the cron job for cleaner management and better error handling.
