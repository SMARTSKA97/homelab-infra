FROM postgres:16

RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    lsb-release \
    git \
    build-essential \
    postgresql-server-dev-16

RUN mkdir -p /etc/apt/keyrings

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc \
    | gpg --dearmor -o /etc/apt/keyrings/postgresql.gpg

RUN echo "deb [signed-by=/etc/apt/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt bookworm-pgdg main" \
    > /etc/apt/sources.list.d/pgdg.list

# pg_cron from package
RUN apt-get update && apt-get install -y \
    postgresql-16-cron

# build pg_partman manually
RUN git clone --branch v5.2.4 https://github.com/pgpartman/pg_partman.git

WORKDIR /pg_partman

RUN make && make install

WORKDIR /

RUN rm -rf /pg_partman

# preload pg_cron
RUN echo "shared_preload_libraries = 'pg_cron'" >> /usr/share/postgresql/postgresql.conf.sample

RUN echo "cron.database_name = 'postgres'" >> /usr/share/postgresql/postgresql.conf.sample

CMD ["postgres"]
