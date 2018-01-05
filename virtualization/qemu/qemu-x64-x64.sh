_testQEMU_hostArch_x64_hardwarevt() {
	#[[ -e /dev/kvm ]] && (grep -i svm /proc/cpuinfo > /dev/null 2>&1 || grep -i vmx /proc/cpuinfo > /dev/null 2>&1)
	
	! [[ -e /dev/kvm ]] && return 1
	
	grep -i svm /proc/cpuinfo > /dev/null 2>&1 && return 0
	grep -i vmx /proc/cpuinfo > /dev/null 2>&1 && return 0
	
	return 1
}

_testQEMU_hostArch_x64_nested() {
	grep '1' /sys/module/kvm_amd/parameters/nested > /dev/null 2>&1 && return 0
	grep 'Y' /sys/module/kvm_amd/parameters/nested > /dev/null 2>&1 && return 0
	grep '1' /sys/module/kvm_intel/parameters/nested > /dev/null 2>&1 && return 0
	grep 'Y' /sys/module/kvm_intel/parameters/nested > /dev/null 2>&1 && return 0
	
	return 1
}

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
	_testQEMU_hostArch_x64-x64 || echo "warn: no native x64"
	_testQEMU_hostArch_x64_hardwarevt || echo "warn: no x64 vt"
	_testQEMU_hostArch_x64_nested || echo "warn: no nested x64"
	
	_getDep qemu-system-x86_64
	_getDep qemu-img
	
	_getDep smbd
}

_qemu-system() {
	qemu-system-x86_64 "$@"
}
