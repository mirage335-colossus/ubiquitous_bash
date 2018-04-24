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
	_app_user "$@" && return 0
	
	_messageNormal 'Launch: _v_'${FUNCNAME[0]}
	_v_${FUNCNAME[0]} "$@"
}

_appUnique() {
	_launch "$@"
}
