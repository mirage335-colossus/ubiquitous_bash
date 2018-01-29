
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
	_getDep ssh
	
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
	nc -q -1 "$proxyTargetHost" "$proxyTargetPort"
}

#Enters remote server at hostname, by SSH, sets up a tunnel, checks tunnel for another SSH server.
#"$1" == host short name
#"$2" == port
_checkRemotePort() {
	local localPort
	localPort=$(_findPort)
	
	_timeout 18 _ssh "$1" -L "$localPort":localhost:"$2" -N > /dev/null 2>&1 &
	sleep 2
	nmap -Pn localhost -p "$localPort" -sV | grep 'ssh' > /dev/null 2>&1 && return 0
	sleep 2
	nmap -Pn localhost -p "$localPort" -sV | grep 'ssh' > /dev/null 2>&1 && return 0
	sleep 2
	nmap -Pn localhost -p "$localPort" -sV | grep 'ssh' > /dev/null 2>&1 && return 0
	sleep 2
	nmap -Pn localhost -p "$localPort" -sV | grep 'ssh' > /dev/null 2>&1 && return 0
	sleep 6
	nmap -Pn localhost -p "$localPort" -sV | grep 'ssh' > /dev/null 2>&1 && return 0
}

#Launches proxy if remote port is open at hostname.
#"$1" == host short name
#"$2" == port
_proxySSH() {
	if _checkRemotePort "$1" "$2"
	then
		_ssh -q -W localhost:"$2" "$1"
		_stop
	fi
	
	return 0
}

#Checks all reverse port assignments through hostname, launches proxy if open.
#"$1" == host short name
_proxySSH_reverse() {
	_get_reversePorts "$1"
	
	local currentReversePort
	for currentReversePort in "${matchingReversePorts[@]}"
	do
		_proxySSH "$1" "$currentReversePort"
	done
}

#Checks hostname for open port.
#"$1" == hostname
#"$2" == port
_checkPort() {
	nmap -Pn "$1" -p "$2" | grep open > /dev/null 2>&1
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

_ssh() {
	ssh -F "$scriptLocal"/ssh/config "$@"
}

_vnc() {
	_start
	
	let vncPort="${reversePorts[0]}"+20
	
	#https://wiki.archlinux.org/index.php/x11vnc#SSH_Tunnel
	#ssh -t -L "$vncPort":localhost:"$vncPort" "$@" 'sudo x11vnc -display :0 -auth /home/USER/.Xauthority'
	
	"$scriptAbsoluteLocation" _ssh -C -c aes256-gcm@openssh.com -m hmac-sha1 -o ConnectTimeout=72 -o ConnectionAttempts=2 -o ServerAliveInterval=5 -o ServerAliveCountMax=5 -o ExitOnForwardFailure=yes -f -L "$vncPort":localhost:"$vncPort" "$@" 'x11vnc -localhost -rfbport '"$vncPort"' -timeout 8 -xkb -display :0 -auth /home/'"$X11USER"'/.Xauthority -noxrecord -noxdamage'
	#-noxrecord -noxfixes -noxdamage
	
	sleep 3
	
	#vncviewer -encodings "copyrect tight zrle hextile" localhost:"$vncPort"
	vncviewer localhost:"$vncPort"
	
	_stop
}

#Builtin version of ssh-copy-id.
_ssh_copy_id() {
	_start
	
	"$scriptAbsoluteLocation" _ssh "$@" 'mkdir -p "$HOME"/.ssh'
	cat "$scriptAbsoluteFolder"/id_rsa.pub | "$scriptAbsoluteLocation" _ssh "$@" 'cat - >> "$HOME"/.ssh/authorized_keys'
	
	_stop
}
alias _ssh-copy-id=_ssh_copy_id

#Overload with "ops".
_setup_ssh_extra() {
	true
}

_setup_ssh() {
	! [[ -e ~/.ssh ]] && mkdir -p ~/.ssh && chmod 700 ~/.ssh
	! [[ -e ~/.ssh/"$ubiquitiousBashID" ]] && mkdir -p ~/.ssh/"$ubiquitiousBashID" && chmod 700 ~/.ssh/"$ubiquitiousBashID"
	! [[ -e ~/.ssh/"$ubiquitiousBashID"/"$netName" ]] && mkdir -p ~/.ssh/"$ubiquitiousBashID"/"$netName" && chmod 700 ~/.ssh/"$ubiquitiousBashID"/"$netName"
	
	! grep "$ubiquitiousBashID" ~/.ssh/config > /dev/null 2>&1 && echo "Include "'"'"~/.ssh/""$ubiquitiousBashID""/config"'"' >> ~/.ssh/config
	
	! grep "$netName" ~/.ssh/"$ubiquitiousBashID"/config > /dev/null 2>&1 && echo "Include "'"'"~/.ssh/""$ubiquitiousBashID""/""$netName""/config"'"' >> ~/.ssh/"$ubiquitiousBashID"/config
	
	if ! [[ -e "$scriptLocal"/ssh/id_rsa ]] && ! [[ -e ~/.ssh/"$ubiquitiousBashID"/"$netName"/id_rsa ]]
	then
		ssh-keygen -b 4096 -t rsa -N "" -f "$scriptLocal"/id_rsa
	fi
	
	chmod 600 "$scriptLocal"/ssh/id_rsa
	chmod 600 "$scriptLocal"/ssh/id_rsa.pub
	
	_cpDiff "$scriptLocal"/ssh/config ~/.ssh/"$ubiquitiousBashID"/"$netName"/config
	cp -n "$scriptLocal"/ssh/id_rsa ~/.ssh/"$ubiquitiousBashID"/"$netName"/id_rsa
	cp -n "$scriptLocal"/ssh/id_rsa.pub ~/.ssh/"$ubiquitiousBashID"/"$netName"/id_rsa.pub
	_cpDiff "$scriptLocal"/ssh/known_hosts ~/.ssh/"$ubiquitiousBashID"/"$netName"/known_hosts
	
	_cpDiff "$scriptAbsoluteLocation" ~/.ssh/"$ubiquitiousBashID"/"$netName"/cautossh
	_cpDiff "$scriptLocal"/ssh/ops ~/.ssh/"$ubiquitiousBashID"/"$netName"/ops
	
	_setup_ssh_extra
	
	return 0
	
}





