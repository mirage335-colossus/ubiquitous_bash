
# ATTENTION: Override with 'ops' or similar.
_rm_broadcastPipe_aggregatorStatic() {
	
	#[[ -e "$1" ]] && [[ "$1" != "" ]] && rm -f "$1"/* > /dev/null 2>&1
	[[ -e "$1" ]] && [[ "$1" != "" ]] && find "$1" -mindepth 1 -maxdepth 1 -type f ! -name 'terminate' -delete > /dev/null 2>&1
	[[ -e "$2" ]] && [[ "$2" != "" ]] && rm -f "$2"/* > /dev/null 2>&1
	
	[[ -e "$1" ]] && [[ "$1" != "" ]] && rm -f "$1"/*-tick-prev* > /dev/null 2>&1
	
	
	return 0
}



_jobs_terminate_aggregatorStatic_procedure() {
	currentStopJobs=$(jobs -p -r 2> /dev/null)
	# WARNING: Although usually bad practice, it is useful for the spaces between PIDs to be interpreted in this case.
	# DANGER: Apparently, it is possible for some not running background jobs to be included in the PID list.
	[[ "$currentStopJobs" != "" ]] && kill $currentStopJobs > /dev/null 2>&1
	
	currentIterations='0'
	while [[ $(jobs -p -r) != "" ]] && [[ "$currentIterations" -lt '3' ]]
	do
		sleep 0.6
		let currentIterations="$currentIterations"+1
	done
	currentStopJobs=$(jobs -p -r 2> /dev/null)
	kill -KILL $currentStopJobs > /dev/null 2>&1
	
	currentIterations='0'
	while [[ $(jobs -p -r) != "" ]] && [[ "$currentIterations" -lt '16' ]]
	do
		sleep 1
		let currentIterations="$currentIterations"+1
	done
}



_broadcastPipe_aggregatorStatic_read_procedure() {
	[[ "$1" == "" ]] && _stop 1
	[[ "$1" == "/" ]] && _stop 1
	[[ "$2" == "/" ]] && _stop 1
	
	local current_demand_dir
	current_demand_dir=$(_demand_dir_broadcastPipe_aggregatorStatic "$1")
	
	# May perhaps take effect when SIGTERM is received directly (eg. when SIGTERM may be sent to all processes) .
	export current_broadcastPipe_inputBufferDir="$1"
	export current_broadcastPipe_outputBufferDir="$2"
	_stop_queue_aggregatorStatic() {
		#_terminate_broadcastPipe_aggregatorStatic "$current_broadcastPipe_inputBufferDir" 2> /dev/null
		_terminate_broadcastPipe_fast "$current_broadcastPipe_inputBufferDir" 2> /dev/null
		sleep 1
		_rm_broadcastPipe_aggregatorStatic "$current_broadcastPipe_inputBufferDir" "$current_broadcastPipe_outputBufferDir"
		[[ "$1" == "$current_demand_dir"* ]] && [[ "$current_demand_dir" != "" ]] && _rm_dir_broadcastPipe_aggregatorStatic
		
		_sleep_spinlock
		rm -f "$1"/terminate > /dev/null 2>&1
		[[ "$1" == "$current_demand_dir"* ]] && [[ "$current_demand_dir" != "" ]] && _rm_dir_broadcastPipe_aggregatorStatic
	}
	
	
	local currentIterations
	
	
	
	rm -f "$1"/reset > /dev/null 2>&1
	rm -f "$1"/terminate > /dev/null 2>&1
	_rm_broadcastPipe_aggregatorStatic "$@"
	
	echo > "$1"/listen
	
	local currentInputBufferCount='0'
	local currentInputBufferCount_prev='0'
	local currentOutputBufferCount='0'
	local currentOutputBufferCount_prev='0'
	
	local currentFile
	
	
	local currentStopJobs
	
	
	while [[ ! -e "$1"/terminate ]] && [[ -d "$1" ]]
	do
		
		currentInputBufferCount_prev="$currentInputBufferCount"
		currentOutputBufferCount_prev="$currentOutputBufferCount"
		while [[ $(jobs -p -r) != "" ]] && [[ "$currentInputBufferCount" == "$currentInputBufferCount_prev" ]] && [[ "$currentOutputBufferCount" == "$currentOutputBufferCount_prev" ]] && [[ ! -e "$1"/terminate ]] && [[ -d "$1" ]]
		do
			
			currentInputBufferCount=0
			for currentFile in "$inputBufferDir"/??????????????????
			do
				[[ "$currentFile" != *'??????????????????' ]] && let currentInputBufferCount="$currentInputBufferCount"+1
			done
			
			currentOutputBufferCount=0
			for currentFile in "$outputBufferDir"/??????????????????
			do
				[[ "$currentFile" != *'??????????????????' ]] && let currentOutputBufferCount="$currentInputBufferCount"+1
			done
			
			# Iterations >1 may reduce CPU consumption with Cygwin/MSW , assuming file exists check is reasonably efficient.
			currentIterations='0'
			while [[ $(jobs -p -r) != "" ]] && [[ "$currentIterations" -lt '3' ]] && [[ "$currentInputBufferCount" == "$currentInputBufferCount_prev" ]] && [[ "$currentOutputBufferCount" == "$currentOutputBufferCount_prev" ]] && [[ ! -e "$1"/terminate ]] && [[ -d "$1" ]]
			do
				sleep 6
				let currentIterations="$currentIterations"+1
			done
		done
		
		
		# TODO: Testing.
		# TODO: All related pipe read/write functions should always call '_reset' , due to possibility of SIGPIPE being ignored.
		# TODO: Only continue sleeping while relevant ' "$1"/skip ' file does not exist.
		rm -f "$1"/skip > /dev/null 2>&1
		currentIterations='0'
		while [[ ! -e "$1"/skip ]] && [[ "$currentIterations" -le 24 ]]
		do
			sleep 1
			let currentIterations="$currentIterations"+1
		done
		#rm -f "$1"/skip > /dev/null 2>&1
		
		
		# https://stackoverflow.com/questions/25906020/are-pid-files-still-flawed-when-doing-it-right/25933330
		# https://stackoverflow.com/questions/360201/how-do-i-kill-background-processes-jobs-when-my-shell-script-exits
		
		
		_jobs_terminate_aggregatorStatic_procedure
		
		
		if [[ ! -e "$1"/terminate ]] && [[ -d "$1" ]]
		then
			
			#https://unix.stackexchange.com/questions/139490/continuous-reading-from-named-pipe-cat-or-tail-f
			#https://stackoverflow.com/questions/11185771/bash-script-to-iterate-files-in-directory-and-pattern-match-filenames
			( for currentFile in "$inputBufferDir"/??????????????????
			do
				[[ "$currentFile" != *'??????????????????' ]] && cat "$currentFile" 2>/dev/null &
			done ) | tee "$outputBufferDir"/?????????????????? > /dev/null 2>&1 &
		fi
		
	done
	
	_jobs_terminate_aggregatorStatic_procedure
	
	# WARNING: Since only one program may successfully remove a single file, that mechanism should allow only one 'broadcastPipe' process to remain in the unlikely case multiple were somehow started.
	[[ -e "$1"/terminate ]] && [[ -e "$1"/reset ]] && rm -f "$1"/reset > /dev/null 2>&1 && _broadcastPipe_aggregatorStatic_read_procedure "$@"
	
	
	_rm_broadcastPipe_aggregatorStatic "$@"
	rm -f "$1"/terminate > /dev/null 2>&1
	[[ "$1" == "$current_demand_dir"* ]] && [[ "$current_demand_dir" != "" ]] && _rm_dir_broadcastPipe_aggregatorStatic
	
	_sleep_spinlock
	rm -f "$1"/terminate > /dev/null 2>&1
	[[ "$1" == "$current_demand_dir"* ]] && [[ "$current_demand_dir" != "" ]] && _rm_dir_broadcastPipe_aggregatorStatic
	
	return 0
}



# WARNING: Any unconnected pipe will block all pipes.
# WARNING: Any disconnection or new pipe will cause 'reset' of all pipes.
# "$1" == inputBufferDir
# "$2" == outputBufferDir
_broadcastPipe_aggregatorStatic_read() {
	_start
	
	_broadcastPipe_aggregatorStatic_read_procedure "$@"
	
	_stop
}







