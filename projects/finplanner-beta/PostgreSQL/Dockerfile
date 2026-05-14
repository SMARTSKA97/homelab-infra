FROM postgres:16

# Install both extensions cleanly using the built-in package manager
RUN apt-get update && apt-get install -y --no-install-recommends \
    postgresql-16-cron \
    postgresql-16-partman \
    && rm -rf /var/lib/apt/lists/*

# Automate configuration injection during initial database initialization
RUN mkdir -p /docker-entrypoint-initdb.d \
    && echo "echo \"shared_preload_libraries = 'pg_cron,pg_partman'\" >> \${PGDATA}/postgresql.conf" > /docker-entrypoint-initdb.d/01_preload.sh \
    && echo "echo \"cron.database_name = 'postgres'\" >> \${PGDATA}/postgresql.conf" >> /docker-entrypoint-initdb.d/01_preload.sh \
    && chmod +x /docker-entrypoint-initdb.d/01_preload.sh

CMD ["postgres"]
