_check_prog() {
	! _typeDep true && return 1
	
	return 0
}

_test_prog() {
	_getDep true
	
	! _check_prog && echo 'missing: dependency mismatch' && _stop 1
}

_test_build_prog() {
	true
}

# WARNING: Only use this function to retrieve initial sources, as documenation.. Do NOT perform update (ie. git submodule) operations. Place those instructions under _update_mod .
_fetch_prog() {
	true
}

_build_prog() {
	_fetch_prog
	
	true
}

_setup_udev() {
	! _wantSudo && echo 'denied: sudo' && _stop 1
	
	sudo -n bash -c '[[ -e /etc/udev/rules.d/ ]]' && sudo -n cp "$scriptLib"/udev/rules/. /etc/udev/rules.d/
	
	
	sudo -n usermod -a -G plugdev "$USER"
}

_setup_prog() {
	_setup_udev
}
