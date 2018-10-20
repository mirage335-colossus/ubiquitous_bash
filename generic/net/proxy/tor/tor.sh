_testTor() {
	_getDep socat
	_getDep curl
	
	if ! _wantGetDep tor
	then
		echo 'warn: tor not available'
		return 1
	fi
	
	if ! _wantGetDep torsocks
	then
		echo 'warn: tor client support requires torsocks'
		return 1
	fi
}

# ATTENTION: Respects "$LOCALLISTENPORT". May be repurposed for services other than SSH (ie. HTTPS).
_torServer_SSH_writeCfg() {
	local currentLocalSSHport
	currentLocalSSHport="$LOCALLISTENPORT"
	[[ "$currentLocalSSHport" == "" ]] && currentLocalSSHport="$LOCALSSHPORT"
	[[ "$currentLocalSSHport" == "" ]] && currentLocalSSHport=22
	
	mkdir -p "$scriptLocal"/tor/sshd/dd
	
	rm "$scriptLocal"/tor/sshd/dd/torrc > /dev/null 2>&1
	
	echo "RunAsDaemon 0" >> "$scriptLocal"/tor/sshd/dd/torrc
	echo "DataDirectory "'"'"$scriptLocal"/tor/sshd/dd'"' >> "$scriptLocal"/tor/sshd/dd/torrc
	echo  >> "$scriptLocal"/tor/sshd/dd/torrc
	
	echo "SocksPort 0" >> "$scriptLocal"/tor/sshd/dd/torrc
	echo  >> "$scriptLocal"/tor/sshd/dd/torrc
	
	local currentReversePort
	for currentReversePort in "${matchingReversePorts[@]}"
	do
		
		mkdir -p "$scriptLocal"/tor/sshd/"$currentReversePort"
		chmod 700 "$scriptLocal"/tor/sshd/"$currentReversePort"
		
		echo "HiddenServiceDir "'"'"$scriptLocal"/tor/sshd/"$currentReversePort"/'"' >> "$scriptLocal"/tor/sshd/dd/torrc
		
		echo "HiddenServicePort ""$currentReversePort"" 127.0.0.1:""$currentLocalSSHport" >> "$scriptLocal"/tor/sshd/dd/torrc
		
		echo  >> "$scriptLocal"/tor/sshd/dd/torrc
		
	done
	
}

_get_torServer_SSH_hostnames() {
	local currentHostname
	local currentReversePort
	
	[[ ! -e "$scriptLocal"/tor/sshd/"${matchingReversePorts[0]}"/hostname ]] && sleep 3
	[[ ! -e "$scriptLocal"/tor/sshd/"${matchingReversePorts[0]}"/hostname ]] && sleep 3
	[[ ! -e "$scriptLocal"/tor/sshd/"${matchingReversePorts[0]}"/hostname ]] && sleep 3
	[[ ! -e "$scriptLocal"/tor/sshd/"${matchingReversePorts[0]}"/hostname ]] && sleep 3
	
	
	for currentReversePort in "${matchingReversePorts[@]}"
	do
		[[ ! -e "$scriptLocal"/tor/sshd/"$currentReversePort"/hostname ]] && sleep 3
		[[ ! -e "$scriptLocal"/tor/sshd/"$currentReversePort"/hostname ]] && continue
		
		currentHostname=$(cat "$scriptLocal"/tor/sshd/"$currentReversePort"/hostname)
		torServer_hostnames+=( "$currentHostname":"$currentReversePort" )
	done
	
	export torServer_hostnames
}

_show_torServer_SSH_hostnames() {
	_get_torServer_SSH_hostnames
	
	echo
	local currentHostname
	for currentHostname in "${torServer_hostnames[@]}"
	do
		echo "$currentHostname"
	done
}

