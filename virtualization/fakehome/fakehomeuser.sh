_userFakeHome_procedure() {
	export actualFakeHome="$instancedFakeHome"
	export fakeHomeEditLib="false"
	_fakeHome "$@"
}

_userFakeHome_sequence() {
	_start
	
	_userFakeHome_procedure "$@"
	
	_stop $?
}

_userFakeHome() {
	"$scriptAbsoluteLocation" _userFakeHome_sequence "$@"
}

_editFakeHome_procedure() {
	export actualFakeHome="$globalFakeHome"
	export fakeHomeEditLib="false"
	_fakeHome "$@"
}

_editFakeHome_sequence() {
	_start
	
	_editFakeHome_procedure "$@"
	
	_stop $?
}

_editFakeHome() {
	"$scriptAbsoluteLocation" _editFakeHome_sequence "$@"
}

_userShortHome_procedure() {
	export actualFakeHome="$shortFakeHome"
	export fakeHomeEditLib="false"
	_fakeHome "$@"
}

_userShortHome_sequence() {
	_start
	
	_userShortHome_procedure "$@"
	
	_stop $?
}

_userShortHome() {
	"$scriptAbsoluteLocation" _userShortHome_sequence "$@"
}

_editShortHome_procedure() {
	export actualFakeHome="$shortFakeHome"
	export fakeHomeEditLib="true"
	_fakeHome "$@"
}

_editShortHome_sequence() {
	_start
	
	_editShortHome_procedure "$@"
	
	_stop $?
}

# WARNING: Only allows persistent modifications to directories which have been linked by "_link_fakeHome" or similar.
_editShortHome() {
	"$scriptAbsoluteLocation" _editShortHome_sequence "$@"
}

_shortHome() {
	_userShortHome "$@"
}

_memFakeHome_procedure() {
	export actualFakeHome="$instancedFakeHome"
	export fakeHomeEditLib="false"
	
	_mountRAM_fakeHome
	
	local fakeHomeExitStatus
	
	_fakeHome "$@"
	fakeHomeExitStatus=$?
	
	_umountRAM_fakeHome
	
	return "$fakeHomeExitStatus"
}

_memFakeHome_sequence() {
	_start
	
	_memFakeHome_procedure "$@"
	
	_stop $?
}

_memFakeHome() {
	"$scriptAbsoluteLocation" _memFakeHome_sequence "$@"
}
