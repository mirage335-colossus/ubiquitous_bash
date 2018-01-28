
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

_setup_ssh() {
	! [[ -e ~/.ssh ]] && mkdir -p ~/.ssh && chmod 700 ~/.ssh
	! [[ -e ~/.ssh/"$ubiquitiousBashID" ]] && mkdir -p ~/.ssh/"$ubiquitiousBashID" && chmod 700 ~/.ssh/"$ubiquitiousBashID"
	! [[ -e ~/.ssh/"$ubiquitiousBashID"/"$netName" ]] && mkdir -p ~/.ssh/"$ubiquitiousBashID"/"$netName" && chmod 700 ~/.ssh/"$ubiquitiousBashID"/"$netName"
	
	! grep "$ubiquitiousBashID" ~/.ssh/config > /dev/null 2>&1 && echo "Include "'"'"~/.ssh/""$ubiquitiousBashID""/config"'"' >> ~/.ssh/config
	
	! grep "$netName" ~/.ssh/"$ubiquitiousBashID"/config > /dev/null 2>&1 && echo "Include "'"'"~/.ssh/""$ubiquitiousBashID""/""$netName""/config"'"' >> ~/.ssh/"$ubiquitiousBashID"/config
	
	_cpDiff "$scriptLocal"/ssh/config ~/.ssh/"$ubiquitiousBashID"/"$netName"/config
	_cpDiff "$scriptLocal"/ssh/id_rsa ~/.ssh/"$ubiquitiousBashID"/"$netName"/id_rsa
	_cpDiff "$scriptLocal"/ssh/id_rsa.pub ~/.ssh/"$ubiquitiousBashID"/"$netName"/id_rsa.pub
	_cpDiff "$scriptLocal"/ssh/known_hosts ~/.ssh/"$ubiquitiousBashID"/"$netName"/known_hosts
	
	_cpDiff "$scriptAbsoluteLocation" ~/.ssh/"$ubiquitiousBashID"/"$netName"/cautossh
	_cpDiff "$scriptLocal"/ssh/ops ~/.ssh/"$ubiquitiousBashID"/"$netName"/ops
	
	return 0
	
}




