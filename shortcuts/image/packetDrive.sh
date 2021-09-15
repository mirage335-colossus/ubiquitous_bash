
_test_packetDriveDevice() {
	_wantGetDep blockdev
	
	_wantGetDep dvd+rw-format
	_wantGetDep growisofs
	
	# https://www.kernel.org/doc/html/latest/cdrom/packet-writing.html
	# pktcdvd driver makes the disc appear as a regular block device with a 2KB block size
	_wantGetDep pktsetup
	
	_wantGetDep partprobe
	_wantGetDep kpartx
	
	_wantGetDep realpath
	_wantGetDep dmsetup
}




_packetDriveDevice_criticalDep() {
	! sudo -n which dvd+rw-format > /dev/null && exit 1
	! which realpath > /dev/null && exit 1
	
	! sudo -n which dmsetup > /dev/null && exit 1
	
	return 0
}


_find_packetDrive() {
	! _packetDriveDevice_criticalDep && exit 1
	
	[[ -e /dev/cdrom ]] && realpath /dev/cdrom && return 0
	[[ -e /dev/cdrw ]] && realpath /dev/cdrw && return 0
	[[ -e /dev/dvd ]] && realpath /dev/dvd && return 0
	[[ -e /dev/sr0 ]] && echo /dev/sr0 && return 0
	[[ -e /dev/sr1 ]] && echo /dev/sr1 && return 0
	
	return 1
}





_check_driveDeviceFile_packetDriveDevice() {
	! [[ -e "$1" ]] && echo 'FAIL: missing: drive' && exit 1
	
	if ! sudo -n dd if="$1" of=/dev/null bs=1k count=1 > /dev/null 2>&1
	then
		echo 'FAIL: drive cannot read any removable media (may be empty)' && exit 1
	fi
	
	if findmnt "$1" > /dev/null 2>&1 || findmnt "$1"-part1 > /dev/null 2>&1  || findmnt "$1"-part2 > /dev/null 2>&1 || findmnt "$1"-part3 > /dev/null 2>&1 || findmnt "$1"1 > /dev/null 2>&1 || findmnt "$1"2 > /dev/null 2>&1 || findmnt "$1"3 > /dev/null 2>&1
	then
		echo 'FAIL: safety: detect: mountpoint' && exit 1
	fi
	
	return 0
}


_packetDriveDevice_remove_procedure() {
	sudo -n dmsetup remove /dev/mapper/uk4uPhB663kVcygT0q_packetDriveDevice? > /dev/null 2>&1
	sudo -n dmsetup remove /dev/mapper/uk4uPhB663kVcygT0q_packetDriveDevice?? > /dev/null 2>&1
	sudo -n dmsetup remove /dev/mapper/uk4uPhB663kVcygT0q_packetDriveDevice > /dev/null 2>&1
}
_packetDriveDevice_remove() {
	_packetDriveDevice_remove_procedure "$@"
	
	! [[ -e /dev/mapper/uk4uPhB663kVcygT0q_packetDriveDevice ]] && _messagePlain_good 'good: dmsetup: remove: '/dev/mapper/uk4uPhB663kVcygT0q_packetDriveDevice
	[[ -e /dev/mapper/uk4uPhB663kVcygT0q_packetDriveDevice ]] && _messagePlain_bad 'fail: dmsetup: remove: '/dev/mapper/uk4uPhB663kVcygT0q_packetDriveDevice
	
	sleep 3
	! [[ -e /dev/mapper/uk4uPhB663kVcygT0q_packetDriveDevice ]]
}

_packetDriveDevice() {
	local currentDrive
	currentDrive=$(_find_packetDrive)
	_check_driveDeviceFile_packetDriveDevice "$currentDrive"
	
	_packetDriveDevice_remove_procedure
	
	local currentDriveLinearSize
	currentDriveLinearSize=$(sudo -n blockdev --getsz "$currentDrive")
	sudo -n dmsetup create uk4uPhB663kVcygT0q_packetDriveDevice --table '0 '"$currentDriveLinearSize"' linear '"$currentDrive"' 0'
	
	sudo -n partprobe
	sudo -n kpartx -a "/dev/mapper/uk4uPhB663kVcygT0q_packetDriveDevice"
	
	ls -A -1 /dev/mapper/uk4uPhB663kVcygT0q_packetDriveDevice*
	
	[[ -e /dev/mapper/uk4uPhB663kVcygT0q_packetDriveDevice ]] && _messagePlain_good 'good: dmsetup: create: '/dev/mapper/uk4uPhB663kVcygT0q_packetDriveDevice
	! [[ -e /dev/mapper/uk4uPhB663kVcygT0q_packetDriveDevice ]] && _messagePlain_bad 'fail: dmsetup: create: '/dev/mapper/uk4uPhB663kVcygT0q_packetDriveDevice
	
	sleep 3
	[[ -e /dev/mapper/uk4uPhB663kVcygT0q_packetDriveDevice ]]
}


_packetDriveDevice_format_bdre() {
	local currentDrive
	currentDrive=$(_find_packetDrive)
	_check_driveDeviceFile_packetDriveDevice "$currentDrive"
	
	_packetDriveDevice_remove_procedure
	
	
	sudo -n dvd+rw-format "$currentDrive" -force -ssa=default
	
	# Apparently resets back to 'ssa=default' anyway.
	#sudo -n dvd+rw-format "$currentDrive" -force=full
	#sudo -n dvd+rw-format "$currentDrive" -force=full -blank=full
	
	#sudo -n dvd+rw-format "$currentDrive" -force -ssa=none
	
	sleep 20
	return
}
_packetDriveDevice_format() {
	_packetDriveDevice_format_bdre "$@"
}
