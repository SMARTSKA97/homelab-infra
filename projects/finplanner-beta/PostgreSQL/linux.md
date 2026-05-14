# pg_cron and pg_partman setup for Linux Environment

## 1. To set up, just run this command
```
sudo apt update
sudo apt install -y postgresql-16-partman postgresql-16-cron
```
## 2. update pg_cron and pg_partman for database
### a. Go to the PostgreSQL Configuration file
```
sudo nano /etc/postgresql/16/main/postgresql.conf
```
### b. Add these
```
shared_preload_libraries = 'pg_cron'
cron.database_name = 'your_database_name'
```

## 3. Restart your server
```
sudo systemctl restart postgresql
```

## 4. Enable extensions
```
-- Enable pg_cron
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Create a dedicated schema for pg_partman (highly recommended)
CREATE SCHEMA IF NOT EXISTS partman;
CREATE EXTENSION IF NOT EXISTS pg_partman SCHEMA partman;
```
> [!IMPORTANT]
> Why is the partman schema needed?
>
> partman schema creates things like:
> - partman.part_config
> - partman.run_maintenance_proc()
> - helper procedures/functions
> - retention configs
> - partition management metadata
>
> These objects are used internally by pg_partman for partition management and automation.
> For pg_partman setup, follow this guide - 🔗 [pg_partman Setup Guide](https://github.com/SMARTSKA97/homelab-infra/blob/main/projects/finplanner-beta/PostgreSQL/pg_partman.md)


## 5. View extensions for the DB
```
SELECT extname FROM pg_extension;
```
