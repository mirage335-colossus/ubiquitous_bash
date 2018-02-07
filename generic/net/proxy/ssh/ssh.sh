_testProxySSH() {
	_getDep ssh
	
	! _wantDep vncviewer && echo 'warn: no vncviewer, recommend tightvnc'
	! _wantDep vncserver && echo 'warn: no vncserver, recommend tightvnc'
	! _wantDep Xvnc && echo 'warn: no Xvnc, recommend tightvnc'
	
	! _wantDep x11vnc && echo 'warn: x11vnc not found'
	
	! _wantDep xpra && echo 'warn: xpra not found'
	! _wantDep xephyr && echo 'warn: xephyr not found'
	! _wantDep xnest && echo 'warn: xnest not found'
}

#Enters remote server at hostname, by SSH, sets up a tunnel, checks tunnel for another SSH server.
#"$1" == host short name
#"$2" == port
#"$3" == remote host (optional, localhost default)
_checkRemoteSSH() {
	local localPort
	localPort=$(_findPort)
	
	local remoteHostDestination
	remoteHostDestination="$3"
	[[ "$remoteHostDestination" == "" ]] && remoteHostDestination="localhost"
	
	_timeout 18 _ssh "$1" -L "$localPort":"$remoteHostDestination":"$2" -N > /dev/null 2>&1 &
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
#"$1" == gateway name
#"$2" == port
#"$3" == remote host (optional, localhost default)
_proxySSH() {
	local remoteHostDestination
	remoteHostDestination="$3"
	[[ "$remoteHostDestination" == "" ]] && remoteHostDestination="localhost"
	
	if _checkRemoteSSH "$1" "$2" "$remoteHostDestination"
	then
		_ssh -q -W "$remoteHostDestination":"$2" "$1"
		_stop
	fi
	
	return 0
}

#Checks all reverse port assignments through hostname, launches proxy if open.
#"$1" == host short name
#"$2" == gateway name
_proxySSH_reverse() {
	_get_reversePorts "$1"
	
	local currentReversePort
	for currentReversePort in "${matchingReversePorts[@]}"
	do
		_proxySSH "$2" "$currentReversePort"
	done
}

_ssh_sequence() {
	_start
	
	export sshBase="$safeTmp"/.ssh
	_prepare_ssh
	
	#_setup_ssh
	_setup_ssh_operations
	
	ssh -F "$sshDir"/config "$@"
	
	_setup_ssh_merge_known_hosts
	
	_stop
}

_ssh() {
	if [[ "$sshInContainment" == "true" ]]
	then
		ssh -F "$sshDir"/config "$@"
		return 0
	fi
	
	export sshInContainment="true"
	"$scriptAbsoluteLocation" _ssh_sequence "$@"
	export sshInContainment=""
}

_vnc_sequence() {
	_start
	
	export permit_x11_override=("$scriptAbsoluteLocation" _ssh -C -o ConnectionAttempts=2 "$@")
	_detect_x11
	
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
	
	cat "$safeTmp"/x11vncpasswd | "$scriptAbsoluteLocation" _ssh -C -c aes256-gcm@openssh.com -m hmac-sha1 -o ConnectTimeout=72 -o ConnectionAttempts=2 -o ServerAliveInterval=5 -o ServerAliveCountMax=5 -o ExitOnForwardFailure=yes -L "$vncPort":localhost:"$vncPort" "$@" 'x11vnc -passwdfile cmd:"/bin/cat -" -localhost -rfbport '"$vncPort"' -timeout 8 -xkb -display '"$destination_DISPLAY"' -auth "$HOME"/.Xauthority -noxrecord -noxdamage' &
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

_desktop_sequence() {
	_start
	
	local vncMinPort
	let vncMinPort="${reversePorts[0]}"+20
	
	local vncMaxPort
	let vncMaxPort="${reversePorts[0]}"+50
	
	local vncPort
	vncPort=$(_findPort "$vncMinPort" "$vncMaxPort")
	
	local vncID
	vncID=$(_uid)
	local vncPasswdFile
	vncPasswdFile='~/.vnctemp/passwd_'"$vncID"
	local vncPIDfile
	vncPIDfile='~/.vnctemp/pid_'"$vncID"
	
	local vncDisplay
	local vncDisplayValid
	for (( vncDisplay = 1 ; vncDisplay <= 9 ; vncDisplay++ ))
	do
		"$scriptAbsoluteLocation" _ssh -C -o ConnectionAttempts=2 "$@" '! [[ -e /tmp/.X'"$vncDisplay"'-lock ]] && ! [[ -e /tmp/.X11-unix/X'"$vncDisplay"' ]]' && vncDisplayValid=true && break
	done
	[[ "$vncDisplayValid" != "true" ]] && _stop 1
	
	echo > "$safeTmp"/vncserverpasswd
	chmod 600 "$safeTmp"/vncserverpasswd
	_uid 8 > "$safeTmp"/vncserverpasswd
	
	if ! _ssh -C -o ConnectionAttempts=2 "$@" 'mkdir -p ~/.vnctemp ; chmod 700 ~/.vnctemp'
	then
		_stop 1
	fi
	
	desktopEnvironmentLaunch='xrdb \$HOME/.Xresources ; xsetroot -solid grey ; x-window-manager & export XKL_XMODMAP_DISABLE=1 ; /etc/X11/Xsession'
	
	cat "$safeTmp"/vncserverpasswd | "$scriptAbsoluteLocation" _ssh -C -c aes256-gcm@openssh.com -m hmac-sha1 -o ConnectTimeout=72 -o ConnectionAttempts=2 -o ServerAliveInterval=5 -o ServerAliveCountMax=5 -o ExitOnForwardFailure=yes -L "$vncPort":localhost:"$vncPort" "$@" 'vncpasswd -f > '"$vncPasswdFile"' && [[ -e '"$vncPasswdFile"' ]] && chmod 600 '"$vncPasswdFile"' ; Xvnc :'"$vncDisplay"' -depth 16 -geometry 1920x1080 -nevershared -dontdisconnect -localhost -rfbport '"$vncPort"' -rfbauth '"$vncPasswdFile"' -rfbwait 12000 & echo $! > '"$vncPIDfile"' ; export DISPLAY=:'"$vncDisplay"' ; '"$desktopEnvironmentLaunch"' ; sleep 12' &
	
	_waitPort localhost "$vncPort"
	sleep 0.8 #VNC service may not always be ready when port is up.
	#sleep 1
	
	#vncviewer -encodings "copyrect tight zrle hextile" localhost:"$vncPort"
	cat "$safeTmp"/vncserverpasswd | vncviewer -autopass localhost:"$vncPort"
	stty echo
	
	_ssh -C -o ConnectionAttempts=2 "$@" 'kill $(cat '"$vncPIDfile"') ; rm -f '"$vncPasswdFile"' ; rm -f '"$vncPIDfile"''
	
	
	
	_stop
}

#Launches VNC server and client, with up to nine nonpersistent desktop environments.
_desktop() {
	"$scriptAbsoluteLocation" _desktop_sequence "$@"
}

#Builtin version of ssh-copy-id.
_ssh_copy_id() {
	_start
	
	"$scriptAbsoluteLocation" _ssh "$@" 'mkdir -p "$HOME"/.ssh'
	cat "$scriptAbsoluteFolder"/id_rsa.pub | "$scriptAbsoluteLocation" _ssh "$@" 'cat - >> "$HOME"/.ssh/authorized_keys'
	
	_stop
}
alias _ssh-copy-id=_ssh_copy_id

#"$1" == "key_name"
#"$2" == "local_subdirectory" (optional)
_setup_ssh_copyKey() {
	local sshKeyName
	local sshKeyLocalSubdirectory
	
	sshKeyName="$1"
	[[ "$2" != "" ]] && sshKeyLocalSubdirectory="$2"/
	
	chmod 600 "$scriptLocal"/ssh/"$sshKeyLocalSubdirectory""$sshKeyName"
	chmod 600 "$scriptLocal"/ssh/"$sshKeyLocalSubdirectory""$sshKeyName".pub
	cp -n "$scriptLocal"/ssh/"$sshKeyLocalSubdirectory""$sshKeyName" "$sshDir"/"$sshKeyName"
	cp -n "$scriptLocal"/ssh/"$sshKeyLocalSubdirectory""$sshKeyName".pub "$sshDir"/"$sshKeyName".pub
}

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

_setup_ssh_operations() {
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
	
	_here_ssh_config >> "$safeTmp"/config
	_cpDiff "$safeTmp"/config "$sshDir"/config
	
	_setup_ssh_copyKey id_rsa
	
	_setup_ssh_merge_known_hosts
	
	_cpDiff "$scriptAbsoluteLocation" "$sshDir"/cautossh
	_cpDiff "$scriptLocal"/ssh/ops "$sshDir"/ops
	
	_setup_ssh_extra
}

_setup_ssh_sequence() {
	_start
	
	_setup_ssh_operations
	
	_stop
}

_setup_ssh() {
	"$scriptAbsoluteLocation" _setup_ssh_sequence "$@"
}

_setup_ssh_commands() {
	find . -name '_vnc' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
	find . -name '_ssh' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
	find . -name '_wake' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
	find . -name '_fs' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
}

#May be overridden by "ops" if multiple gateways are required.
_ssh_autoreverse() {
	_torServer_SSH
	_autossh
	
	#_autossh firstGateway
	#_autossh secondGateway
}
