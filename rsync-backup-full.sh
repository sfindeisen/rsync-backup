#!/bin/sh

# Source in the common file
. $(dirname $0)/rsync-backup-common.sh

check_src_dir           # make sure BACKUP_SRC_DIR is set
check_dst_dir           # make sure BACKUP_DST_DIR is set

# check if destination directory exists
check_create_dir $BACKUP_DST_DIR
check_create_dir $BACKUP_DST_DIR/full

date=`date --utc "+%Y%m%dT%H%M%S"`
ddir=$BACKUP_DST_DIR/full/$date
log_info "Making full backup of $BACKUP_SRC_DIR into $ddir"
rsync -crzpl "$BACKUP_SRC_DIR" "$ddir" || fatal "rsync command failed"
log_info "Successfully created full backup of $BACKUP_SRC_DIR in $ddir"
rm -f $BACKUP_DST_DIR/full/current
ln -s $ddir $BACKUP_DST_DIR/full/current

