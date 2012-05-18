# Library constants and functions for use by the checks

# Nagios plugin exit codes
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

# Convert '2456' to '2.5 kB' and '133000' to '133 kB'
function bytes_to_human() {
	UNITS=(
		"PB $((1000 * 1000 * 1000 * 1000 * 1000))"
		"TB $((1000 * 1000 * 1000 * 1000))"
		"GB $((1000 * 1000 * 1000))"
		"MB $((1000 * 1000))"
		"kB $((1000))"
	)

	bytes_to_human_impl $@
}

# Convert '2456' to '2.4 kB' and '133000' to '130 kB'
function bytes_to_human_bi() {
	UNITS=(
		"PiB $((1024 * 1024 * 1024 * 1024 * 1024))"
		"TiB $((1024 * 1024 * 1024 * 1024))"
		"GiB $((1024 * 1024 * 1024))"
		"MiB $((1024 * 1024))"
		"KiB $((1024))"
	)

	bytes_to_human_impl $@
}

# Only call this after you've set the UNITS variable
# This function only supports Bash integers (64 bit unsigned on my system)
function bytes_to_human_impl() {
	for UNIT in "${UNITS[@]}"; do
		UNIT=($UNIT)
		SYMBOL=${UNIT[0]}
		NUM=${UNIT[1]}

		if [ $1 -ge $NUM ]; then
			bc -l <<< "
				result = $1 / $NUM
				result_ln = l(result);
				ten_ln = l(10);
				scale = 0;
				scale = 2 - result_ln / ten_ln;
				print result / 1, \" $SYMBOL\n\"" 2>/dev/null
			return
		fi
	done

	echo $1 B
}
