-- PostgreSQL Multi-Database Initialization Script
-- Executed automatically on container first initialization via /docker-entrypoint-initdb.d/

-- 1. Create Paperless-ngx database if it doesn't already exist
SELECT 'CREATE DATABASE paperless'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'paperless')\gexec

-- 2. Grant permissions to standard user
GRANT ALL PRIVILEGES ON DATABASE paperless TO postgres;

