#!/bin/bash

RESTIC_REPOSITORY="${RESTIC_REPOSITORY:-}"
RESTIC_PASSWORD="${RESTIC_PASSWORD:-}"
RESTIC_PASSWORD_FILE="${RESTIC_PASSWORD_FILE:-}"
RESTIC_FORGET_FLAGS="${RESTIC_FORGET_FLAGS:-}"

SSH_CONFIG_FILE="${SSH_CONFIG_FILE:-/dev/null}"

BACKUP_TARGET="${BACKUP_TARGET:-/target}"

if [ ! -z "$RESTIC_FORGET_FLAGS" ]; then
    restic forget "$RESTIC_FORGET_FLAGS"
fi

rm -f /etc/ssh/ssh_config
ln -s "$SSH_CONFIG_FILE" /etc/ssh/ssh_config

exec restic backup "$BACKUP_TARGET"
