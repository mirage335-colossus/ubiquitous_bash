_testProxySSH() {
	_getDep ssh
}

#Enters remote server at hostname, by SSH, sets up a tunnel, checks tunnel for another SSH server.
#"$1" == host short name
#"$2" == port
_checkRemoteSSH() {
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
	if _checkRemoteSSH "$1" "$2"
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

_ssh() {
	ssh -F "$scriptLocal"/ssh/config "$@"
}

_vnc() {
	_start
	
	local vncMinPort
	let vncMinPort="${reversePorts[0]}"+20
	
	local vncMaxPort
	let vncMaxPort="${reversePorts[0]}"+50
	
	local vncPort
	vncPort=$(_findPort "$vncMinPort" "$vncMaxPort")
	
	#https://wiki.archlinux.org/index.php/x11vnc#SSH_Tunnel
	#ssh -t -L "$vncPort":localhost:"$vncPort" "$@" 'sudo x11vnc -display :0 -auth /home/USER/.Xauthority'
	
	#mkdir -p "$scriptTokens"
	#if [[ ! -e "$scriptTokens" ]]
	#then
	#	echo > "$scriptTokens"/x11vncpasswd
	#	chmod 600 "$scriptTokens"/x11vncpasswd
	#	_uid > "$scriptTokens"/x11vncpasswd
	#fi
	#cp "$scriptTokens"/x11vncpasswd "$safeTmp"/x11vncpasswd
	
	echo > "$safeTmp"/x11vncpasswd
	chmod 600 "$safeTmp"/x11vncpasswd
	_uid > "$safeTmp"/x11vncpasswd
	
	cat "$safeTmp"/x11vncpasswd | "$scriptAbsoluteLocation" _ssh -C -c aes256-gcm@openssh.com -m hmac-sha1 -o ConnectTimeout=72 -o ConnectionAttempts=2 -o ServerAliveInterval=5 -o ServerAliveCountMax=5 -o ExitOnForwardFailure=yes -L "$vncPort":localhost:"$vncPort" "$@" 'x11vnc -passwdfile cmd:"/bin/cat -" -localhost -rfbport '"$vncPort"' -timeout 8 -xkb -display :0 -auth "$HOME"/.Xauthority -noxrecord -noxdamage' &
	#-noxrecord -noxfixes -noxdamage
	
	_waitPort localhost "$vncPort"
	sleep 0.8 #VNC service may not always be ready when port is up.
	#sleep 1
	
	#vncviewer -encodings "copyrect tight zrle hextile" localhost:"$vncPort"
	cat "$safeTmp"/x11vncpasswd | vncviewer -autopass localhost:"$vncPort"
	
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

_setup_ssh_sequence() {
	_start
	
	! [[ -e ~/.ssh ]] && mkdir -p ~/.ssh && chmod 700 ~/.ssh
	! [[ -e ~/.ssh/"$ubiquitiousBashID" ]] && mkdir -p ~/.ssh/"$ubiquitiousBashID" && chmod 700 ~/.ssh/"$ubiquitiousBashID"
	! [[ -e ~/.ssh/"$ubiquitiousBashID"/"$netName" ]] && mkdir -p ~/.ssh/"$ubiquitiousBashID"/"$netName" && chmod 700 ~/.ssh/"$ubiquitiousBashID"/"$netName"
	
	! grep "$ubiquitiousBashID" ~/.ssh/config > /dev/null 2>&1 && echo "Include "'"'"~/.ssh/""$ubiquitiousBashID""/config"'"' >> ~/.ssh/config
	
	! grep "$netName" ~/.ssh/"$ubiquitiousBashID"/config > /dev/null 2>&1 && echo "Include "'"'"~/.ssh/""$ubiquitiousBashID""/""$netName""/config"'"' >> ~/.ssh/"$ubiquitiousBashID"/config
	
	if [[ "$keepKeys_SSH" == "false" ]]
	then
		rm -f "$scriptLocal"/ssh/id_rsa >/dev/null 2>&1
		rm -f "$scriptLocal"/ssh/id_rsa.pub >/dev/null 2>&1
		rm -f ~/.ssh/"$ubiquitiousBashID"/"$netName"/id_rsa >/dev/null 2>&1
		rm -f ~/.ssh/"$ubiquitiousBashID"/"$netName"/id_rsa.pub >/dev/null 2>&1
	fi
	
	if ! [[ -e "$scriptLocal"/ssh/id_rsa ]] && ! [[ -e ~/.ssh/"$ubiquitiousBashID"/"$netName"/id_rsa ]]
	then
		ssh-keygen -b 4096 -t rsa -N "" -f "$scriptLocal"/id_rsa
	fi
	
	chmod 600 "$scriptLocal"/ssh/id_rsa
	chmod 600 "$scriptLocal"/ssh/id_rsa.pub
	
	_cpDiff "$scriptLocal"/ssh/config ~/.ssh/"$ubiquitiousBashID"/"$netName"/config
	cp -n "$scriptLocal"/ssh/id_rsa ~/.ssh/"$ubiquitiousBashID"/"$netName"/id_rsa
	cp -n "$scriptLocal"/ssh/id_rsa.pub ~/.ssh/"$ubiquitiousBashID"/"$netName"/id_rsa.pub
	
	sort "$scriptLocal"/ssh/known_hosts ~/.ssh/"$ubiquitiousBashID"/"$netName"/known_hosts | uniq > "$safeTmp"/known_hosts_uniq
	_cpDiff "$safeTmp"/known_hosts_uniq "$scriptLocal"/ssh/known_hosts
	
	_cpDiff "$scriptLocal"/ssh/known_hosts ~/.ssh/"$ubiquitiousBashID"/"$netName"/known_hosts
	
	_cpDiff "$scriptAbsoluteLocation" ~/.ssh/"$ubiquitiousBashID"/"$netName"/cautossh
	_cpDiff "$scriptLocal"/ssh/ops ~/.ssh/"$ubiquitiousBashID"/"$netName"/ops
	
	_setup_ssh_extra
	
	_stop
}

_setup_ssh() {
	"$scriptAbsoluteLocation" _setup_ssh_sequence "$@"
}

#May be overridden by "ops" if multiple gateways are required.
_ssh_autoreverse() {
	_torServer_SSH
	_autossh
	
	#_autossh firstGateway
	#_autossh secondGateway
}
