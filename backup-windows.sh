#!/bin/bash
# Path to the rsync executable on the Windows machine
RSYNC_WIN_PATH="C:/msys64/usr/bin/rsync.exe"
LOG_FILE="$HOME/backup.log"

# Perform the sync
# -a: archive, -v: verbose, -z: compress, --delete: mirror mode
rsync -avz --delete --rsync-path="$RSYNC_WIN_PATH" \
win:"/C/Users/USER_NAME/Desktop/" ~/Documents/Windows_Backup/Desktop/ >> $LOG_FILE 2>&1
