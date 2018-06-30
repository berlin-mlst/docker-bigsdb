#!/bin/bash

DCD=/docker-entrypoint-initdb.d

# copy postgres configuration files
cp $DCD/conf/*.conf /var/lib/postgresql/data

# create users apache and bigsdb
createuser -U "$POSTGRES_USER" apache
psql -U "$POSTGRES_USER" -c "ALTER ROLE apache WITH PASSWORD '$BIGS_PG_APACHE_PASSWORD'";
createuser -U "$POSTGRES_USER" bigsdb
psql -U "$POSTGRES_USER" -c "ALTER ROLE bigsdb WITH PASSWORD '$BIGS_PG_BIGSDB_PASSWORD'";

# create databases
createdb -U "$POSTGRES_USER" bigsdb_auth
psql -U "$POSTGRES_USER" -f $DCD/sql/auth.sql bigsdb_auth
createdb -U "$POSTGRES_USER" bigsdb_prefs
psql -U "$POSTGRES_USER" -f $DCD/sql/prefs.sql bigsdb_prefs
createdb -U "$POSTGRES_USER" bigsdb_refs
psql -U "$POSTGRES_USER" -f $DCD/sql/refs.sql bigsdb_refs
createdb -U "$POSTGRES_USER" bigsdb_jobs
psql -U "$POSTGRES_USER" -f $DCD/sql/jobs.sql bigsdb_jobs

# reload postgres
psql -U "$POSTGRES_USER" -c "SELECT pg_reload_conf()";
