#!/usr/bin/env bash

# Get the directory name of this script and include the common file
SCRIPT_DIR=`dirname "$(readlink -f "$0")"`
. $SCRIPT_DIR/rsync-backup-common.sh

check_src_dir           # make sure BACKUP_SRC_DIR is set
check_dst_dir           # make sure BACKUP_DST_DIR is set

# check if destination directory exists
check_create_dir $BACKUP_DST_DIR
check_create_dir $BACKUP_DST_DIR/full

date=`date --utc "+%Y%m%dT%H%M%S"`
ddir=$BACKUP_DST_DIR/full/$date
log_info "Making full backup of $BACKUP_SRC_DIR into $ddir"
rstart=`date`
set -x
$RSYNC_CMD $RSYNC_OPTS "$BACKUP_SRC_DIR" "$ddir"
RSYNC_STATUS=$?
set +x
log_info "Started  : $rstart"
log_info "Finished : `date`"

if [ 0 -eq $RSYNC_STATUS ] ; then
  log_info "Successfully created full backup of $BACKUP_SRC_DIR in $ddir"
  rm -f $BACKUP_DST_DIR/full/current
  ln -r -s $ddir $BACKUP_DST_DIR/full/current
else
  log_error "rsync command failed (exit code: $RSYNC_STATUS)"
  log_warning "removing partially done backup: $ddir"
  delete_dir "$ddir"
  exit $RSYNC_STATUS
fi
