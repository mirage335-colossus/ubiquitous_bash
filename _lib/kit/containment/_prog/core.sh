##### Core

_app_command() {
	"$scriptAbsoluteFolder"/_local/setups/appExe "$@"
}

_app_edit() {
	"$scriptAbsoluteLocation" _editFakeHome "$scriptAbsoluteLocation" _app_command "$@"
}

_app_user() {
	"$scriptAbsoluteLocation" _userFakeHome "$scriptAbsoluteLocation" _app_command "$@"
}

_v_app() {
	_userQemu "$scriptAbsoluteLocation" _app_user "$@"
}

_app() {
	if ! _check_prog
	then
		_messageNormal 'Launch: _v'${FUNCNAME[0]}
		_v${FUNCNAME[0]} "$@"
		return
	fi
	
	_app_user "$@" && return 0
	
	#_messageNormal 'Launch: _v'${FUNCNAME[0]}
	#_v${FUNCNAME[0]} "$@"
}
