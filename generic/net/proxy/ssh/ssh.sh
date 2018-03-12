_testProxySSH() {
	_getDep ssh
	
	! _wantDep base64 && echo 'warn: no base64'
	
	! _wantDep vncviewer && echo 'warn: no vncviewer, recommend tigervnc'
	! _wantDep vncserver && echo 'warn: no vncserver, recommend tigervnc'
	! _wantDep Xvnc && echo 'warn: no Xvnc, recommend tigervnc'
	
	! _wantDep x11vnc && echo 'warn: x11vnc not found'
	! _wantDep x0tigervncserver && echo 'warn: x0tigervncserver not found'
	
	! _wantDep vncpasswd && echo 'warn: vncpasswd not found, x11vnc broken!'
	
	! _wantDep xset && echo 'warn: xset not found'
	
	#! _wantDep xpra && echo 'warn: xpra not found'
	#! _wantDep xephyr && echo 'warn: xephyr not found'
	#! _wantDep xnest && echo 'warn: xnest not found'
	
	if [[ -e /usr/share/doc/realvnc-vnc-server ]] || type vnclicense >/dev/null 2>&1
	then
		echo 'TAINT: unsupported vnc!'
	fi
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
	
	_timeout 14 _ssh -f "$1" -L "$localPort":"$remoteHostDestination":"$2" -N > /dev/null 2>&1
	sleep 2
	nmap -Pn localhost -p "$localPort" -sV 2> /dev/null | grep 'ssh' > /dev/null 2>&1 && return 0
	sleep 2
	nmap -Pn localhost -p "$localPort" -sV 2> /dev/null | grep 'ssh' > /dev/null 2>&1 && return 0
	sleep 2
	nmap -Pn localhost -p "$localPort" -sV 2> /dev/null | grep 'ssh' > /dev/null 2>&1 && return 0
	sleep 2
	nmap -Pn localhost -p "$localPort" -sV 2> /dev/null | grep 'ssh' > /dev/null 2>&1 && return 0
	sleep 3
	nmap -Pn localhost -p "$localPort" -sV 2> /dev/null | grep 'ssh' > /dev/null 2>&1 && return 0
	
	return 1
}

#Launches proxy if remote port is open at hostname.
#"$1" == gateway name
#"$2" == port
#"$3" == remote host (optional, localhost default)
_proxySSH() {
	local remoteHostDestination
	remoteHostDestination="$3"
	[[ "$remoteHostDestination" == "" ]] && remoteHostDestination="localhost"
	
	#Checking for remote port is usually unnecessary, as the SSH command seems to fail normally if the remote destination is not up. Not explicitly checking with nmap saves significant time (performance). However, the code remains in place for immediate return to default if proven useful.
	#if _checkRemoteSSH "$1" "$2" "$remoteHostDestination"
	#then
		if _ssh -q -W "$remoteHostDestination":"$2" "$1"
		then
			_stop
		fi
	#fi
	
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
	
	local sshExitStatus
	ssh -F "$sshDir"/config "$@"
	sshExitStatus="$?"
	
	#Preventative workaround, not normally necessary.
	stty echo > /dev/null 2>&1
	
	_setup_ssh_merge_known_hosts
	
	_stop "$sshExitStatus"
}

_ssh() {
	if [[ "$sshInContainment" == "true" ]]
	then
		if ssh -F "$sshDir"/config "$@"
		then
			return 0
		fi
		return 1
	fi
	
	export sshInContainment="true"
	
	local sshExitStatus
	"$scriptAbsoluteLocation" _ssh_sequence "$@"
	sshExitStatus="$?"
	
	export sshInContainment=""
	
	return "$sshExitStatus"
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
	
	export vncPIDfile="$safeTmpSSH"/.vncpid
	export vncPIDfile_local="$safeTmp"/.vncpid
	
}

_vncpasswd() {
	#TigerVNC, specifically.
	if type tigervncpasswd >/dev/null 2>&1
	then
		echo | cat "$vncPasswdFile".pln - "$vncPasswdFile".pln | tigervncpasswd "$vncPasswdFile"
		return 0
	fi
	
	#Supported by both TightVNC and TigerVNC.
	if echo | vncpasswd -x --help 2>&1 | grep -i 'vncpasswd \[FILE\]' >/dev/null 2>&1
	then
		echo | cat "$vncPasswdFile".pln - "$vncPasswdFile".pln | vncpasswd "$vncPasswdFile"
		return 0
	fi
	
	return 1
}

