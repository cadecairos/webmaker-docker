FROM postgres:9.4

COPY ./create-webmaker-tables.sql /docker-entrypoint-initdb.d/
COPY ./create-id-tables.sql /docker-entrypoint-initdb.d/
COPY ./create-publish-database.sql /docker-entrypoint-initdb.d/

ENV POSTGRES_USER=webmaker
ENV POSTGRES_PASSWORD=webmaker
ENV PGDATA=/var/lib/postgresql/data/pg_data
