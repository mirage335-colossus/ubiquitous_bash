_testAutoSSH() {
	if ! _wantGetDep /usr/bin/autossh
	then
		echo 'warn: autossh not available'
		return 1
	fi
}

# ATTENTION: Respects "$LOCALLISTENPORT". May be repurposed for services other than SSH (ie. HTTPS).
#"$1" == "$gatewayName"
#"$2" == "$reversePort"
_autossh_external() {
	_overrideReversePorts
	
	#Workaround. SSH will call CoreAutoSSH recursively as the various "proxy" directives are called. These processes should be managed by SSH, and not recorded in the daemon PID list file, as daemon management scripts may be confused by these many processes quitting long before daemon failure.
	export isDaemon=
	
	local currentLocalSSHport
	currentLocalSSHport="$LOCALLISTENPORT"
	[[ "$currentLocalSSHport" == "" ]] && currentLocalSSHport="$LOCALSSHPORT"
	[[ "$currentLocalSSHport" == "" ]] && currentLocalSSHport=22
	
	local autosshPID
	/usr/bin/autossh -M 0 -F "$sshDir"/config -R "$2":localhost:"$currentLocalSSHport" "$1" -N &
	autosshPID="$!"
	
	#echo "$autosshPID" | _prependDaemonPID
	
	#_pauseForProcess "$autosshPID"
	wait "$autosshPID"
}

# WARNING: Accepts "matchingReversePorts". Must be set with current values by "_get_reversePorts" or similar!
#Searches for an unused port in the reversePorts list, binds reverse proxy to it.
#Until "_proxySSH_reverse" can differentiate "known_hosts" at remote ports, there is little point in performing a check for open ports at the remote end, since these would be used automatically. Thus, "_autossh_direct" is recommended for now.
#"$1" == "$gatewayName"
_autossh_find() {
	local currentReversePort
	for currentReversePort in "${matchingReversePorts[@]}"
	do
		if ! _checkRemoteSSH "$1" "$currentReversePort"
		then
			_autossh_external "$1" "$currentReversePort"
			return 0
		fi
	done
	return 1
}

# WARNING: Accepts "matchingReversePorts". Must be set with current values by "_get_reversePorts" or similar!
#"$1" == "$gatewayName"
_autossh_direct() {
	_autossh_external "$1" "${matchingReversePorts[0]}"
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
	_overrideReversePorts
	
	_start
	
	export sshBase="$safeTmp"/.ssh
	_prepare_ssh
	
	#_setup_ssh
	_setup_ssh_operations
	
	export sshInContainment="true"
	
	while true
	do
		"$scriptAbsoluteLocation" _autossh_entry "$@"
		
		sleep 3
		
		if [[ "$EMBEDDED" == "true" ]]
		then
			sleep 270
		fi
		
	done
	
	_stop
}

# WARNING Not all autossh functions have been fully tested yet. However, previous versions of this system are known to be much more robust than autossh defaults.
_autossh() {
	mkdir -p "$scriptLocal"/ssh/log
	local logID
	logID=$(_uid)
	_cmdDaemon "$scriptAbsoluteLocation" _autossh_launch "$@" >> "$scriptLocal"/ssh/log/_autossh."$logID".log 2>&1
}

# WARNING: Accepts "matchingReversePorts". Must be set with current values by "_get_reversePorts" or similar!
_reversessh() {
	local currentLocalSSHport
	currentLocalSSHport="$LOCALLISTENPORT"
	[[ "$currentLocalSSHport" == "" ]] && currentLocalSSHport="$LOCALSSHPORT"
	[[ "$currentLocalSSHport" == "" ]] && currentLocalSSHport=22
	
	_ssh -R "${matchingReversePorts[0]}":localhost:"$currentLocalSSHport" "$gatewayName" -N "$@"
}

_overrideReversePorts() {
	[[ "$overrideLOCALLISTENPORT" != "" ]] && export LOCALLISTENPORT="$overrideLOCALLISTENPORT"
	[[ "${overrideMatchingReversePorts[0]}" != "" ]] && export matchingReversePorts=( "${overrideMatchingReversePorts[@]}" )
}

