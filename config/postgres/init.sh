#!/bin/bash

cp /docker-entrypoint-initdb.d/*.conf /var/lib/postgresql/data

psql --username=postgres --dbname=postgres -c "SELECT pg_reload_conf();"
