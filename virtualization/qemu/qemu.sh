_qemu() {
	local hostArch
	hostArch=$(uname -m)
	
	if [[ "$hostArch" == "x86_64" ]]
	then
		mkdir -p "$scriptLocal"
		_createLocked "$scriptLocal"/_qemu || return 1
		
		qemu-system-x86_64 -machine accel=kvm -drive format=raw,file="$scriptLocal"/vm.img -boot c -m 768
		
		rm -f "$scriptLocal"/_qemu
		return 0
	fi
	
	return 1
}

_userQemu_sequence() {
	_start
	
	mkdir -p "$instancedVirtDir" || _stop 1
	
	_readLocked "$scriptLocal"/_qemu && _stop 1
	
	_commandBootdisc "$@" || _stop 1
	
	qemu-system-x86_64 -snapshot -machine accel=kvm -drive format=raw,file="$scriptLocal"/vm.img -drive file="$hostToGuestISO",media=cdrom -boot c -m 768
	
	_safeRMR "$instancedVirtDir" || _stop 1
	
	_stop
}

_userQemu() {
	"$scriptAbsoluteLocation" _userQemu_sequence "$@"
}
