#!/bin/bash -eu

function connectionmonitor {
  while true
  do
    # shellcheck disable=SC2034
    for i in {1..5}
    do
      if timeout 6 /root/bin/archive-is-reachable.sh "$ARCHIVE_SERVER"
      then
        # sleep and then continue outer loop
        sleep 5
        continue 2
      fi
    done
    log "connection dead, killing archive-clips"
    # Since there can be a substantial delay before rsync deletes archived
    # source files, give it an opportunity to delete them before killing it
    # hard.
    killall rsync || true
    sleep 2
    killall -9 rsync || true
    kill -9 "$1" || true
    return
  done
}

connectionmonitor $$ &

# rsync's temp files may be left behind if the connection is lost,
# but rsync doesn't clean these up on subsequent runs. Putting
# them in a temp dir allows them to be easily cleaned up.
rsynctmp=".teslausbtmp"
rm -rf "$ARCHIVE_MOUNT/${rsynctmp:?}"
mkdir -p "$ARCHIVE_MOUNT/$rsynctmp"

while [ -n "${1+x}" ]
do
  rsync -avhRL --remove-source-files --temp-dir="$rsynctmp" --no-perms --omit-dir-times --stats --log-file=/tmp/archive-rsync-cmd.log \
        --files-from="$2" "$1/" "$ARCHIVE_MOUNT" &> /tmp/rsynclog
  shift 2
done

rm -rf "$ARCHIVE_MOUNT/${rsynctmp:?}"

kill %1 || true
