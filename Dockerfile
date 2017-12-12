FROM debian:jessie

RUN apt-get -q update && \
    apt-get upgrade -y && \
    apt-get install -y openssh-client sshpass curl bzip2 && \
    curl -L https://github.com/restic/restic/releases/download/v0.8.0/restic_0.8.0_linux_amd64.bz2 -o /usr/local/bin/restic.bz2 && \
    bzip2 -d /usr/local/bin/restic.bz2 && \
    chmod 755 /usr/local/bin/restic && \
    apt-get --purge remove -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD entrypoint.sh /usr/local/bin

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
