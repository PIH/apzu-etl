# Malawi Reporting PETL — Docker Runbook

Unlike production, reporting is a self-contained instance: no live `openmrs`
webapp, just `openmrs-db` (source), `petl`, and `petl-sqlserver` (target).

## One-time setup

    SERVICES=openmrs-db,petl,petl-sqlserver \
      openmrs-docker create malawi-reporting

Add to `~/openmrs/malawi-reporting/env`:

    PETL_IMAGE_NAME=partnersinhealth/apzu-etl
    PETL_FULL_REFRESH_JOBS=refresh-full.yml
    PETL_MYSQL_ROOT_PASSWORD=<same as OPENMRS_DB_ROOT_PASSWORD>

`PETL_MYSQL_ROOT_PASSWORD` is required, not optional: both the base image's
MySQL user/grant bootstrap and this image's warehouse-database creation are
skipped when it is unset, and the run then fails with `Access denied ... to
database '<warehouse db>'`.

## Database names

Two databases this stack writes to are configurable:

| Variable | Default | Controls |
| --- | --- | --- |
| `PETL_WAREHOUSE_DATABASE` | `openmrs_warehouse` | the MySQL warehouse database — read by `docker-entrypoint-wrapper.sh` (which creates it) and by `application.yml`'s `mysqlReporting.databaseName` |
| `PETL_SQLSERVER_DATABASE` | `openmrs_reporting` | the SQL Server target database — read by the `petl-sqlserver` service (which creates it) and by `application.yml`'s `sqlServerReporting.databaseName` |

Caveat: `openmrs-contrib-distro-tools`' `docker/services/petl.yaml` enumerates
the environment it passes into the `petl` container, and neither variable is
in that list — so setting either one in the instance `env` file reaches
`petl-sqlserver` but *not* `petl`. Until that fragment passes them through,
overriding either default requires also dropping a small compose override into
the instance directory (every `*.yaml` there is merged), e.g.
`~/openmrs/malawi-reporting/petl-db-names.yaml`:

    services:
      petl:
        environment:
          PETL_WAREHOUSE_DATABASE: ${PETL_WAREHOUSE_DATABASE:-openmrs_warehouse}
          PETL_SQLSERVER_DATABASE: ${PETL_SQLSERVER_DATABASE:-openmrs_reporting}

Leaving both at their defaults needs no override and is the expected setup.

## Refreshing from a new backup

    openmrs-docker malawi-reporting destroy --force   # only if re-seeding from scratch
    SERVICES=openmrs-db,petl,petl-sqlserver openmrs-docker create malawi-reporting
    openmrs-docker malawi-reporting restore --from-percona /path/to/backup   # or --from-dump
    openmrs-docker malawi-reporting start
    openmrs-docker malawi-reporting run-service petl

`create` already attaches `petl-sqlserver` via `SERVICES=` — do not follow it
with `add-service petl-sqlserver`, which fails with `error: petl-sqlserver
already present on malawi-reporting`.

Real malawi backups are password-protected `.7z` archives. For those, set
`PETL_BACKUP_PASSWORD` in the instance's own `env` file *before* running
`restore` — do not pass it on the `restore` command line, where
`openmrs-docker`'s sourcing of the instance env file overwrites it with the
(empty) value from `petl.env.defaults`.

## Why this image has its own entrypoint wrapper

`Dockerfile.runtime` overrides the base `partnersinhealth/petl` image's
entrypoint with `docker-entrypoint-wrapper.sh`, which creates the warehouse
MySQL database (idempotently, `CREATE DATABASE IF NOT EXISTS`, named by
`PETL_WAREHOUSE_DATABASE`) before delegating to the base image's own
`/docker-entrypoint.sh` (which bootstraps the PETL MySQL user and grants).
The base image's bootstrap step only ever handles the user/grants — it
assumes the warehouse database already exists — and since the standard
`mysql` image always auto-creates the `openmrs` user/database from env vars
regardless of how the instance was seeded, nothing else in the stack ever
creates it on a fresh instance. This wrapper is apzu-etl-specific (not a
petl-repo change) because `refresh-full.yml`'s warehouse schema is a concern
of this per-country image, not of the base ETL runtime. Both the wrapper and
`application-docker.yml` read `PETL_WAREHOUSE_DATABASE` with the same
`openmrs_warehouse` default, so the two can never disagree.

