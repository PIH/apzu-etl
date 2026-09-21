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

## Refreshing from a new backup

    openmrs-docker malawi-reporting destroy --force   # only if re-seeding from scratch
    SERVICES=openmrs-db,petl,petl-sqlserver openmrs-docker create malawi-reporting
    openmrs-docker malawi-reporting restore --from-percona /path/to/backup   # or --from-dump
    openmrs-docker malawi-reporting add-service petl-sqlserver
    openmrs-docker malawi-reporting start
    openmrs-docker malawi-reporting run-service petl

## Known issues that block this procedure today

Two gaps were found by driving the whole pipeline end-to-end (see
Verification below). Both need to be fixed before this runbook works
unmodified. Neither is in this repo's `docs/` scope to fix, so they're
recorded here rather than patched silently.

1. **`application-docker.yml` is missing a `mysqlOpenmrs` datasource
   block.** `jobs/execute-pentaho-job.yml` resolves the OpenMRS *source*
   connection used by every `.ktr` transform under
   `jobs/pentaho/openmrs/transforms/` and `jobs/pentaho/malawi/transforms/`
   via `${mysqlOpenmrs.host}`, `.port`, `.databaseName`, `.user`,
   `.password`. `application-docker.yml` defines `mysqlReporting` and
   `sqlServerReporting` but never `mysqlOpenmrs`, so every OpenMRS-source
   transform fails at step-initialization with:

       Cannot load connection class because of underlying exception:
       com.mysql.cj.exceptions.WrongArgumentException: Failed to parse the
       host:port pair '${mysqlOpenmrs.host}:${mysqlOpenmrs.port}'.

   This is a hard blocker for `refresh-omrs-tables.yml` and
   `refresh-mw-tables.yml` in **any** deployment, not specific to a test
   fixture. Fix: add to `application-docker.yml` (mirroring the
   `mysqlReporting` block, pointed at the source `openmrs` database instead
   of `warehouse`):

       mysqlOpenmrs:
         host: ${petl.mysql.host}
         port: ${petl.mysql.port}
         databaseName: "openmrs"
         user: ${petl.mysql.user}
         password: ${petl.mysql.password}
         options: ""

2. **Nothing creates the `warehouse` database.** `docker-entrypoint.sh` in
   the `petl` image (`bootstrap_petl_mysql_user`) only creates the PETL
   MySQL user and grants it `ALL PRIVILEGES ON *.*` — it never issues
   `CREATE DATABASE warehouse`. Against a brand-new `openmrs-db` (or any
   `openmrs-db` where the `openmrs`/`openmrs` user/db already exist, which
   is every instance, since the standard `mysql` image env vars always
   create them), `run-service petl` fails immediately with:

       Caused by: com.mysql.cj.exceptions.CJException: Unknown database
       'warehouse'

   Until this is fixed upstream (likely: `CREATE DATABASE IF NOT EXISTS
   warehouse` added to the bootstrap step, or a `createDatabaseIfNotExist=
   true` option on the `mysqlReporting` datasource), it must be created by
   hand once per fresh instance:

       docker exec <instance>-openmrs-db mysql -uroot -p"$OPENMRS_DB_ROOT_PASSWORD" \
         -e "CREATE DATABASE IF NOT EXISTS warehouse;"

## Verification

This procedure was driven end-to-end against a throwaway instance with a
hand-built minimal OpenMRS source fixture, to prove real data actually
flows `openmrs` (source) → `warehouse` (MySQL) → SQL Server, not just that
the containers start.

### Fixture (Step 2)

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
other Malawi transform reads only from the `warehouse` database, so it was
out of scope to seed further: with only a generic fixture (no PIH/Malawi
concept dictionary), `mw_*` tables besides `mw_patient`/`mw_users` are
expected to load as empty-but-present tables, not errors.

A hand-written SQL fixture (schema + synthetic data, no real patient data)
was built for exactly those 31 tables — loose types, no FK constraints
(MySQL only needs the `SELECT`s to succeed; referential integrity was
ensured by hand), two synthetic patients linked through a visit, an
encounter, an obs group, a program enrollment/state, and a relationship.
It was validated by loading it into a scratch `mysql:5.6` container and
running the actual join queries from the `.ktr` files against it before
ever touching `openmrs-docker`.

### Full pipeline run

    export OPENMRS_DB_ROOT_PASSWORD=openmrs
    SERVICES=openmrs-db,petl,petl-sqlserver \
      OPENMRS_DOCKER_HOME=/tmp/openmrs-docker-test \
      openmrs-docker create malawi-reporting-test
    { echo "PETL_IMAGE_NAME=partnersinhealth/apzu-etl"
      echo "PETL_IMAGE_TAG=local"
      echo "PETL_FULL_REFRESH_JOBS=refresh-full.yml"
      echo "PETL_MYSQL_ROOT_PASSWORD=openmrs"
    } >> /tmp/openmrs-docker-test/malawi-reporting-test/env
    OPENMRS_DOCKER_HOME=/tmp/openmrs-docker-test \
      openmrs-docker malawi-reporting-test restore --from-dump <fixture.sql>
    OPENMRS_DOCKER_HOME=/tmp/openmrs-docker-test openmrs-docker malawi-reporting-test start
    # workaround for known issue 2 above:
    docker exec malawi-reporting-test-openmrs-db mysql -uroot -popenmrs \
      -e "CREATE DATABASE IF NOT EXISTS warehouse;"
    # workaround for known issue 1 above: PETL_IMAGE_TAG pointed at a locally
    # built image = partnersinhealth/apzu-etl:local plus a corrected
    # application.yml adding the mysqlOpenmrs block shown above
    OPENMRS_DOCKER_HOME=/tmp/openmrs-docker-test openmrs-docker malawi-reporting-test run-service petl

With both workarounds applied, `refresh-full.yml` completed successfully:

    ================================================================================
    PETL Run Summary
    ================================================================================
      Job:        refresh-full.yml
      Status:     SUCCEEDED
      Duration:   9m 34s

    PETL execution completed successfully

Every step succeeded: `refresh-omrs-tables.yml` (functions, reference
lookups, `omrs_*` tables, the `omrs_obs`/`omrs_obs_group` pair),
`create-reporting-utilities.yml`, `refresh-mw-tables.yml` (all `mw_*`
tables), `refresh-derived-mysql-data.yml`, then
`refresh-sqlserver-reporting.yml` loading every one of those tables into
SQL Server.

### SQL Server verification (Step 4)

Table count (the brief's literal check):

    docker exec malawi-reporting-test-petl-sqlserver /opt/mssql-tools/bin/sqlcmd \
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
(`openmrs` → `warehouse` → SQL Server) carried real data through, including
a resolved concept name (`lookup_concept` → `concept`) and an obs-group
relationship.

### Cleanup (Step 5)

    OPENMRS_DOCKER_HOME=/tmp/openmrs-docker-test openmrs-docker malawi-reporting-test destroy --force

Confirmed: all containers, volumes, and the instance directory were
removed; no leftover state.
