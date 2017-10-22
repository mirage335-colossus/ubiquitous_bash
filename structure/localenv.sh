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
	
	rm "$pidFile" > /dev/null 2>&1	#Redundant, as this usually resides in "$safeTmp".
	_safeRMR "$safeTmp"
	_safeRMR "$shortTmp"
	
	#Daemon uses a separate instance, and will not be affected by previous actions.
	_tryExec _killDaemon
	
	#Optionally always try to remove any systemd shutdown hook.
	#_unhook_systemd_shutdown
	
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

_readLocked() {
	mkdir -p "$bootTmp"
	
	local rebootToken
	rebootToken=$(cat "$1" 2> /dev/null)
	
	#Remove miscellaneous files if appropriate.
	if [[ -d "$bootTmp" ]] && ! [[ -e "$bootTmp"/"$rebootToken" ]]
	then
		rm "$scriptLocal"/*.log && rm "$scriptLocal"/imagedev && rm "$scriptLocal"/WARNING
		
		[[ -e "$lock_quicktmp" ]] && sleep 0.1 && [[ -e "$lock_quicktmp" ]] && rm "$lock_quicktmp"
	fi
	
	! [[ -e "$1" ]] && return 1
	##Lock file exists.
	
	if [[ -d "$bootTmp" ]]
	then
		if ! [[ -e "$bootTmp"/"$rebootToken" ]]
		then
			##Lock file obsolete.
			
			#Remove old lock.
			rm "$1" > /dev/null 2>&1
			return 1
		fi
		
		##Lock file and token exists.
		return 0
	fi
	
	##Lock file exists, token cannot be found.
	return 0
	
	
	
}

_createLocked() {
	mkdir -p "$bootTmp"
	
	! [[ -e "$bootTmp"/"$sessionid" ]] && echo > "$bootTmp"/"$sessionid"
	
	echo "$sessionid" > "$lock_quicktmp"
	mv -n "$lock_quicktmp" "$1" > /dev/null 2>&1 || return 1
	
}

_resetLocks() {
	
	_readLocked "$lock_open"
	_readLocked "$lock_opening"
	_readLocked "$lock_closed"
	_readLocked "$lock_closing"
	_readLocked "$lock_instance"
	_readLocked "$lock_instancing"
	
}

#Wrapper. Operates lock file for mounting shared resources (eg. persistent virtual machine image). Avoid if possible.
#"$1" == waitOpen function && shift
#"$@" == wrapped function and parameters
_open() {
	_readLocked "$lock_open" && return 0
	
	_readLocked "$lock_closing" && return 1
	
	if _readLocked "$lock_opening"
	then
		if _waitFileCommands "$lock_opening" "$1"
		then
			_readLocked "$lock_open" || return 1
			return 0
		else
			return 1
		fi
	fi
	
	_createLocked "$lock_opening" || return 1
	
	shift
	
	echo "LOCKED" > "$scriptLocal"/WARNING
	
	"$@"
	
	if [[ "$?" == "0" ]]
	then
		_createLocked "$lock_open" || return 1
		rm "$lock_opening"
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
	
	if ! _readLocked "$lock_open" && [[ "$closeForceEnable" != "true" ]]
	then
		return 0
	fi
	
	if _readLocked "$lock_closing" && [[ "$closeForceEnable" != "true" ]]
	then
		if _waitFileCommands "$lock_closing" "$1"
		then
			return 0
		else
			return 1
		fi
	fi
	
	if [[ "$closeForceEnable" != "true" ]]
	then
		_createLocked "$lock_closing" || return 1
	fi
	! _readLocked "$lock_closing" && _createLocked "$lock_closing"
	
	shift
	
	"$@"
	
	if [[ "$?" == "0" ]]
	then
		rm "$lock_open" || return 1
		rm "$lock_closing"
		rm "$scriptLocal"/WARNING
		return 0
	fi
	
	return 1
	
	
}
