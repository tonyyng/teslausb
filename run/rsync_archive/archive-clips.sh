#!/bin/bash -eu

while [ -n "${1+x}" ]
do
  # shellcheck disable=SC2154
  rsync -avhRL --timeout=60 --remove-source-files --no-perms --omit-dir-times --stats --log-file=/tmp/archive-rsync-cmd.log --files-from="$2" "$1" "$RSYNC_USER@$RSYNC_SERVER:$RSYNC_PATH" &> /tmp/rsynclog
  shift 2
done
