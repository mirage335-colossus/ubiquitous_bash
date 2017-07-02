_waitForDaemon() {
	ps -e | grep "$daemonPID" >/dev/null 2>&1 && sleep 0.1
	ps -e | grep "$daemonPID" >/dev/null 2>&1 && sleep 0.3
	ps -e | grep "$daemonPID" >/dev/null 2>&1 && sleep 1
	ps -e | grep "$daemonPID" >/dev/null 2>&1 && sleep 2
}

_killDaemon() {
	ps -e | grep "$daemonPID" >/dev/null 2>&1 && kill -TERM "$daemonPID" >/dev/null 2>&1
	
	_waitForDaemon
	
	ps -e | grep "$daemonPID" >/dev/null 2>&1 && kill -KILL "$daemonPID" >/dev/null 2>&1
	
	_waitForDaemon
	
	rm "$pidFile" >/dev/null 2>&1
}

_execDaemon() {
	"$scriptAbsoluteLocation" &
	echo "$!" > "$pidFile"
}
