_test_fakehome() {
	_getDep mount
	_getDep mountpoint
}

_resetFakeHomeEnv_extra() {
	true
}

_resetFakeHomeEnv_nokeep() {
	! [[ "$setFakeHome" == "true" ]] && return 0
	export setFakeHome="false"
	
	export HOME="$realHome"
	
	_resetFakeHomeEnv_extra
}

_resetFakeHomeEnv() {
	#[[ "$keepFakeHome" == "true" ]] && return 0
	[[ "$keepFakeHome" != "false" ]] && return 0
	
	_resetFakeHomeEnv_nokeep
}

_setFakeHomeEnv_extra() {
	true
}

_setFakeHomeEnv() {
	[[ "$setFakeHome" == "true" ]] && return 0
	export setFakeHome="true"
	
	export realHome="$HOME"
	export fakeHome=$(_findDir "$1")
	
	export HOME="$fakeHome"
	
	_setFakeHomeEnv_extra
}


_editFakeHome_sequence() {
	_start
	
	_resetFakeHomeEnv_nokeep
	_prepareFakeHome
	
	_setFakeHomeEnv "$globalFakeHome"
	
	"$@"
	
	_resetFakeHomeEnv_nokeep
	_stop
}

_editFakeHome() {
	"$scriptAbsoluteLocation" _editFakeHome_sequence "$@"
}

_makeFakeHome_extra() {
	true
}

_makeFakeHome() {
	ln -s "$realHome" "$HOME"/realHome
	
	ln -s "$realHome"/.bashrc "$HOME"/
	ln -s "$realHome"/.ubcore "$HOME"/
	
	ln -s "$realHome"/Downloads "$HOME"/
	
	ln -s "$realHome"/Desktop "$HOME"/
	ln -s "$realHome"/Documents "$HOME"/
	ln -s "$realHome"/Music "$HOME"/
	ln -s "$realHome"/Pictures "$HOME"/
	ln -s "$realHome"/Public "$HOME"/
	ln -s "$realHome"/Templates "$HOME"/
	ln -s "$realHome"/Videos "$HOME"/
	
	ln -s "$realHome"/bin "$HOME"/
	
	ln -s "$realHome"/core "$HOME"/
	ln -s "$realHome"/project "$HOME"/
	ln -s "$realHome"/projects "$HOME"/
	
	ln -s "$realHome"/.ssh "$HOME"/
	ln -s "$realHome"/.gitconfig "$HOME"/
	
	_makeFakeHome_extra
}

_createFakeHome_sequence() {
	_start
	
	_resetFakeHomeEnv_nokeep
	_prepareFakeHome
	
	_setFakeHomeEnv "$globalFakeHome"
	
	_makeFakeHome
	
	_resetFakeHomeEnv_nokeep
	_stop
}

_createFakeHome() {
	"$scriptAbsoluteLocation" _createFakeHome_sequence "$@"
}

_mountRAM_fakeHome_instance_sequence() {
	_mustGetSudo
	mkdir -p "$instancedFakeHome"
	sudo -n mount -t ramfs ramfs "$instancedFakeHome"
	sudo -n chown "$USER":"$USER" "$instancedFakeHome"
	! mountpoint "$instancedFakeHome" > /dev/null 2>&1 && _stop 1
	return 0
}

_mountUserFakeHome_instance() {
	! _mountRAM_fakeHome_instance_sequence && _stop 1
	return 0
}

_umountRAM_fakeHome_instance_sequence() {
	mkdir -p "$instancedFakeHome"
	sudo -n umount "$instancedFakeHome"
	mountpoint "$instancedFakeHome" > /dev/null 2>&1 && _stop 1
	return 0
}

_umountUserFakeHome_instance() {
	! _umountRAM_fakeHome_instance_sequence && _stop 1
	return 0
}

#userFakeHome_enableMemMount="true"
_userFakeHome_sequence() {
	_start
	
	[[ "$instancedFakeHome" == "" ]] && _stop 1
	
	[[ "$userFakeHome_enableMemMount" == "true" ]] && ! _mountUserFakeHome_instance && _stop 1
	
	_resetFakeHomeEnv_nokeep
	_prepareFakeHome
	_prepareFakeHome_instance
	
	_setFakeHomeEnv "$instancedFakeHome"
	
	"$@"
	
	[[ "$userFakeHome_enableMemMount" == "true" ]] && ! _umountUserFakeHome_instance && _stop 1
	
	_resetFakeHomeEnv_nokeep
	_rm_instance_fakeHome
	
	_stop
}

_userFakeHome() {
	"$scriptAbsoluteLocation" _userFakeHome_sequence "$@"
}

_memFakeHome() {
	export userFakeHome_enableMemMount="true"
	"$scriptAbsoluteLocation" _userFakeHome_sequence "$@"
}
