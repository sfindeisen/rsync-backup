#!/bin/sh

# Source in the common file
. $(dirname $0)/rsync-backup-common.sh

# Source in the config file
. $(dirname $0)/dell.cfg

check_src_dir           # make sure SRC_DIR is set
check_dst_dir           # make sure DST_DIR is set

# check if destination directory exists
check_create_dir $DST_DIR
check_create_dir $DST_DIR/full

date=`date --utc "+%Y%m%dT%H%M%S"`
ddir=$DST_DIR/full/$date
log_info "Making full backup of $SRC_DIR into $ddir"
rsync -crzpl "$SRC_DIR" "$ddir" || fatal "rsync command failed"
log_info "Successfully created full backup of $SRC_DIR in $ddir"
rm -f $DST_DIR/full/current
ln -s $ddir $DST_DIR/full/current

