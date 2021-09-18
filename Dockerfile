FROM debian:buster-slim

ARG BUILD_DATE="N/A"
ARG REVISION="N/A"

ARG RESTIC_VERSION="0.12.1"
ARG RESTIC_ARCH="linux_amd64"

LABEL org.opencontainers.image.authors="Alexander Trost <galexrt@googlemail.com>" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.title="galexrt/container-restic-sftp" \
    org.opencontainers.image.description="Container image with Restic + SSH + Wrapper for simply SFTP backups with restic." \
    org.opencontainers.image.documentation="https://github.com/galexrt/container-restic-sftp/blob/main/README.md" \
    org.opencontainers.image.url="https://github.com/galexrt/container-restic-sftp" \
    org.opencontainers.image.source="https://github.com/galexrt/container-restic-sftp" \
    org.opencontainers.image.revision="${REVISION}" \
    org.opencontainers.image.vendor="galexrt" \
    org.opencontainers.image.version="N/A"

RUN apt-get -q update && \
    apt-get upgrade -y && \
    apt-get install -y openssh-client openssh-server sshpass curl bzip2 rsync s3fs && \
    curl -L "https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/restic_${RESTIC_VERSION}_${RESTIC_ARCH}.bz2" -o /usr/local/bin/restic.bz2 && \
    bzip2 -d /usr/local/bin/restic.bz2 && \
    chmod 755 /usr/local/bin/restic && \
    mkdir -p /var/lib/node_exporter && \
    apt-get remove -y bzip2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/var/lib/node_exporter"]

ADD entrypoint.sh /usr/local/bin

RUN chmod 755 /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
