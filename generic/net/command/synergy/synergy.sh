_test_synergy() {
	_getDep synergy
	_getDep synergyc
	_getDep synergys
	#_getDep quicksynergy
}

_synergy_ssh() {
	"$scriptAbsoluteLocation" _ssh -C -c aes256-gcm@openssh.com -m hmac-sha1 -o ConnectionAttempts=2 -o ServerAliveInterval=5 -o ServerAliveCountMax=5 -o ExitOnForwardFailure=yes "$@" 
}

_findPort_synergy() {
	_findPort
}

_prepare_synergy() {
	export synergyPort=$(_findPort_synergy)
	_messagePlain_probe 'synergyPort= '"$synergyPort"
	
	export synergyPIDfile="$safeTmpSSH"/.synpid
	export synergyPIDfile_local="$safeTmp"/.synpid
}

_synergy_command_client() {
	#[[ "$synergyRemoteHostname" == "" ]] && export synergyRemoteHostname="generic"
	#export HOME="$HOME"/'.ubcore'/net/"$synergyRemoteHostname"
	
	#export HOME="$HOME"/'.ubcore'/net/synergy
	
	mkdir -p "$HOME"
	cd "$HOME"
	
	synergyc --no-daemon "$@"
}

_synergy_command_server() {
	#[[ "$synergyRemoteHostname" == "" ]] && export synergyRemoteHostname="generic"
	#export HOME="$HOME"/'.ubcore'/net/"$synergyRemoteHostname"
	
	#export HOME="$HOME"/'.ubcore'/net/synergy
	
	mkdir -p "$HOME"
	cd "$HOME"
	
	pgrep ^synergy$ && sleep 48 && return 0
	
	synergy "$@" &
	[[ "$synergyPIDfile" != "" ]] && echo $! > "$synergyPIDfile"
	sleep 48
}

_synergyc_operations() {
	_messagePlain_nominal 'init: _synergyc_operations'
	
	_messagePlain_nominal 'Searching for X11 display.'
	! _detect_x11 && _messagePlain_warn 'fail: _detect_x11'
	
	export DISPLAY="$destination_DISPLAY"
	export XAUTHORITY="$destination_AUTH"
	_messagePlain_probe '_synergyc_operations'
	_report_detect_x11
	
	_messagePlain_nominal 'Launching synergy (client).'
	
	_synergy_command_client --no-restart localhost:"$synergyPort"
}

_synergyc() {
	"$scriptAbsoluteLocation" _synergyc_operations "$@"
}

_synergys_operations() {
	_messagePlain_nominal 'init: _synergys_operations'
	
	_messagePlain_nominal 'Searching for X11 display.'
	! _detect_x11 && _messagePlain_warn 'fail: _detect_x11'
	
	export DISPLAY="$destination_DISPLAY"
	export XAUTHORITY="$destination_AUTH"
	_messagePlain_probe '_synergys_operations'
	_report_detect_x11
	
	_messagePlain_nominal 'Launching synergy (server).'
	
	_synergy_command_server "$@"
}

#No production use.
_synergys_terminate() {
	if [[ -e "$synergyPIDfile" ]] && [[ -s "$synergyPIDfile" ]]
	then
		_messagePlain_good 'found: usable "$synergyPIDfile"'
		
		pkill -P $(cat "$synergyPIDfile")
		kill $(cat "$synergyPIDfile")
		#sleep 1
		#kill -KILL $(cat "$synergyPIDfile")
		rm "$synergyPIDfile"
		
		pgrep "^synergy$" && _messagePlain_warn 'found: synergy process'
		
		return 0
	fi
	
	_messagePlain_bad 'missing: usable "$synergyPIDfile'
	_messagePlain_bad 'terminate: ^synergy$'
	
	pkill ^synergy$
	
	return 1
}

#No production use.
_synergyc_terminate() {
	if [[ -e "$synergyPIDfile" ]] && [[ -s "$synergyPIDfile" ]]
	then
		_messagePlain_good 'found: usable "$synergyPIDfile"'
		
		pkill -P $(cat "$synergyPIDfile")
		kill $(cat "$synergyPIDfile")
		#sleep 1
		#kill -KILL $(cat "$synergyPIDfile")
		rm "$synergyPIDfile"
		
		pgrep "^synergyc$" && _messagePlain_warn 'found: synergyc process'
		
		return 0
	fi
	
	_messagePlain_bad 'missing: usable "$synergyPIDfile'
	_messagePlain_bad 'terminate: ^synergyc$'
	
	pkill ^synergyc$
	
	rm "$synergyPIDfile"
	
	return 1
}