#Typically used to create onion addresses for an entire network of machines.
_torServer_SSH_all_launch() {
	_get_reversePorts '*'
	_torServer_SSH_writeCfg
	tor -f "$scriptLocal"/tor/sshd/dd/torrc
	
	_get_reversePorts '*'
	_offset_reversePorts
	export matchingReversePorts=( "${matchingOffsetPorts[@]}" )
	_torServer_SSH_writeCfg
	tor -f "$scriptLocal"/tor/sshd/dd/torrc
	
	_get_reversePorts '*'
	_show_torServer_SSH_hostnames
	
	_get_reversePorts '*'
	_offset_reversePorts
	export matchingReversePorts=( "${matchingOffsetPorts[@]}" )
	_show_torServer_SSH_hostnames
}

# WARNING: Accepts "matchingReversePorts". Must be set with current values by "_get_reversePorts" or similar!
#Especially intended for IPv4 NAT punching.
_torServer_SSH_launch() {
	_overrideReversePorts
	
	_torServer_SSH_writeCfg
	
	tor -f "$scriptLocal"/tor/sshd/dd/torrc
	
	_show_torServer_SSH_hostnames
	
}

_torServer_SSH() {
	mkdir -p "$scriptLocal"/ssh/log
	local logID
	logID=$(_uid)
	"$scriptAbsoluteLocation" _cmdDaemon _torServer_SSH_launch "$@" >> "$scriptLocal"/ssh/log/_torServer_SSH."$logID".log 2>&1
}

_checkTorPort_sequence() {
	_start
	
	#Does not work, because torsocks does not handle the DNS resolution method used by nmap.
	#torsocks nmap -n -Pn -sT "$1" -p "$2" | grep open > /dev/null 2>&1
	
	local curlPid
	! torsocks curl --connect-timeout 72 --max-time 72 -v telnet://"$1":"$2" > "$safeTmp"/curl 2>&1 && echo FAIL > "$safeTmp"/fail &
	curlPid=$!
	
	while true
	do
		if grep "Connected" "$safeTmp"/curl > /dev/null 2>&1
		then
			kill -TERM "$curlPid"
			#Unneeded curl process considered lower risk than misdirected signal to user process.
			#ps --no-headers -p "$curlPid" > /dev/null 2>&1 && sleep 0.1 && ps --no-headers -p "$curlPid" > /dev/null 2>&1 && kill -KILL "$curlPid"
			_stop 0
		fi
		
		if grep "FAIL" "$safeTmp"/fail > /dev/null 2>&1
		then
			_stop 1
		fi
		
		
		sleep 0.1
	done
	
	
	_stop
	
}

#Checks hostname for open port.
#"$1" == hostname
#"$2" == port
_checkTorPort() {
	"$scriptAbsoluteLocation" _checkTorPort_sequence "$@"
}

_proxyTor_direct() {
 	local proxyTargetHost
	local proxyTargetPort
	
	proxyTargetHost="$1"
	proxyTargetPort="$2"
	
	#Use of "-q" parameter may not be useful in all cases.
	##printf "HEAD / HTTP/1.0\r\n\r\n" | torsocks nc sejnfjrq6szgca7v.onion 80
	#torsocks nc -q 96 "$proxyTargetHost" "$proxyTargetPort"
	#torsocks nc -q -1 "$proxyTargetHost" "$proxyTargetPort"
	#torsocks nc "$proxyTargetHost" "$proxyTargetPort"
	#torsocks socat - TCP:"$proxyTargetHost":"$proxyTargetPort"
	socat - SOCKS4A:localhost:"$proxyTargetHost":"$proxyTargetPort",socksport=9050
}

# WARNING: Does NOT honor "$netTimeout" !
#Launches proxy if port at hostname is open.
#"$1" == hostname
#"$2" == port
_proxyTor() {
	if _checkTorPort "$1" "$2"
	then
		_proxyTor_direct "$1" "$2"
		if _proxyTor_direct "$1" "$2"
		then
			# WARNING: Not to be relied upon. May not reach if terminated by signal.
			_stop
		fi
	fi
}

#Checks all reverse port assignments through hostname, launches proxy if open.
#"$1" == host short name
#"$1" == hostname (typically onion)
_proxyTor_reverse() {
	_get_reversePorts "$1"
	
	local currentReversePort
	for currentReversePort in "${matchingReversePorts[@]}"
	do
		_proxyTor "$2" "$currentReversePort"
	done
}



