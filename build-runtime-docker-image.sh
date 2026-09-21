#!/bin/bash -eux

# Local builds layer on the locally-built petl base image; the Dockerfile's own
# default (partnersinhealth/petl:latest) is what CI uses.
docker build -f Dockerfile.runtime \
  --build-arg PETL_BASE_IMAGE=partnersinhealth/petl:local \
  -t partnersinhealth/apzu-etl:local .
