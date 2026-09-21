#!/bin/sh
set -eu

# petl's own base-image entrypoint (docker-entrypoint.sh) bootstraps the PETL
# MySQL user and grants it privileges, but never creates the warehouse
# database it needs -- that was assumed to already exist. Since the standard
# mysql image always auto-creates the openmrs user/database from env vars,
# a fresh instance never gets a warehouse database any other way. This
# wrapper creates it (idempotently) before delegating to the base image's
# own entrypoint.
#
# PETL_WAREHOUSE_DATABASE must match application.yml's
# mysqlReporting.databaseName, which reads the same variable with the same
# default -- that is the single knob for the warehouse database name.
PETL_WAREHOUSE_DATABASE="${PETL_WAREHOUSE_DATABASE:-openmrs_warehouse}"
if [ -n "${PETL_MYSQL_ROOT_PASSWORD:-}" ]; then
    echo "Ensuring ${PETL_WAREHOUSE_DATABASE} database exists..."
    MYSQL_PWD="${PETL_MYSQL_ROOT_PASSWORD}" mysql -h "${PETL_MYSQL_HOST}" -P "${PETL_MYSQL_PORT:-3306}" -uroot -e "CREATE DATABASE IF NOT EXISTS \`${PETL_WAREHOUSE_DATABASE}\` CHARACTER SET utf8;"
fi
exec /docker-entrypoint.sh "$@"
