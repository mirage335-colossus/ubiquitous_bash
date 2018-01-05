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
	_testQEMU_hostArch_x64-x64 || echo "warning: no native x64"
	
	_getDep qemu-system-x86_64
	_getDep qemu-img
	
	_getDep smbd
}

_qemu-system() {
	qemu-system-x86_64 "$@"
}
