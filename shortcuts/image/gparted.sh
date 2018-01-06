_test_gparted() {
	_getDep gparted
}

_gparted_sequence() {
	_start
	
	_mustGetSudo
	
	_openLoop || _stop 1
	
	local imagedev
	imagedev=$(cat "$scriptLocal"/imagedev)
	
	sudo -n gparted "$imagedev"
	
	_closeLoop || _stop 1
	
	_stop
}

_gparted() {
	"$scriptAbsoluteLocation" _gparted_sequence
}
