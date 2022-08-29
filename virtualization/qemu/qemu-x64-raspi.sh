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
	
	#\|Raspbian
	if [[ -e /etc/issue ]] && cat /etc/issue | grep 'Debian\|Ubuntu' > /dev/null 2>&1
	then
		_getDep update-binfmts
	fi
	
	
	sudo -n systemctl status binfmt-support 2>&1 | head -n 2 | grep -i 'chroot' > /dev/null && return 0
	systemctl status binfmt-support 2>&1 | head -n 2 | grep -i 'chroot' > /dev/null && return 0
	
	
	
	if ! sudo -n cat /proc/sys/fs/binfmt_misc/* 2> /dev/null | grep qemu | grep 'arm$\|arm-static$\|arm-binfmt-P$\|arm-binfmt' > /dev/null 2>&1 && ! _if_cygwin
	then
		echo 'binfmts does not mention qemu-arm'
		[[ "$INSTANCE_ID" == "" ]] && _stop 1
	fi
	
	if ! sudo -n cat /proc/sys/fs/binfmt_misc/* 2> /dev/null | grep qemu | grep 'armeb$\|armeb-static$\|armeb-binfmt-P$\|armeb-binfmt' > /dev/null 2>&1 && ! _if_cygwin
	then
		echo 'binfmts does not mention qemu-armeb'
		[[ "$INSTANCE_ID" == "" ]] && _stop 1
	fi
	
	return 0
}


