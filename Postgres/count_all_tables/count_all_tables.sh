#!/bin/bash

# ==============================
# CONFIGURATION
# ==============================
RDS_HOST="$1"
RDS_USER="$2"
RDS_PASSWORD="$3"
RDS_PORT="${4:-5432}"

export PGPASSWORD=$RDS_PASSWORD

# ==============================
# GET ALL DATABASES
# ==============================
DATABASES=$(psql -h $RDS_HOST -U $RDS_USER -p $RDS_PORT -d postgres -t -c "
SELECT datname 
FROM pg_database 
WHERE datistemplate = false 
AND datname NOT IN ('rdsadmin');
")

echo "========================================"
echo "Starting Row Count on Server: $RDS_HOST"
echo "========================================"

for DB in $DATABASES; do
    echo ""
    echo "----------------------------------------"
    echo "Database: $DB"
    echo "----------------------------------------"

    psql -h $RDS_HOST -U $RDS_USER -p $RDS_PORT -d $DB -c "
    DO \$\$
    DECLARE
        r RECORD;
        row_count BIGINT;
    BEGIN
        FOR r IN 
            SELECT schemaname, tablename
            FROM pg_tables
            WHERE schemaname NOT IN ('pg_catalog','information_schema')
        LOOP
            EXECUTE format('SELECT COUNT(*) FROM %I.%I', r.schemaname, r.tablename)
            INTO row_count;

            RAISE NOTICE '%.% --> % rows',
                r.schemaname, r.tablename, row_count;
        END LOOP;
    END
    \$\$;
    "

done

echo ""
echo "Row count completed."