_test_synergy() {
	_getDep synergy
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
}

_synergy_command() {
	#[[ "$synergyRemoteHostname" == "" ]] && export synergyRemoteHostname="generic"
	#export HOME="$HOME"/'.ubcore'/net/"$synergyRemoteHostname"
	
	#export HOME="$HOME"/'.ubcore'/net/synergy
	
	mkdir -p "$HOME"
	cd "$HOME"
	
	synergy "$@"
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
	
	_synergy_command "$@"
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
	
	_synergy_command "$@"
}

_synergys() {
	"$scriptAbsoluteLocation" _synergys_operations "$@"
}

_synergy_sequence() {
	_messageNormal '_synergy_sequence Start'
	_start
	_start_safeTmp_ssh "$@"
	
	_messageNormal '_synergy_sequence Launch: _synergys'
	_synergy_ssh -L "$synergyPort":localhost:24800 "$@" 'env synergyPort='"$synergyPort"' '"$safeTmpSSH"/cautossh' _synergys' &
	
	_waitPort localhost "$synergyPort"
	
	_messageNormal 'synergy_sequence: Ready: _waitPort localhost synergyport= '"$synergyPort"
	
	bash -c 'env synergyPort='"$synergyPort"' destination_DISPLAY='"$DISPLAY"' destination_AUTH='"$XAUTHORITY"' '"$scriptAbsoluteLocation"' _synergyc'
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_synergy() {
	"$scriptAbsoluteLoation" _synergy_sequence "$@"
}

_push_synergy_sequence() {
	_messageNormal '_push_synergy_sequence Start'
	_start
	_start_safeTmp_ssh "$@"
	
	_messageNormal '_push_synergy_sequence Launch: _synergys'
	_synergy_ssh -L "$synergyPort":localhost:24800 "$@" 'env synergyPort='"$synergyPort"' '"$safeTmpSSH"/cautossh' _synergyc' &
	
	_waitPort localhost "$synergyPort"
	
	_messageNormal 'synergy_sequence: Ready: _waitPort localhost synergyport= '"$synergyPort"
	
	bash -c 'env synergyPort='"$synergyPort"' destination_DISPLAY='"$DISPLAY"' destination_AUTH='"$XAUTHORITY"' '"$scriptAbsoluteLocation"' _synergys'
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_push_synergy() {
	"$scriptAbsoluteLoation" _push_synergy_sequence "$@"
}
