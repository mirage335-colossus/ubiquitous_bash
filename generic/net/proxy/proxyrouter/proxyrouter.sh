
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
	_getDep nmap
	
	if "$scriptAbsoluteLocation" _testProxyRouter_sequence "$@"
	then
		return 0
	fi
	
	_stop 1
}

#Routes standard in/out to a target host/port through netcat.
_proxy_direct() {
	local proxyTargetHost
	local proxyTargetPort
	
	proxyTargetHost="$1"
	proxyTargetPort="$2"
	
	#nc -q 96 "$proxyTargetHost" "$proxyTargetPort"
	#nc -q -1 "$proxyTargetHost" "$proxyTargetPort"
	nc "$proxyTargetHost" "$proxyTargetPort" 2> /dev/null
}

#Launches proxy if port at hostname is open.
#"$1" == hostname
#"$2" == port
_proxy() {
	if _checkPort "$1" "$2"
	then
		_proxy_direct "$1" "$2"
		_stop
	fi
	
	return 0
}

#Checks all reverse port assignments, launches proxy if open.
#"$1" == host short name
#"$2" == hostname
_proxy_reverse() {
	_get_reversePorts "$1"
	
	local currentReversePort
	for currentReversePort in "${matchingReversePorts[@]}"
	do
		_proxy "$2" "$currentReversePort"
	done
}

