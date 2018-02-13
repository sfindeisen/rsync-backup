#!/bin/sh

# rsync base options
#
# Please note that this options have been omitted:
# -x, --one-file-system       don't cross filesystem boundaries
# -v, --verbose               increase verbosity
RSYNC_OPTS="-crRpezAXogt -LK --safe-links"

# Executable script name
APPNAME=$(basename $0 | sed "s/\.sh$//")

log_info()    { echo "$APPNAME: [info] $1"; }
log_warning() { echo "$APPNAME: [warning] $1" 1>&2; }
log_error()   { echo "$APPNAME: [error] $1" 1>&2; }

# Report a fatal error and exit
fatal() {
  code=$?
  if [ 0 -eq "$code" ]; then
    log_error "$*"
  else
    log_error "$* (status $?)"
  fi
  exit 1
}

# Make sure BACKUP_SRC_DIR is set
check_src_dir() {
  if [ -z "$BACKUP_SRC_DIR" ]; then
    log_error "missing BACKUP_SRC_DIR"
    exit 1
  fi
}

# Make sure BACKUP_DST_DIR is set
check_dst_dir() {
  if [ -z "$BACKUP_DST_DIR" ]; then
    log_error "missing BACKUP_DST_DIR"
    exit 1
  fi
}

# Make sure the directory exists; create if not
check_create_dir() {
  dir=$1
  if [ ! -d "$dir" ]; then
    log_warning "Directory ($dir) does not exist - creating..."
    mkdir -v -m 700 -p $dir || fatal "unable to create directory ($dir)"
  fi
}

delete_dir() {
  dir_to_delete=$1
  log_info "force delete dir: $dir_to_delete"
  chmod -R u+rwx "$dir_to_delete"
  rm -rf $dir_to_delete
}

