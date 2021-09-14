
_test_packetDrive() {
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




_packetDrive_criticalDep() {
	! sudo -n which dvd+rw-format > /dev/null && exit 1
	! which realpath > /dev/null && exit 1
	
	! sudo -n which dmsetup > /dev/null && exit 1
	
	return 0
}


_find_packetDrive() {
	! _packetDrive_criticalDep && exit 1
	
	[[ -e /dev/cdrom ]] && realpath /dev/cdrom && return 0
	[[ -e /dev/cdrw ]] && realpath /dev/cdrw && return 0
	[[ -e /dev/dvd ]] && realpath /dev/dvd && return 0
	[[ -e /dev/sr0 ]] && echo /dev/sr0 && return 0
	[[ -e /dev/sr1 ]] && echo /dev/sr1 && return 0
	
	return 1
}





_check_driveDeviceFile_packetDrive() {
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


_packetDrive_remove() {
	sudo -n dmsetup remove /dev/mapper/uk4uPhB663kVcygT0q_packetDrive? > /dev/null 2>&1
	sudo -n dmsetup remove /dev/mapper/uk4uPhB663kVcygT0q_packetDrive > /dev/null 2>&1
}

_packetDrive() {
	local currentDrive
	currentDrive=$(_find_packetDrive)
	_check_driveDeviceFile_packetDrive "$currentDrive"
	
	_packetDrive_remove
	
	local currentDriveLinearSize
	currentDriveLinearSize=$(sudo -n blockdev --getsz "$currentDrive")
	sudo -n dmsetup create uk4uPhB663kVcygT0q_packetDrive --table '0 '"$currentDriveLinearSize"' linear '"$currentDrive"' 0'
	
	#ls -A -1 /dev/mapper/uk4uPhB663kVcygT0q_packetDrive
}


_packetDrive_format_bdre() {
	local currentDrive
	currentDrive=$(_find_packetDrive)
	_check_driveDeviceFile_packetDrive "$currentDrive"
	
	_packetDrive_remove
	
	
	sudo -n dvd+rw-format "$currentDrive" -force -ssa=default
	
	# Apparently resets back to 'ssa=default' anyway.
	#sudo -n dvd+rw-format "$currentDrive" -force=full
	#sudo -n dvd+rw-format "$currentDrive" -force=full -blank=full
	
	#sudo -n dvd+rw-format "$currentDrive" -force -ssa=none
	
	return
}
_packetDrive_format() {
	_packetDrive_format_bdre "$@"
}
