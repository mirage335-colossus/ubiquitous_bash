_waitForTermination() {
	ps -e | grep "$daemonPID" >/dev/null 2>&1 && sleep 0.1
	ps -e | grep "$daemonPID" >/dev/null 2>&1 && sleep 0.3
	ps -e | grep "$daemonPID" >/dev/null 2>&1 && sleep 1
	ps -e | grep "$daemonPID" >/dev/null 2>&1 && sleep 2
}
alias _waitForDaemon=_waitForTermination

#Kills background process using PID file.
_killDaemon() {
	ps -e | grep "$daemonPID" >/dev/null 2>&1 && kill -TERM "$daemonPID" >/dev/null 2>&1
	
	_waitForTermination
	
	ps -e | grep "$daemonPID" >/dev/null 2>&1 && kill -KILL "$daemonPID" >/dev/null 2>&1
	
	_waitForTermination
	
	rm "$pidFile" >/dev/null 2>&1
}

#Executes self in background (ie. as daemon).
_execDaemon() {
	"$scriptAbsoluteLocation" &
	echo "$!" > "$pidFile"
}
