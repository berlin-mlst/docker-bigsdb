#!/bin/bash

DCD=/docker-entrypoint-initdb.d

# copy postgres configuration files

cp $DCD/conf/*.conf /var/lib/postgresql/data

# create users apache and bigsdb
createuser -U "$BIGSDB_POSTGRES_USER" apache
psql -U "$BIGSDB_POSTGRES_USER" -c "ALTER ROLE apache WITH PASSWORD '$BIGSDB_PG_APACHE_PASSWORD'";
createuser -U "$BIGSDB_POSTGRES_USER" bigsdb
psql -U "$BIGSDB_POSTGRES_USER" -c "ALTER ROLE bigsdb WITH PASSWORD '$BIGSDB_PG_BIGSDB_PASSWORD'";

# create databases
createdb -U "$BIGSDB_POSTGRES_USER" bigsdb_auth
psql -U "$BIGSDB_POSTGRES_USER" -f $DCD/sql/auth.sql bigsdb_auth
createdb -U "$BIGSDB_POSTGRES_USER" bigsdb_prefs
psql -U "$BIGSDB_POSTGRES_USER" -f $DCD/sql/prefs.sql bigsdb_prefs
createdb -U "$BIGSDB_POSTGRES_USER" bigsdb_refs
psql -U "$BIGSDB_POSTGRES_USER" -f $DCD/sql/refs.sql bigsdb_refs
createdb -U "$BIGSDB_POSTGRES_USER" bigsdb_jobs
psql -U "$BIGSDB_POSTGRES_USER" -f $DCD/sql/jobs.sql bigsdb_jobs
createdb -U "$BIGSDB_POSTGRES_USER" "$BIGSDB_USER_DATABASE"
psql -U "$BIGSDB_POSTGRES_USER" -f $DCD/sql/users.sql "$BIGSDB_USER_DATABASE"

# add admin user
psql -U "$BIGSDB_POSTGRES_USER" -c "INSERT INTO USERS (user_name,surname,first_name,email,affiliation,date_entered,datestamp,status) VALUES ('$BIGSDB_ADMIN_LOGIN','$BIGSDB_ADMIN_SNAME','$BIGSDB_ADMIN_FNAME','$BIGSDB_ADMIN_EMAIL','$BIGSDB_ADMIN_AFFILIATION','now','now','validated')" "$BIGSDB_USER_DATABASE"

# reload postgres
psql -U "$BIGSDB_POSTGRES_USER" -c "SELECT pg_reload_conf()";
