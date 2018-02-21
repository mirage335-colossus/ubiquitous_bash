_testAutoSSH() {
	if ! _wantGetDep autossh
	then
		echo 'warn: autossh not available'
		return 1
	fi
}

#"$1" == "$gatewayName"
#"$2" == "$reversePort"
_autossh_external() {
	_start
	
	export sshBase="$safeTmp"/.ssh
	_prepare_ssh
	
	#_setup_ssh
	_setup_ssh_operations
	
	
	
	local autosshPID
	/usr/bin/autossh -M 0 -F "$sshDir"/config -R "$2":localhost:22 "$1" -N &
	autosshPID="$!"
	
	#echo "$autosshPID" | _prependDaemonPID
	
	#_pauseForProcess "$autosshPID"
	wait "$autosshPID"
	
	
	_setup_ssh_merge_known_hosts
	
	_stop "$sshExitStatus"
}

#Searches for an unused port in the reversePorts list, binds reverse proxy to it.
#Until "_proxySSH_reverse" can differentiate "known_hosts" at remote ports, there is little point in performing a check for open ports at the remote end, since these would be used automatically. Thus, "_autossh_direct" is recommended for now.
#"$1" == "$gatewayName"
_autossh_find() {
	local currentReversePort
	for currentReversePort in "${reversePorts[@]}"
	do
		if ! _checkRemoteSSH "$1" "$currentReversePort"
		then
			_autossh_external "$1" "$currentReversePort"
			return 0
		fi
	done
	return 1
}

#"$1" == "$gatewayName"
_autossh_direct() {
	_autossh_external "$1" "${reversePorts[0]}"
}

#"$1" == "$gatewayName"
_autossh_ready() {
	local sshExitStatus
	
	_ssh "$1" true
	sshExitStatus="$?"
	if [[ "$sshExitStatus" != "255" ]]
	then
		_autossh_direct "$1"
		_stop
	fi
}

#May be overridden by "ops" if multiple gateways are required.
#Not recommended. If multiple gateways are required, it is better to launch autossh daemons for each of them simultaneously. See "_ssh_autoreverse".
_autossh_list_sequence() {
	_start
	
	_autossh_ready "$1"
	
	#_autossh_ready firstGateway
	#_autossh_ready secondGateway
	
	_stop
}

_autossh_list() {
	"$scriptAbsoluteLocation" _autossh_list_sequence "$@"
}

#May be overridden by "ops" to point to direct, find, or list.
_autossh_entry() {
	[[ "$1" != "" ]] && export gatewayName="$1"
	
	_autossh_direct "$gatewayName"
	#_autossh_find "$gatewayName"
	#_autossh_list "$gatewayName"
}

_autossh_launch() {
	_setup_ssh
	
	while true
	do
		"$scriptAbsoluteLocation" _autossh_entry "$@"
		
		sleep 30
		
		if [[ "$EMBEDDED" == "true" ]]
		then
			sleep 270
		fi
		
	done
}

# WARNING Not all autossh functions have been fully tested yet. However, previous versions of this system are known to be much more robust than autossh defaults.
_autossh() {
	mkdir -p "$scriptLocal"/ssh/log
	local logID
	logID=$(_uid)
	"$scriptAbsoluteLocation" _cmdDaemon _autossh_launch "$@" >> "$scriptLocal"/ssh/log/_autossh."$logID".log 2>&1
}

_reversessh() {
	_ssh -R "${reversePorts[0]}":localhost:22 "$gatewayName" -N "$@"
}

