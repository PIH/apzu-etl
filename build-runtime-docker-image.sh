#!/bin/bash -eux

# Populates target/docker/ with the packaged datasources/jobs/Dockerfile -- the same
# build context CI uses, never the source tree directly (see pom.xml's
# package-docker-context execution).
mvn package

# Local builds layer on the locally-built petl base image; the Dockerfile's own
# default (partnersinhealth/petl:latest) is what CI uses.
docker build \
  --build-arg PETL_BASE_IMAGE=partnersinhealth/petl:local \
  -t partnersinhealth/apzu-etl:local target/docker
