#!/bin/sh

app_dir=$(dirname $0)
. $app_dir/config-dell.sh
$app_dir/rsync-backup-incremental.sh