_vncviewer_operations() {
	if _detect_x11
	then
		export DISPLAY="$destination_DISPLAY"
		export XAUTHORITY="$destination_AUTH"
	fi
	
	#TigerVNC
	if vncviewer --help 2>&1 | grep 'PasswordFile   \- Password file for VNC authentication (default\=)' >/dev/null 2>&1
	then
		vncviewer -DotWhenNoCursor -passwd "$vncPasswdFile" localhost:"$vncPort" "$@"
		stty echo > /dev/null 2>&1
		return 0
	fi
	
	#TightVNC
	if vncviewer --help 2>&1 | grep '\-passwd' >/dev/null 2>&1
	then
		#vncviewer -encodings "copyrect tight zrle hextile" localhost:"$vncPort"
		vncviewer -passwd "$vncPasswdFile" localhost:"$vncPort" "$@"
		stty echo > /dev/null 2>&1
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

#To be overrideden by ops (eg. for "-repeat").
_x11vnc_command() {
	x11vnc "$@"
}

_x11vnc_operations() {
	if _detect_x11
	then
		export DISPLAY="$destination_DISPLAY"
		export XAUTHORITY="$destination_AUTH"
	fi
	
	#x11vnc
	if type x11vnc >/dev/null 2>&1
	then
		#-passwdfile cmd:"/bin/cat -"
		_x11vnc_command -localhost -rfbauth "$vncPasswdFile" -rfbport "$vncPort" -timeout 16 -xkb -display "$destination_DISPLAY" -auth "$destination_AUTH" -noxrecord -noxdamage
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

_vncserver_operations() {
	#[[ "$desktopEnvironmentLaunch" == "" ]] && desktopEnvironmentLaunch="true"
	[[ "$desktopEnvironmentLaunch" == "" ]] && desktopEnvironmentLaunch="startlxde"
	[[ "$desktopEnvironmentGeometry" == "" ]] && desktopEnvironmentGeometry='1920x1080'
	
	local vncDisplay
	local vncDisplayValid
	for (( vncDisplay = 1 ; vncDisplay <= 9 ; vncDisplay++ ))
	do
		! [[ -e /tmp/.X"$vncDisplay"-lock ]] && ! [[ -e /tmp/.X11-unix/X"$vncDisplay" ]] && vncDisplayValid=true && break
	done
	[[ "$vncDisplayValid" != "true" ]] && _stop 1
	
	#TigerVNC
	if echo | vncserver -x --help 2>&1 | grep '\-fg' >/dev/null 2>&1
	then
		echo
		echo '*****TigerVNC Server Detected'
		echo
		#"-fg" may be unreliable
		#vncserver :"$vncDisplay" -depth 16 -geometry "$desktopEnvironmentGeometry" -localhost -rfbport "$vncPort" -rfbauth "$vncPasswdFile" &
		
		
		export XvncCommand="Xvnc"
		type Xtigervnc >/dev/null 2>&1 && export XvncCommand="Xtigervnc"
		"$XvncCommand" :"$vncDisplay" -depth 16 -geometry "$desktopEnvironmentGeometry" -localhost -rfbport "$vncPort" -rfbauth "$vncPasswdFile" &
		echo $! > "$vncPIDfile"
		
		export DISPLAY=:"$vncDisplay"
		
		local currentCount
		for (( currentCount = 0 ; currentCount < 90 ; currentCount++ ))
		do
			xset q >/dev/null 2>&1 && break
			sleep 1
		done
		
		bash -c "$desktopEnvironmentLaunch" &
		
		sleep 12
		
		return 0
	fi
	
	#TightVNC
	if type vncserver >/dev/null 2>&1
	then
		echo
		echo '*****TightVNC Server Detected'
		echo
		vncserver :"$vncDisplay" -depth 16 -geometry "$desktopEnvironmentGeometry" -nevershared -dontdisconnect -localhost -rfbport "$vncPort" -rfbauth "$vncPasswdFile" -rfbwait 12000
		
		export DISPLAY=:"$vncDisplay"
		
		bash -c "$desktopEnvironmentLaunch" &
		
		sleep 12
		
		return 0
	fi
	
	return 1
}

_vncserver_sequence() {
	_start
	
	cat - > "$vncPasswdFile".pln
	! _vncpasswd && _stop 1
	
	! _vncserver_operations && _stop 1
	
	_stop
}

#Password must be given on standard input. Environment variables "$vncPort", "$vncPIDfile", must be set. Environment variables "$desktopEnvironmentGeometry", "$desktopEnvironmentLaunch", may be forced.
_vncserver() {
	"$scriptAbsoluteLocation" _vncserver_sequence "$@"
}

#Environment variable "$vncPIDfile", must be set.
_vncserver_terminate() {
	if [[ -e "$vncPIDfile" ]] && [[ -s "$vncPIDfile" ]]
	then
		pkill -P $(cat "$vncPIDfile")
		kill $(cat "$vncPIDfile")
		#sleep 1
		#kill -KILL $(cat "$vncPIDfile")
		rm "$vncPIDfile"
		
		#For now, this does not always work with TigerVNC.
		#return 0
	fi
	
	pkill Xvnc
	pkill Xtightvnc
	pkill Xtigervnc
	rm "$vncPIDfile"
	return 1
}

_vnc_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	_prepare_vnc
	
	# TODO WARNING Terminal echo (ie. "stty echo") lockup errors are possible as ssh is backgrounded without "-f".
	cat "$vncPasswdFile".pln | _vnc_ssh -L "$vncPort":localhost:"$vncPort" "$@" 'env vncPort='"$vncPort"' '"$safeTmpSSH"/cautossh' _x11vnc' &
	
	_waitPort localhost "$vncPort"
	
	#VNC service may not always be ready when port is up.
	
	sleep 0.8
	if ! _checkPort localhost "$vncPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' destination_DISPLAY='"$DISPLAY"' '"$scriptAbsoluteLocation"' _vncviewer'
	
	sleep 3
	if ! _checkPort localhost "$vncPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' destination_DISPLAY='"$DISPLAY"' '"$scriptAbsoluteLocation"' _vncviewer'
	
	sleep 9
	if ! _checkPort localhost "$vncPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' destination_DISPLAY='"$DISPLAY"' '"$scriptAbsoluteLocation"' _vncviewer'
	
	stty echo > /dev/null 2>&1
	
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
	
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' '"$scriptAbsoluteLocation"' _x11vnc' &
	#-noxrecord -noxfixes -noxdamage
	
	_waitPort localhost "$vncPort"
	
	#VNC service may not always be ready when port is up.
	
	sleep 0.8
	if ! _checkPort localhost "$vncPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' destination_DISPLAY='"$DISPLAY"' '"$scriptAbsoluteLocation"' _vncviewer'
	
	sleep 3
	if ! _checkPort localhost "$vncPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' destination_DISPLAY='"$DISPLAY"' '"$scriptAbsoluteLocation"' _vncviewer'
	
	sleep 9
	if ! _checkPort localhost "$vncPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' destination_DISPLAY='"$DISPLAY"' '"$scriptAbsoluteLocation"' _vncviewer'
	
	_stop_safeTmp_ssh "$@"
	_stop 1
}

_push_vnc() {
	"$scriptAbsoluteLocation" _push_vnc_sequence "$@"
}

_desktop_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	_prepare_vnc
	
	# TODO WARNING Terminal echo (ie. "stty echo") lockup errors are possible as ssh is backgrounded without "-f".
	cat "$vncPasswdFile".pln | _vnc_ssh -L "$vncPort":localhost:"$vncPort" "$@" 'env vncPort='"$vncPort"' vncPIDfile='"$vncPIDfile"' desktopEnvironmentGeometry='"$desktopEnvironmentGeometry"' desktopEnvironmentLaunch='"$desktopEnvironmentLaunch"' '"$safeTmpSSH"/cautossh' _vncserver' &
	
	
	_waitPort localhost "$vncPort"
	sleep 0.8 #VNC service may not always be ready when port is up.
	
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' destination_DISPLAY='"$DISPLAY"' '"$scriptAbsoluteLocation"' _vncviewer'
	stty echo > /dev/null 2>&1
	
	_vnc_ssh "$@" 'env vncPIDfile='"$vncPIDfile"' '"$safeTmpSSH"/cautossh' _vncserver_terminate'
	
	_stop_safeTmp_ssh "$@"
	_stop
}