Similarly, `application-docker.yml` defines a `mysqlOpenmrs` datasource
block (alongside `mysqlReporting`/`sqlServerReporting`) so that
`jobs/execute-pentaho-job.yml` can resolve `${mysqlOpenmrs.host}` etc. for
the OpenMRS *source* connection every `.ktr` transform under
`jobs/pentaho/openmrs/transforms/` and `jobs/pentaho/malawi/transforms/`
uses. It mirrors `mysqlReporting`'s `${petl.mysql.*}` indirection, just
pointed at the source `openmrs` database instead of the warehouse.

## Verification

This procedure was driven end-to-end against a throwaway instance with a
hand-built minimal OpenMRS source fixture, to prove real data actually
flows `openmrs` (source) → warehouse (MySQL) → SQL Server, not just that
the containers start.

### Fixture

The fixture is committed at **`docs/fixtures/minimal-openmrs.sql`** — feed it
straight to `restore --from-dump` to reproduce this verification without a
real backup:

    openmrs-docker <instance> restore --from-dump docs/fixtures/minimal-openmrs.sql

It contains no real patient or employee data; every value in it is synthetic.
How its scope was derived:

`refresh-omrs-tables.yml`'s Pentaho transforms
(`jobs/pentaho/openmrs/transforms/*.ktr`) and `refresh-mw-tables.yml`'s
`mw_users.ktr` were read directly (their embedded `<sql>` blocks, not
guessed) to find every OpenMRS source table/column actually queried. That
traced to 31 tables: `person`, `patient`, `person_name`, `person_address`,
`person_attribute`, `person_attribute_type`, `patient_identifier`,
`patient_identifier_type`, `obs`, `encounter`, `encounter_type`,
`encounter_provider`, `encounter_role`, `visit`, `visit_type`, `location`,
`provider`, `concept`, `concept_name`, `drug`, `form`, `users`,
`patient_program`, `program`, `program_workflow`, `program_workflow_state`,
`patient_state`, `relationship`, `relationship_type`,
`authentication_event_log`, `user_property`.

`jobs/pentaho/malawi/transforms/*.ktr` (78 files) were also scanned for any
direct OpenMRS-source table reference beyond what `refresh-omrs-tables.yml`
needs; only `mw_users.ktr` reads further (`authentication_event_log`,
`user_property`, `users`, `person_name` — already covered above). Every
other Malawi transform reads only from the warehouse database, so it was
out of scope to seed further: with only a generic fixture (no PIH/Malawi
concept dictionary), `mw_*` tables besides `mw_patient`/`mw_users` are
expected to load as empty-but-present tables, not errors.

`docs/fixtures/minimal-openmrs.sql` covers exactly those 31 tables — loose
types, no FK constraints (MySQL only needs the `SELECT`s to succeed;
referential integrity is ensured by hand), two synthetic patients linked
through a visit, an encounter, an obs group, a program enrollment/state, and
a relationship. It was validated by loading it into a scratch `mysql:5.6`
container and running the actual join queries from the `.ktr` files against
it before ever touching `openmrs-docker`.

### Full pipeline run

    export OPENMRS_DB_ROOT_PASSWORD=openmrs
    SERVICES=openmrs-db,petl,petl-sqlserver \
      OPENMRS_DOCKER_HOME=/tmp/openmrs-docker-test \
      openmrs-docker create mlw1865-defaults
    { echo "PETL_IMAGE_NAME=partnersinhealth/apzu-etl"
      echo "PETL_IMAGE_TAG=local"
      echo "PETL_FULL_REFRESH_JOBS=refresh-full.yml"
      echo "PETL_MYSQL_ROOT_PASSWORD=openmrs"
    } >> /tmp/openmrs-docker-test/mlw1865-defaults/env
    OPENMRS_DOCKER_HOME=/tmp/openmrs-docker-test openmrs-docker mlw1865-defaults \
      restore --from-dump docs/fixtures/minimal-openmrs.sql
    OPENMRS_DOCKER_HOME=/tmp/openmrs-docker-test openmrs-docker mlw1865-defaults start
    OPENMRS_DOCKER_HOME=/tmp/openmrs-docker-test openmrs-docker mlw1865-defaults run-service petl

