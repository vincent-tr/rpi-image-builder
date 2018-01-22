#!/bin/sh

# https://gist.github.com/shawnrice/11076762

logFile="/var/log/mylife-home-core-storage-service.log"

mountPoint="/media/mmcblk0p1"
mediaFile="$mountPoint/mylife-home/mylife-home-core-components.json"
targetFile="/home/mylife-home/mylife-home-core/data/components.json"

runInterval=5 # In seconds

doRestore() {
  if [ -f $mediaFile ]
  then
    su - -s /bin/sh -c "mkdir -p $(dirname $targetFile)" mylife-home
    install -o142 -g142 -m644 -p "$mediaFile" "$targetFile"
    log "Restore : media file installed"
  else
    log "Restore : media file does not exist"
  fi
}

doBackup() {
  if ! [ -f $targetFile ]
  then
    # nothing to backup
    return 0
  fi

  if [ -f $mediaFile ] && ! [ $targetFile -nt $mediaFile ]
  then
    # nothing to backup
    return 0
  fi

  # remount rw, copy, remount ro
  mount -o remount,rw "$mountPoint"
  install -pD "$targetFile" "$mediaFile"
  mount -o remount,ro "$mountPoint"

  log "Backup : media file backup done"
}

loop() {
  # This is the loop.
  now=`date +%s`

  if [ -z $last ]; then
    last=`date +%s`
  fi

  # Do everything you need the daemon to do.
  doBackup

  # Check to see how long we actually need to sleep for. If we want this to run
  # once a minute and it's taken more than a minute, then we should just run it
  # anyway.
  last=`date +%s`

  # Set the sleep interval
  if [[ ! $((now-last+runInterval+1)) -lt $((runInterval)) ]]; then
    sleep $((now-last+runInterval))
  fi

  # Startover
  loop
}

log() {
  # Generic log function.
  echo "`date +"%Y-%m-%d %H:%M:%S"` - $1" >> "$logFile"
}

doRestore
loop
