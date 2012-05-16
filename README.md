# My Nagios Checks

What we have here:

- `check_mem` checks memory usage with warning and critical levels in percentages. The check reports total memory used and memory used excluding buffers/cache. It uses `/proc/meminfo`.
- `check_io` doesn't check anything but reports kB/s read and written from `sar`.
- `check_if` als doesn't check anything, it reports kB/s received and sent for an interface from `sar`.
- `check_leaseweb_traffic` uses the Leaseweb API to calculate a projected end-of-month traffic quantity, and checks that for the given levels. It reports the projected quantity, the traffic for the current month, and the daily traffic averaged over the last seven days. This is obviously only useful if you have hosts at Leaseweb.

