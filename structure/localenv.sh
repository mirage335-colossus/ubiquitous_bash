#####Local Environment Management

_prepare() {
	
	mkdir -p "$safeTmp"
	
	mkdir -p "$shortTmp"
	
	mkdir -p "$logTmp"
}

_start() {
	
	_prepare
	
	
}

_stop() {
	
	_safeRMR "$safeTmp"
	_safeRMR "$shortTmp"
	
	_tryExec _killDaemon
	
	#Broken.
	if [[ "$1" != "" ]]
	then
		exit "$1"
	else
		exit 0
	fi
}

_preserveLog() {
	cp "$logTmp"/* ./  >/dev/null 2>&1
}

#Traps
trap 'excode=$?; _stop; trap - EXIT; echo $excode' EXIT HUP INT QUIT PIPE TERM		# reset
trap 'excode=$?; trap "" EXIT; _stop; echo $excode' EXIT HUP INT QUIT PIPE TERM		# ignore
