#!/bin/bash

RESTIC_HOSTNAME="${RESTIC_HOSTNAME:-${HOSTNAME}}"
RESTIC_REPOSITORY="${RESTIC_REPOSITORY:-}"
RESTIC_PASSWORD="${RESTIC_PASSWORD:-}"
RESTIC_PASSWORD_FILE="${RESTIC_PASSWORD_FILE:-}"
RESTIC_FORGET_FLAGS="${RESTIC_FORGET_FLAGS:-}"
IONICE_CLASS="${IONICE_CLASS:-2}"
IONICE_CLASSDATA="${IONICE_CLASSDATA:-7}"

BACKUP_TARGET="${BACKUP_TARGET:-/target}"

PROMETHEUS_METRICS=${PROMETHEUS_METRICS:-true}
PROMETHEUS_METRICS_PATH="${PROMETHEUS_METRICS_PATH:-/var/lib/node_exporter/backup-restic-sftp.prom}"

if [ ! -z "$RESTIC_FORGET_FLAGS" ]; then
    echo "-> Running 'restic forget $RESTIC_FORGET_FLAGS' ..."
    restic forget --host "$RESTIC_HOSTNAME" $RESTIC_FORGET_FLAGS
fi

echo "=== Restic Snapshots"
restic snapshots --host "$RESTIC_HOSTNAME"
echo "==="

echo "-> Running 'restic backup $BACKUP_TARGET' ..."
ionice -c "$IONICE_CLASS" -n "$IONICE_CLASSDATA" restic backup --hostname "$RESTIC_HOSTNAME" "$BACKUP_TARGET"

SFTP_SERVER="$(echo "$RESTIC_REPOSITORY" | cut -d':' -f2)"
SFTP_DF_OUTPUT="$(echo "df" | sftp "${SFTP_SERVER}" | tail -n1)"

if [ $PROMETHEUS_METRICS ]; then
    cat <<EOF > "$PROMETHEUS_METRICS_PATH"
# HELP sftp_backup_space_size SFTP backup space size in bytes.
# TYPE sftp_backup_space_size gauge
sftp_backup_space_size{server="${SFTP_SERVER}"} $(echo "${SFTP_DF_OUTPUT}" | awk '{print $1}')
# HELP sftp_backup_space_used SFTP backup space used in bytes.
# TYPE sftp_backup_space_used gauge
sftp_backup_space_used{server="${SFTP_SERVER}"} $(echo "${SFTP_DF_OUTPUT}" | awk '{print $2}')
EOF
fi
