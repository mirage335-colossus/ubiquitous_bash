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

_makeFakeHome_extra_layer0() {
	_relink "$realHome"/.bashrc "$HOME"/.bashrc
	_relink "$realHome"/.ubcore "$HOME"/.ubcore
	
	_relink "$realHome"/.Xauthority "$HOME"/.Xauthority
	
	_relink "$realHome"/.ssh "$HOME"/.ssh
	_relink "$realHome"/.gitconfig "$HOME"/.gitconfig
	
	mkdir -p "$realHome"/.config
}

_makeFakeHome_extra_layer1() {
	true
}

_makeFakeHome() {
	[[ "$HOME" == "" ]] && return 0
	[[ "$HOME" == "/home/""$USER" ]] && return 0
	
	_relink "$realHome" "$HOME"/realHome
	
	_relink "$realHome"/Downloads "$HOME"/Downloads
	
	_relink "$realHome"/Desktop "$HOME"/Desktop
	_relink "$realHome"/Documents "$HOME"/Documents
	_relink "$realHome"/Music "$HOME"/Music
	_relink "$realHome"/Pictures "$HOME"/Pictures
	_relink "$realHome"/Public "$HOME"/Public
	_relink "$realHome"/Templates "$HOME"/Templates
	_relink "$realHome"/Videos "$HOME"/Videos
	
	_relink "$realHome"/bin "$HOME"/bin
	
	_relink "$realHome"/core "$HOME"/core
	_relink "$realHome"/project "$HOME"/project
	_relink "$realHome"/projects "$HOME"/projects
	
	
	
	_makeFakeHome_extra_layer0
	_makeFakeHome_extra_layer1
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

_editFakeHome_sequence() {
	_start
	
	_resetFakeHomeEnv_nokeep
	_prepareFakeHome
	
	_setFakeHomeEnv "$globalFakeHome"
	_makeFakeHome > /dev/null 2>&1
	
	"$@"
	
	_resetFakeHomeEnv_nokeep
	_stop
}

_editFakeHome() {
	"$scriptAbsoluteLocation" _editFakeHome_sequence "$@"
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
	_makeFakeHome > /dev/null 2>&1
	
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
