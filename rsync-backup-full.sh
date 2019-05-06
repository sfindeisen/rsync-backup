#!/bin/sh

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
cpstart=`date`
cp $CP_OPTS "$BACKUP_SRC_DIR" "$ddir"
CP_STATUS=$?
log_info "Started  : $cpstart"
log_info "Finished : `date`"

if [ 0 -eq $CP_STATUS ] ; then
  log_info "Successfully created full backup of $BACKUP_SRC_DIR in $ddir"
  rm -f $BACKUP_DST_DIR/full/current
  ln -s $ddir $BACKUP_DST_DIR/full/current
else
  log_error "cp command failed (exit code: $CP_STATUS)"
  log_warning "removing partially done backup: $ddir"
  delete_dir "$ddir"
  exit $CP_STATUS
fi

