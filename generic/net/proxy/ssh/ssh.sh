_ssh_criticalDep() {
	! type ssh > /dev/null 2>&1 && return 1
	#! type ssh > /dev/null 2>&1 && _messagePlain_bad 'missing: ssh' && return 1
	[[ -L /usr/bin/ssh ]] && ls -l /usr/bin/ssh | grep firejail > /dev/null 2>&1 && _messagePlain_bad 'conflict: firejail' && return 1
	return 0
}

_testProxySSH() {
	_getDep ssh
	
	if [[ -L /usr/local/bin/ssh ]] && ls -l /usr/local/bin/ssh | grep firejail > /dev/null 2>&1
	then
		_messagePlain_warn 'workaround: firejail'
		_messagePlain_probe 'FireJail containment of SSH itself interferes with proxy host jumping, and also inserts a message into the character stream. Most CoreAutoSSH features will not work, if bypassing this is not possible.'
		
		[[ -L /usr/bin/ssh ]] && ls -l /usr/bin/ssh | grep firejail > /dev/null 2>&1 && _messagePlain_bad 'conflict: firejail' && return 1
	fi
	
	#For both _package and _rsync .
	! _wantDep rsync && echo 'warn: no rsync'
	
	! _wantDep sshfs && echo 'warn: sshfs not found'
	
	! _wantDep base64 && echo 'warn: no base64'
	
	! _wantDep vncviewer && echo 'warn: no vncviewer, recommend tigervnc'
	! _wantDep vncserver && echo 'warn: no vncserver, recommend tigervnc'
	! _wantDep Xvnc && echo 'warn: no Xvnc, recommend tigervnc'
	
	! _wantDep x11vnc && echo 'warn: x11vnc not found'
	! _wantDep x0tigervncserver && echo 'warn: x0tigervncserver not found'
	
	! _wantDep vncpasswd && echo 'warn: vncpasswd not found, x11vnc broken!'
	! _wantDep xset && echo 'warn: xset not found, vnc broken!'
	
	#! _wantDep pv && echo 'warn: pv not found, ssh benchmark broken'
	#! _wantDep time && echo 'warn: time not found, ssh benchmark broken'
	
	! _wantDep curl && echo 'warn: missing: curl - public ip detection broken'
	! _wantDep iperf3 && echo 'warn: missing: iperf3 - throughput benchmark broken'
	
	! _wantDep dash && echo 'warn: dash not found, latency benchmark inflated'
	
	#! _wantDep xpra && echo 'warn: xpra not found'
	#! _wantDep xephyr && echo 'warn: xephyr not found'
	#! _wantDep xnest && echo 'warn: xnest not found'
	
	if [[ -e /usr/share/doc/realvnc-vnc-server ]] || type vnclicense >/dev/null 2>&1
	then
		export ubTAINT="true"
		echo 'TAINT: unsupported vnc!'
	fi
	
	#May be required by some _rsync backup scripts.
	#! _wantDep fakeroot && echo 'warn: fakeroot not found'
}

