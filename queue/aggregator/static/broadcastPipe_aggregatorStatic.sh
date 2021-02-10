
# ATTENTION: Override with 'ops' or similar.
_rm_broadcastPipe_aggregatorStatic() {
	! _safePath_demand_broadcastPipe_aggregatorStatic "$1" && return 1
	! _safePath_demand_broadcastPipe_aggregatorStatic "$2" && return 1
	
	#[[ -e "$1" ]] && [[ "$1" != "" ]] && rm -f "$1"/* > /dev/null 2>&1
	[[ -e "$1" ]] && [[ "$1" != "" ]] && find "$1" -mindepth 1 -maxdepth 1 \( -type f -o -type p -o -type l \) ! -name 'terminate' ! -name 'reset' -delete > /dev/null 2>&1
	[[ -e "$2" ]] && [[ "$2" != "" ]] && rm -f "$2"/* > /dev/null 2>&1
	
	
	return 0
}

# ATTENTION: Override with 'ops' or similar.
_rm_broadcastPipe_aggregatorStatic_keepListen() {
	! _safePath_demand_broadcastPipe_aggregatorStatic "$1" && return 1
	! _safePath_demand_broadcastPipe_aggregatorStatic "$2" && return 1
	
	#[[ -e "$1" ]] && [[ "$1" != "" ]] && rm -f "$1"/* > /dev/null 2>&1
	[[ -e "$1" ]] && [[ "$1" != "" ]] && find "$1" -mindepth 1 -maxdepth 1 \( -type f -o -type p -o -type l \) ! -name 'terminate' ! -name 'listen' -delete > /dev/null 2>&1
	[[ -e "$2" ]] && [[ "$2" != "" ]] && rm -f "$2"/* > /dev/null 2>&1
	
	
	return 0
}



_jobs_terminate_aggregatorStatic_procedure() {
	currentStopJobs=$(jobs -p -r 2> /dev/null)
	# WARNING: Although usually bad practice, it is useful for the spaces between PIDs to be interpreted in this case.
	# DANGER: Apparently, it is possible for some not running background jobs to be included in the PID list.
	[[ "$currentStopJobs" != "" ]] && kill $currentStopJobs > /dev/null 2>&1
	kill "$1" > /dev/null 2>&1
	
	currentIterations='0'
	while [[ $(jobs -p -r) != "" ]] && [[ "$currentIterations" -lt '3' ]]
	do
		sleep 0.6
		let currentIterations="$currentIterations"+1
	done
	currentStopJobs=$(jobs -p -r 2> /dev/null)
	kill -KILL $currentStopJobs > /dev/null 2>&1
	kill -KILL "$1" > /dev/null 2>&1
	
	currentIterations='0'
	while [[ $(jobs -p -r) != "" ]] && [[ "$currentIterations" -lt '16' ]]
	do
		sleep 1
		let currentIterations="$currentIterations"+1
	done
}



_broadcastPipe_aggregatorStatic_read_procedure() {
	_messageNormal 'init: _broadcastPipe_aggregatorStatic_read_procedure'
	[[ "$1" == "" ]] && _stop 1
	[[ "$1" == "/" ]] && _stop 1
	[[ "$2" == "/" ]] && _stop 1
	
	local current_demand_dir
	current_demand_dir=$(_demand_dir_broadcastPipe_aggregatorStatic "$1")
	
	# May perhaps take effect when SIGTERM is received directly (eg. when SIGTERM may be sent to all processes) .
	export current_broadcastPipe_inputBufferDir="$1"
	export current_broadcastPipe_outputBufferDir="$2"
	export current_broadcastPipe_current_demand_dir="$current_demand_dir"
	_stop_queue_aggregatorStatic() {
		#_terminate_broadcastPipe_aggregatorStatic "$current_broadcastPipe_inputBufferDir" 2> /dev/null
		_terminate_broadcastPipe_fast "$current_broadcastPipe_inputBufferDir" 2> /dev/null
		sleep 1
		_rm_broadcastPipe_aggregatorStatic "$current_broadcastPipe_inputBufferDir" "$current_broadcastPipe_outputBufferDir"
		[[ "$current_broadcastPipe_inputBufferDir" == "$current_broadcastPipe_current_demand_dir"* ]] && [[ "$current_broadcastPipe_current_demand_dir" != "" ]] && _rm_dir_broadcastPipe_aggregatorStatic
		
		_sleep_spinlock
		rm -f "$current_broadcastPipe_inputBufferDir"/reset > /dev/null 2>&1
		rm -f "$current_broadcastPipe_inputBufferDir"/terminate > /dev/null 2>&1
		[[ "$current_broadcastPipe_inputBufferDir" == "$current_broadcastPipe_current_demand_dir"* ]] && [[ "$current_broadcastPipe_current_demand_dir" != "" ]] && _rm_dir_broadcastPipe_aggregatorStatic
	}
	
	
	local currentIterations
	
	
	
	_rm_broadcastPipe_aggregatorStatic "$@"
	rm -f "$1"/reset > /dev/null 2>&1
	rm -f "$1"/terminate > /dev/null 2>&1
	
	echo > "$1"/listen
	
	local currentInputBufferCount='0'
	local currentInputBufferCount_prev='0'
	local currentOutputBufferCount='0'
	local currentOutputBufferCount_prev='0'
	
	local currentFile
	
	
	local currentStopJobs
	
	local currentIsEmptyOut
	
	local currentPID
	
	local noJobsTwice
	
	_messagePlain_nominal ' 0 : reached loop'
	_messagePlain_probe "$1"
	_messagePlain_probe "$2"
	while [[ ! -e "$1"/terminate ]] && [[ -d "$1" ]]
	do
		_messagePlain_nominal ' 1 : loop'
		
		#rm -f "$1"/skip > /dev/null 2>&1
		
		currentInputBufferCount_prev="$currentInputBufferCount"
		currentOutputBufferCount_prev="$currentOutputBufferCount"
		#[[ $(jobs -p -r) != "" ]] && 
		while [[ "$currentInputBufferCount" == "$currentInputBufferCount_prev" ]] && [[ "$currentOutputBufferCount" == "$currentOutputBufferCount_prev" ]] && [[ ! -e "$1"/terminate ]] && [[ -d "$1" ]]
		do
			_messagePlain_nominal ' 2 : wait for change'
			
			currentInputBufferCount=0
			for currentFile in "$1"/??????????????????
			do
				_messagePlain_nominal '11 : count: currentInputBufferCount= '"$currentInputBufferCount"
				[[ "$currentFile" != *'??????????????????' ]] && let currentInputBufferCount="$currentInputBufferCount"+1
			done
			
			currentOutputBufferCount=0
			for currentFile in "$2"/??????????????????
			do
				_messagePlain_nominal '11 : count: currentOutputBufferCount= '"$currentOutputBufferCount"
				[[ "$currentFile" != *'??????????????????' ]] && let currentOutputBufferCount="$currentOutputBufferCount"+1
			done
			
			_messagePlain_probe_var currentInputBufferCount_prev
			_messagePlain_probe_var currentOutputBufferCount_prev
			_messagePlain_probe_var currentInputBufferCount
			_messagePlain_probe_var currentOutputBufferCount
			
			if ( [[ "$currentInputBufferCount" -gt 0 ]] || [[ "$currentOutputBufferCount" -gt 0 ]] ) && [[ $(jobs -p -r) == "" ]] && [[ "$currentInputBufferCount" == "$currentInputBufferCount_prev" ]] && [[ "$currentOutputBufferCount" == "$currentOutputBufferCount_prev" ]] && [[ "$noJobsTwice" == 'true' ]]
			then
				_messagePlain_warn 'obscure: 2.1: change: no jobs 2x: remove: unused pipe files'
				_rm_broadcastPipe_aggregatorStatic_keepListen "$@"
				#rm -f "$1"/skip > /dev/null 2>&1
				noJobsTwice='false'
			elif ( [[ "$currentInputBufferCount" -gt 0 ]] || [[ "$currentOutputBufferCount" -gt 0 ]] ) && [[ $(jobs -p -r) == "" ]] && [[ "$currentInputBufferCount" == "$currentInputBufferCount_prev" ]] && [[ "$currentOutputBufferCount" == "$currentOutputBufferCount_prev" ]] && [[ "$noJobsTwice" != 'true' ]]
			then
				_messagePlain_warn 'obscure: 2.1: change: no jobs 1x: set: noJobsTwice'
				noJobsTwice='true'
			fi
			
			
			# DANGER: Delay time > ~24seconds may result in unused/blocking FIFO pipes remaining (additional delay in remainder of loop is tolerable).
			# Iterations >1 may reduce CPU consumption with Cygwin/MSW , assuming file exists check is reasonably efficient.
			currentIterations='0'
			while [[ "$currentIterations" -lt '3' ]] && [[ "$currentInputBufferCount" == "$currentInputBufferCount_prev" ]] && [[ "$currentOutputBufferCount" == "$currentOutputBufferCount_prev" ]] && [[ ! -e "$1"/terminate ]] && [[ -d "$1" ]]
			do
				# If pipes are already connected, maybe delay a while longer to reduce CPU consumption.
				if [[ $(jobs -p -r) != "" ]]
				then
					_messagePlain_nominal '12 : idle: jobs: long delay'
					sleep 6
				fi
				
				# If pipes are not already connected, maybe delay a less, to improve interactivity.
				if [[ $(jobs -p -r) == "" ]]
				then
					_messagePlain_nominal '12 : idle: no jobs: short delay'
					sleep 3
				fi
				
				let currentIterations="$currentIterations"+1
			done
		done
		#_messagePlain_warn 'obscure:  3 : done: loop: detected: new pipe files: complicated procedure: suspected failability'
		_messagePlain_good ' 3 : done: loop: detected: new pipe files'
		
		
		# ATTENTION: delay: InterProcess-Communication
		# CAUTION: Before reducing the delay (24 seconds recommended), consider that remote/peripherial may have latencies independent of any OS 'kernel', 'real-time' or otherwise!
		echo -e '\E[1;33;47m ''13 : delay: InterProcess-Communication: 24 seconds'' \E[0m'
		currentIterations='0'
		while [[ "$currentIterations" -le 4 ]] && [[ ! -e "$1"/skip ]] && [[ ! -e "$1"/terminate ]] && [[ -d "$1" ]] && [[ "$currentOutputBufferCount" -gt 0 ]]
		#( [[ "$currentInputBufferCount" -gt 0 ]] || [[ "$currentOutputBufferCount" -gt 0 ]] )
		do
			#_messageDELAYipc
			_messagePlain_probe '13 : delay: InterProcess-Communication: 6 second iteration'
			#_messagePlain_probe '13 : delay: InterProcess-Communication: 6 second iteration: 24 seconds'
			#_messagePlain_nominal '13 : delay: InterProcess-Communication: 6 second iteration: 24 seconds'
			#echo -e '\E[1;33;47m ''13 : delay: InterProcess-Communication: 6 second iteration: 24 seconds'' \E[0m'
			sleep 6
			let currentIterations="$currentIterations"+1
		done
		rm "$1"/skip > /dev/null 2>&1 && _messagePlain_good 'good: skip'
		rm -f "$1"/skip > /dev/null 2>&1
		
		currentInputBufferCount=0
		for currentFile in "$1"/??????????????????
		do
			_messagePlain_nominal '14 : count: currentInputBufferCount= '"$currentInputBufferCount"
			[[ "$currentFile" != *'??????????????????' ]] && let currentInputBufferCount="$currentInputBufferCount"+1
		done
		
		currentOutputBufferCount=0
		for currentFile in "$2"/??????????????????
		do
			_messagePlain_nominal '15 : count: currentOutputBufferCount= '"$currentOutputBufferCount"
			[[ "$currentFile" != *'??????????????????' ]] && let currentOutputBufferCount="$currentOutputBufferCount"+1
		done
		
		
		# https://stackoverflow.com/questions/25906020/are-pid-files-still-flawed-when-doing-it-right/25933330
		# https://stackoverflow.com/questions/360201/how-do-i-kill-background-processes-jobs-when-my-shell-script-exits
		
		_messagePlain_nominal ' 4 : _jobs_terminate_aggregatorStatic_procedure'
		_jobs_terminate_aggregatorStatic_procedure "$currentPID"
		
		_messagePlain_nominal ' 5 : detect: currentIsEmptyOut'
		#currentIsEmptyOut='false'
		# Although this may seem inefficient, the alternatives of calling external programs, filling variables, or setting 'shopt', may also be undesirable.
		# https://www.cyberciti.biz/faq/linux-unix-shell-check-if-directory-empty/
		currentIsEmptyOut='true'
		for currentFile in "$2"/??????????????????
		do
			if [[ "$currentFile" != *'??????????????????' ]]
			then
				_messagePlain_good '16 : detected: output pipe file'
				currentIsEmptyOut='false'
				break
			fi
		done
		_messagePlain_nominal ' 6 : decision'
		_messagePlain_probe_var currentInputBufferCount
		_messagePlain_probe_var currentOutputBufferCount
		[[ ! -e "$1"/terminate ]] && _messagePlain_probe ' 7.1: flag: missing: terminate'
		[[ -d "$1" ]] && _messagePlain_probe ' 7.2: detect: present: input directory'
		[[ "$currentIsEmptyOut" == 'false' ]] && _messagePlain_good ' 7.3: flag: detect: output pipe files'
		if [[ ! -e "$1"/terminate ]] && [[ -d "$1" ]] && [[ "$currentIsEmptyOut" == 'false' ]] && [[ "$currentInputBufferCount" -gt 0 ]] && [[ "$currentOutputBufferCount" -gt 0 ]]
		then
			_messagePlain_nominal ' 7 : ##### connect pipes #####'
			#https://unix.stackexchange.com/questions/139490/continuous-reading-from-named-pipe-cat-or-tail-f
			#https://stackoverflow.com/questions/11185771/bash-script-to-iterate-files-in-directory-and-pattern-match-filenames
			(
			for currentFile in "$1"/??????????????????
			do
				[[ "$currentFile" != *'??????????????????' ]] && cat "$currentFile" 2>/dev/null &
			done
			) | tee "$2"/?????????????????? > /dev/null 2>&1 &
			currentPID="$!"
			
			#rm -f "$1"/skip > /dev/null 2>&1
		fi
		
		_messagePlain_nominal ' 8 : repeat'
		
		# WARNING: Some processes within the subshell (ie. 'sleep' ) may allow the subshell to terminate rather than maintain a 'jobs' PID.
		_messagePlain_probe 'jobs: '$(jobs -p -r)
	done
	
	_messagePlain_nominal ' 9 : ##### terminate or reset #####'
	
	_jobs_terminate_aggregatorStatic_procedure "$currentPID"
	
	# WARNING: Since only one program may successfully remove a single file, that mechanism should allow only one 'broadcastPipe' process to remain in the unlikely case multiple were somehow started.
	[[ -e "$1"/terminate ]] && [[ -e "$1"/reset ]] && rm "$1"/reset > /dev/null 2>&1 && _broadcastPipe_aggregatorStatic_read_procedure "$@"
	rm -f "$1"/reset > /dev/null 2>&1
	
	_rm_broadcastPipe_aggregatorStatic "$@"
	rm -f "$1"/reset > /dev/null 2>&1
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







