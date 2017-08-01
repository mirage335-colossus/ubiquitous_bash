#Waits for the process PID specified by first parameter to end. Useful in conjunction with $! to provide process control and/or PID files.
_pauseForProcess() {
	while ps --no-headers -p $1 &> /dev/null
	do
		sleep 0.1
	done
}
alias _waitForProcess=_pauseForProcess
alias waitForProcess=_pauseForProcess
