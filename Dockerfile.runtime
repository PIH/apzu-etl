# Defaults to the published base image, so CI -- which has no locally-built petl
# image -- can build this. build-runtime-docker-image.sh overrides it with
# partnersinhealth/petl:local so local builds layer on a locally-built base.
ARG PETL_BASE_IMAGE=partnersinhealth/petl:latest
FROM ${PETL_BASE_IMAGE}

COPY datasources /home/petl/configurations/datasources
COPY jobs /home/petl/configurations/jobs
COPY application-docker.yml /home/petl/bin/application.yml

# Ensures the `warehouse` database exists before delegating to the base
# image's own entrypoint -- see docker-entrypoint-wrapper.sh for why.
COPY docker-entrypoint-wrapper.sh /docker-entrypoint-wrapper.sh
RUN chmod +x /docker-entrypoint-wrapper.sh
ENTRYPOINT ["/docker-entrypoint-wrapper.sh"]
