#!/bin/bash

RESTIC_HOSTNAME="${RESTIC_HOSTNAME:-${HOSTNAME}}"
RESTIC_REPOSITORY="${RESTIC_REPOSITORY:-}"
RESTIC_PASSWORD="${RESTIC_PASSWORD:-}"
RESTIC_PASSWORD_FILE="${RESTIC_PASSWORD_FILE:-}"
RESTIC_FORGET_FLAGS="${RESTIC_FORGET_FLAGS:-}"
IONICE_CLASS="${IONICE_CLASS:-2}"
IONICE_CLASSDATA="${IONICE_CLASSDATA:-7}"

BACKUP_TARGET="${BACKUP_TARGET:-/target}"

if [ ! -z "$RESTIC_FORGET_FLAGS" ]; then
    echo "-> Running 'restic forget $RESTIC_FORGET_FLAGS' ..."
    restic forget --host "$RESTIC_HOSTNAME" $RESTIC_FORGET_FLAGS
fi

echo "=== Restic Snapshots"
restic snapshots --host "$RESTIC_HOSTNAME"
echo "==="

echo "-> Running 'restic backup $BACKUP_TARGET' ..."
exec ionice -c "$IONICE_CLASS" -n "$IONICE_CLASSDATA" restic backup --hostname "$RESTIC_HOSTNAME" "$BACKUP_TARGET"