_testRemoteSSH() {
	_start
	_start_safeTmp_ssh "$@"
	
	_ssh "$@" "$safeTmpSSH"'/cautossh _test'
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_self() {
	_start
	_start_safeTmp_ssh "$1"
	
	_ssh "$1" "$safeTmpSSH"'/cautossh '"$@"
	
	_stop_safeTmp_ssh "$1"
	_stop
}

_ssh_setupUbiquitous() {
	_start
	_start_safeTmp_ssh "$@"
	
	_ssh "$@" "$safeTmpSSH"'/cautossh _setupUbiquitous'
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_setupUbiquitous_nonet() {
	_start
	_start_safeTmp_ssh "$@"
	
	_ssh "$@" "$safeTmpSSH"'/cautossh _setupUbiquitous_nonet'
	
	_stop_safeTmp_ssh "$@"
	_stop
}

#Enters remote server at hostname, by SSH, sets up a tunnel, checks tunnel for another SSH server.
#"$1" == host short name
#"$2" == port
#"$3" == remote host (optional, localhost default)
_checkRemoteSSH() {
	local remoteHostDestination
	remoteHostDestination="$3"
	[[ "$remoteHostDestination" == "" ]] && remoteHostDestination="localhost"
	
	#local localPort
	#localPort=$(_findPort)
	
	#_timeout "$netTimeout" _ssh -f "$1" -L "$localPort":"$remoteHostDestination":"$2" -N > /dev/null 2>&1
	#sleep 2
	#nmap --host-timeout "$netTimeout" -Pn localhost -p "$localPort" -sV 2> /dev/null | grep 'ssh' > /dev/null 2>&1 && return 0
	
	mkdir -p "$safeTmp"
	echo | _timeout "$netTimeout" _ssh -q -W "$remoteHostDestination":"$2" "$1" | head -c 3 2> /dev/null > "$safeTmp"/_checkRemoteSSH_header &
	
	local currentIteration
	
	for currentIteration in `seq 1 "$netTimeout"`;
	do
		sleep 0.3
		grep 'SSH' "$safeTmp"/_checkRemoteSSH_header > /dev/null 2>&1 && return 0
		sleep 0.3
		grep 'SSH' "$safeTmp"/_checkRemoteSSH_header > /dev/null 2>&1 && return 0
		sleep 0.3
		grep 'SSH' "$safeTmp"/_checkRemoteSSH_header > /dev/null 2>&1 && return 0
	done
	
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
	
	#Checking for remote port is necessary, as the SSH command hangs indefinitely if a zombie tunnel is present (usually avoidable but highly detremential failure mode).
	if _checkRemoteSSH "$1" "$2" "$remoteHostDestination"
	then
		if _ssh -q -W "$remoteHostDestination":"$2" "$1"
		then
			_stop
		fi
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

_ssh_command() {
	! _ssh_criticalDep && return 1
	
	if [[ -L /usr/local/bin/ssh ]] && ls -l /usr/local/bin/ssh | grep firejail > /dev/null 2>&1
	then
		if /usr/bin/ssh -F "$sshDir"/config "$@"
		then
			return 0
		fi
		return 1
	fi
	
	if ssh -F "$sshDir"/config "$@"
	then
		return 0
	fi
	return 1
}

_ssh_sequence() {
	_start
	
	export sshBase="$safeTmp"/.ssh
	_prepare_ssh
	
	#_setup_ssh
	_setup_ssh_operations
	
	local sshExitStatus
	_ssh_command "$@"
	sshExitStatus="$?"
	
	#Preventative workaround, not normally necessary.
	stty echo > /dev/null 2>&1
	
	_setup_ssh_merge_known_hosts
	
	_stop "$sshExitStatus"
}

_ssh() {
	local currentEchoStatus
	currentEchoStatus=$(stty --file=/dev/tty -g 2>/dev/null)
	
	if [[ "$sshInContainment" == "true" ]]
	then
		if _ssh_command "$@"
		then
			stty --file=/dev/tty "$currentEchoStatus" 2> /dev/null
			return 0
		fi
		stty --file=/dev/tty "$currentEchoStatus" 2> /dev/null
		return 1
	fi
	
	export sshInContainment="true"
	
	local sshExitStatus
	"$scriptAbsoluteLocation" _ssh_sequence "$@"
	sshExitStatus="$?"
	
	export sshInContainment=""
	
	stty --file=/dev/tty "$currentEchoStatus" 2> /dev/null
	return "$sshExitStatus"
}

# WARNING Structure should match _ssh_sequence .
_sshfs_sequence() {
	_start
	
	export sshBase="$safeTmp"/.ssh
	_prepare_ssh
	
	#_setup_ssh
	_setup_ssh_operations
	
	local sshExitStatus
	sshfs -F "$sshDir"/config "$@"
	sshExitStatus="$?"
	
	#Preventative workaround, not normally necessary.
	stty echo > /dev/null 2>&1
	
	_setup_ssh_merge_known_hosts
	
	_stop "$sshExitStatus"
}

# WARNING Structure should match _ssh .
_sshfs() {
	if [[ "$sshInContainment" == "true" ]]
	then
		if sshfs -F "$sshDir"/config "$@"
		then
			return 0
		fi
		return 1
	fi
	
	export sshInContainment="true"
	
	local sshExitStatus
	"$scriptAbsoluteLocation" _sshfs_sequence "$@"
	sshExitStatus="$?"
	
	export sshInContainment=""
	
	return "$sshExitStatus"
}


#"$1" == commandName
_command_ssh_user_field() {
	echo "$1" | grep '^_ssh$' > /dev/null 2>&1 && return 1
	echo "$1" | grep '^_ssh' > /dev/null 2>&1 && echo "$1" | sed 's/^_ssh-//g' && return 0
	echo "$1" | grep '^_rsync$' > /dev/null 2>&1 && return 1
	echo "$1" | grep '^_rsync' > /dev/null 2>&1 && echo "$1" | sed 's/^_rsync-//g' && return 0
	
	echo "$1" | grep '^_backup$' > /dev/null 2>&1 && return 1
	echo "$1" | grep '^_backup' > /dev/null 2>&1 && echo "$1" | sed 's/^_backup-//g' && return 0
	
	return 1
}

#"$1" == commandName
_command_ssh_user() {
	local field_sshCommandUser
	field_sshCommandUser=$(_command_ssh_user_field "$1")
	
	#Output blank, default user specified by SSH config or here document.
	[[ "$field_sshCommandUser" == "home" ]] && return 0
	
	[[ "$field_sshCommandUser" != "" ]] && echo "$field_sshCommandUser" && return 0
	
	#Blank may be regarded as error condition.
	return 1
	
}

_command_ssh_machine() {
	true
}

_rsync_command_check_backup_dependencies() {
	#_messageNormal "Checking - dependencies."
	
	##Check for sudo, especially if fakeroot is unavailable or undesirable.
	#if [[ "$criticalSSHUSER" == "root" ]]
	#then
		#[[ $(id -u) != 0 ]] && _messageError 'fail: not root' && return 1
		criticalSudoAvailable=false
		criticalSudoAvailable=$(sudo -n echo true)
		! [[ "$criticalSudoAvailable" == "true" ]] && _messageError 'bad: sudo' && return 1
	#fi

	#Check for fakeroot.
	#! type fakeroot > /dev/null 2>&1  && _messageError 'missing: fakeroot' && return 1
	
	# WARNING Intended for direct copy/paste inclusion into independent launch wrapper scripts. Kept here for redundancy.
	! type _command_safeBackup > /dev/null 2>&1 && _messageError "missing: _command_safeBackup" && return 1
	
	return 0
}

#"$1" == criticalBackupSource
#"$2" == criticalBackupDestination
_prepare_rsync_backup_env() {
	_messageNormal "Preparing - env."
	
	[[ "$1" != "" ]] && export criticalBackupSource="$1"
	[[ "$2" != "" ]] && export criticalBackupDestination="$2"

	[[ "$criticalBackupSource" == "" ]] && _messageError 'blank: criticalBackupSource' && return 1
	[[ "$criticalBackupDestination" == "" ]] && _messageError 'blank: criticalBackupDestination' && return 1

	mkdir -p "$criticalBackupDestination"
	[[ ! -e "$criticalBackupDestination" ]] && _messageError 'fail: mkdir criticalBackupDestination= '"$criticalBackupDestination" && return 1

	mkdir -p "$criticalBackupDestination"/fs
	[[ ! -e "$criticalBackupDestination"/fs ]] && _messageError 'fail: mkdir criticalBackupDestination/fs= '"$criticalBackupDestination"/fs && return 1
	
	! sudo -n chown root:root "$criticalBackupDestination"/fs && _messageError 'chown: '"$criticalBackupDestination" && return 1
	! sudo -n chmod 700 "$criticalBackupDestination"/fs && _messageError 'chmod: '"$criticalBackupDestination" && return 1

	#Fakeroot, pseudo, and image, optional features are provisioned here, but not expected to be used. Containing all operations within Uqibuitous Bash virtualization is generally expected to represent best practice.

	#mkdir -p "$criticalBackupDestination"/fakeroot
	#[[ ! -e "$criticalBackupDestination"/fakeroot ]] && _messageError 'fail: mkdir criticalBackupDestination/fakeroot= '"$criticalBackupDestination"/fakeroot && return 1
	#[[ ! -e "$criticalBackupDestination"/fakeroot.db ]] && echo -n > "$criticalBackupDestination"/fakeroot.db
	#[[ ! -e "$criticalBackupDestination"/fakeroot.db ]] && _messageError 'fail: mkdir criticalBackupDestination/fakeroot.db= '"$criticalBackupDestination"/fakeroot.db && return 1

	#mkdir -p "$criticalBackupDestination"/pseudo
	#[[ ! -e "$criticalBackupDestination"/pseudo ]] && _messageError 'fail: mkdir criticalBackupDestination/pseudo= '"$criticalBackupDestination"/pseudo && return 1
	#[[ ! -e "$criticalBackupDestination"/pseudo.db ]] && echo -n > "$criticalBackupDestination"/pseudo.db
	#[[ ! -e "$criticalBackupDestination"/pseudo.db ]] && _messageError 'fail: mkdir criticalBackupDestination/pseudo.db= '"$criticalBackupDestination"/pseudo.db && return 1

	#mkdir -p "$criticalBackupDestination"/image
	#[[ ! -e "$criticalBackupDestination"/image ]] && _messageError 'fail: mkdir criticalBackupDestination/image= '"$criticalBackupDestination"/image && return 1
	#[[ ! -e "$criticalBackupDestination"/image.img ]] && echo -n > "$criticalBackupDestination"/image.img
	#[[ ! -e "$criticalBackupDestination"/image.img ]] && _messageError 'fail: mkdir criticalBackupDestination/image.img= '"$criticalBackupDestination"/image.img && return 1
	
	! _safeBackup "$criticalBackupDestination" && _messageError "check: _command_safeBackup" && return 1
	
	return 0
}

# WARNING Sets and accepts global variables. Do NOT reuse or recurse without careful consideration or guard statements.
#Generates "root@machine:/" format rsync address from machine name, user, and path.
#_rsync_sourceAddress "machine" "/path/" "user"
#_rsync_sourceAddress "machine" "" "user"
#"$1" == criticalSSHmachine
#"$2" == criticalSourcePath (optional)
#"$3" == criticalUser (optional)
_rsync_remoteAddress() {
	#root@machine:/
	#user@machine:
	#machine:
	
	[[ "$1" != "" ]] && export criticalSSHmachine="$1"
	[[ "$2" != "" ]] && export criticalSourcePath="$2"
	[[ "$3" != "" ]] && export criticalUser="$3"
	
	[[ "$criticalSourcePath" == "" ]] && [[ "$criticalUser" == "root" ]] && export criticalSourcePath="/"
	
	export criticalUserAddress="$criticalUser"
	[[ "$criticalUserAddress" != "" ]] && export criticalUserAddress="$criticalUser"'@'
	
	export criticalRsyncAddress="$criticalUserAddress""$criticalSSHmachine"':'"$criticalSourcePath"
	
	echo "$criticalRsyncAddress"
	
	[[ "$criticalSSHmachine" == "" ]] && return 1
	return 0
}

# WARNING Sets and accepts global variables. Do NOT reuse or recurse without careful consideration or guard statements.
#"$1" == criticalSSHmachine
#"$2" == criticalSourcePath (optional)
#"$3" == criticalUser (optional)
#"$4" == commandName
#_rsync_backup_remote "$machineName" "" "" "$commandName"
_rsync_backup_remote() {
	[[ "$1" != "" ]] && export criticalSSHmachine="$1"
	[[ "$2" != "" ]] && export criticalSourcePath="$2"
	[[ "$3" != "" ]] && export criticalUser="$3"
	
	[[ "$criticalUser" == "" ]] && export criticalUser=$(_command_ssh_user "$4")
	
	[[ "$criticalSSHmachine" == "" ]] && return 1
	
	_rsync_remoteAddress "$criticalSSHmachine" "$criticalSourcePath" "$criticalUser"
}

# WARNING Sets and accepts global variables. Do NOT reuse or recurse without careful consideration or guard statements.
#"$1" == criticalDestinationPrefix (optional, default "_arc")
#"$2" == $criticalDestinationPath (optional)
#"$3" == criticalUser (optional)
#"$4" == commandName
#_rsync_backup_local "" "" "" "$commandName"
_rsync_backup_local() {
	[[ "$1" != "" ]] && export criticalDestinationPrefix="$1"
	[[ "$criticalDestinationPrefix" == "" ]] && export criticalDestinationPrefix="_arc"
	
	[[ "$3" != "" ]] && export criticalUser="$3"
	[[ "$criticalUser" == "" ]] && export criticalUser=$(_command_ssh_user_field "$4")
	
	[[ "$2" != "" ]] && export criticalDestinationPath="$2"
	[[ "$criticalDestinationPath" == "" ]] && export criticalDestinationPath="$criticalUser"
	
	[[ "$criticalDestinationPath" == "" ]] && return 1
	
	export criticalDestinationPrefixAddress="$criticalDestinationPrefix"
	[[ "$criticalDestinationPrefixAddress" != "" ]] && export criticalDestinationPrefixAddress="$criticalDestinationPrefixAddress"'/'
	
	echo "$criticalDestinationPrefixAddress""$criticalDestinationPath"
}

_rsync() {
	rsync -e "$scriptAbsoluteLocation"" _ssh" "$@"
}

_ssh_internal_command() {
	_ssh -C -o ConnectionAttempts=3 "$@"
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
	_ssh_internal_command "$@" '
rm '"$safeTmpSSH"'/cautossh
rmdir '"$safeTmpSSH"'/_local > /dev/null 2>&1
rmdir '"$safeTmpSSH"'
'
	#Preventative workaround, not normally necessary.
	stty echo > /dev/null 2>&1
}

# WARNING: Intermittent unreliability due to unlikely port collision rate.
_get_ssh_external() {
	export remotePublicIPv4=$(_ssh_internal_command "$@" "$safeTmpSSH"'/cautossh' _find_public_ipv4 | tr -dc 'a-zA-Z0-9.:')
	export remotePublicIPv6=$(_ssh_internal_command "$@" "$safeTmpSSH"'/cautossh' _find_public_ipv6 | tr -dc 'a-zA-Z0-9.:')
	
	export remoteRouteIPv4=$(_ssh_internal_command "$@" "$safeTmpSSH"'/cautossh' _find_route_ipv4 | tr -dc 'a-zA-Z0-9.:')
	export remoteRouteIPv6=$(_ssh_internal_command "$@" "$safeTmpSSH"'/cautossh' _find_route_ipv6 | tr -dc 'a-zA-Z0-9.:')
	
	# Common practice to use separate ports for dynamic IPv4 and IPv6 services, due to some applications not supporting both simultaneously.
	export remotePortPublicIPv4=$(_ssh_internal_command "$@" "$safeTmpSSH"'/cautossh' _findPort 35500 49075 | tr -dc 'a-zA-Z0-9.:')
	export remotePortPublicIPv6=$(_ssh_internal_command "$@" "$safeTmpSSH"'/cautossh' _findPort 35500 49075 | tr -dc 'a-zA-Z0-9.:')
	
	export remotePortRouteIPv4=$(_ssh_internal_command "$@" "$safeTmpSSH"'/cautossh' _findPort 35500 49075 | tr -dc 'a-zA-Z0-9.:')
	export remotePortRouteIPv6=$(_ssh_internal_command "$@" "$safeTmpSSH"'/cautossh' _findPort 35500 49075 | tr -dc 'a-zA-Z0-9.:')
}

# WARNING: Intermittent unreliability due to significant port collision rate.
_get_ssh_relay() {
	export relayPortIn=$(_ssh_internal_command "$@" "$safeTmpSSH"'/cautossh' _findPort | tr -dc 'a-zA-Z0-9.:')
	export relayPortOut=$(_ssh_internal_command "$@" "$safeTmpSSH"'/cautossh' _findPort | tr -dc 'a-zA-Z0-9.:')
}

_prepare_ssh_fifo() {
	mkfifo "$safeTmp"/up
	mkfifo "$safeTmp"/down
	mkfifo "$safeTmp"/control
	mkfifo "$safeTmp"/back
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

_report_vncpasswd() {
	_messagePlain_probe 'report: _report_vncpasswd'
	
	! [[ -e "$vncPasswdFile".pln ]] && _messagePlain_bad 'missing: "$vncPasswdFile".pln' && return 0
	
	! [[ -s "$vncPasswdFile".pln ]] && _messagePlain_bad 'blank: "$vncPasswdFile".pln' && return 0
	
	if [[ -s "$vncPasswdFile".pln ]]
	then
		#Blue. Diagnostic instrumentation.
		echo -e -n '\E[0;34m '
		cat "$vncPasswdFile".pln
		echo -e -n ' \E[0m'
		echo
		return 0
	fi
	
	return 0
}

_vncpasswd() {
	_messagePlain_nominal "init: _vncpasswd"
	
	#TigerVNC, specifically.
	if type tigervncpasswd >/dev/null 2>&1
	then
		_messagePlain_good 'found: tigervnc'
		_report_vncpasswd
		! echo | cat "$vncPasswdFile".pln - "$vncPasswdFile".pln | tigervncpasswd "$vncPasswdFile" && _messagePlain_bad 'fail: vncpasswd' && return 1
		return 0
	fi
	
	#Supported by both TightVNC and TigerVNC.
	if echo | vncpasswd -x --help 2>&1 | grep -i 'vncpasswd \[FILE\]' >/dev/null 2>&1
	then
		_messagePlain_good 'found: vncpasswd'
		_report_vncpasswd
		! echo | cat "$vncPasswdFile".pln - "$vncPasswdFile".pln | vncpasswd "$vncPasswdFile" && _messagePlain_bad 'fail: vncpasswd' && return 1
		return 0
	fi
	
	type vncpasswd > /dev/null 2>&1 && _messagePlain_bad 'unsupported: vncpasswd'
	! type vncpasswd > /dev/null 2>&1 && _messagePlain_bad 'missing: vncpasswd'
	
	return 1
}

_vncviewer_sequence() {
	_messageNormal '_vncviewer_sequence: Start'
	_start
	
	_messageNormal '_vncviewer_sequence: Setting vncpasswd .'
	cat - > "$vncPasswdFile".pln
	_report_vncpasswd
	! _vncpasswd && _messageError 'FAIL: vncpasswd' && _stop 1
	
	_messageNormal '_vncviewer_sequence: Operations .'
	! _vncviewer_operations "$@" && _messageError 'FAIL: vncviewer' && _stop 1
	
	_messageNormal '_vncviewer_sequence: Stop'
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

_x11vnc_sequence() {
	_messageNormal '_x11vnc_sequence: Start'
	_start
	
	_messageNormal '_x11vnc_sequence: Setting vncpasswd .'
	cat - > "$vncPasswdFile".pln
	_report_vncpasswd
	! _vncpasswd && _messageError 'FAIL: vncpasswd' && _stop 1
	
	_messageNormal '_x11vnc_sequence: Operations .'
	! _x11vnc_operations && _messageError 'FAIL: x11vnc' && _stop 1
	
	_messageNormal '_x11vnc_sequence: Stop'
	_stop
}

#Password must be given on standard input. Environment variable "$vncPort" must be set. Environment variable "$destination_DISPLAY" may be forced.
_x11vnc() {
	"$scriptAbsoluteLocation" _x11vnc_sequence "$@"
}

_vncserver_sequence() {
	_messageNormal '_vncserver_sequence: Start'
	_start
	
	_messageNormal '_vncserver_sequence: Setting vncpasswd .'
	cat - > "$vncPasswdFile".pln
	! _vncpasswd && _messageError 'FAIL: vncpasswd' && _stop 1
	
	_messageNormal '_x11vnc_sequence: Operations .'
	! _vncserver_operations && _messageError 'FAIL: vncserver' && _stop 1
	
	_stop
}

#Password must be given on standard input. Environment variables "$vncPort", "$vncPIDfile", must be set. Environment variables "$desktopEnvironmentGeometry", "$desktopEnvironmentLaunch", may be forced.
_vncserver() {
	"$scriptAbsoluteLocation" _vncserver_sequence "$@"
}

#Environment variable "$vncPIDfile", must be set.
_vncserver_terminate() {
	
	# WARNING: For now, this does not always work with TigerVNC.
	if [[ -e "$vncPIDfile" ]] && [[ -s "$vncPIDfile" ]]
	then
		_messagePlain_good 'found: usable "$vncPIDfile"'
		
		pkill -P $(cat "$vncPIDfile")
		kill $(cat "$vncPIDfile")
		#sleep 1
		#kill -KILL $(cat "$vncPIDfile")
		rm "$vncPIDfile"
		
		pgrep Xvnc && _messagePlain_warn 'found: Xvnc process'
		pgrep Xtightvnc && _messagePlain_warn 'found: Xtightvnc process'
		pgrep Xtigervnc && _messagePlain_warn 'found: Xtigervnc process'
		
		return 0
	fi
	
	_messagePlain_bad 'missing: usable "$vncPIDfile'
	_messagePlain_bad 'terminate: Xvnc, Xtightvnc, Xtigervnc'
	
	pkill Xvnc
	pkill Xtightvnc
	pkill Xtigervnc
	rm "$vncPIDfile"
	
	return 1
}

_vnc_sequence() {
	_messageNormal '_vnc_sequence: Start'
	_start
	_start_safeTmp_ssh "$@"
	_prepare_vnc
	
	_messageNormal '_vnc_sequence: Launch: _x11vnc'
	
	# TODO WARNING Terminal echo (ie. "stty echo") lockup errors are possible as ssh is backgrounded without "-f".
	cat "$vncPasswdFile".pln | _vnc_ssh -L "$vncPort":localhost:"$vncPort" "$@" 'env vncPort='"$vncPort"' x11vnc_clip='"$x11vnc_clip"' x11vnc_scale='"$x11vnc_scale"' x11vnc_scale_cursor='"$x11vnc_scale_cursor"' '"$safeTmpSSH"/cautossh' _x11vnc' &
	
	_waitPort localhost "$vncPort"
	
	_messageNormal '_vnc_sequence: Ready: _waitPort localhost vncport= '"$vncPort"
	
	#VNC service may not always be ready when port is up.
	
	sleep 0.8
	if ! _checkPort localhost "$vncPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	_messageNormal '_vnc_sequence: Ready: sleep, _checkPort. Launch: _vncviewer'
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' destination_DISPLAY='"$DISPLAY"' destination_AUTH='"$XAUTHORITY"' vncviewer_startFull='"$vncviewer_startFull"' vncviewer_manual='"$vncviewer_manual"' '"$scriptAbsoluteLocation"' _vncviewer'
	'env vncPort='"$vncPort"' destination_DISPLAY='"$DISPLAY"' destination_AUTH='"$XAUTHORITY"' vncviewer_startFull='"$vncviewer_startFull"' vncviewer_manual='"$vncviewer_manual"' '"$scriptAbsoluteLocation"' _vncviewer'
	
	sleep 3
	if ! _checkPort localhost "$vncPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	_messageNormal '_vnc_sequence: Ready: sleep, _checkPort. Launch: _vncviewer'
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' destination_DISPLAY='"$DISPLAY"' destination_AUTH='"$XAUTHORITY"' vncviewer_startFull='"$vncviewer_startFull"' vncviewer_manual='"$vncviewer_manual"' '"$scriptAbsoluteLocation"' _vncviewer'
	
	sleep 9
	if ! _checkPort localhost "$vncPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	_messageNormal '_vnc_sequence: Ready: sleep, _checkPort. Launch: _vncviewer'
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' destination_DISPLAY='"$DISPLAY"' destination_AUTH='"$XAUTHORITY"' vncviewer_startFull='"$vncviewer_startFull"' vncviewer_manual='"$vncviewer_manual"' '"$scriptAbsoluteLocation"' _vncviewer'
	
	
	_messageNormal '_vnc_sequence: Done: final attempt: _vncviewer'
	
	_messageNormal '_vnc_sequence: Stop'
	stty echo > /dev/null 2>&1
	_stop_safeTmp_ssh "$@"
	_stop
}

_vnc() {
	"$scriptAbsoluteLocation" _vnc_sequence "$@"
}

_push_vnc_sequence() {
	_messageNormal '_push_vnc_sequence: Start'
	_start
	_start_safeTmp_ssh "$@"
	_prepare_vnc
	
	_messageNormal '_push_vnc_sequence: Launch: _x11vnc'
	
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' x11vnc_clip='"$x11vnc_clip"' x11vnc_scale='"$x11vnc_scale"' x11vnc_scale_cursor='"$x11vnc_scale_cursor"' '"$scriptAbsoluteLocation"' _x11vnc' &
	#-noxrecord -noxfixes -noxdamage
	
	_waitPort localhost "$vncPort"
	
	_messageNormal '_push_vnc_sequence: Ready: _waitPort localhost vncport= '"$vncPort"
	
	#VNC service may not always be ready when port is up.
	
	sleep 0.8
	if ! _checkPort localhost "$vncPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	_messageNormal '_push_vnc_sequence: Ready: sleep, _checkPort. Launch: _vncviewer'
	cat "$vncPasswdFile".pln | _vnc_ssh -R "$vncPort":localhost:"$vncPort" "$@" 'env vncPort='"$vncPort"' vncviewer_startFull='"$vncviewer_startFull"' vncviewer_manual='"$vncviewer_manual"' '"$safeTmpSSH"/cautossh' _vncviewer'
	
	sleep 3
	if ! _checkPort localhost "$vncPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	_messageNormal '_push_vnc_sequence: Ready: sleep, _checkPort. Launch: _vncviewer'
	cat "$vncPasswdFile".pln | _vnc_ssh -R "$vncPort":localhost:"$vncPort" "$@" 'env vncPort='"$vncPort"' vncviewer_startFull='"$vncviewer_startFull"' vncviewer_manual='"$vncviewer_manual"' '"$safeTmpSSH"/cautossh' _vncviewer'
	
	sleep 9
	if ! _checkPort localhost "$vncPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	_messageNormal '_push_vnc_sequence: Ready: sleep, _checkPort. Launch: _vncviewer'
	cat "$vncPasswdFile".pln | _vnc_ssh -R "$vncPort":localhost:"$vncPort" "$@" 'env vncPort='"$vncPort"' vncviewer_startFull='"$vncviewer_startFull"' vncviewer_manual='"$vncviewer_manual"' '"$safeTmpSSH"/cautossh' _vncviewer'
	
	_messageNormal '_push_vnc_sequence: Done: final attempt: _vncviewer'
	
	_messageNormal '_push_vnc_sequence: Stop'
	stty echo > /dev/null 2>&1
	_stop_safeTmp_ssh "$@"
	_stop 1
}

_push_vnc() {
	"$scriptAbsoluteLocation" _push_vnc_sequence "$@"
}

_desktop_sequence() {
	_messageNormal '_desktop_sequence: Start'
	_start
	_start_safeTmp_ssh "$@"
	_prepare_vnc
	
	_messageNormal '_vnc_sequence: Launch: _vncserver'
	# TODO WARNING Terminal echo (ie. "stty echo") lockup errors are possible as ssh is backgrounded without "-f".
	cat "$vncPasswdFile".pln | _vnc_ssh -L "$vncPort":localhost:"$vncPort" "$@" 'env vncPort='"$vncPort"' vncPIDfile='"$vncPIDfile"' desktopEnvironmentGeometry='"$desktopEnvironmentGeometry"' desktopEnvironmentLaunch='"$desktopEnvironmentLaunch"' '"$safeTmpSSH"/cautossh' _vncserver' &
	
	
	_waitPort localhost "$vncPort"
	sleep 0.8 #VNC service may not always be ready when port is up.
	
	_messageNormal '_vnc_sequence: Ready: _waitPort. Launch: _vncviewer'
	
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' destination_DISPLAY='"$DISPLAY"' destination_AUTH='"$XAUTHORITY"' vncviewer_startFull='"$vncviewer_startFull"' vncviewer_manual='"$vncviewer_manual"' '"$scriptAbsoluteLocation"' _vncviewer'
	stty echo > /dev/null 2>&1
	
	_messageNormal '_vnc_sequence: Terminate: _vncserver_terminate'
	
	_vnc_ssh "$@" 'env vncPIDfile='"$vncPIDfile"' '"$safeTmpSSH"/cautossh' _vncserver_terminate'
	
	_messageNormal '_desktop_sequence: Stop'
	_stop_safeTmp_ssh "$@"
	_stop
}

#Launches VNC server and client, with up to nine nonpersistent desktop environments.
_desktop() {
	"$scriptAbsoluteLocation" _desktop_sequence "$@"
}

_push_desktop_sequence() {
	_messageNormal '_push_desktop_sequence: Start'
	_start
	_start_safeTmp_ssh "$@"
	_prepare_vnc
	
	_messageNormal '_push_desktop_sequence: Launch: _vncserver'
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' vncPIDfile='"$vncPIDfile_local"' desktopEnvironmentGeometry='"$desktopEnvironmentGeometry"' desktopEnvironmentLaunch='"$desktopEnvironmentLaunch"' '"$scriptAbsoluteLocation"' _vncserver' &
	
	
	_waitPort localhost "$vncPort"
	sleep 0.8 #VNC service may not always be ready when port is up.
	
	_messageNormal '_push_desktop_sequence: Ready: _waitPort. Launch: _vncviewer'
	
	cat "$vncPasswdFile".pln | _vnc_ssh -R "$vncPort":localhost:"$vncPort" "$@" 'env vncPort='"$vncPort"' destination_DISPLAY='""' vncviewer_startFull='"$vncviewer_startFull"' vncviewer_manual='"$vncviewer_manual"' '"$safeTmpSSH"/cautossh' _vncviewer'
	stty echo > /dev/null 2>&1
	
	_messageNormal '_push_desktop_sequence: Terminate: _vncserver_terminate'
	
	bash -c 'env vncPIDfile='"$vncPIDfile_local"' '"$scriptAbsoluteLocation"' _vncserver_terminate'
	
	_messageNormal '_desktop_sequence: Stop'
	_stop_safeTmp_ssh "$@"
	_stop
}

_push_desktop() {
	"$scriptAbsoluteLocation" _push_desktop_sequence "$@"
}

#Builtin version of ssh-copy-id.
_ssh_copy_id() {
	_start
	
	#"$scriptAbsoluteLocation" _ssh "$@" 'mkdir -p "$HOME"/.ssh'
	cat "$scriptLocal"/ssh/id_rsa.pub | "$scriptAbsoluteLocation" _ssh "$@" 'mkdir -p "$HOME"/.ssh < /dev/null ; cat - >> "$HOME"/.ssh/authorized_keys'
	
	_stop
}
alias _ssh-copy-id=_ssh_copy_id

#Builtin version of ssh-copy-id.
_ssh_copy_id_gateway() {
	_start
	
	#"$scriptAbsoluteLocation" _ssh "$@" 'mkdir -p "$HOME"/.ssh'
	cat "$scriptLocal"/ssh/rev_gate.pub | "$scriptAbsoluteLocation" _ssh "$@" 'mkdir -p "$HOME"/.ssh < /dev/null ; cat - >> "$HOME"/.ssh/authorized_keys'
	
	_stop
}
alias _ssh-copy-id-gateway=_ssh_copy_id_gateway

#Builtin version of ssh-copy-id.
_ssh_copy_id_command() {
	_start
	
	#"$scriptAbsoluteLocation" _ssh "$@" 'mkdir -p "$HOME"/.ssh'
	cat "$scriptLocal"/ssh/rev_command.pub | "$scriptAbsoluteLocation" _ssh "$@" 'mkdir -p "$HOME"/.ssh < /dev/null ; cat - >> "$HOME"/.ssh/authorized_keys'
	
	_stop
}
alias _ssh-copy-id-command=_ssh_copy_id_command

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

_setup_ssh_rmKey() {
	rm -f "$scriptLocal"/ssh/"$1" >/dev/null 2>&1
	rm -f "$scriptLocal"/ssh/"$1".pub >/dev/null 2>&1
	rm -f "$sshDir"/"$1" >/dev/null 2>&1
	rm -f "$sshDir"/"$1".pub >/dev/null 2>&1
	rm -f "$sshLocalSSH"/"$1" >/dev/null 2>&1
	rm -f "$sshLocalSSH"/"$1".pub >/dev/null 2>&1
}

_setup_ssh_operations() {
	# "_setup_local" .
	[[ "$ub_setup_local" == 'true' ]] && export sshBase="$safeTmp"/.ssh
	
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
		_setup_ssh_rmKey id_rsa
		_setup_ssh_rmKey rev_gate
		_setup_ssh_rmKey rev_cmd
	fi
	
	if ! [[ -e "$scriptLocal"/ssh/id_rsa ]] && ! [[ -e "$sshLocalSSH"/id_rsa ]]
	then
		ssh-keygen -b 4096 -t rsa -N "" -f "$scriptLocal"/ssh/id_rsa -C cautossh@"$netName"
	fi
	
	#Less privileged key used by asset machines to establish persistent reverse tunnels ending at a gateway server.
	if ! [[ -e "$scriptLocal"/ssh/rev_gate ]] && ! [[ -e "$sshLocalSSH"/rev_gate ]]
	then
		ssh-keygen -b 4096 -t rsa -N "" -f "$scriptLocal"/ssh/rev_gate -C cautossh@"$netName"
	fi
	
	#Less privileged key used by random machines to establish temporary reverse tunnels ending at a command machine.
	if ! [[ -e "$scriptLocal"/ssh/rev_cmd ]] && ! [[ -e "$sshLocalSSH"/rev_cmd ]]
	then
		ssh-keygen -b 4096 -t rsa -N "" -f "$scriptLocal"/ssh/rev_cmd -C cautossh@"$netName"
	fi
	
	_here_ssh_config >> "$safeTmp"/config
	_cpDiff "$safeTmp"/config "$sshDir"/config
	
	_setup_ssh_copyKey id_rsa
	_setup_ssh_copyKey rev_gate
	_setup_ssh_copyKey rev_cmd
	
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
	_find_setupCommands -name '_ssh' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
	_find_setupCommands -name '_rsync' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
	
	_find_setupCommands -name '_sshfs' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
	
	_find_setupCommands -name '_web' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
	
	_find_setupCommands -name '_backup' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
	
	_find_setupCommands -name '_fs' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
	
	_find_setupCommands -name '_vnc' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
	_find_setupCommands -name '_push_vnc' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
	_find_setupCommands -name '_desktop' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
	_find_setupCommands -name '_push_desktop' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
	
	_find_setupCommands -name '_wake' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
	
	_find_setupCommands -name '_meta' -exec "$scriptAbsoluteLocation" _setupCommand_meta '{}' \;
}

_package_cautossh() {
	local localFunctionEntryPWD
	localFunctionEntryPWD="$PWD"
	cd "$scriptAbsoluteFolder"
	
	
	#cp -a "$scriptAbsoluteFolder"/_index "$safeTmp"/package
	
	#https://stackoverflow.com/questions/4585929/how-to-use-cp-command-to-exclude-a-specific-directory
	#find ./_index -type f -not -path '*_arc*' -exec cp -d --preserve=all '{}' "$safeTmp"'/package/''{}' \;
	
	mkdir -p ./_local
	rsync -av --progress --exclude "_arc" ./_index/ "$safeTmp"/package/_index/
	
	mkdir -p ./_local
	cp -a ./_local/ssh "$safeTmp"/package/_local/
	cp -a ./_local/tor "$safeTmp"/package/_local/
	
	
	cd "$localFunctionEntryPWD"
}

#May be overridden by "ops" if multiple gateways are required.
_ssh_autoreverse() {
	_torServer_SSH
	_autossh
	
	#_autossh firstGateway
	#_autossh secondGateway
}

# WARNING: Allows self to login as self to local SSH server with own SSH key.
# WARNING: Requires local SSH server listening on port 22.
#https://blog.famzah.net/2015/06/26/openssh-ciphers-performance-benchmark-update-2015/
_ssh_cipher_benchmark_local_sequence() {
	_start
	
	local localSSHpubKeySample
	localSSHpubKeySample=$(tail -c +9 "$HOME"/.ssh/id_rsa.pub | head -c 36 | tr -dc 'a-zA-Z0-9')
	
	mkdir -p "$HOME"/.ssh
	[[ ! -e "$HOME"/.ssh/id_rsa ]] && [[ ! -e "$HOME"/.ssh/id_rsa.pub ]] && ssh-keygen -b 4096 -t rsa -N "" -f "$HOME"/.ssh/id_rsa
	
	[[ ! -e "$HOME"/.ssh/authorized_keys ]] && echo >> "$HOME"/.ssh/authorized_keys
	
	! grep "$localSSHpubKeySample" "$HOME"/.ssh/authorized_keys > /dev/null 2>&1 && cat "$HOME"/.ssh/id_rsa.pub >> "$HOME"/.ssh/authorized_keys
	
	[[ ! -e "$HOME"/.ssh/id_rsa ]] && _messagePlain_bad 'fail: missing: ssh key private' && _stop 1
	[[ ! -e "$HOME"/.ssh/id_rsa.pub ]] && _messagePlain_bad 'fail: missing: ssh key public' && _stop 1
	[[ ! -e "$HOME"/.ssh/authorized_keys ]] && _messagePlain_bad 'fail: missing: ssh authorized_keys' && _stop 1
	
	_messagePlain_nominal '_ssh_cipher_benchmark: fill'
	dd if=/dev/urandom bs=1M count=512 | base64 > "$safeTmp"/fill
	[[ ! -e "$safeTmp"/fill ]] && _messagePlain_bad 'fail: missing: fill' && _stop 1
	
	_messagePlain_nominal '_ssh_cipher_benchmark: benchmark'
	# uses "$safeTmp"/dd.txt as a temporary file
	#for cipher in aes128-cbc aes128-ctr aes128-gcm@openssh.com aes192-cbc aes192-ctr aes256-cbc aes256-ctr aes256-gcm@openssh.com arcfour arcfour128 arcfour256 blowfish-cbc cast128-cbc chacha20-poly1305@openssh.com 3des-cbc
	for cipher in aes128-ctr aes128-gcm@openssh.com aes192-ctr aes256-ctr aes256-gcm@openssh.com chacha20-poly1305@openssh.com
	do
		for i in 1 2 3
		do
			_messagePlain_probe "Cipher: $cipher (try $i)"
			
			#dd if="$safeTmp"/fill bs=4M count=512 2>"$safeTmp"/dd.txt | pv --size 2G | time -p ssh -c "$cipher" "$USER"@localhost 'cat > /dev/null'
			dd if="$safeTmp"/fill bs=4M 2>/dev/null | ssh -c "$cipher" "$USER"@localhost 'dd of=/dev/null' 2>&1 | grep -v records
			#grep -v records "$safeTmp"/dd.txt
		done
	done
	
	
	_stop
}

_ssh_cipher_benchmark_remote_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	
	_ssh "$@" "$safeTmpSSH"'/cautossh _ssh_cipher_benchmark_local_sequence'
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_cipher_benchmark_local() {
	"$scriptAbsoluteLocation" _ssh_cipher_benchmark_local_sequence "$@"
}

_ssh_cipher_benchmark_remote() {
	"$scriptAbsoluteLocation" _ssh_cipher_benchmark_remote_sequence "$@"
}

_ssh_cipher_benchmark() {
	_ssh_cipher_benchmark_remote "$@"
}

_ssh_iperf_procedure() {
	_messagePlain_nominal 'iperf: A'
	local currentPort_iperf_up=$(_findPort)
	_messageCMD _ssh -o 'Compression=no' -L "$currentPort_iperf_up":localhost:"$currentPort_iperf_up" "$@" "$safeTmpSSH"/cautossh' '_ssh_benchmark_iperf_server' '"$currentPort_iperf_up" &
	sleep 5
	#_waitPort localhost "$currentPort_iperf_up"
	iperf3 -c "localhost" -p "$currentPort_iperf_up"
	
	_messagePlain_nominal 'iperf: B'
	local currentPort_iperf_down=$(_findPort)
	_ssh_benchmark_iperf_server "$currentPort_iperf_down" &
	sleep 5
	#_waitPort localhost "$currentPort_iperf_down"
	_messageCMD _ssh -o 'Compression=no' -R "$currentPort_iperf_down":localhost:"$currentPort_iperf_down" "$@" 'iperf3 -c localhost -p '"$currentPort_iperf_down"
}

_ssh_emit_procedure() {
	_messagePlain_nominal 'emit: upload'
	
	_messagePlain_probe '1k'
	dd if=/dev/urandom bs=1k count=1 2>/dev/null | base64 > "$safeTmp"/fill_001k
	dd if="$safeTmp"/fill_001k bs=512 2>/dev/null | _timeout 5 _ssh "$@" 'dd of=/dev/null' 2>&1 | grep -v records
	_messagePlain_probe '10k'
	dd if=/dev/urandom bs=1k count=10 2>/dev/null | base64 > "$safeTmp"/fill_010k
	dd if="$safeTmp"/fill_010k bs=1k 2>/dev/null | _timeout 5 _ssh "$@" 'dd of=/dev/null' 2>&1 | grep -v records
	
	_messagePlain_probe '1M'
	dd if=/dev/urandom bs=1M count=1 2>/dev/null | base64 > "$safeTmp"/fill_001M
	dd if="$safeTmp"/fill_001M bs=4096 2>/dev/null | _timeout 10 _ssh "$@" 'dd of=/dev/null' 2>&1 | grep -v records
	_messagePlain_probe '10M'
	dd if=/dev/urandom bs=1M count=10 2>/dev/null | base64 > "$safeTmp"/fill_010M
	dd if="$safeTmp"/fill_010M bs=4096 2>/dev/null | _timeout 30 _ssh "$@" 'dd of=/dev/null' 2>&1 | grep -v records
	
	_messagePlain_probe '100M'
	dd if=/dev/urandom bs=1M count=100 2>/dev/null | base64 > "$safeTmp"/fill_100M
	dd if="$safeTmp"/fill_100M bs=4096 2>/dev/null | _timeout 45 _ssh "$@" 'dd of=/dev/null' 2>&1 | grep -v records
	
	# WARNING: Less reliable test, non-link bottlenecks.
	_messagePlain_nominal 'emit: download'
	
	# https://superuser.com/questions/792427/creating-a-large-file-of-random-bytes-quickly
	#dd if=<(openssl enc -aes-256-ctr -pass pass:"$(dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64)" -nosalt < /dev/zero) bs=1M count=100 iflag=fullblock
	
	_timeout 45 _ssh "$@" 'dd if=<(openssl enc -aes-256-ctr -pass pass:"$(head -c 128 /dev/urandom | base64)" -nosalt < /dev/zero 2> /dev/null ) bs=1M count=15 iflag=fullblock 2>/dev/null' | dd bs=1M of=/dev/null | grep -v records
}

_ssh_benchmark_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	_prepare_ssh_fifo
	
	_messagePlain_nominal 'get: external'
	#_get_ssh_external "$@"
	#_messagePlain_nominal 'get: relay'
	#_get_ssh_relay "$@"
	
	_ssh_cycle "$@"
	
	_ssh_latency_procedure "$@"
	
	_ssh_iperf_procedure "$@"
	_ssh_emit_procedure "$@"
	
	_ssh_common_internal_procedure "$@"
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_benchmark() {
	"$scriptAbsoluteLocation" _ssh_benchmark_sequence "$@"
}

_ssh_pulse_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	_prepare_ssh_fifo
	
	_messagePlain_nominal 'get: external'
	_get_ssh_external "$@"
	#_messagePlain_nominal 'get: relay'
	#_get_ssh_relay "$@"
	
	_ssh_ping_public_procedure "$@"
	_ssh_ping_route_procedure "$@"
	
	_ssh_iperf_raw_public_procedure "$@"
	_ssh_iperf_raw_route_procedure "$@"
	
	_ssh_common_external_public_procedure "$@"
	_ssh_common_external_route_procedure "$@"
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_pulse() {
	"$scriptAbsoluteLocation" _ssh_pulse_sequence "$@"
}

_ssh_check_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	_prepare_ssh_fifo
	
	_messagePlain_nominal 'get: external'
	_get_ssh_external "$@"
	#_messagePlain_nominal 'get: relay'
	#_get_ssh_relay "$@"
	
	_ssh_cycle "$@"
	
	_ssh_latency_procedure "$@"
	
	_ssh_iperf_procedure "$@"
	_ssh_emit_procedure "$@"
	
	
	_ssh_ping_public_procedure "$@"
	_ssh_ping_route_procedure "$@"
	
	_ssh_iperf_raw_public_procedure "$@"
	_ssh_iperf_raw_route_procedure "$@"
	
	_ssh_common_external_public_procedure "$@"
	_ssh_common_external_route_procedure "$@"
	
	stop_safeTmp_ssh "$@"
	_stop
}

_ssh_check() {
	"$scriptAbsoluteLocation" _ssh_check_sequence "$@"
}


# Tests showed slightly better performance with netcat vs socat, and 2-3x improvement over SSH.
# Stream of pseudorandom bytes to whoever connects. Intended only for benchmarking.
# "$1" == listen port
# "$2" == MB (MegaBytes)
_ssh_benchmark_download_public_source_sequence_ipv4() {
	dd if=<(openssl enc -aes-256-ctr -pass pass:"$(head -c 128 /dev/urandom | base64)" -nosalt < /dev/zero 2> /dev/null ) bs=1M count="$2" iflag=fullblock 2>/dev/null | socat -4 - TCP-LISTEN:"$1"
	
	#openssl enc -aes-256-ctr -pass pass:$(dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64) -nosalt < /dev/zero) | socat - TCP-LISTEN:"10000" > /dev/null 2>&1 &
	#openssl enc -aes-256-ctr -pass pass:"$(head -c 128 /dev/urandom | base64)" -nosalt < /dev/zero 2>/dev/null | head -c 15000000 | socat - TCP-LISTEN:"10000"
	
	#socat -u /dev/zero TCP4-LISTEN:10000
	#_proxy_direct 45.62.232.168 10000 | dd bs=1M count=15 of=/dev/null iflag=fullblock
	
	#socat -u /dev/zero TCP4-LISTEN:10000
	#socat -u TCP4:45.62.232.168:10000 STDOUT | dd of=/dev/null iflag=fullblock bs=1M count=100
}

_ssh_benchmark_download_public_source_ipv4() {
	nohup "$scriptAbsoluteLocation" _ssh_benchmark_download_public_source_sequence_ipv4 "$@" > /dev/null 2>&1 &
}

# Tests showed slightly better performance with netcat vs socat, and 2-3x improvement over SSH.
# Stream of pseudorandom bytes to whoever connects. Intended only for benchmarking.
# "$1" == listen port
# "$2" == MB (MegaBytes)
_ssh_benchmark_download_public_source_sequence_ipv6() {
	dd if=<(openssl enc -aes-256-ctr -pass pass:"$(head -c 128 /dev/urandom | base64)" -nosalt < /dev/zero 2> /dev/null ) bs=1M count="$2" iflag=fullblock 2>/dev/null | socat -6 - TCP-LISTEN:"$1"
}

_ssh_benchmark_download_public_source_ipv6() {
	nohup "$scriptAbsoluteLocation" _ssh_benchmark_download_public_source_sequence_ipv6 "$@" > /dev/null 2>&1 &
}

_ssh_benchmark_iperf_server() {
	"$scriptAbsoluteLocation" _timeout 300 iperf3 -s -p "$1" > /dev/null 2>&1
}

_ssh_benchmark_iperf_server_ipv4() {
	nohup "$scriptAbsoluteLocation" _timeout 300 iperf3 -s -p "$1" > /dev/null 2>&1 &
}

_ssh_benchmark_iperf_server_ipv6() {
	nohup "$scriptAbsoluteLocation" _timeout 300 iperf3 -V -s -p "$1" > /dev/null 2>&1 &
}

_ssh_benchmark_iperf_client_ipv4() {
	_timeout 120 iperf3 -c "$1" -p "$2"
}

_ssh_benchmark_iperf_client_ipv4_rev() {
	_timeout 120 iperf3 -c "$1" -p "$2" -R
}

_ssh_benchmark_iperf_client_ipv6() {
	_timeout 120 iperf3 -V -c "$1" -p "$2"
}

_ssh_benchmark_iperf_client_ipv6_rev() {
	_timeout 120 iperf3 -V -c "$1" -p "$2" -R
}

_ssh_benchmark_download_raw_procedure_ipv4() {
	#_messagePlain_probe _ssh_benchmark_download_public_source_ipv4 "$remotePortPublicIPv4"
	_ssh "$@" "$safeTmpSSH_alt"'/cautossh'' '_ssh_benchmark_download_public_source_ipv4' '"$remotePortPublicIPv4"' '25 > /dev/null 2>&1 &
	
	sleep 3
	
	#_messagePlain_nominal '_download: public IPv4'
	#_messagePlain_probe _proxy_direct "$remotePublicIPv4" "$remotePortPublicIPv4"
	_proxy_direct "$remotePublicIPv4" "$remotePortPublicIPv4"
}

_ssh_benchmark_download_raw_procedure_ipv6() {
	_messagePlain_probe _ssh_benchmark_download_public_source_ipv6 "$remotePortPublicIPv6"
	_ssh "$@" "$safeTmpSSH_alt"'/cautossh'' '_ssh_benchmark_download_public_source_ipv6' '"$remotePortPublicIPv6"' '25 > /dev/null 2>&1 &
	
	sleep 3
	
	#_messagePlain_nominal '_download: public IPv6'
	#_messagePlain_probe _proxy_direct "$remotePublicIPv4" "$remotePortPublicIPv6"
	_proxy_direct "$remotePublicIPv6" "$remotePortPublicIPv6"
}

# Establishes raw tunel and transmits random binary data through it as bandwidth test.
# DANGER: Even with many parallel streams, this technique tends to be inaccurate.
# CAUTION: Generally, SSH connections are to be preferred for simplicity and flexiblity.
# WARNING: ATTENTION: Considered to use relatively poor programming practices.
# WARNING: Requires public IP address, LAN IP address, and/or forwarded ports 35500-49075 .
# WARNING: Intended to produce end-user data. Use multiple specific IPv4 or IPv6 tests at a static address if greater reliability is needed.
_ssh_benchmark_download_raw() {
	_start
	_start_safeTmp_ssh "$@"
	
	_messagePlain_nominal 'get: external'
	_get_ssh_external "$@"
	
	mkfifo "$safeTmp"/aggregate_fifo
	
	export safeTmpSSH_alt="$safeTmpSSH"
	
	_messagePlain_nominal '_download: public IPv4: establishing links'
	
	local currentIteration
	for ((currentIteration=0; currentIteration < "12"; currentIteration++))
	do
		"$scriptAbsoluteLocation" _ssh_benchmark_download_raw_procedure_ipv4 "$@" > "$safeTmp"/aggregate_fifo &
		#head -c 100000000 /dev/urandom > "$safeTmp"/aggregate_fifo &
	done
	
	sleep 12
	
	_messagePlain_nominal '_download: public IPv4: downloading'
	dd if="$safeTmp"/aggregate_fifo of=/dev/null iflag=fullblock
	#cat "$safeTmp"/aggregate_fifo
	
	sleep 2
	
	
	
	_messagePlain_nominal '_download: public IPv6: establishing links'
	
	local currentIteration
	for ((currentIteration=0; currentIteration < "12"; currentIteration++))
	do
		"$scriptAbsoluteLocation" _ssh_benchmark_download_raw_procedure_ipv6 "$@" > "$safeTmp"/aggregate_fifo &
		#head -c 100000000 /dev/urandom > "$safeTmp"/aggregate_fifo &
	done
	
	sleep 12
	
	_messagePlain_nominal '_download: public IPv6: downloading'
	dd if="$safeTmp"/aggregate_fifo of=/dev/null iflag=fullblock
	#cat "$safeTmp"/aggregate_fifo
	
	sleep 2
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_iperf_raw_public_procedure() {
	_messagePlain_probe _ssh_benchmark_iperf_server_ipv4 "$remotePortPublicIPv4"
	_ssh "$@" "$safeTmpSSH"'/cautossh' _ssh_benchmark_iperf_server_ipv4 "$remotePortPublicIPv4" | tr -dc 'a-zA-Z0-9.:'
	
	#_waitPort "$remotePublicIPv4" "$remotePortPublicIPv4"
	sleep 3
	
	_messagePlain_nominal 'iperf: A: public IPv4'
	_messagePlain_probe _ssh_benchmark_iperf_client_ipv4 "$remotePublicIPv4" "$remotePortPublicIPv4"
	_ssh_benchmark_iperf_client_ipv4 "$remotePublicIPv4" "$remotePortPublicIPv4"
	
	_messagePlain_nominal 'iperf: B: public IPv4'
	_messagePlain_probe _ssh_benchmark_iperf_client_ipv4_rev "$remotePublicIPv4" "$remotePortPublicIPv4"
	_ssh_benchmark_iperf_client_ipv4_rev "$remotePublicIPv4" "$remotePortPublicIPv4"
	
	_messagePlain_probe _ssh_benchmark_iperf_server_ipv6 "$remotePortPublicIPv6"
	_ssh "$@" "$safeTmpSSH"'/cautossh' _ssh_benchmark_iperf_server_ipv6 "$remotePortPublicIPv6" | tr -dc 'a-zA-Z0-9.:'
	
	#_waitPort "$remotePublicIPv6" "$remotePortPublicIPv6"
	sleep 3
	
	_messagePlain_nominal 'iperf: A: public IPv6'
	_messagePlain_probe _ssh_benchmark_iperf_client_ipv6 "$remotePublicIPv6" "$remotePortPublicIPv6"
	_ssh_benchmark_iperf_client_ipv6 "$remotePublicIPv6" "$remotePortPublicIPv6"
	
	_messagePlain_nominal 'iperf: B: public IPv6'
	_messagePlain_probe _ssh_benchmark_iperf_client_ipv6_rev "$remotePublicIPv6" "$remotePortPublicIPv6"
	_ssh_benchmark_iperf_client_ipv6_rev "$remotePublicIPv6" "$remotePortPublicIPv6"
	
	sleep 2
}

_ssh_iperf_raw_route_procedure() {
	_messagePlain_probe _ssh_benchmark_iperf_server_ipv4 "$remotePortRouteIPv4"
	_ssh "$@" "$safeTmpSSH"'/cautossh' _ssh_benchmark_iperf_server_ipv4 "$remotePortRouteIPv4" | tr -dc 'a-zA-Z0-9.:'
	
	#_waitPort "$remoteRouteIPv4" "$remotePortRouteIPv4"
	sleep 3
	
	_messagePlain_nominal 'iperf: A: route IPv4'
	_messagePlain_probe _ssh_benchmark_iperf_client_ipv4 "$remoteRouteIPv4" "$remotePortRouteIPv4"
	_ssh_benchmark_iperf_client_ipv4 "$remoteRouteIPv4" "$remotePortRouteIPv4"
	
	_messagePlain_nominal 'iperf: B: route IPv4'
	_messagePlain_probe _ssh_benchmark_iperf_client_ipv4_rev "$remoteRouteIPv4" "$remotePortRouteIPv4"
	_ssh_benchmark_iperf_client_ipv4_rev "$remoteRouteIPv4" "$remotePortRouteIPv4"
	
	_messagePlain_probe _ssh_benchmark_iperf_server_ipv6 "$remotePortRouteIPv6"
	_ssh "$@" "$safeTmpSSH"'/cautossh' _ssh_benchmark_iperf_server_ipv6 "$remotePortRouteIPv6" | tr -dc 'a-zA-Z0-9.:'
	
	#_waitPort "$remoteRouteIPv6" "$remotePortRouteIPv6"
	sleep 3
	
	_messagePlain_nominal 'iperf: A: route IPv6'
	_messagePlain_probe _ssh_benchmark_iperf_client_ipv6 "$remoteRouteIPv6" "$remotePortRouteIPv6"
	_ssh_benchmark_iperf_client_ipv6 "$remoteRouteIPv6" "$remotePortRouteIPv6"
	
	_messagePlain_nominal 'iperf: B: route IPv6'
	_messagePlain_probe _ssh_benchmark_iperf_client_ipv6_rev "$remoteRouteIPv6" "$remotePortRouteIPv6"
	_ssh_benchmark_iperf_client_ipv6_rev "$remoteRouteIPv6" "$remotePortRouteIPv6"
	
	sleep 2
}

# Establishes raw connection and runs iperf across it.
# DANGER: Not completely tested. May be inaccurate.
# CAUTION: Generally, SSH connections are to be preferred for simplicity and flexiblity.
# WARNING: Requires public IP address, LAN IP address, and/or forwarded ports 35500-49075 .
# WARNING: Intended to produce end-user data. Use multiple specific IPv4 or IPv6 tests at a static address if greater reliability is needed.
_ssh_iperf_public_raw_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	
	_messagePlain_nominal 'get: external'
	_get_ssh_external "$@"
	
	_ssh_iperf_raw_public_procedure "$@"
	
	_stop_safeTmp_ssh "$@"
	_stop
}

# Establishes raw connection and runs iperf across it.
# DANGER: Not completely tested. May be inaccurate.
# CAUTION: Generally, SSH connections are to be preferred for simplicity and flexiblity.
# WARNING: Requires public IP address, LAN IP address, and/or forwarded ports 35500-49075 .
# WARNING: Intended to produce end-user data. Use multiple specific IPv4 or IPv6 tests at a static address if greater reliability is needed.
_ssh_iperf_route_raw_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	
	_messagePlain_nominal 'get: external'
	
	_messagePlain_nominal 'get: external'
	_get_ssh_external "$@"
	
	_ssh_iperf_raw_route_procedure "$@"
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_ping_public_procedure() {
	_messagePlain_nominal 'ping: public: IPv4'
	_messageCMD ping -4 -U -i 1 -c 3 "$remotePublicIPv4"
	
	_messagePlain_nominal 'ping: public: IPv6'
	_messageCMD ping -6 -U -i 1 -c 3 "$remotePublicIPv6"
}

_ssh_ping_public_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	
	_messagePlain_nominal 'get: external'
	_get_ssh_external "$@"
	
	_ssh_ping_public_procedure "$@"
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_ping_public() {
	"$scriptAbsoluteLocation" _ssh_ping_public_sequence "$@"
}

_ssh_ping_route_procedure() {
	_messagePlain_nominal 'ping: route: IPv4'
	_messageCMD ping -4 -U -i 1 -c 3 "$remoteRouteIPv4"
	
	_messagePlain_nominal 'ping: route: IPv6'
	_messageCMD ping -6 -U -i 1 -c 3 "$remoteRouteIPv6"
}

_ssh_ping_route_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	
	_messagePlain_nominal 'get: external'
	_get_ssh_external "$@"
	
	_ssh_ping_route_procedure "$@"
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_ping_route() {
	"$scriptAbsoluteLocation" _ssh_ping_route_sequence "$@"
}

_ssh_ping_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	
	_messagePlain_nominal 'get: external'
	_get_ssh_external "$@"
	
	_ssh_ping_public_procedure "$@"
	_ssh_ping_route_procedure "$@"
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_ping() {
	"$scriptAbsoluteLocation" _ssh_ping_sequence "$@"
}

_ssh_cycle() {
	_messagePlain_nominal 'cycle: ms'
	_stopwatch _ssh "$@" true
}

# WARNING: May be significantly inflated. Consider as a 'worst case' measurement.
# ATTENTION: Values comparable to "$netTimeout" indicate failure.
# PREREQUSITE: _get_ssh_relay "$@"
_ssh_latency_net_procedure() {
	(
		_messagePlain_nominal 'latency: ms'
		
		local currentPortIn=$(_findPort)
		local currentPortOut=$(_findPort)
		
		#_messagePlain_probe 'socat -4 - TCP-LISTEN:'"$currentPortOut"' > /dev/null 2>&1 &'
		_timeout "$netTimeout" socat -4 - TCP-LISTEN:"$currentPortOut" | head -c 1 > /dev/null 2>&1 &
		
		#_messagePlain_probe '_ssh '"$@"' -L '"$currentPortIn"':localhost:'"$relayPortOut"' -R '"$relayPortIn"':localhost:'"$currentPortOut"' socat tcp-listen:'"$relayPortOut"' tcp:localhost:'"$relayPortIn"' &'
		_timeout "$netTimeout" _ssh "$@" -L "$currentPortIn":localhost:"$relayPortOut" -R "$relayPortIn":localhost:"$currentPortOut" socat tcp-listen:"$relayPortOut" tcp:localhost:"$relayPortIn" &
		
		sleep 3
		
		#_messagePlain_probe 'echo -n 1 | _proxy_direct localhost '"$currentPortIn"
		echo -n 1 | _proxy_direct localhost "$currentPortIn" > /dev/null 2>&1
		
		( sleep 6 ; echo -n 1 | _proxy_direct localhost "$currentPortIn" ) &
		( sleep 9 ; echo -n 1 | _proxy_direct localhost "$currentPortIn" ) &
		( sleep $(expr "$netTimeout" - 2) ; echo -n 1 | _proxy_direct localhost "$currentPortIn" ) &
		
		#_messagePlain_probe wait %1
		_stopwatch wait %1
	)
}


# WARNING: May not be an exact measurement, especially at ranges near 3second . Expected error is less than approximately plus cycle time.
#https://serverfault.com/questions/807910/measure-total-latency-of-ssh-session
#https://www.cyberciti.biz/faq/linux-unix-read-one-character-atatime-while-loop/
_ssh_latency_character_procedure() {
	_messagePlain_nominal 'latency: ms'
	
	sleep 90 < "$safeTmp"/down &
	#sleep 90 > "$safeTmp"/up &
	
	(
	
	sleep 3
	
	cat "$safeTmp"/down > /dev/null 2>&1 &
	
	echo -n 1 > "$safeTmp"/up
	_stopwatch wait
	
	) &
	
	cat "$safeTmp"/up | _ssh "$@" head -c 1 > "$safeTmp"/down
	
	return 0
}

# WARNING: Depends on python resources.
_ssh_latency_python_procedure() {
	_messagePlain_nominal 'latency: ms'
	
	python -m timeit -n 25 -s 'import subprocess; p = subprocess.Popen(["'"$scriptAbsoluteLocation"'", "_ssh", "'"$@"'", "cat"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, bufsize=0); p.stdin.write(b"z"); assert p.stdout.read(1) == b"z"' 'p.stdin.write(b"z"); assert p.stdout.read(1) == b"z"'
}

_ssh_latency_procedure() {
	_ssh_latency_python_procedure "$@"
}

_ssh_latency_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	_prepare_ssh_fifo
	
	#_messagePlain_nominal 'get: external'
	#_get_ssh_external "$@"
	#_messagePlain_nominal 'get: relay'
	#_get_ssh_relay "$@"
	
	#_ssh_latency_net_procedure "$@"
	
	#_ssh_latency_character_procedure "$@"
	
	_ssh_latency_python_procedure "$@"
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_latency() {
	"$scriptAbsoluteLocation" _ssh_latency_sequence "$@"
}


# Checks common ports.
_ssh_common_internal_procedure() {
	_messagePlain_nominal 'nmap: IPv4'
	ssh "$@" nmap localhost -p 22,80,443
	
	_messagePlain_nominal 'nmap: IPv6'
	ssh "$@" nmap -6 localhost -p 22,80,443
}


_ssh_common_external_public_procedure() {
	_messagePlain_nominal 'nmap: public IPv4'
	nmap "$remotePublicIPv4" -p 22,80,443
	
	_messagePlain_nominal 'nmap: public IPv6'
	nmap -6 "$remotePublicIPv6" localhost -p 22,80,443
}

_ssh_common_external_route_procedure() {
	_messagePlain_nominal 'nmap: route IPv4'
	nmap "$remoteRouteIPv4" -p 22,80,443
	
	_messagePlain_nominal 'nmap: route IPv6'
	nmap -6 "$remoteRouteIPv6" -p 22,80,443
}


