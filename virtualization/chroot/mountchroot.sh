
# May override with 'ops.sh' or similar. Future development intended. Currently, creating an image of a physical device is strongly recommended instead.
_detect_deviceAsChRootImage() {
	false
	
	# TODO: Determine if "$ubVirtImageOverride" or "$scriptLocal" points to a device file (typically under '/dev').
	# TODO: Should call separate function _detect_deviceAsVirtImage .
	# DANGER: Functions under 'mountimage.sh' must also respect this.
}


#"$1" == ChRoot Dir
_mountChRoot() {
	_mustGetSudo
	
	[[ ! -e "$1" ]] && return 1
	
	local absolute1
	absolute1=$(_getAbsoluteLocation "$1")
	
	_bindMountManager "/dev" "$absolute1"/dev
	_bindMountManager "/proc" "$absolute1"/proc
	_bindMountManager "/sys" "$absolute1"/sys
	
	_bindMountManager "/dev/pts" "$absolute1"/dev/pts
	
	_bindMountManager "/tmp" "$absolute1"/tmp
	
	#Provide an shm filesystem at /dev/shm.
	sudo -n mount -t tmpfs -o size=4G tmpfs "$absolute1"/dev/shm
	
	#Install ubiquitous_bash itself to chroot.
	sudo -n mkdir -p "$absolute1"/usr/local/bin/
	sudo -n mkdir -p "$absolute1"/usr/local/share/ubcore/bin/
	
	sudo -n cp "$scriptAbsoluteLocation" "$absolute1"/usr/local/bin/ubiquitous_bash.sh
	sudo -n chmod 0755 "$absolute1"/usr/local/bin/ubiquitous_bash.sh
	sudo -n chown root:root "$absolute1"/usr/local/bin/ubiquitous_bash.sh
	
	if [[ -e "$scriptAbsoluteFolder"/lean.sh ]]
	then
		sudo -n cp "$scriptAbsoluteFolder"/lean.sh "$absolute1"/usr/local/bin/lean.sh
		sudo -n chmod 0755 "$absolute1"/usr/local/bin/lean.sh
		sudo -n chown root:root "$absolute1"/usr/local/bin/lean.sh
	fi
	
	sudo -n cp "$scriptBin"/gosu-armel "$absolute1"/usr/local/share/ubcore/bin/gosu-armel
	sudo -n cp "$scriptBin"/gosu-amd64 "$absolute1"/usr/local/share/ubcore/bin/gosu-amd64
	sudo -n cp "$scriptBin"/gosu-i386 "$absolute1"/usr/local/share/ubcore/bin/gosu-i386
	sudo -n chmod 0755 "$absolute1"/usr/local/share/ubcore/bin/*
	sudo -n chown root:root "$absolute1"/usr/local/share/ubcore/bin/*
	
	#Workaround NetworkManager stealing /etc/resolv.conf with broken symlink.
	if ! _chroot test -f /etc/resolv.conf
	then
		sudo -n mv "$absolute1"/etc/resolv.conf "$absolute1"/etc/resolv.conf.bak > /dev/null 2>&1
		sudo -n rm -f "$absolute1"/etc/resolv.conf > /dev/null 2>&1
	fi
	
	if ! grep '8\.8\.8\.8' "$absolute1"/etc/resolv.conf > /dev/null 2>&1
	then
		echo 'nameserver 8.8.8.8' | sudo -n tee -a "$absolute1"/etc/resolv.conf > /dev/null 2>&1
	fi
	
	if ! grep '2001\:4860\:4860\:\:8888' "$absolute1"/etc/resolv.conf > /dev/null 2>&1
	then
		echo 'nameserver 2001:4860:4860::8888' | sudo -n tee -a "$absolute1"/etc/resolv.conf > /dev/null 2>&1
	fi
	
	return 0
}

#"$1" == ChRoot Dir
_umountChRoot() {
	_mustGetSudo
	
	[[ ! -e "$1" ]] && return 1
	
	local absolute1
	absolute1=$(_getAbsoluteLocation "$1")
	
	_wait_umount "$absolute1"/home/"$virtGuestUser"/project >/dev/null 2>&1
	_wait_umount "$absolute1"/home/"$virtGuestUser" >/dev/null 2>&1
	_wait_umount "$absolute1"/root/project >/dev/null 2>&1
	_wait_umount "$absolute1"/root >/dev/null 2>&1
	
	_wait_umount "$absolute1"/dev/shm
	_wait_umount "$absolute1"/dev/pts
	
	
	if [[ -e "$absolute1"/proc/sys/fs/binfmt_misc ]] && mountpoint "$absolute1"/proc/sys/fs/binfmt_misc > /dev/null 2>&1
	then
		_wait_umount "$absolute1"/proc/sys/fs/binfmt_misc
	fi
	
	
	_wait_umount "$absolute1"/proc
	_wait_umount "$absolute1"/sys
	
	_wait_umount "$absolute1"/tmp
	
	_wait_umount "$absolute1"/dev
	
	# Full umount of chroot directory may be done by standard '_umountImage'.
	#_wait_umount "$absolute1" >/dev/null 2>&1
}

_readyChRoot() {
	
	local absolute1
	absolute1=$(_getAbsoluteLocation "$1")
	
	#mountpoint "$absolute1" > /dev/null 2>&1 || return 1
	
	mountpoint "$absolute1"/dev > /dev/null 2>&1 || return 1
	mountpoint "$absolute1"/proc > /dev/null 2>&1 || return 1
	mountpoint "$absolute1"/sys > /dev/null 2>&1 || return 1
	
	mountpoint "$absolute1"/dev/pts > /dev/null 2>&1 || return 1
	
	mountpoint "$absolute1"/tmp > /dev/null 2>&1 || return 1
	
	mountpoint "$absolute1"/dev/shm > /dev/null 2>&1 || return 1
	
	return 0
	
}

# ATTENTION: Override with "core.sh" or similar.
# WARNING: Must return true to complete mount/umount procedure.
_mountChRoot_image_raspbian_prog() {
	true
	
	#local current_imagedev
	#current_imagedev=$(cat "$scriptLocal"/imagedev)
	
	#mkdir -p "$globalVirtFS"/../boot
	#sudo -n mount "$current_imagedev"p1 "$globalVirtFS"/../boot
	
	return 0
}

_mountChRoot_image_raspbian() {
	_mustGetSudo
	
	_start
	
	mkdir -p "$chrootDir"
	
	"$scriptAbsoluteLocation" _checkForMounts "$chrootDir" && _stop 1
	
	
	! _mountImage "$chrootDir" && _stop 1
	
	
	
	_mountChRoot "$chrootDir"
	
	_readyChRoot "$chrootDir" || _stop 1
	
	sudo -n cp /usr/bin/qemu-arm-static "$chrootDir"/usr/bin/
	sudo -n cp /usr/bin/qemu-armeb-static "$chrootDir"/usr/bin/
	
	sudo -n cp -n "$chrootDir"/etc/ld.so.preload "$chrootDir"/etc/ld.so.preload.orig
	echo | sudo -n tee "$chrootDir"/etc/ld.so.preload > /dev/null 2>&1
	
	
	local chrootimagedev
	chrootimagedev=$(cat "$scriptLocal"/imagedev)
	! _mountChRoot_image_raspbian_prog "$chrootimagedev" && _stop 1
	
	
	return 0
}

_umountChRoot_directory_raspbian() {
	
	_mustGetSudo
	
	mkdir -p "$chrootDir"
	
	sudo -n cp "$chrootDir"/etc/ld.so.preload.orig "$chrootDir"/etc/ld.so.preload
	
}

_mountChRoot_image_x64_efi() {
	[[ "$ubVirtPlatform" != "x64-efi" ]] && return 1
	[[ "$ubVirtImageEFI" == "" ]] && return 1
	
	local current_imagedev
	current_imagedev=$(cat "$scriptLocal"/imagedev)
	
	_determine_rawFileRootPartition "$current_imagedev" > /dev/null 2>&1
	
	local loopdevfs
	loopdevfs=$(sudo -n blkid -s TYPE -o value "$current_imagedev""$ubVirtImageEFI" | tr -dc 'a-zA-Z0-9')
	
	! [[ "$loopdevfs" == "vfat" ]] && _stop 1
	
	
	mkdir -p "$globalVirtFS"/boot/efi
	
	sudo -n mount "$current_imagedev""$ubVirtImageEFI" "$globalVirtFS"/boot/efi
	
	return 0
}

# ATTENTION: Override with "core.sh" or similar.
# WARNING: Must return true to complete mount/umount procedure.
# By default attempts to mount EFI partition as specified by "$current_imagedev""$ubVirtImageEFI" .
_mountChRoot_image_x64_prog() {
	true
	
	if [[ "$ubVirtPlatform" == "x64-efi" ]]
	then
		_mountChRoot_image_x64_efi "$@"
		return
	fi
	
	return 0
}

# ATTENTION: Mounts image containing only root partiton.
_mountChRoot_image_x64() {
	_mustGetSudo
	
	_start
	
	mkdir -p "$chrootDir"
	
	"$scriptAbsoluteLocation" _checkForMounts "$chrootDir" && _stop 1
	
	
	! _mountImage "$chrootDir" && _stop 1
	
	
	
	_mountChRoot "$chrootDir"
	
	_readyChRoot "$chrootDir" || _stop 1
	
	
	local chrootimagedev
	chrootimagedev=$(cat "$scriptLocal"/imagedev)
	! _mountChRoot_image_x64_prog "$chrootimagedev" && _stop 1
	
	return 0
}

_umountChRoot_directory_x64() {
	_mustGetSudo
	
	mkdir -p "$chrootDir"
}

_mountChRoot_image() {
	_tryExecFull _hook_systemd_shutdown_action "_closeChRoot_emergency" "$sessionid"
	
	# Include platform determination code for correct determination of partition and mounts.
	_loopImage_imagefilename > /dev/null 2>&1
	
	if [[ "$ubVirtPlatform" == "raspbian" ]]
	then
		_mountChRoot_image_raspbian
		return "$?"
	fi
	
	if [[ "$ubVirtPlatform" == "x64"* ]]
	then
		_mountChRoot_image_x64
		return "$?"
	fi
	
	#Default x64 .
	"$scriptAbsoluteLocation" _mountChRoot_image_x64
	return "$?"
}

_umountChRoot_directory_platform() {
	# Include platform determination code for correct determination of partition and mounts.
	_loopImage_imagefilename > /dev/null 2>&1
	
	if [[ "$ubVirtPlatform" == "raspbian" ]]
	then
		"$scriptAbsoluteLocation" _umountChRoot_directory_raspbian
		return "$?"
	fi
	
	if [[ "$ubVirtPlatform" == "x64"* ]]
	then
		"$scriptAbsoluteLocation" _umountChRoot_directory_x64
		return "$?"
	fi
	
	#Default "vm.img" will be operated on as x64 image.
	"$scriptAbsoluteLocation" _umountChRoot_directory_x64
	return "$?"
}

_umountChRoot_directory() {
	! _umountChRoot_directory_platform && return 1
	
	_stopChRoot "$1"
	_umountChRoot "$1"
	
	# Full umount of chroot directory may be done by standard '_umountImage'.
	#mountpoint "$1" > /dev/null 2>&1 && sudo -n umount "$1"
	#"$scriptAbsoluteLocation" _checkForMounts "$1" && return 1
	
	return 0
}

# ATTENTION: Override with "core.sh" or similar.
# WARNING: Must return true to complete mount/umount procedure.
_umountChRoot_image_prog() {
	true
	
	#[[ -d "$globalVirtFS"/../boot ]] && mountpoint "$globalVirtFS"/../boot >/dev/null 2>&1 && sudo -n umount "$globalVirtFS"/../boot >/dev/null 2>&1
	
	#[[ -d "$globalVirtFS"/boot/efi ]] && mountpoint "$globalVirtFS"/boot/efi >/dev/null 2>&1 && sudo -n umount "$globalVirtFS"/boot/efi >/dev/null 2>&1
	#[[ -d "$globalVirtFS"/boot ]] && mountpoint "$globalVirtFS"/boot >/dev/null 2>&1 && sudo -n umount "$globalVirtFS"/boot >/dev/null 2>&1
}

_umountChRoot_image() {
	_mustGetSudo || return 1
	
	# x64-efi (typical)
	[[ -d "$globalVirtFS"/boot/efi ]] && mountpoint "$globalVirtFS"/boot/efi >/dev/null 2>&1 && sudo -n umount "$globalVirtFS"/boot/efi >/dev/null 2>&1
	[[ -d "$globalVirtFS"/boot ]] && mountpoint "$globalVirtFS"/boot >/dev/null 2>&1 && sudo -n umount "$globalVirtFS"/boot >/dev/null 2>&1
	
	
	! _umountChRoot_directory "$chrootDir" && return 1
	
	! _umountChRoot_image_prog && return 1
	
	# raspbian (typical)
	[[ -d "$globalVirtFS"/../boot ]] && mountpoint "$globalVirtFS"/../boot >/dev/null 2>&1 && sudo -n umount "$globalVirtFS"/../boot >/dev/null 2>&1
	
	_umountImage "$chrootDir"
	
	
	
	rm -f "$permaLog"/gsysd.log > /dev/null 2>&1
	
	return 0
}

_waitChRoot_opening() {
	_readyChRoot "$chrootDir" && return 0
	sleep 1
	_readyChRoot "$chrootDir" && return 0
	sleep 3
	_readyChRoot "$chrootDir" && return 0
	sleep 9
	_readyChRoot "$chrootDir" && return 0
	sleep 27
	_readyChRoot "$chrootDir" && return 0
	sleep 81
	_readyChRoot "$chrootDir" && return 0
	
	return 1
}

_waitChRoot_closing() {
	_readyChRoot "$chrootDir" || return 0
	sleep 1
	_readyChRoot "$chrootDir" || return 0
	sleep 3
	_readyChRoot "$chrootDir" || return 0
	sleep 9
	_readyChRoot "$chrootDir" || return 0
	sleep 27
	_readyChRoot "$chrootDir" || return 0
	sleep 81
	_readyChRoot "$chrootDir" || return 0
	
	return 1
}

_openChRoot() {
	export specialLock="$lock_open_chroot"
	_open _waitChRoot_opening _mountChRoot_image
}

_closeChRoot() {
	_findInfrastructure_virtImage ${FUNCNAME[0]} "$@"
	[[ "$ubVirtImageLocal" == "false" ]] && return
	
	export specialLock="$lock_open_chroot"
	if [[ "$1" == "--force" ]]
	then
		_close --force _waitChRoot_closing _umountChRoot_image
		return
	fi
	
	_close _waitChRoot_closing _umountChRoot_image
}

_haltAllChRoot() {
	find "$scriptAbsoluteFolder"/v_*/fs -maxdepth 1 -type d -exec "$scriptAbsoluteLocation" _umountChRoot_directory '{}' \;
	find "$scriptAbsoluteFolder"/v_*/tmp -maxdepth 1 -type d -exec sudo -n umount '{}' \;
	find "$scriptAbsoluteFolder"/v_*/ -maxdepth 12 -type d | head -n 48 | tac | xargs rmdir
	
	"$scriptAbsoluteLocation" _closeChRoot --force
	
	#Closing file may remain if chroot was not open to begin with. Since haltAllChRoot is usually called for forced/emergency shutdown purposes, clearing the resultant lock file is usually safe.
	rm -f "$lock_closing"
}

