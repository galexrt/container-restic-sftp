FROM debian:jessie

RUN apt-get -q update && \
    apt-get upgrade -y && \
    apt-get install -y sshfs curl && \
    curl -L https://github.com/restic/restic/releases/download/v0.8.0/restic_0.8.0_linux_amd64.bz2 -o /usr/local/bin/restic && \
    mkdir -p /destination

ADD entrypoint.sh /usr/local/bin

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