_synergys() {
	"$scriptAbsoluteLocation" _synergys_operations "$@"
}

_synergy_sequence() {
	_messageNormal '_synergy_sequence Start'
	_start
	_start_safeTmp_ssh "$@"
	_prepare_synergy
	
	_messageNormal '_synergy_sequence Launch: _synergys'
	_synergy_ssh -L "$synergyPort":localhost:24800 "$@" 'env synergyPort='"$synergyPort"' '"$safeTmpSSH"/cautossh' _synergys' &
	
	_waitPort localhost "$synergyPort"
	
	_messageNormal 'synergy_sequence: Ready: _waitPort localhost synergyport= '"$synergyPort"
	
	#Service may not always be ready when port is up.
	
	sleep 0.8
	if ! _checkPort localhost "$synergyPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	
	_messageNormal '_synergy_sequence: Ready: sleep, _checkPort. Launch: _synergyc'
	
	bash -c 'env synergyPort='"$synergyPort"' destination_DISPLAY='"$DISPLAY"' destination_AUTH='"$XAUTHORITY"' '"$scriptAbsoluteLocation"' _synergyc'
	
	sleep 3
	if ! _checkPort localhost "$synergyPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	
	_messageNormal '_synergy_sequence: Ready: sleep, _checkPort. Launch: _synergyc'
	
	bash -c 'env synergyPort='"$synergyPort"' destination_DISPLAY='"$DISPLAY"' destination_AUTH='"$XAUTHORITY"' '"$scriptAbsoluteLocation"' _synergyc'
	
	sleep 9
	if ! _checkPort localhost "$synergyPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	
	_messageNormal '_synergy_sequence: Ready: sleep, _checkPort. Launch: _synergyc'
	
	bash -c 'env synergyPort='"$synergyPort"' destination_DISPLAY='"$DISPLAY"' destination_AUTH='"$XAUTHORITY"' '"$scriptAbsoluteLocation"' _synergyc'
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_synergy() {
	"$scriptAbsoluteLocation" _synergy_sequence "$@"
}

_push_synergy_sequence() {
	_messageNormal '_synergy_sequence Start'
	_start
	_start_safeTmp_ssh "$@"
	_prepare_synergy
	
	_messageNormal '_synergy_sequence Launch: _synergys'
	bash -c 'env synergyPort='"$synergyPort"' destination_DISPLAY='"$DISPLAY"' destination_AUTH='"$XAUTHORITY"' '"$scriptAbsoluteLocation"' _synergys' &
	
	_waitPort localhost "$synergyPort"
	
	_messageNormal 'synergy_sequence: Ready: _waitPort localhost synergyport= '"$synergyPort"
	
	#Service may not always be ready when port is up.
	
	sleep 0.8
	if ! _checkPort localhost "$synergyPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	
	_messageNormal '_synergy_sequence: Ready: sleep, _checkPort. Launch: _synergyc'
	
	_synergy_ssh -L "$synergyPort":localhost:24800 "$@" 'env synergyPort='"$synergyPort"' '"$safeTmpSSH"/cautossh' _synergyc'
	
	sleep 3
	if ! _checkPort localhost "$synergyPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	
	_messageNormal '_synergy_sequence: Ready: sleep, _checkPort. Launch: _synergyc'
	
	_synergy_ssh -L "$synergyPort":localhost:24800 "$@" 'env synergyPort='"$synergyPort"' '"$safeTmpSSH"/cautossh' _synergyc'
	
	sleep 9
	if ! _checkPort localhost "$synergyPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	
	_messageNormal '_synergy_sequence: Ready: sleep, _checkPort. Launch: _synergyc'
	
	_synergy_ssh -L "$synergyPort":localhost:24800 "$@" 'env synergyPort='"$synergyPort"' '"$safeTmpSSH"/cautossh' _synergyc'
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_push_synergy() {
	"$scriptAbsoluteLocation" _push_synergy_sequence "$@"
}
