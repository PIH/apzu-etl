# Malawi Production PETL — Docker Runbook

Production already runs as an `openmrs-docker` instance (`openmrs`,
`openmrs-db`). This adds petl to that existing, already-running instance —
it does not create a new stack, and never restores/replaces production data.

## One-time setup

    openmrs-docker <production-instance-name> add-service petl

Then add to that instance's `env` file:

    PETL_IMAGE_NAME=partnersinhealth/apzu-etl
    PETL_FULL_REFRESH_JOBS=refresh-mysql-reporting.yml

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
connection handshake against it — the job then failed with `Access denied
... to database 'warehouse'`, because this fresh stand-in never had a
`warehouse` schema or grants set up. That's a job-logic/missing-seed-data
failure specific to the stand-in, not a wiring or networking error (no
"unknown host" or "connection refused" anywhere in the log), confirming the
`add-service petl` / `run-service petl` attachment mechanism itself works
against an existing `openmrs`/`openmrs-db` instance.

`OPENMRS_IMAGE_NAME=openmrs/openmrs-core:2.9.x-dev` was used only to stand
up a throwaway instance with the right shape for this verification; it is
not a statement about what the real production instance runs.