#Fast dismount of all ChRoot filesystems/instances and cleanup of lock files. Specifically intended to act on SIGTERM or during system(d) shutdown, when time and disk I/O may be limited.
# TODO Use a tmpfs mount to track reboots (with appropriate BSD/Linux/Solaris checking) in the first place.
#"$1" == sessionid (optional override for cleaning up stale systemd files)
_closeChRoot_emergency() {
	_checkSpecialLocks "$lock_open_chroot"
	
	if [[ -e "$instancedVirtFS" ]]
	then
		_stopChRoot "$instancedVirtFS" >> "$logTmp"/usrchrt.log 2>&1
		_umountChRoot_project >> "$logTmp"/usrchrt.log 2>&1
		_umountChRoot_user_home >> "$logTmp"/usrchrt.log 2>&1
		_umountChRoot_user >> "$logTmp"/usrchrt.log 2>&1
		
		_rm_ubvrtusrChRoot
		
		_stop_virt_instance >> "$logTmp"/usrchrt.log 2>&1
	fi
	
	#Not called by systemd, AND instanced directories still mounted, do not globally halt all. (optional)
	#[[ "$1" == "" ]] && find "$scriptAbsoluteFolder"/v_* -maxdepth 1 -type d | _condition_lines_zero && return 0
	
	#Not called by systemd, do not globally halt all.
	[[ "$1" == "" ]] && return 0
	
	! _readLocked "$lock_open" && find "$scriptAbsoluteFolder"/v_*/fs -maxdepth 1 -type d | _condition_lines_zero && return 0
	_readLocked "$lock_closing" && return 1
	_readLocked "$lock_opening" && return 1
	
	_readLocked "$lock_emergency" && return 0
	_createLocked "$lock_emergency"
	
	_haltAllChRoot
	
	rm -f "$lock_emergency" || return 1
	
	
	local hookSessionid
	hookSessionid="$sessionid"
	[[ "$1" != "" ]] && hookSessionid="$1"
	_tryExecFull _unhook_systemd_shutdown "$hookSessionid"
	
}

#Debugging function.
_removeChRoot() {
	_haltAllChRoot
	
	rm -f "$lock_closing"
	rm -f "$lock_opening"
	rm -f "$lock_instancing"
	
	rm -f "$globalVirtDir"/_ubvrtusr
	
	
}
