# rsync-backup

rsync(1) based backup solution.

## Usage

1. Set the environment variables. For example:

```
. config-dell-home.sh
```

2. Run the full backup at least once

```
rsync-backup-full.sh
```

3. Run the incremental backup whenever you want

```
rsync-backup-incremental.sh
```
