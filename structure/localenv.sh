#####Local Environment Management (Instancing)

_start() {
	
	_prepare
	
	#touch "$varStore"
	#. "$varStore"
	
	
}

_saveVar() {
	true
	#declare -p varName > "$varStore"
}

_stop() {
	
	_safeRMR "$safeTmp"
	_safeRMR "$shortTmp"
	
	_tryExec _killDaemon
	
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
trap 'excode=$?; _stop $excode; trap - EXIT; echo $excode' EXIT HUP INT QUIT PIPE TERM		# reset
trap 'excode=$?; trap "" EXIT; _stop $excode; echo $excode' EXIT HUP INT QUIT PIPE TERM		# ignore
