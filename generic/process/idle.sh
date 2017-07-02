#####Idle

_idle() {
	_start
	
	_checkDep getIdle
	
	_killDaemon
	
	while true
	do
		sleep 5
		
		if [[ -e "$pidFile" ]]
		then
			daemonPID=$(cat "$pidFile")
		fi
		
		idleTime=$("$scriptBin"/getIdle)
		
		if [[ "$idleTime" -lt "3300000" ]] && ps -e | grep "$daemonPID" >/dev/null 2>&1
		then
			_killDaemon
		fi
		
		
		if [[ "$idleTime" -gt "3600000" ]] && ! ps -e | grep "$daemonPID" >/dev/null 2>&1
		then
			_execDaemon
		fi
		
		
		
	done
	
	_stop
}

_idleTest() {
	
	true
	
}

_idleBuild() {
	
	idleSourceCode=$(find "$scriptAbsoluteFolder" -type f -name "getIdle.c" | head -n 1)
	
	mkdir -p "$scriptBin"
	gcc -o "$scriptBin"/getIdle "$idleSourceCode" -lXss -lX11
	
}
