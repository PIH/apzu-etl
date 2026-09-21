#!/bin/bash -eux

docker build -f Dockerfile.runtime -t partnersinhealth/apzu-etl:local .
