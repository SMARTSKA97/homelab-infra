# pg_cron and pg_partman setup

## 1. To set up, just run this command
```
sudo apt-get update && apt-get install -y postgresql-16-partman postgresql-16-cron
```
## 2. update pg_cron and pg_partman for database
```
echo "shared_preload_libraries = 'pg_cron,pg_partman'" >> /var/lib/postgresql/data/postgresql.conf
echo "cron.database_name = 'your_database_name'" >> /var/lib/postgresql/data/postgresql.conf
```

## 3. Restart your server

## 4. Enable extensions
```
-- Enable pg_cron
CREATE EXTENSION pg_cron;

-- Create a dedicated schema for pg_partman (highly recommended)
CREATE SCHEMA partman;
CREATE EXTENSION pg_partman SCHEMA partman;
```
