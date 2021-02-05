# "$1" == inputBufferDir
# "$2" == inputFilesPrefix
# "$3" == maxTime (approximately how many milliseconds buffer should be checked for new data)
# "$4" == maxBytes (IGNORED)
# "$ub_force_limit_page_rate"
#	'' == Write new pages as fast as buffers fill up. Readers may miss some pages. (Default. Strongly recommended.)
#	'true' == Write only one page per "$maxTime" interval. WARNING: Writes may backlog indefinitely, breaking real-time messaging. (IGNORED by '_page_read')
#	'false' == Write and read new pages continiously. WARNING: Read processes will consume 100% CPU. Readers may still miss some pages, although reads may happen faster than writes.
_page_read() {
	local inputBufferDir="$1"
	local inputFilesPrefix="$2"
	if [[ "$inputBufferDir" == "" ]] || [[ "$inputBufferDir" == "" ]]
	then
		local current_demand_dir
		current_demand_dir=$(_demand_dir_broadcastPipe_page "$1")
		[[ "$current_demand_dir" == "" ]] && _stop 1
		
		inputBufferDir="$current_demand_dir"/outputBufferDir
		! mkdir -p "$inputBufferDir" && return 1
		
		[[ "$inputFilesPrefix" == "" ]] && inputFilesPrefix='out-'
	fi
	
	
	! mkdir -p "$inputBufferDir" && return 1
	! [[ -e "$inputBufferDir" ]] && return 1
	! [[ -d "$inputBufferDir" ]] && return 1
	
	local currentMaxTime
	currentMaxTime="$3"
	# 6/60Hz == 100ms , loop time ~ 35ms
	# 0.1s desired minimum sleep
	#[[ "$currentMaxTime" == "" ]] && currentMaxTime=175
	[[ "$currentMaxTime" == "" ]] && currentMaxTime=$(_default_page_read_maxTime)
	
	local currentMaxTime_seconds
	currentMaxTime_seconds=$(bc <<< "$currentMaxTime * 0.001")
	
	
	local measureTickA
	local measureTickB
	
	while true
	do
		[[ "$ub_force_limit_page_rate" != 'false' ]] && sleep "$currentMaxTime_seconds"
		
		[[ -e "$inputBufferDir"/"$inputFilesPrefix"tick ]] && measureTickA=$(head -n 1 "$inputBufferDir"/"$inputFilesPrefix"tick 2>/dev/null)
		[[ "$measureTickA" != '0' ]] && [[ "$measureTickA" != '1' ]] && [[ "$measureTickA" != '2' ]] && continue
		
		[[ "$measureTickB" == '' ]] && measureTickB='doNotMatch'
		[[ "$measureTickA" == "$measureTickB" ]] && continue
		
		cat "$inputBufferDir"/"$inputFilesPrefix""$measureTickA" 2>/dev/null
		
		measureTickB="$measureTickA"
	done
}