No manual workarounds needed — `refresh-full.yml` completed successfully
on the first attempt, using the real `partnersinhealth/apzu-etl:local`
image built by this repo's own `build-runtime-docker-image.sh` and the
committed fixture above:

    Ensuring openmrs_warehouse database exists...
    Bootstrapping PETL MySQL user 'openmrs'...
    PETL MySQL user 'openmrs' already exists, not re-creating
    ...
    ================================================================================
    PETL Run Summary
    ================================================================================
      Job:        refresh-full.yml
      Status:     SUCCEEDED
      Duration:   9m 31s

    PETL execution completed successfully

On the MySQL side, the warehouse database created by the wrapper holds the
built tables:

    $ docker exec mlw1865-defaults-openmrs-db mysql -uroot -popenmrs -N \
        -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='openmrs_warehouse';"
    99

Every step succeeded: `refresh-omrs-tables.yml` (functions, reference
lookups, `omrs_*` tables, the `omrs_obs`/`omrs_obs_group` pair),
`create-reporting-utilities.yml`, `refresh-mw-tables.yml` (all `mw_*`
tables), `refresh-derived-mysql-data.yml`, then
`refresh-sqlserver-reporting.yml` loading every one of those tables into
SQL Server.

### SQL Server verification

Table count:

    docker exec mlw1865-defaults-petl-sqlserver /opt/mssql-tools/bin/sqlcmd \
      -S localhost -U sa -P '9%4qP7b2H!%J' -d openmrs_reporting \
      -Q "SELECT COUNT(*) FROM sys.tables"
    -- table_count: 86

Row counts, to prove real data flowed through (not just empty tables):

    t                         c
    ------------------------- ---
    omrs_patient                2
    omrs_encounter              1
    omrs_obs                    2
    omrs_visit                  1
    omrs_program_enrollment     1
    omrs_program_state          1
    omrs_relationship           2
    omrs_patient_identifier     2
    omrs_encounter_provider     1
    mw_patient                  2
    mw_users                    1

And the actual values, confirmed to trace back to the fixture's synthetic
patients (not fabricated in SQL Server itself):

    patient_id  patient_uuid                          gender birthdate
    2           22222222-2222-2222-2222-222222222222  F      1990-05-15
    3           33333333-3333-3333-3333-333333333333  M      2000-11-02

    obs_id  uuid                                   patient_id  concept       value_numeric  obs_group_id
    1       h1111111-1111-1111-1111-111111111111   2           Weight (kg)   62.5           NULL
    3       h3333333-3333-3333-3333-333333333333   2           Test State    NULL           2

These `patient_uuid`/`gender`/`birthdate` and `obs` values are exactly what
was written into the fixture's `openmrs` schema — proof the full chain
(`openmrs` → warehouse → SQL Server) carried real data through, including
a resolved concept name (`lookup_concept` → `concept`) and an obs-group
relationship.

### Overridden database names

The same run was repeated on a second throwaway instance with
`PETL_WAREHOUSE_DATABASE=alt_warehouse` and
`PETL_SQLSERVER_DATABASE=alt_reporting` (both in the instance `env` file,
plus the `petl-db-names.yaml` compose override described under "Database
names"). `refresh-full.yml` again SUCCEEDED in 9m 31s, and every table
landed under the overridden names — no `openmrs_warehouse` or
`openmrs_reporting` database was created anywhere:

    Ensuring alt_warehouse database exists...

    mysql> SHOW DATABASES;
    information_schema / alt_warehouse / mysql / openmrs / performance_schema
    -- alt_warehouse tables: 99, alt_warehouse.omrs_patient rows: 2

    sqlcmd -Q "SELECT name FROM sys.databases"
    master / tempdb / model / msdb / alt_reporting
    -- alt_reporting: 86 tables, same two synthetic patients

### Cleanup

    OPENMRS_DOCKER_HOME=/tmp/openmrs-docker-test openmrs-docker mlw1865-defaults destroy --force
    OPENMRS_DOCKER_HOME=/tmp/openmrs-docker-test openmrs-docker mlw1865-override destroy --force

Confirmed: all containers, volumes, and the instance directories were
removed; no leftover state.
