
# "$1" == outputBufferDir
# "$2" == outputFilesPrefix (IGNORED)
_aggregator_write_procedure() {
	local outputBufferDir="$1"
	local outputFilesPrefix="$2"
	#if [[ "$outputBufferDir" == "" ]] || [[ "$outputFilesPrefix" == "" ]]
	if [[ "$outputBufferDir" == "" ]]
	then
		local current_demand_dir
		current_demand_dir=$(_demand_dir_broadcastPipe_aggregatorStatic "$1")
		[[ "$current_demand_dir" == "" ]] && _stop 1
		
		outputBufferDir="$current_demand_dir"/inputBufferDir
		! mkdir -p "$outputBufferDir" && return 1
		
		#[[ "$outputFilesPrefix" == "" ]] && outputFilesPrefix='stream-'
	fi
	
	# ATTENTION: IGNORE "$outputFilesPrefix" .
	outputFilesPrefix=''
	
	
	! mkdir -p "$outputBufferDir" && return 1
	! [[ -e "$outputBufferDir" ]] && return 1
	! [[ -d "$outputBufferDir" ]] && return 1
	
	
	
	
	local currentFifo
	currentFifo="$outputBufferDir"/"$outputFilesPrefix"$(_uid 18)
	_aggregator_fifo "$currentFifo"
	
	#if ! [[ -e "$safeTmp" ]]
	#then
		export current_aggregator_write_fifo="$currentFifo"
		_stop_queue_aggregator() {
			rm -f "$current_aggregator_write_fifo" > /dev/null 2>&1
		}
	#fi
	
	# WARNING: Removal of FIFO may not occur while not connected to both input and output. Apparently 'trap' does not work here.
	# WARNING: May be incompatible with '_timeout' .
	cat > "$currentFifo"
	
	rm -f "$currentFifo" > /dev/null 2>&1
	
	return 0
}



_aggregator_write_sequence() {
	_start
	
	_aggregator_write_procedure "$@"
	
	_stop
}


_aggregator_write() {
	"$scriptAbsoluteLocation" _aggregator_write_sequence "$@"
}



