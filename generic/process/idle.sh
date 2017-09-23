#####Idle

_idle() {
	_start
	
	_checkDep getIdle
	
	_killDaemon
	
	while true
	do
		sleep 5
		
		idleTime=$("$scriptBin"/getIdle)
		
		if [[ "$idleTime" -lt "3300000" ]] && _daemonStatus
		then
			true
			_killDaemon	#Comment out if unnecessary.
		fi
		
		
		if [[ "$idleTime" -gt "3600000" ]] && ! _daemonStatus
		then
			_execDaemon
		fi
		
		
		
	done
	
	_stop
}

_testIdle() {
	
	_checkDep getIdle
	
	idleTime=$("$scriptBin"/getIdle)
	
	if ! echo "$idleTime" | grep '^[0-9]*$' >/dev/null 2>&1
	then
		echo getIdle invalid response
		_stop 1
	fi
	
}

_buildIdle() {
	
	idleSourceCode=$(find "$scriptAbsoluteFolder" -type f -name "getIdle.c" | head -n 1)
	
	mkdir -p "$scriptBin"
	gcc -o "$scriptBin"/getIdle "$idleSourceCode" -lXss -lX11
	
}