#Launches VNC server and client, with up to nine nonpersistent desktop environments.
_desktop() {
	"$scriptAbsoluteLocation" _desktop_sequence "$@"
}

_push_desktop_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	_prepare_vnc
	
	
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' vncPIDfile='"$vncPIDfile_local"' desktopEnvironmentGeometry='"$desktopEnvironmentGeometry"' desktopEnvironmentLaunch='"$desktopEnvironmentLaunch"' '"$scriptAbsoluteLocation"' _vncserver' &
	
	
	_waitPort localhost "$vncPort"
	sleep 0.8 #VNC service may not always be ready when port is up.
	
	cat "$vncPasswdFile".pln | _vnc_ssh -R "$vncPort":localhost:"$vncPort" "$@" 'env vncPort='"$vncPort"' destination_DISPLAY='""' '"$safeTmpSSH"/cautossh' _vncviewer'
	stty echo > /dev/null 2>&1
	
	bash -c 'env vncPIDfile='"$vncPIDfile_local"' '"$scriptAbsoluteLocation"' _vncserver_terminate'
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_push_desktop() {
	"$scriptAbsoluteLocation" _push_desktop_sequence "$@"
}

#Builtin version of ssh-copy-id.
_ssh_copy_id() {
	_start
	
	"$scriptAbsoluteLocation" _ssh "$@" 'mkdir -p "$HOME"/.ssh'
	cat "$scriptLocal"/ssh/id_rsa.pub | "$scriptAbsoluteLocation" _ssh "$@" 'cat - >> "$HOME"/.ssh/authorized_keys'
	
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
	
	if [[ -e "$scriptLocal"/ssh/"$sshKeyLocalSubdirectory""$sshKeyName" ]]
	then
		chmod 600 "$scriptLocal"/ssh/"$sshKeyLocalSubdirectory""$sshKeyName"
		chmod 600 "$scriptLocal"/ssh/"$sshKeyLocalSubdirectory""$sshKeyName".pub > /dev/null 2>&1
		
		cp -n "$scriptLocal"/ssh/"$sshKeyLocalSubdirectory""$sshKeyName" "$sshLocalSSH"/"$sshKeyName"
		cp -n "$scriptLocal"/ssh/"$sshKeyLocalSubdirectory""$sshKeyName".pub "$sshLocalSSH"/"$sshKeyName".pub > /dev/null 2>&1
		
		return 0
	fi
	
	if [[ -e "$scriptLocal"/ssh/"$sshKeyName" ]]
	then
		chmod 600 "$scriptLocal"/ssh/"$sshKeyName"
		chmod 600 "$scriptLocal"/ssh/"$sshKeyName".pub > /dev/null 2>&1
		
		cp -n "$scriptLocal"/ssh/"$sshKeyName" "$sshLocalSSH"/"$sshKeyName"
		cp -n "$scriptLocal"/ssh/"$sshKeyName".pub "$sshLocalSSH"/"$sshKeyName".pub > /dev/null 2>&1
		
		return 0
	fi
	
	return 1
}

