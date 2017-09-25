_testQEMU_hostArch_x64-x64() {
	local hostArch
	hostArch=$(uname -m)
	
	if [[ "$hostArch" != "x86_64" ]]
	then
		return 1
	fi
	
	return 0
}

_testQEMU_x64-x64() {
	_testQEMU_hostArch_x64-x64 || _stop 1
	
	_checkDep qemu-system-x86_64
	_checkDep qemu-img
}

_qemu-system() {
	qemu-system-x86_64 "$@"
}
