##### Core

_v_gnucash() {
	_userQemu "$scriptAbsoluteLocation" _userFakeHome gnucash "$@"
}

_gnucash() {
	if _wantDep 'gnucash'
	then
		_messageNormal 'Launch: gnucash'
		"$scriptAbsoluteLocation" _userFakeHome gnucash "$@"
		return 0
	fi
	
	_messageNormal 'Launch: _v_gnucash'
	_v_gnucash "$@"
}

