# My Nagios Checks (for Linux)

What's here:

- `check_mem` checks memory usage with warning and critical levels in percentages. The check reports all the usual numbers and some lesser known values: reclaimable slab, this is memory used by the kernel that may be reclaimed under memory pressure, I got it get quite big when `rsync`ing 1+ million files, use `slabtop` to find out what's in your slab; and committed memory, this is the sum of all memory allocated by (promised to) processes, they may not use it all, but they might want to use it at some point. Plot the performance data with a lineformat like `rest,data=AREA;sReclaimable,data=AREA,STACK;buffers,data=AREA,STACK;cached,data=AREA,STACK`. The check uses `/proc/meminfo`.
- `check_mount` checks space used as a percentage of the usable space (total space excluding the reserved-for-root blocks). I prefer this to checking the inverse, which Nagios' `check_disk` does. This check also provides a more useful status report. The check uses `stat -f`.
- `check_io` doesn't check anything but returns bytes/iops read/written for a block device since the last invocation. `/sys/block/*/stat` is used as the source.
- `check_if` also doesn't check anything, it returns bytes received and sent for an interface since the last invocation. `/sys/class/net/*/statistics/*` is used as the source.
- `check_fpm` checks if a PHP-FPM pool is responsive. The number of idle and active processes and the queue (maximum) length are reported. It requires `xmlstarlet` and the `cgi-fcgi` binary (package fcgi on EPEL, libfcgi0ldbl on Debian).
- `check_redis` checks if Redis is alive and reports its statistics, some of them (hits, misses, etc.) averaged since the last invocation (to hits per second, misses per second, etc.).
- `check_apc` checks PHP APC available memory, hit ratio, expunges, etc. Make this script available and point the check to it: `<?php foreach(apc_sma_info(true) + apc_cache_info('', true) as $k => $v) { echo "$k=$v\n"; }`. Depends on `curl`.
- `check_ebs_snapshot` checks whether an Amazon EBS volume has a recent snapshot. Requires [Boto](http://docs.pythonboto.org/) and assumes AWS credentials are set through its configuration.
- `check_backup_s3` checks if a location on S3 contains a timestamped backup, and optionally its age and size. Same dependency on Boto.
- `check_rds_storage` checks the free storage for a given RDS instance. Same dependency on Boto.
- `check_urls` checks all given URLs. Reports URLs as down (network/http errors and empty responses), aberrant (response size is less than 25% of previous one), or up. Depends on `curl`.

All of the checks require `bash` and `bc`.