#Overload with "ops".
_setup_ssh_extra() {
	true
}

_setup_ssh_merge_known_hosts() {
	[[ ! -e "$scriptLocal"/ssh/known_hosts ]] && echo > "$scriptLocal"/ssh/known_hosts
	[[ ! -e "$sshLocalSSH"/known_hosts ]] && echo > "$sshLocalSSH"/known_hosts
	sort "$scriptLocal"/ssh/known_hosts "$sshLocalSSH"/known_hosts | uniq > "$safeTmp"/known_hosts_uniq
	_cpDiff "$safeTmp"/known_hosts_uniq "$scriptLocal"/ssh/known_hosts
	
	_cpDiff "$scriptLocal"/ssh/known_hosts "$sshLocalSSH"/known_hosts
}

_setup_ssh_operations() {
	_prepare_ssh
	
	mkdir -p "$scriptLocal"/ssh
	
	! [[ -e "$sshBase" ]] && mkdir -p "$sshBase" && chmod 700 "$sshBase"
	! [[ -e "$sshBase"/"$ubiquitiousBashID" ]] && mkdir -p "$sshBase"/"$ubiquitiousBashID" && chmod 700 "$sshBase"/"$ubiquitiousBashID"
	! [[ -e "$sshDir" ]] && mkdir -p "$sshDir" && chmod 700 "$sshDir"
	! [[ -e "$sshLocal" ]] && mkdir -p "$sshLocal" && chmod 700 "$sshLocal"
	! [[ -e "$sshLocalSSH" ]] && mkdir -p "$sshLocalSSH" && chmod 700 "$sshLocalSSH"
	
	#! grep "$ubiquitiousBashID" "$sshBase"/config > /dev/null 2>&1 && echo 'Include "'"$sshUbiquitous"'/config"' >> "$sshBase"/config
	
	#Prepend include directive. Mitigates the risk of falling under an existing config directive (eg. Host/Match). Carries the relatively insignificant risk of a non-atomic operation.
	if ! grep "$ubiquitiousBashID" "$sshBase"/config > /dev/null 2>&1 && [[ ! -e "$sshBase"/config.tmp ]]
	then
		echo -n >> "$sshBase"/config
		echo 'Include "'"$sshUbiquitous"'/config"' >> "$sshBase"/config.tmp
		echo >> "$sshBase"/config.tmp
		cat "$sshBase"/config >> "$sshBase"/config.tmp
		mv "$sshBase"/config.tmp "$sshBase"/config
		
	fi
	
	! grep "$netName" "$sshUbiquitous"/config > /dev/null 2>&1 && echo 'Include "'"$sshDir"'/config"' >> "$sshBase"/config >> "$sshUbiquitous"/config
	
	if [[ "$keepKeys_SSH" == "false" ]]
	then
		rm -f "$scriptLocal"/ssh/id_rsa >/dev/null 2>&1
		rm -f "$scriptLocal"/ssh/id_rsa.pub >/dev/null 2>&1
		rm -f "$sshDir"/id_rsa >/dev/null 2>&1
		rm -f "$sshDir"/id_rsa.pub >/dev/null 2>&1
		rm -f "$sshLocalSSH"/id_rsa >/dev/null 2>&1
		rm -f "$sshLocalSSH"/id_rsa.pub >/dev/null 2>&1
	fi
	
	if ! [[ -e "$scriptLocal"/ssh/id_rsa ]] && ! [[ -e "$sshLocalSSH"/id_rsa ]]
	then
		ssh-keygen -b 4096 -t rsa -N "" -f "$scriptLocal"/ssh/id_rsa
	fi
	
	_here_ssh_config >> "$safeTmp"/config
	_cpDiff "$safeTmp"/config "$sshDir"/config
	
	_setup_ssh_copyKey id_rsa
	
	_setup_ssh_merge_known_hosts
	
	_cpDiff "$scriptAbsoluteLocation" "$sshDir"/cautossh
	
	# TODO Replace with a less oversimplified destination directory structure.
	#Concatenates all "ops" directives into one file to allow a single "cpDiff" operation.
	[[ -e "$objectDir"/ops ]] && cat "$objectDir"/ops >> "$safeTmp"/opsAll
	[[ -e "$scriptLocal"/ops ]] && cat "$scriptLocal"/ops >> "$safeTmp"/opsAll
	[[ -e "$scriptLocal"/ssh/ops ]] && cat "$scriptLocal"/ssh/ops >> "$safeTmp"/opsAll
	
	[[ -e "$objectDir"/opsauto ]] && cat "$objectDir"/opsauto >> "$safeTmp"/opsAll
	[[ -e "$scriptLocal"/opsauto ]] && cat "$scriptLocal"/opsauto >> "$safeTmp"/opsAll
	[[ -e "$scriptLocal"/ssh/opsauto ]] && cat "$scriptLocal"/ssh/opsauto >> "$safeTmp"/opsAll
	
	
	_cpDiff "$safeTmp"/opsAll "$sshLocalSSH"/ops
	
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
	find . -name '_ssh' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
	find . -name '_fs' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
	
	find . -name '_vnc' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
	find . -name '_push_vnc' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
	find . -name '_desktop' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
	find . -name '_push_desktop' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
	
	find . -name '_wake' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
}

_package_cautossh() {
	cp -a "$scriptAbsoluteFolder"/_index "$safeTmp"/package
}

#May be overridden by "ops" if multiple gateways are required.
_ssh_autoreverse() {
	_torServer_SSH
	_autossh
	
	#_autossh firstGateway
	#_autossh secondGateway
}
