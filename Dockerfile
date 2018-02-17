FROM debian:stretch-slim

ENV RESTIC_VERSION="0.8.2"

RUN apt-get -q update && \
    apt-get upgrade -y && \
    apt-get install -y openssh-client sshpass curl bzip2 && \
    curl -L "https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/restic_${RESTIC_VERSION}_linux_amd64.bz2" -o /usr/local/bin/restic.bz2 && \
    bzip2 -d /usr/local/bin/restic.bz2 && \
    chmod 755 /usr/local/bin/restic && \
    mkdir -p /var/lib/node_exporter && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/var/lib/node_exporter"]

ADD entrypoint.sh /usr/local/bin

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
