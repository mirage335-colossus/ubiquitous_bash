
_testProxyRouter_sequence() {
	_start
	
	local testPort
	testPort=$(_findPort)
	
	_timeout 10 nc -l -p "$testPort" > "$safeTmp"/nctest &
	
	sleep 0.1 && ! echo PASS | nc localhost "$testPort" &&
	sleep 0.3 && ! echo PASS | nc localhost "$testPort" &&
	sleep 0.9 && ! echo PASS | nc localhost "$testPort" &&
	sleep 3 && ! echo PASS | nc localhost "$testPort" &&
	sleep 6 && ! echo PASS | nc localhost "$testPort" &&
	false
	! grep 'PASS' "$safeTmp"/nctest > /dev/null 2>&1 && _stop 1
	
	_stop 0
}

_testProxyRouter() {
	_getDep nc
	
	if "$scriptAbsoluteLocation" _testProxyRouter_sequence "$@"
	then
		return 0
	fi
	
	_stop 1
}

#Routes standard in/out to a target host/port through netcat.
_proxy() {
	local proxyTargetHost
	local proxyTargetPort
	
	proxyTargetHost="$1"
	proxyTargetPort="$2"
	
	nc "$proxyTargetHost" "$proxyTargetPort"
}

_writeSSH_machine() {
	_here_proxyrouter_sshconfig_header
}

_proxy_path_at_machine() {
	mkdir -p "$safeTmp"/.ssh
	_writeSSH_machine > "$safeTmp"/.ssh/config
	
	ssh -F "$safeTmp"/.ssh/config
}

#Example. WIP.
_proxyrouter_machine() {
	local sshProxyCommand
	
	_testRemotePort "$(machinePort)" _proxy_path_at_machine
	
	
	
}

_proxyrouter() {
	_proxyrouter_"$1"
}
