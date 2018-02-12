#!/bin/sh

# Source in the common file
. $(dirname $0)/rsync-backup-common.sh

# Source in the config file
. $(dirname $0)/dell.cfg

check_src_dir           # make sure SRC_DIR is set
check_dst_dir           # make sure DST_DIR is set

# check if destination directory exists
check_create_dir $DST_DIR
dinc=$DST_DIR/incremental/
check_create_dir $dinc

date=`date --utc "+%Y%m%dT%H%M%S"`
ddir=$dinc/$date
bdir=$DST_DIR/full/current/
log_info "Making incremental backup of $SRC_DIR into $ddir using $bdir as the base"
rsync -vcrzpl --delete --link-dest=$bdir "$SRC_DIR" "$ddir" || fatal "rsync command failed"
log_info "Successfully created incremental backup of $SRC_DIR in $ddir using $bdir as the base"
ln -s $bdir $ddir.offset  || error "unable to symlink from $ddir.offset to $bdir"
rm -f $dinc/current
ln -s $ddir $dinc/current || error "unable to symlink from $dinc/current to $ddir"

