
# Use open jdk 8 alpine as base image
FROM adoptopenjdk/openjdk11:alpine

# Build time arguments (GraphDB edition and version)
ARG edition=free
ARG version=9.3.0

ENV GRAPHDB_PARENT_DIR=/opt/graphdb
ENV GRAPHDB_HOME=${GRAPHDB_PARENT_DIR}/home
ENV GRAPHDB_INSTALL_DIR=${GRAPHDB_PARENT_DIR}/dist
ENV DUMPFILE=truthy_noliteral_head.nt.gz

# Add GraphDB and config to image
COPY graphdb-${edition}-${version}-dist.zip /tmp/
COPY config.ttl /tmp/ 
COPY ${DUMPFILE} /tmp/
# Setup GraphDB

RUN apk add --no-cache bash util-linux procps net-tools busybox-extras wget less && \
    mkdir -p ${GRAPHDB_PARENT_DIR} && \
    cd ${GRAPHDB_PARENT_DIR} && \
    unzip /tmp/graphdb-${edition}-${version}-dist.zip && \
    rm /tmp/graphdb-free-${version}-dist.zip && \
    mv graphdb-${edition}-${version} dist && \
    mkdir -p ${GRAPHDB_HOME} && \
    # Tune loadrdf
    #sed -i 's/com.ontotext.graphdb.loadrdf.LoadRDF/-Dpool.buffer.size=400000 -Dinfer.pool.size=4 com.ontotext.graphdb.loadrdf.LoadRDF/' /opt/graphdb/dist/bin/loadrdf && \
    # Restore repository
    /opt/graphdb/dist/bin/loadrdf -c /tmp/config.ttl -m parallel /tmp/${DUMPFILE} && \
    rm -rf /tmp/*

ENV PATH=${GRAPHDB_INSTALL_DIR}/bin:$PATH

ENTRYPOINT ["/opt/graphdb/dist/bin/graphdb"]

# Expose default GraphDB port
EXPOSE 7200
