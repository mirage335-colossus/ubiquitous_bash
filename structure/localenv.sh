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

#Wrapper. If lock file is present, waits for unlocking operation to complete successfully, then reports status.
#"$1" == checkFile
#"$@" == wait command and parameters
_waitFileCommands() {
	if [[ -e "$1" ]]
	then
		local waitFileCommandStatus
		
		"$@"
		
		waitFileCommandStatus="$?"
		
		if [[ "$waitFileCommandStatus" != "0" ]]
		then
			return "$waitFileCommandStatus"
		fi
		
		[[ -e "$1" ]] && return 1
		
	fi
	
	return 0
}

#Wrapper. Operates lock file for mounting shared resources (eg. persistent virtual machine image). Avoid if possible.
#"$1" == waitOpen function && shift
#"$@" == wrapped function and parameters
_open() {
	[[ -e "$scriptLocal"/_open ]] && return 0
	
	[[ -e "$scriptLocal"/_closing ]] && return 1
	
	if [[ -e "$scriptLocal"/_opening ]]
	then
		if _waitFileCommands "$scriptLocal"/_opening "$1"
		then
			[[ -e "$scriptLocal"/_open ]] || return 1
			return 0
		else
			return 1
		fi
	fi
	echo > "$scriptLocal"/_opening
	shift
	
	echo "LOCKED" > "$scriptLocal"/WARNING
	
	"$@"
	
	
	if [[ "$?" == "0" ]]
	then
		echo > "$scriptLocal"/_open
		rm "$scriptLocal"/_opening
		return 0
	fi
	
	return 1
}

#Wrapper. Operates lock file for shared resources (eg. persistent virtual machine image). Avoid if possible.
#"$1" == <"--force"> && shift
#"$1" == waitClose function && shift
#"$@" == wrapped function and parameters
_close() {
	if [[ "$1" == "--force" ]]
	then
		shift
	elif ! [[ -e "$scriptLocal"/_open ]]
	then
		return 0
	fi
	
	if [[ -e "$scriptLocal"/_closing ]]
	then
		if _waitFileCommands "$scriptLocal"/_closing "$1"
		then
			return 0
		else
			return 1
		fi
	fi
	echo > "$scriptLocal"/_closing
	shift
	
	"$@"
	
	if [[ "$?" == "0" ]]
	then
		rm "$scriptLocal"/_open
		rm "$scriptLocal"/_closing
		rm "$scriptLocal"/WARNING
		return 0
	fi
	
	return 1
	
	
}
