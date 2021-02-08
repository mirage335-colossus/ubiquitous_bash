
# TODO: Testing.
# TODO: All related pipe read/write functions should always call '_reset' , due to possibility of SIGPIPE being ignored.
# TODO: Only continue sleeping while relevant ' "$1"/skip ' file does not exist.

# "$1" == inputBufferDir
# "$2" == inputFilesPrefix (IGNORED)
_aggregator_read_procedure() {
	local inputBufferDir="$1"
	local inputFilesPrefix="$2"
	local service_inputBufferDir
	#if [[ "$inputBufferDir" == "" ]] || [[ "$inputBufferDir" == "" ]]
	if [[ "$inputBufferDir" == "" ]]
	then
		local current_demand_dir
		current_demand_dir=$(_demand_dir_broadcastPipe_aggregatorStatic "$1")
		[[ "$current_demand_dir" == "" ]] && _stop 1
		
		inputBufferDir="$current_demand_dir"/outputBufferDir
		! mkdir -p "$inputBufferDir" && return 1
		
		service_inputBufferDir="$current_demand_dir"/inputBufferDir
		
		#[[ "$inputFilesPrefix" == "" ]] && inputFilesPrefix='out-'
	fi
	
	# ATTENTION: IGNORE "$inputFilesPrefix" .
	inputFilesPrefix=''
	
	
	! mkdir -p "$inputBufferDir" && return 1
	! [[ -e "$inputBufferDir" ]] && return 1
	! [[ -d "$inputBufferDir" ]] && return 1
	
	
	
	
	local currentFifo
	currentFifo="$inputBufferDir"/"$inputFilesPrefix"$(_uid 18)
	_aggregator_fifo "$currentFifo"
	
	
	#if ! [[ -e "$safeTmp" ]]
	#then
		export current_aggregator_read_fifo="$currentFifo"
		_stop_queue_aggregator() {
			rm -f "$current_aggregator_read_fifo" > /dev/null 2>&1
		}
	#fi
	
	# WARNING: Removal of FIFO may not occur while not connected to both input and output. Apparently 'trap' does not work here.
	# WARNING: May be incompatible with '_timeout' .
	cat "$currentFifo"
	
	rm -f "$currentFifo" > /dev/null 2>&1
	
	return 0
}



_aggregator_read_sequence() {
	_start
	
	_aggregator_read_procedure "$@"
	
	_stop
}


_aggregator_read() {
	"$scriptAbsoluteLocation" _aggregator_read_sequence "$@"
}


