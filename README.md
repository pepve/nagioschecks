# My Nagios Checks (for Linux)

What's here:

- `check_mem` checks memory usage with warning and critical levels in percentages. The check reports all the usual numbers and some lesser known values: reclaimable slab, this is memory used by the kernel that may be reclaimed under memory pressure, I got it get quite big when `rsync`ing 1+ million files, use `slabtop` to find out what's in your slab; and committed memory, this is the sum of all memory allocated by (promised to) processes, they may not use it all, but they might want to use it at some point. Plot the performance data with a lineformat like `rest,data=AREA;sReclaimable,data=AREA,STACK;buffers,data=AREA,STACK;cached,data=AREA,STACK`. The check uses `/proc/meminfo`.
- `check_mount` checks space used as a percentage of the usable space (total space excluding the reserved-for-root blocks). I prefer this to checking the inverse, which Nagios' `check_disk` does. This check also provides a more useful status report. The check uses `stat -f`.
- `check_io` doesn't check anything but returns bytes read and written for a block device since the last invocation. `/sys/block/*/stat` is used as the source.
- `check_if` also doesn't check anything, it returns bytes received and sent for an interface since the last invocation. `/sys/class/net/*/statistics/*` is used as the source.
- `check_fpm` checks if a PHP-FPM pool is responsive. The number of idle and active processes and the queue (maximum) length are reported. It requires `xmlstarlet` and the `cgi-fcgi` binary (package fcgi on EPEL, libfcgi0ldbl on Debian).
- `check_leaseweb_traffic` uses the Leaseweb API to calculate a projected end-of-month traffic quantity, and checks that for the given levels. It reports the projected quantity, the traffic for the current month, and the daily traffic averaged over the last seven days. This is obviously only useful if you have hosts at Leaseweb. The script requires `curl` and `xmlstarlet`.

All of the checks require `bash` and `bc`.
