#!/bin/sh
set -eu

# petl's own base-image entrypoint (docker-entrypoint.sh) bootstraps the PETL
# MySQL user and grants it privileges, but never creates the `warehouse`
# database it needs -- that was assumed to already exist. Since the standard
# mysql image always auto-creates the openmrs user/database from env vars,
# a fresh instance never gets a `warehouse` database any other way. This
# wrapper creates it (idempotently) before delegating to the base image's
# own entrypoint.
if [ -n "${PETL_MYSQL_ROOT_PASSWORD:-}" ]; then
    echo "Ensuring warehouse database exists..."
    MYSQL_PWD="${PETL_MYSQL_ROOT_PASSWORD}" mysql -h "${PETL_MYSQL_HOST}" -P "${PETL_MYSQL_PORT:-3306}" -uroot -e "CREATE DATABASE IF NOT EXISTS warehouse CHARACTER SET utf8;"
fi
exec /docker-entrypoint.sh "$@"
