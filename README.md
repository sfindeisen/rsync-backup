# rsync-backup

Personal, minimalistic, simple to use, space-efficient rsync(1) based backup
solution. Unchanged files are hardlinked to previous copies => they take no
extra space.

## Requirements

1. rsync (on a Debian-like operating system: `apt-get install rsync`)
2. target filesystem must support hardlinks (tested with: `ext3`)

## How to use

1. Set the source and destination environment variables. For example:

```
export BACKUP_SRC_DIR=/etc/
export BACKUP_DST_DIR=/mnt/my-external-storage/backup/etc/
```

2. [optional] adjust `rsync` exclude patterns if needed (`rsync-exclude.txt`)

3. Run the full backup at least once

```
rsync-backup-full.sh
```

4. Run the incremental backup whenever you want

```
rsync-backup-incremental.sh
```

## Restoring files

Navigate to your latest (or earlier) incremental backup directory
and just copy the files from there.

## Best practices

I run the full backup every couple of weeks. It helps limit the incremental
backup size.

## TODO

[ ] consider enabling -N (error: `rsync: This rsync does not support --crtimes (-N)`)
[ ] consider enabling -U
