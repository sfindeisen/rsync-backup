#!/bin/sh

# Get the directory name of this script and include the common file
SCRIPT_DIR=`dirname "$(readlink -f "$0")"`
. $SCRIPT_DIR/rsync-backup-common.sh

check_src_dir           # make sure BACKUP_SRC_DIR is set
check_dst_dir           # make sure BACKUP_DST_DIR is set

# check if destination directory exists
check_create_dir $BACKUP_DST_DIR
dinc=$BACKUP_DST_DIR/incremental/
check_create_dir $dinc

date=`date --utc "+%Y%m%dT%H%M%S"`
ddir=$dinc/$date
bdir=$BACKUP_DST_DIR/full/current/
bdir_absolute=$(readlink -e $bdir)

if [ -z "$bdir_absolute" ] || [ ! -d "$bdir_absolute" ]; then
  log_error "You need at least 1 full backup first!"
  exit 1
fi

log_info "Making incremental backup of $BACKUP_SRC_DIR into $ddir using $bdir_absolute as the base"
rstart=`date`
rsync $RSYNC_OPTS --link-dest=$bdir "$BACKUP_SRC_DIR" "$ddir"
RSYNC_STATUS=$?
log_info "Started  : $rstart"
log_info "Finished : `date`"

if [ 0 -eq $RSYNC_STATUS ] ; then
  log_info "Successfully created incremental backup of $BACKUP_SRC_DIR in $ddir using $bdir_absolute as the base"
  ln -s $bdir_absolute $ddir.offset  || error "unable to symlink from $ddir.offset to $bdir_absolute"
  rm -f $dinc/current
  ln -s $ddir $dinc/current || error "unable to symlink from $dinc/current to $ddir"
else
  log_error "rsync command failed (exit code: $RSYNC_STATUS)"
  log_warning "removing partially done backup: $ddir"
  delete_dir "$ddir"
  exit $RSYNC_STATUS
fi

