
_testProxyRouter_sequence() {
	_start
	
	local testPort
	testPort=$(_findPort)
	
	_timeout 10 nc -l -p "$testPort" 2>/dev/null > "$safeTmp"/nctest &
	
	sleep 0.1 && ! echo PASS | nc localhost "$testPort" 2>/dev/null &&
	sleep 0.3 && ! echo PASS | nc localhost "$testPort" 2>/dev/null &&
	sleep 0.9 && ! echo PASS | nc localhost "$testPort" 2>/dev/null &&
	sleep 3 && ! echo PASS | nc localhost "$testPort" 2>/dev/null &&
	sleep 6 && ! echo PASS | nc localhost "$testPort" 2>/dev/null &&
	false
	! grep 'PASS' "$safeTmp"/nctest > /dev/null 2>&1 && _stop 1
	
	_stop 0
}

_testProxyRouter() {
	_getDep socat
	
	_getDep nmap
	
	_getDep curl
	
	# WARNING: Cygwin does not pass netcat tests.
	uname -a | grep -i cygwin > /dev/null 2>&1 && return 0
	
	# WARNING: Do not rely on 'netcat' functionality. Relatively non-portable. Prefer "socat" .
	_getDep nc
	
	if "$scriptAbsoluteLocation" _testProxyRouter_sequence "$@"
	then
		return 0
	fi
	
	_stop 1
}

_proxy_direct_ipv4() {
	local proxyTargetHost
	local proxyTargetPort
	
	proxyTargetHost="$1"
	proxyTargetPort="$2"
	
	socat -4 - TCP:"$proxyTargetHost":"$proxyTargetPort",connect-timeout="$netTimeout" 2> /dev/null
}

_proxy_direct_ipv6() {
	local proxyTargetHost
	local proxyTargetPort
	
	proxyTargetHost="$1"
	proxyTargetPort="$2"
	
	[[ "$proxyTargetHost" == *':'* ]] && proxyTargetHost='['"$proxyTargetHost"']'
	
	socat -6 - TCP:"$proxyTargetHost":"$proxyTargetPort",connect-timeout="$netTimeout" 2> /dev/null
}

#Routes standard in/out to a target host/port through netcat.
_proxy_direct() {
	local proxyTargetHost
	local proxyTargetPort
	
	proxyTargetHost="$1"
	proxyTargetPort="$2"
	
	[[ "$proxyTargetHost" == *':'* ]] && proxyTargetHost='['"$proxyTargetHost"']'
	
	#nc -q 96 "$proxyTargetHost" "$proxyTargetPort"
	#nc -q -1 "$proxyTargetHost" "$proxyTargetPort"
	#nc "$proxyTargetHost" "$proxyTargetPort" 2> /dev/null
	
	socat - TCP:"$proxyTargetHost":"$proxyTargetPort",connect-timeout="$netTimeout" 2> /dev/null
}

_proxy_ipv4() {
	if _checkPort_ipv4 "$1" "$2"
	then
		#_proxy_direct_ipv4 "$1" "$2"
		if _proxy_direct_ipv4 "$1" "$2"
		then
			# WARNING: Not to be relied upon. May not reach if terminated by signal.
			_stop
		fi
	fi
	
	return 0
}

_proxy_ipv6() {
	if _checkPort_ipv6 "$1" "$2"
	then
		#_proxy_direct_ipv6 "$1" "$2"
		if _proxy_direct_ipv6 "$1" "$2"
		then
			# WARNING: Not to be relied upon. May not reach if terminated by signal.
			_stop
		fi
	fi
	
	return 0
}

#Launches proxy if port at hostname is open.
#"$1" == hostname
#"$2" == port
_proxy() {
	if _checkPort "$1" "$2"
	then
		#_proxy_direct "$1" "$2"
		if _proxy_direct "$1" "$2"
		then
			# WARNING: Not to be relied upon. May not reach if terminated by signal.
			_stop
		fi
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

# WARNING: Choose reputable services that have been documented alive for at least a few years.
#https://gist.github.com/yurrriq/7fc7634dd00494072f45
_find_public_ipv4() {
	local currentPublicIPaddr
	
	currentPublicIPaddr=$(curl --connect-timeout "$netTimeout" -4 -s https://ipv4.icanhazip.com/ | tr -dc 'a-zA-Z0-9.:')
	[[ "$currentPublicIPaddr" == "" ]] && currentPublicIPaddr=$(curl --connect-timeout "$netTimeout" -4 -s https://ipv4.icanhazip.com/ | tr -dc 'a-zA-Z0-9.:')
	
	[[ "$currentPublicIPaddr" == "" ]] && currentPublicIPaddr=$(curl --connect-timeout "$netTimeout" -4 -s https://v4.ident.me/ | tr -dc 'a-zA-Z0-9.:')
	
	# CAUTION: Not explicitly IPv4 (though probably nearly so) - https://ipecho.net/developers.html .
	[[ "$currentPublicIPaddr" == "" ]] && currentPublicIPaddr=$(curl --connect-timeout "$netTimeout" -4 -s https://ipecho.net/plain | tr -dc 'a-zA-Z0-9.:')
	
	
	[[ "$currentPublicIPaddr" == "" ]] && return 1
	echo -n "$currentPublicIPaddr"
	return 0
}

# WARNING: Choose reputable services that have been documented alive for at least a few years.
#https://gist.github.com/yurrriq/7fc7634dd00494072f45
_find_public_ipv6() {
	local currentPublicIPaddr
	
	currentPublicIPaddr=$(curl --connect-timeout "$netTimeout" -6 -s https://ipv6.icanhazip.com/ | tr -dc 'a-zA-Z0-9.:')
	[[ "$currentPublicIPaddr" == "" ]] && currentPublicIPaddr=$(curl --connect-timeout "$netTimeout" -6 -s https://ipv6.icanhazip.com/ | tr -dc 'a-zA-Z0-9.:')
	
	[[ "$currentPublicIPaddr" == "" ]] && currentPublicIPaddr=$(curl --connect-timeout "$netTimeout" -6 -s https://v6.ident.me/ | tr -dc 'a-zA-Z0-9.:')
	
	
	[[ "$currentPublicIPaddr" == "" ]] && return 1
	echo -n "$currentPublicIPaddr"
	return 0
}

_find_public_ip() {
	local currentPublicIPaddr
	
	[[ "$currentPublicIPaddr" == "" ]] && currentPublicIPaddr=$(_find_public_ipv6)
	[[ "$currentPublicIPaddr" == "" ]] && currentPublicIPaddr=$(_find_public_ipv4)
	
	
	[[ "$currentPublicIPaddr" == "" ]] && return 1
	echo -n "$currentPublicIPaddr"
	return 0
}

