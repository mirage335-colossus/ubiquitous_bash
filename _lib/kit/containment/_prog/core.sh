#all2=""

#command
_app_command() {
	"$scriptAbsoluteFolder"/_local/setups/appExe "$@"
}

#edit
_app_edit() {
	"$scriptAbsoluteLocation" _editFakeHome "$scriptAbsoluteLocation" _app_command "$@"
}

#user
_app_user() {
	"$scriptAbsoluteLocation" _userFakeHome "$scriptAbsoluteLocation" _app_command "$@"
}

#virtualized
_v_app() {
	_userQemu "$scriptAbsoluteLocation" _app_user "$@"
}

#default
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

#duplicate _anchor
_refresh_anchors() {
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_app
}


#####^ Core
