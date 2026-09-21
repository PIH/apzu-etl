# Malawi Production PETL — Docker Runbook

Production already runs as an `openmrs-docker` instance (`openmrs`,
`openmrs-db`). This adds petl to that existing, already-running instance —
it does not create a new stack, and never restores/replaces production data.

## One-time setup

    openmrs-docker <production-instance-name> add-service petl

Then add to that instance's `env` file:

    PETL_IMAGE_NAME=partnersinhealth/apzu-etl
    PETL_FULL_REFRESH_JOBS=refresh-mysql-reporting.yml
    PETL_MYSQL_ROOT_PASSWORD=<same value as this instance's OPENMRS_DB_ROOT_PASSWORD>

`PETL_MYSQL_ROOT_PASSWORD` is required: both bootstrap steps that petl needs
on first run — the base image's MySQL user/grant bootstrap and this image's
warehouse-database creation (see the reporting runbook's "Why this image has
its own entrypoint wrapper") — are skipped entirely when it is unset, and the
job then fails with `Access denied ... to database '<warehouse db>'`.

The warehouse database name defaults to `openmrs_warehouse` and can be changed
with `PETL_WAREHOUSE_DATABASE` (read by both the entrypoint wrapper and
`application.yml`); see the reporting runbook for the caveat about getting that
variable into the petl container.

## Running

    openmrs-docker <production-instance-name> run-service petl

Typically invoked from cron with no arguments, relying on
`PETL_FULL_REFRESH_JOBS`. No `restore` step — production always runs
directly against the live `openmrs-db` in that same instance.

## Verification

This procedure was verified against a local, throwaway stand-in instance
that mimics production's shape (`openmrs`, `openmrs-db`), never against
real infrastructure:

    export OPENMRS_IMAGE_NAME=openmrs/openmrs-core
    export OPENMRS_IMAGE_TAG=2.9.x-dev
    export OPENMRS_DB_ROOT_PASSWORD=openmrs
    OPENMRS_DOCKER_HOME=/tmp/openmrs-docker-test openmrs-docker create malawi-prod-standin
    OPENMRS_DOCKER_HOME=/tmp/openmrs-docker-test openmrs-docker malawi-prod-standin add-service petl

    # NOTE: PETL_MYSQL_ROOT_PASSWORD is absent here -- that omission is what
    # produced the failure analysed below. Do not copy this block as-is.
    {
      echo "PETL_IMAGE_NAME=partnersinhealth/apzu-etl"
      echo "PETL_IMAGE_TAG=local"
      echo "PETL_FULL_REFRESH_JOBS=refresh-mysql-reporting.yml"
    } >> /tmp/openmrs-docker-test/malawi-prod-standin/env
    OPENMRS_DOCKER_HOME=/tmp/openmrs-docker-test openmrs-docker malawi-prod-standin start
    OPENMRS_DOCKER_HOME=/tmp/openmrs-docker-test openmrs-docker malawi-prod-standin run-service petl
    OPENMRS_DOCKER_HOME=/tmp/openmrs-docker-test openmrs-docker malawi-prod-standin destroy --force

Result: `add-service petl` attached the fragment and left `petl` down
(profiled, as expected); `start` brought `openmrs`/`openmrs-db` up, with
`openmrs-db` healthy immediately. `run-service petl` picked up
`PETL_FULL_REFRESH_JOBS=refresh-mysql-reporting.yml` from the env file with
no CLI arguments, resolved the `openmrs-db` hostname, and completed a MySQL
connection handshake against it.

The job then failed with `Access denied ... to database 'warehouse'` (the
warehouse database was named `warehouse` when this test ran; it is now
`openmrs_warehouse` by default, so the same failure reads
`... to database 'openmrs_warehouse'` today). That
failure is **not** specific to the stand-in, and it is not a missing-seed-data
problem: the env additions used above omitted `PETL_MYSQL_ROOT_PASSWORD`, and
both bootstrap paths that would create the warehouse database and grant petl
access to it are gated on that variable being set. Any instance configured the
way this test was — stand-in or real production — produces exactly this error.
That is why `PETL_MYSQL_ROOT_PASSWORD` is now listed in "One-time setup"
above; it was missing from the configuration this verification exercised.

What the run does establish is the attachment mechanism itself: `add-service
petl` / `run-service petl` correctly attached to an existing
`openmrs`/`openmrs-db` instance, picked up the env file with no CLI arguments,
and reached MySQL over the instance network (no "unknown host" or "connection
refused" anywhere in the log). The bootstrap gap above was found by a later
review of this write-up, not by re-running the stand-in.

`OPENMRS_IMAGE_NAME=openmrs/openmrs-core:2.9.x-dev` was used only to stand
up a throwaway instance with the right shape for this verification; it is
not a statement about what the real production instance runs.
