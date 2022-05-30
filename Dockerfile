FROM maven:3-jdk-8 AS builder

ARG ATLAS_VERSION=2.2.0
ARG ATLAS_URL=https://dlcdn.apache.org/atlas/${ATLAS_VERSION}/apache-atlas-${ATLAS_VERSION}-sources.tar.gz

WORKDIR /
RUN mkdir apache-atlas-sources \
    && curl ${ATLAS_URL} \
    | tar -xz -C apache-atlas-sources --strip-components=1 \
    && cd apache-atlas-sources \
    && mvn clean -DskipTests package -Pdist,embedded-hbase-solr

FROM openjdk:8-jre

ARG ATLAS_PACKAGE=/apache-atlas-sources/distro/target/apache-atlas-*-server.tar.gz

WORKDIR /
COPY --from=builder ${ATLAS_PACKAGE} apache-atlas-server.tar.gz
RUN mkdir apache-atlas \
    && tar -xf apache-atlas-server.tar.gz -C apache-atlas --strip-components=1 \
    && rm apache-atlas-server.tar.gz
