#####Idle

_idle() {
	_start
	
	_checkDep getIdle
	
	_daemonStatus && _stop 1
	
	#Default 20 minutes.
	[[ "$idleMax" == "" ]] && export idleMax=1200000
	[[ "$idleMin" == "" ]] && export idleMin=60000
	
	while true
	do
		sleep 5
		
		idleTime=$("$scriptBin"/getIdle)
		
		if [[ "$idleTime" -lt "$idleMin" ]] && _daemonStatus
		then
			true
			_killDaemon	#Comment out if unnecessary.
		fi
		
		
		if [[ "$idleTime" -gt "$idleMax" ]] && ! _daemonStatus
		then
			_execDaemon
		fi
		
		
		
	done
	
	_stop
}

_test_buildIdle() {
	_getDep "X11/extensions/scrnsaver.h"
}

_testBuiltIdle() {
	
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
