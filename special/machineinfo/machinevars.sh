#Machine information.

if [[ -e "/proc/meminfo" ]]
then
	export hostMemoryTotal=$(cat /proc/meminfo | grep MemTotal | tr -cd '[[:digit:]]')
	export hostMemoryAvailable=$(cat /proc/meminfo | grep MemAvailable | tr -cd '[[:digit:]]')
	export hostMemoryQuantity="$hostMemoryTotal"
else
	export hostMemoryTotal="384000"
	export hostMemoryAvailable="256000"
	export hostMemoryQuantity="$hostMemoryTotal"
fi
