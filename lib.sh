# Library constants and functions for use by the checks

# Nagios plugin exit codes
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

# Convert '2456' to '2.45 kB' and '134000' to '133 kB'
function bytes_to_human() {
	bytes_to_human_impl "B kB MB GB TB PB" 1000 $@
}

# Convert '2456' to '2.39 KiB' and '134000' to '130 KiB'
function bytes_to_human_bi() {
	bytes_to_human_impl "B KiB MiB GiB TiB PiB" 1024 $@
}

function bytes_to_human_impl() {
	UNITS=($1)
	BASE=$2
	BYTES=$3

	# This script works for pretty large non-negative integers (tested up to 100
	# digits), and it truncates to at least three significant digits.
	# 'Normal' rounding would need to take into account that 1048064 should be
	# displayed as 1.00 MiB, which it won't if you calculate the unit before the
	# rounding takes place (it will display 1024 KiB). Somehow the calculation
	# of the unit would have to incorporate the rounding, and I can't come up
	# with the math to do that.
	BC=($(bc -l <<< "
		/* Special-case everything less than the first unit */
		if ($BYTES < $BASE) {
			$BYTES
			0
			halt
		}

		/* First compute and round the unit to use */
		scale = length($BYTES) + 2
		unit = l($BYTES) / l($BASE)
		scale = 0
		unit /= 1

		/* We do not have all units available */
		if (unit >= ${#UNITS[@]}) {
			unit = ${#UNITS[@]} - 1
		}

		/* Compute the result for the unit */
		scale = 3
		result = $BYTES / $BASE ^ unit

		/* Set the number of digits to show after the decimal point */
		if (length(result) > 6) {
			scale = 0
		} else {
			scale = 6 - length(result)
		}

		/* Print the rounded result and its unit */
		result / 1
		unit
		"))

	echo ${BC[0]} ${UNITS[${BC[1]}]}
}
