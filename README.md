APUZ-ETL - ETL Jobs to support reporting and analytics from OpenMRS at APZU
============================================================================

This project is based off of the original [PIH Pentaho](https://github.com/PIH/pih-pentaho) project, and adapted 
to enable growth beyond Pentaho and to allow for execution through the [PETL](https://github.com/PIH/petl) ETL tool.

This project currently supports and executes the following jobs:

1. ETL from OpenMRS database into MySQL warehouse database
2. ETL from MySQL warehouse database into a SQL Server reporting database

# Installation

For implementers, see [Puppet](https://github.com/PIH/mirebalais-puppet/tree/master/mirebalais-modules/petl)

### Install Java
The recommended Java version is **OpenJDK 8 JDK**

### Source MySQL databases
You must have access to source MySQL OpenMRS database
The recommendation is that these databases are replicas of production DBs, not the actual production instances, as a 
precaution to ensure no production data is inadvertently affected by the ETL process.

### Target MySQL databases
* You must have access to a target MySQL instance into which to ETL from the OpenMRS MySQL database
* You must create new databases inside this MySQL instance for OpenMRS to use

Example:

```bash
mysql> create database neno_reporting default charset utf8;
Query OK, 1 row affected (0.00 sec)

mysql> create database lisungwi_reporting default charset utf8;
Query OK, 1 row affected (0.00 sec)
```

### Target SQL Server databases
* You must have access to a SQL Server target instance into which to ETL from MySQL
* You can use the Docker instance [described here](https://github.com/PIH/petl/tree/master/docs/examples/sqlserver-docker).

### Install PETL application and jobs

1. Create a directory to serve as your execution environment directory
2. Install the jobs and datasources into this directory
   1. For developers, create a symbolic link to the datasources and jobs folders of this project
   2. For implementers, download the zip artifact from maven and extract it into this directory
3. Install an application.yml file into this directory
   1. For developers, copy or create a symolic link to example-application.yml, and modify settings to match your database configuration
   2. For implementers, install the application.yml file, and ensure all of the database settings are setup correctly
   3. For more details on configuration options for application.yml, see the [PETL](https://github.com/PIH/petl) project
4. Install the PETL executable jar file
   1. For developers, you can clone and build the PETL application locally and create a symbolic link to target/petl-*.jar
   2. For developers or implementers, you can download the latest PETL jar from Bamboo

The directory structure should look like this:

```bash
/opt/petl/apzu-etl/
  ├── datasources/
    ├── mysqlReporting.yml
    ├── sqlServerReporting.yml
  ├── jobs/
      ├── pentaho/
          ├── config/...
          ├── opemrs/...
          ├── malawi/...
      ├── refresh-full.yml
      ├── refresh-mysql-reporting.yml
      ├── refresh-sqlserver-reporting.yml
      ├── ...
  ├── application.yml
  ├── petl.jar
```

# Configuration Notes

The application.yml file provided sets the refresh-full.yml job up in the "startup.jobs" property.  This is mainly there
to facilitate development and testing, as this is where one simply wants to fire up the application and execute their job.
However, on a typical test or production server, you may want to remove this from the startup.jobs, as keeping it here will
mean that anytime the server or application is restarted, the jobs will run and will drop and recreate the warehouse tables.
You can adjust the schedule and frequency of the job execution within the "schedule" property of refresh-full.yml
In the event you want to simply execute the job and exit the application from an external script, you would want to remove
the schedule property from the refresh-full.yml file, and keep this job listed in the startup.jobs property of application.yml.
This might be desirable, for example, if one needed to control the exact timing of execution in a shell script or cron job
based on external dependencies (eg. the availability of new copies of the source database to execute against).

# Execution

To execute the ETL pipeline, simply run from the installation directory:

```shell
java -jar petl.jar
```

# Docker Image

`partnersinhealth/apzu-etl` layers this project's `datasources`/`jobs`/`application-docker.yml`
on top of the [PETL](https://github.com/PIH/petl) base image (`partnersinhealth/petl`). CI builds
and pushes it (`Dockerfile`, build context `target/docker/` — populated by `mvn package`, never
built from source directly) on every push to `master` and on every release. To build it locally:
`./build-runtime-docker-image.sh`, which layers on `partnersinhealth/petl:local` instead.

It's meant to be run via
[`openmrs-docker`](https://github.com/PIH/openmrs-contrib-distro-tools)'s `petl` service, either
attached to an existing `openmrs`/`openmrs-db` instance (production — `add-service petl`) or as
part of a self-contained reporting instance (`SERVICES=openmrs-db,petl,petl-sqlserver`). Either
way, add to the instance's `env` file:

    PETL_IMAGE_NAME=partnersinhealth/apzu-etl
    PETL_FULL_REFRESH_JOBS=refresh-full.yml           # or refresh-mysql-reporting.yml for production, which never touches SQL Server
    PETL_MYSQL_ROOT_PASSWORD=<same value as this instance's OPENMRS_DB_ROOT_PASSWORD>

`PETL_MYSQL_ROOT_PASSWORD` is required, not optional: both the base image's MySQL user/grant
bootstrap and this image's own warehouse-database creation (`docker-entrypoint-wrapper.sh`,
needed because the base image assumes that database already exists) are skipped entirely when
it's unset, and the run then fails with `Access denied ... to database '<warehouse db>'`.

Two database names are configurable, both read by `application-docker.yml` alongside whatever
creates them:

| Variable | Default | Also read/created by |
| --- | --- | --- |
| `PETL_WAREHOUSE_DATABASE` | `openmrs_warehouse` | `docker-entrypoint-wrapper.sh` (creates it) |
| `PETL_SQLSERVER_DATABASE` | `openmrs_reporting` | the `petl-sqlserver` service (creates it) |

Caveat: `openmrs-contrib-distro-tools`'s `docker/services/petl.yaml` doesn't currently pass either
variable through to the `petl` container, so overriding either default needs a small compose
override dropped into the instance directory in addition to the `env` file entry, e.g.
`petl-db-names.yaml`:

    services:
      petl:
        environment:
          PETL_WAREHOUSE_DATABASE: ${PETL_WAREHOUSE_DATABASE:-openmrs_warehouse}
          PETL_SQLSERVER_DATABASE: ${PETL_SQLSERVER_DATABASE:-openmrs_reporting}

Restoring from a real (password-protected `.7z`) backup needs `PETL_BACKUP_PASSWORD` set in the
instance's own `env` file *before* running `restore` — not on the `restore` command line, which
gets overwritten by `openmrs-docker`'s own env-file sourcing.

# Troubleshooting

1. Could not acquire change log lock.
   - after launching petl the following error would be displayed:
     ```bash
      org.springframework.beans.factory.BeanCreationException: Error creating bean with name 'liquibase' defined in class path resource [org/springframework/boot/autoconfigure/liquibase/LiquibaseAutoConfiguration$LiquibaseConfiguration.class]: Invocation of init method failed; nested exception is liquibase.exception.LockException: Could not acquire change log lock.  Currently locked by 25.60.164.30 (25.60.164.30) since 9/13/23 11:33 AM
     ```
     - "This happens sometimes if the system shuts down unexpectedly or another issue occurs when liquibase is updating, and the record that it writes to the PETL_DATABASE_CHANGE_LOG_LOCK table to indicate it is in the process of updating never gets reset. For Malawi, we use the default PETL configuration which connects to an H2 database for storing job execution history. "
     - To fix this problem, just delete all files(petl H2 database files) in the /opt/petl/data/ and restart petl
     - more details about this problem at https://pihemr.atlassian.net/browse/MLW-1560 

# Pentaho Jobs and Transforms

The "jobs/pentaho" directory represent the core Pentaho ETL jobs that are executed.  These are made up of:

* Kettle jobs (*.kjb):  Represent a sequence of transforms that can be executed or run on a schedule to process data
* Kettle transforms (*.ktr):  Represent specific data transformations (Extract, Transform, and Load) that can be exectuted within one more more jobs
* Other files (.sql, etc): Files used by these jobs and transforms

=====================

DEV ENVIRONMENT SETUP

For development, it is most helpful to utilize Pentaho Spoon, which is a graphical designer and editor for creating, editing, and viewing
Pentaho jobs and transforms.

* Download Pentaho Data Integration from here: https://sourceforge.net/projects/pentaho/files/
  * Click into the latest Pentaho -> Client Tools, and then download the zip named "pdi-ce-xxx.zip"
* Unzip and copy into your preferred executable directory (eg. /opt/pentaho/data-integration)
* Download the latest mysql connector jar from here: https://dev.mysql.com/downloads/file/?id=465644
* Extract the mysql connector jar out of the above zip file and copy it into the data-integration/lib folder
* Create a new mysql database for the warehouse ( eg. _create database openmrs_warehouse default charset utf8;_ )
* Checkout out jobs (this repository).  Make note of the location where this is located.
* Edit or create ~/.kettle/kettle.properties with the following variables set to your preferred values:

** PIH_PENTAHO_HOME points at this checkout's `jobs/pentaho` directory
** The remaining variables configure the source and target databases — these are auto-supplied by PETL at runtime, but Spoon needs them for local development.
** Sample below:

```
PIH_PENTAHO_HOME = /checked/out/folder/jobs/pentaho

openmrs.db.host = localhost
openmrs.db.port = 3306
openmrs.db.name = openmrs
openmrs.db.user = root
openmrs.db.password = rootpw

warehouse.db.host = localhost
warehouse.db.port = 3306
warehouse.db.name = openmrs_warehouse
warehouse.db.user = root
warehouse.db.password = rootpw
```

* Run "spoon.sh" to start

Link your shared.xml to the shared file used by the project:
* Go to $HOME/.kettle/shared.xml and delete this file if it exists
* Create a new shared.xml that is a symbolic link to "jobs/pentaho/shared-connections.xml" in this project.

* Test it out by trying to run a job in the pih-pentaho/jobs folder (eg. load-from-openmrs.kjb)
