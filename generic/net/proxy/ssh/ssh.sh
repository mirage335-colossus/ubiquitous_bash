_testProxySSH() {
	_getDep ssh
	
	! _wantDep base64 && echo 'warn: no base64'
	
	! _wantDep vncviewer && echo 'warn: no vncviewer, recommend tigervnc'
	! _wantDep vncserver && echo 'warn: no vncserver, recommend tigervnc'
	! _wantDep Xvnc && echo 'warn: no Xvnc, recommend tigervnc'
	
	! _wantDep x11vnc && echo 'warn: x11vnc not found'
	! _wantDep x0tigervncserver && echo 'warn: x0tigervncserver not found'
	
	#! _wantDep xpra && echo 'warn: xpra not found'
	#! _wantDep xephyr && echo 'warn: xephyr not found'
	#! _wantDep xnest && echo 'warn: xnest not found'
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

_start_safeTmp_ssh() {
	cat "$scriptAbsoluteLocation" | base64 | _ssh -C -o ConnectionAttempts=2 "$@" '
mkdir -p '"$safeTmpSSH"'
chmod 700 '"$safeTmpSSH"'
cat - | base64 -d > '"$safeTmpSSH"'/cautossh
chmod 700 '"$safeTmpSSH"'/cautossh
'
	
	#cat "$scriptAbsoluteLocation" | base64 | _ssh -C -o ConnectionAttempts=2 "$@" 'cat - | base64 -d > '"$safeTmpSSH"'/cautossh'
	#_ssh -C -o ConnectionAttempts=2 "$@" 'chmod 700 '"$safeTmpSSH"'/cautossh'
}

_stop_safeTmp_ssh() {
#rm '"$safeTmpSSH"'/w_*/*
	cat "$scriptAbsoluteLocation" | _ssh -C -o ConnectionAttempts=2 "$@" '
rm '"$safeTmpSSH"'/cautossh
rmdir '"$safeTmpSSH"'/_local
rmdir '"$safeTmpSSH"'
'
	
}

_vnc_ssh() {
	"$scriptAbsoluteLocation" _ssh -C -c aes256-gcm@openssh.com -m hmac-sha1 -o ConnectionAttempts=2 -o ServerAliveInterval=5 -o ServerAliveCountMax=5 -o ExitOnForwardFailure=yes "$@" 
}

_findPort_vnc() {
	local vncMinPort
	let vncMinPort="${reversePorts[0]}"+20
	
	local vncMaxPort
	let vncMaxPort="${reversePorts[0]}"+50
	
	_findPort "$vncMinPort" "$vncMaxPort"
}

_prepare_vnc() {
	
	echo > "$vncPasswdFile".pln
	chmod 600 "$vncPasswdFile".pln
	_uid 8 > "$vncPasswdFile".pln
	
	export vncPort=$(_findPort_vnc)
	
}

_vncpasswd() {
	#Supported by both TightVNC and TigerVNC.
	if echo | vncpasswd -x --help 2>&1 | grep -i 'vncpasswd \[FILE\]' >/dev/null 2>&1
	then
		echo | cat "$vncPasswdFile".pln - "$vncPasswdFile".pln | vncpasswd "$vncPasswdFile"
		return 0
	fi
	
	return 1
}

_vncviewer_operations() {
	_detect_x11
	export DISPLAY="$destination_DISPLAY"
	
	#TightVNC
	if vncviewer --help 2>&1 | grep '\-passwd' >/dev/null 2>&1
	then
		#vncviewer -encodings "copyrect tight zrle hextile" localhost:"$vncPort"
		vncviewer -passwd "$vncPasswdFile" localhost:"$vncPort" "$@"
		stty echo
		return 0
	fi
	
	#TigerVNC
	if vncviewer --help 2>&1 | grep 'PasswordFile   \- Password file for VNC authentication (default\=)' >/dev/null 2>&1
	then
		vncviewer -DotWhenNoCursor -passwd "$vncPasswdFile" localhost:"$vncPort" "$@"
		stty echo
		return 0
	fi
	
	return 1
}

_vncviewer_sequence() {
	_start
	
	cat - > "$vncPasswdFile".pln
	! _vncpasswd && _stop 1
	
	! _vncviewer_operations "$@" && _stop 1
	
	
	_stop
}

#Password must be given on standard input. Environment variable "$vncPort" must be set. Environment variable "$destination_DISPLAY" may be forced.
_vncviewer() {
	"$scriptAbsoluteLocation" _vncviewer_sequence "$@"
}

_x11vnc_operations() {
	_detect_x11
	export DISPLAY="$destination_DISPLAY"
	
	#x11vnc
	if type x11vnc >/dev/null 2>&1
	then
		#-passwdfile cmd:"/bin/cat -"
		x11vnc -localhost -rfbauth "$vncPasswdFile" -rfbport "$vncPort" -timeout 8 -xkb -display "$destination_DISPLAY" -auth "$HOME"/.Xauthority -noxrecord -noxdamage
		#-noxrecord -noxfixes -noxdamage
		return 0
	fi
	
	#TigerVNC.
	if type x0tigervncserver
	then
		x0tigervncserver -rfbauth "$vncPasswdFile" -rfbport "$vncPort"
		return 0
	fi
	
	return 1
}

_x11vnc_sequence() {
	_start
	
	cat - > "$vncPasswdFile".pln
	! _vncpasswd && _stop 1
	
	! _x11vnc_operations && _stop 1
	
	_stop
}

#Password must be given on standard input. Environment variable "$vncPort" must be set. Environment variable "$destination_DISPLAY" may be forced.
_x11vnc() {
	"$scriptAbsoluteLocation" _x11vnc_sequence "$@"
}

_vnc_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	_prepare_vnc
	
	
	cat "$vncPasswdFile".pln | _vnc_ssh -L "$vncPort":localhost:"$vncPort" "$@" 'env vncPort='"$vncPort"' safeTmpSSH='"$safeTmpSSH"' '"$safeTmpSSH"/cautossh' _x11vnc' &
	#-noxrecord -noxfixes -noxdamage
	
	_waitPort localhost "$vncPort"
	sleep 0.8 #VNC service may not always be ready when port is up.
	
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' destination_DISPLAY='"$DISPLAY"' '"$scriptAbsoluteLocation"' _vncviewer'
	
	stty echo
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_vnc() {
	"$scriptAbsoluteLocation" _vnc_sequence "$@"
}

_push_vnc_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	_prepare_vnc
	
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' safeTmpSSH='"$safeTmpSSH"' '"$scriptAbsoluteLocation"' _x11vnc' &
	#-noxrecord -noxfixes -noxdamage
	
	_waitPort localhost "$vncPort"
	sleep 0.8 #VNC service may not always be ready when port is up.
	
	cat "$vncPasswdFile".pln | _vnc_ssh -R "$vncPort":localhost:"$vncPort" "$@" 'env vncPort='"$vncPort"' destination_DISPLAY='"$DISPLAY"' '"$safeTmpSSH"/cautossh' _vncviewer'
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_push_vnc() {
	"$scriptAbsoluteLocation" _push_vnc_sequence "$@"
}

_desktop_sequence() {
	_start
	
	local vncPort
	vncPort=$(_findPort_vnc)
	
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
	
	#desktopEnvironmentLaunch='xrdb \$HOME/.Xresources ; xsetroot -solid grey ; x-window-manager & export XKL_XMODMAP_DISABLE=1 ; /etc/X11/Xsession'
	desktopEnvironmentLaunch='true'
	desktopEnvironmentGeometry='1920x1080'
	
	local localClientDisplay="$DISPLAY"
	
	#Xvnc works properly with PID files, whereas vncserver does not.
	cat "$safeTmp"/vncserverpasswd | "$scriptAbsoluteLocation" _ssh -C -c aes256-gcm@openssh.com -m hmac-sha1 -o ConnectTimeout=72 -o ConnectionAttempts=2 -o ServerAliveInterval=5 -o ServerAliveCountMax=5 -o ExitOnForwardFailure=yes -L "$vncPort":localhost:"$vncPort" "$@" 'vncpasswd -f > '"$vncPasswdFile"' && [[ -e '"$vncPasswdFile"' ]] && chmod 600 '"$vncPasswdFile"' ; vncserver :'"$vncDisplay"' -depth 16 -geometry '"$desktopEnvironmentGeometry"' -nevershared -dontdisconnect -localhost -rfbport '"$vncPort"' -rfbauth '"$vncPasswdFile"' -rfbwait 12000 & echo $! > '"$vncPIDfile"' ; export DISPLAY=:'"$vncDisplay"' ; '"$desktopEnvironmentLaunch"' ; sleep 12' &
	
	export DISPLAY="$localClientDisplay"
	
	_waitPort localhost "$vncPort"
	sleep 0.8 #VNC service may not always be ready when port is up.
	#sleep 1
	
	#vncviewer -encodings "copyrect tight zrle hextile" localhost:"$vncPort"
	cat "$safeTmp"/vncserverpasswd | vncviewer -autopass localhost:"$vncPort"
	stty echo
	
	#_ssh -C -o ConnectionAttempts=2 "$@" 'kill $(cat '"$vncPIDfile"') ; rm -f '"$vncPasswdFile"' ; rm -f '"$vncPIDfile"''
	_ssh -C -o ConnectionAttempts=2 "$@" 'pkill Xvnc ; pkill Xtightvnc  ; rm -f '"$vncPasswdFile"' ; rm -f '"$vncPIDfile"''
	
	
	_stop
}

#Launches VNC server and client, with up to nine nonpersistent desktop environments.
_desktop() {
	"$scriptAbsoluteLocation" _desktop_sequence "$@"
}

_push_desktop_sequence() {
	_start
	
	export permit_x11_override=("$scriptAbsoluteLocation" _ssh -C -o ConnectionAttempts=2 "$@")
	_detect_x11
	
	local vncPort
	vncPort=$(_findPort_vnc)
	
	local vncID
	vncID=$(_uid)
	local vncPasswdFile
	vncPasswdFile="$HOME"'/.vnctemp/passwd_'"$vncID"
	local vncPIDfile
	vncPIDfile="$HOME"'/.vnctemp/pid_'"$vncID"
	
	local vncDisplay
	local vncDisplayValid
	for (( vncDisplay = 1 ; vncDisplay <= 9 ; vncDisplay++ ))
	do
		! [[ -e /tmp/.X"$vncDisplay"-lock ]] && ! [[ -e /tmp/.X11-unix/X"$vncDisplay" ]] && vncDisplayValid=true && break
	done
	[[ "$vncDisplayValid" != "true" ]] && _stop 1
	
	echo > "$safeTmp"/vncserverpasswd
	chmod 600 "$safeTmp"/vncserverpasswd
	_uid 8 > "$safeTmp"/vncserverpasswd
	
	mkdir -p ~/.vnctemp
	chmod 700 ~/.vnctemp
	
	#desktopEnvironmentLaunch='xrdb \$HOME/.Xresources ; xsetroot -solid grey ; x-window-manager & export XKL_XMODMAP_DISABLE=1 ; /etc/X11/Xsession'
	desktopEnvironmentLaunch='true'
	desktopEnvironmentGeometry='1280x720'
	
	local localClientDisplay="$DISPLAY"
	
	#Xvnc works properly with PID files, whereas vncserver does not.
	cat "$safeTmp"/vncserverpasswd | bash -c 'vncpasswd -f > '"$vncPasswdFile"' && [[ -e '"$vncPasswdFile"' ]] && chmod 600 '"$vncPasswdFile"' ; vncserver :'"$vncDisplay"' -depth 16 -geometry '"$desktopEnvironmentGeometry"' -nevershared -dontdisconnect -localhost -rfbport '"$vncPort"' -rfbauth '"$vncPasswdFile"' -rfbwait 12000 & echo $! > '"$vncPIDfile"' ; export DISPLAY=:'"$vncDisplay"' ; '"$desktopEnvironmentLaunch"' ; sleep 12' &
	
	export DISPLAY="$localClientDisplay"
	
	_waitPort localhost "$vncPort"
	sleep 0.8 #VNC service may not always be ready when port is up.
	#sleep 1
	
	#vncviewer -encodings "copyrect tight zrle hextile" localhost:"$vncPort"
	cat "$safeTmp"/vncserverpasswd | "$scriptAbsoluteLocation" _ssh -C -c aes256-gcm@openssh.com -m hmac-sha1 -o ConnectTimeout=72 -o ConnectionAttempts=2 -o ServerAliveInterval=5 -o ServerAliveCountMax=5 -o ExitOnForwardFailure=yes -R "$vncPort":localhost:"$vncPort" "$@" 'env DISPLAY='"$destination_DISPLAY"' vncviewer -autopass localhost:'"$vncPort"
	stty echo
	
	#kill $(cat "$vncPIDfile") ; rm -f "$vncPasswdFile" ; rm -f "$vncPIDfile"
	pkill Xvnc ; pkill Xtightvnc ; rm -f "$vncPasswdFile" ; rm -f "$vncPIDfile"
	
	_stop
}

_push_desktop() {
	"$scriptAbsoluteLocation" _push_desktop_sequence "$@"
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
