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
	_preserveLog
	
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

#Called upon SIGTERM or similar signal.
_stop_emergency() {
	[[ "$noEmergency" == true ]] && _stop "$1"
	
	export EMERGENCYSHUTDOWN=true
	
	_closeChRoot_emergency
	
	_stop "$1"
	
}

_waitFile() {
	
	[[ -e "$1" ]] && sleep 1
	[[ -e "$1" ]] && sleep 9
	[[ -e "$1" ]] && sleep 27
	[[ -e "$1" ]] && sleep 81
	[[ -e "$1" ]] && _return 1
	
	return 0
}

#Wrapper. If lock file is present, waits for unlocking operation to complete successfully, then reports status.
#"$1" == checkFile
#"$@" == wait command and parameters
_waitFileCommands() {
	local waitCheckFile
	waitCheckFile="$1"
	shift
	
	if [[ -e "$waitCheckFile" ]]
	then
		local waitFileCommandStatus
		
		"$@"
		
		waitFileCommandStatus="$?"
		
		if [[ "$waitFileCommandStatus" != "0" ]]
		then
			return "$waitFileCommandStatus"
		fi
		
		[[ -e "$waitCheckFile" ]] && return 1
		
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
	
	echo > "$scriptLocal"/quicktmp
	mv -n "$scriptLocal"/quicktmp "$scriptLocal"/_opening > /dev/null 2>&1 || return 1
	
	shift
	
	echo "LOCKED" > "$scriptLocal"/WARNING
	
	"$@"
	
	if [[ "$?" == "0" ]]
	then
		echo > "$scriptLocal"/_open || return 1
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
	local closeForceEnable
	closeForceEnable=false
	
	if [[ "$1" == "--force" ]]
	then
		closeForceEnable=true
		shift
	fi
	
	if ! [[ -e "$scriptLocal"/_open ]] && [[ "$closeForceEnable" != "true" ]]
	then
		return 0
	fi
	
	if [[ -e "$scriptLocal"/_closing ]] && [[ "$closeForceEnable" != "true" ]]
	then
		if _waitFileCommands "$scriptLocal"/_closing "$1"
		then
			return 0
		else
			return 1
		fi
	fi
	
	if [[ "$closeForceEnable" != "true" ]]
	then
		echo > "$scriptLocal"/quicktmp
		mv -n "$scriptLocal"/quicktmp "$scriptLocal"/_closing || return 1
	fi
	! [[ -e "$scriptLocal"/_closing ]] && echo > "$scriptLocal"/_closing
	
	shift
	
	"$@"
	
	if [[ "$?" == "0" ]]
	then
		rm "$scriptLocal"/_open || return 1
		rm "$scriptLocal"/_closing
		rm "$scriptLocal"/WARNING
		return 0
	fi
	
	return 1
	
	
}
