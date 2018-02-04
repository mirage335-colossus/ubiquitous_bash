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

_ssh_sequence() {
	_start
	
	export sshBase="$safeTmp"/.ssh
	
	_setup_ssh
	
	ssh -F "$sshDir"/config "$@"
	
	_setup_ssh_merge_known_hosts
	
	_stop
}

_ssh() {
	"$scriptAbsoluteLocation" _ssh_sequence "$@"
}

_vnc_sequence() {
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
	stty echo
	
	_stop
}

_vnc() {
	"$scriptAbsoluteLocation" _vnc_sequence "$@"
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

_setup_ssh_merge_known_hosts() {
	[[ ! -e "$scriptLocal"/ssh/known_hosts ]] && echo > "$scriptLocal"/ssh/known_hosts
	[[ ! -e "$sshDir"/known_hosts ]] && echo > "$sshDir"/known_hosts
	sort "$scriptLocal"/ssh/known_hosts "$sshDir"/known_hosts | uniq > "$safeTmp"/known_hosts_uniq
	_cpDiff "$safeTmp"/known_hosts_uniq "$scriptLocal"/ssh/known_hosts
	
	_cpDiff "$scriptLocal"/ssh/known_hosts "$sshDir"/known_hosts
}

_setup_ssh_commands() {
	_prepare_ssh
	
	mkdir -p "$scriptLocal"/ssh
	
	! [[ -e "$sshBase" ]] && mkdir -p "$sshBase" && chmod 700 "$sshBase"
	! [[ -e "$sshBase"/"$ubiquitiousBashID" ]] && mkdir -p "$sshBase"/"$ubiquitiousBashID" && chmod 700 "$sshBase"/"$ubiquitiousBashID"
	! [[ -e "$sshDir" ]] && mkdir -p "$sshDir" && chmod 700 "$sshDir"
	
	! grep "$ubiquitiousBashID" "$sshBase"/config > /dev/null 2>&1 && echo 'Include "'"$sshUbiquitous"'/config"' >> "$sshBase"/config
	
	! grep "$netName" "$sshUbiquitous"/config > /dev/null 2>&1 && echo 'Include "'"$sshDir"'/config"' >> "$sshBase"/config >> "$sshUbiquitous"/config
	
	if [[ "$keepKeys_SSH" == "false" ]]
	then
		rm -f "$scriptLocal"/ssh/id_rsa >/dev/null 2>&1
		rm -f "$scriptLocal"/ssh/id_rsa.pub >/dev/null 2>&1
		rm -f "$sshDir"/id_rsa >/dev/null 2>&1
		rm -f "$sshDir"/id_rsa.pub >/dev/null 2>&1
	fi
	
	if ! [[ -e "$scriptLocal"/ssh/id_rsa ]] && ! [[ -e "$sshDir"/id_rsa ]]
	then
		ssh-keygen -b 4096 -t rsa -N "" -f "$scriptLocal"/id_rsa
	fi
	
	chmod 600 "$scriptLocal"/ssh/id_rsa
	chmod 600 "$scriptLocal"/ssh/id_rsa.pub
	
	_here_ssh_config >> "$safeTmp"/config
	_cpDiff "$safeTmp"/config "$sshDir"/config
	
	
	cp -n "$scriptLocal"/ssh/id_rsa "$sshDir"/id_rsa
	cp -n "$scriptLocal"/ssh/id_rsa.pub "$sshDir"/id_rsa.pub
	
	_setup_ssh_merge_known_hosts
	
	_cpDiff "$scriptAbsoluteLocation" "$sshDir"/cautossh
	_cpDiff "$scriptLocal"/ssh/ops "$sshDir"/ops
	
	_setup_ssh_extra
}

_setup_ssh_sequence() {
	_start
	
	_setup_ssh_commands
	
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
