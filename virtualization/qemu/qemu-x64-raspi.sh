_testQEMU_hostArch_x64-raspi() {
	local hostArch
	hostArch=$(uname -m)
	
	if [[ "$hostArch" != "x86_64" ]]
	then
		return 1
	fi
	
	return 0
}

_testQEMU_x64-raspi() {
	
	_testQEMU_x64-x64
	_getDep qemu-arm-static
	_getDep qemu-armeb-static
	
	_getDep qemu-system-arm
	_getDep qemu-system-aarch64
	
	_mustGetSudo
	
	! _testQEMU_hostArch_x64-raspi && echo "warn: not checking x64 translation" && return 0
	
	
	
	
	if ! sudo -n cat /proc/sys/fs/binfmt_misc/* 2> /dev/null | grep qemu | grep 'arm$\|arm-static$\|arm-binfmt-P$\|arm-binfmt' > /dev/null 2>&1
	then
		echo 'binfmts does not mention qemu-arm'
		_stop 1
	fi
	
	if ! sudo -n cat /proc/sys/fs/binfmt_misc/* 2> /dev/null | grep qemu | grep 'armeb$\|armeb-static$\|armeb-binfmt-P$\|armeb-binfmt' > /dev/null 2>&1
	then
		echo 'binfmts does not mention qemu-armeb'
		_stop 1
	fi
}


