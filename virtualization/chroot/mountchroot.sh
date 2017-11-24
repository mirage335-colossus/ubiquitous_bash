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
	sudo -n mkdir -p "$chrootDir"/usr/local/bin/
	sudo -n mkdir -p "$chrootDir"/usr/local/share/ubcore/bin/
	
	sudo -n cp "$scriptAbsoluteLocation" "$chrootDir"/usr/local/bin/ubiquitous_bash.sh
	sudo -n chmod 755 "$chrootDir"/usr/local/bin/ubiquitous_bash.sh
	sudo -n chown root:root "$chrootDir"/usr/local/bin/ubiquitous_bash.sh
	sudo -n cp "$scriptBin"/gosu-armel "$chrootDir"/usr/local/share/ubcore/bin/gosu-armel
	sudo -n cp "$scriptBin"/gosu-amd64 "$chrootDir"/usr/local/share/ubcore/bin/gosu-amd64
	sudo -n cp "$scriptBin"/gosu-i386 "$chrootDir"/usr/local/share/ubcore/bin/gosu-i386
	sudo -n chmod 755 "$chrootDir"/usr/local/share/ubcore/bin/*
	sudo -n chown root:root "$chrootDir"/usr/local/share/ubcore/bin/*
	
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
	
	_wait_umount "$absolute1"/proc
	_wait_umount "$absolute1"/sys
	
	_wait_umount "$absolute1"/tmp
	
	_wait_umount "$absolute1"/dev
	
	_wait_umount "$absolute1" >/dev/null 2>&1
	
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

_mountChRoot_image_raspbian() {
	_mustGetSudo
	
	_start
	
	mkdir -p "$chrootDir"
	
	"$scriptAbsoluteLocation" _checkForMounts "$chrootDir" && _stop 1
	
	if sudo -n losetup -f -P --show "$scriptLocal"/vm-raspbian.img > "$safeTmp"/imagedev 2> /dev/null
	then
		#Preemptively declare device open to prevent potentially dangerous multiple mount attempts.
		#Should now be redundant with use of lock_opening .
		#_createLocked "$lock_open" || _stop 1
		
		cp -n "$safeTmp"/imagedev "$scriptLocal"/imagedev > /dev/null 2>&1 || _stop 1
		
		local chrootimagedev
		chrootimagedev=$(cat "$safeTmp"/imagedev)
		
		local chrootimagepart
		chrootimagepart="$chrootimagedev"p2
		
		local chrootloopdevfs
		chrootloopdevfs=$(eval $(sudo -n blkid "$chrootimagepart" | awk ' { print $3 } '); echo $TYPE)
		
		if [[ "$chrootloopdevfs" == "ext4" ]]
		then
			
			sudo -n mount "$chrootimagepart" "$chrootDir" || _stop 1
			
			mountpoint "$chrootDir" > /dev/null 2>&1 || _stop 1
			
			_mountChRoot "$chrootDir"
			
			_readyChRoot "$chrootDir" || _stop 1
			
			sudo -n cp /usr/bin/qemu-arm-static "$chrootDir"/usr/bin/
			sudo -n cp /usr/bin/qemu-armeb-static "$chrootDir"/usr/bin/
			
			sudo -n cp -n "$chrootDir"/etc/ld.so.preload "$chrootDir"/etc/ld.so.preload.orig
			echo | sudo -n tee "$chrootDir"/etc/ld.so.preload > /dev/null 2>&1
			
			_stop 0
		fi
		
	fi
	
	_stop 1
}

_umountChRoot_directory_raspbian() {
	
	_mustGetSudo
	
	mkdir -p "$chrootDir"
	
	sudo -n cp "$chrootDir"/etc/ld.so.preload.orig "$chrootDir"/etc/ld.so.preload
	
}

_mountChRoot_image_x64() {
	_mustGetSudo
	
	_start
	
	mkdir -p "$chrootDir"
	
	"$scriptAbsoluteLocation" _checkForMounts "$chrootDir" && _stop 1
	
	local chrootvmimage
	[[ -e "$scriptLocal"/vm-x64.img ]] && chrootvmimage="$scriptLocal"/vm-x64.img
	[[ -e "$scriptLocal"/vm.img ]] && chrootvmimage="$scriptLocal"/vm.img
	
	sudo -n losetup -f -P --show "$chrootvmimage" > "$safeTmp"/imagedev 2> /dev/null || _stop 1
	
	cp -n "$safeTmp"/imagedev "$scriptLocal"/imagedev > /dev/null 2>&1 || _stop 1
	
	local chrootimagedev
	chrootimagedev=$(cat "$safeTmp"/imagedev)
	
	local chrootimagepart
	#chrootimagepart="$chrootimagedev"p2
	chrootimagepart="$chrootimagedev"p1
	
	local chrootloopdevfs
	chrootloopdevfs=$(eval $(sudo -n blkid "$chrootimagepart" | awk ' { print $3 } '); echo $TYPE)
	
	! [[ "$chrootloopdevfs" == "ext4" ]] && _stop 1
	
	sudo -n mount "$chrootimagepart" "$chrootDir" || _stop 1
	
	mountpoint "$chrootDir" > /dev/null 2>&1 || _stop 1
	
	_mountChRoot "$chrootDir"
	
	_readyChRoot "$chrootDir" || _stop 1
	
	_stop 0
}

_umountChRoot_directory_x64() {
	_mustGetSudo
	
	mkdir -p "$chrootDir"
}

_mountChRoot_image() {
	_tryExecFull _hook_systemd_shutdown_action "_closeChRoot_emergency" "$sessionid"
	
	if [[ -e "$scriptLocal"/vm-raspbian.img ]]
	then
		"$scriptAbsoluteLocation" _mountChRoot_image_raspbian
		return "$?"
	fi
	
	if [[ -e "$scriptLocal"/vm-x64.img ]]
	then
		"$scriptAbsoluteLocation" _mountChRoot_image_x64
		return "$?"
	fi
	
	#Default "vm.img" will be operated on as x64 image.
	"$scriptAbsoluteLocation" _mountChRoot_image_x64
	return "$?"
}

_umountChRoot_directory() {
	if [[ -e "$scriptLocal"/vm-raspbian.img ]]
	then
		"$scriptAbsoluteLocation" _umountChRoot_directory_raspbian || return "$?"
	fi
	
	if [[ -e "$scriptLocal"/vm-x64.img ]]
	then
		"$scriptAbsoluteLocation" _umountChRoot_directory_x64 || return "$?"
	fi
	
	#Default "vm.img" will be operated on as x64 image.
	"$scriptAbsoluteLocation" _umountChRoot_directory_x64 || return "$?"
	
	_stopChRoot "$1"
	_umountChRoot "$1"
	mountpoint "$1" > /dev/null 2>&1 && sudo -n umount "$1"
	
	"$scriptAbsoluteLocation" _checkForMounts "$1" && return 1
}

_umountChRoot_image() {
	_mustGetSudo || return 1
	
	_umountChRoot_directory "$chrootDir" && return 1
	
	local chrootimagedev
	chrootimagedev=$(cat "$scriptLocal"/imagedev)
	
	sudo -n losetup -d "$chrootimagedev" > /dev/null 2>&1 || return 1
	
	rm -f "$scriptLocal"/imagedev || return 1
	
	rm -f "$lock_quicktmp" > /dev/null 2>&1
	
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
	_open _waitChRoot_opening _mountChRoot_image
}

_closeChRoot() {
	if [[ "$1" == "--force" ]]
	then
		_close --force _waitChRoot_closing _umountChRoot_image
		return
	fi
	
	_close _waitChRoot_closing _umountChRoot_image
}

_haltAllChRoot() {
	find "$scriptAbsoluteFolder"/v_*/fs -maxdepth 1 -type d -exec "$scriptAbsoluteLocation" _umountChRoot_directory {} \;
	find "$scriptAbsoluteFolder"/v_*/tmp -maxdepth 1 -type d -exec sudo -n umount {} \;
	find "$scriptAbsoluteFolder"/v_*/ -maxdepth 12 -type d | head -n 48 | tac | xargs rmdir
	
	"$scriptAbsoluteLocation" _closeChRoot --force
	
	#Closing file may remain if chroot was not open to begin with. Since haltAllChRoot is usually called for forced/emergency shutdown purposes, clearing the resultant lock file is usually safe.
	rm -f "$lock_closing"
}

#Fast dismount of all ChRoot filesystems/instances and cleanup of lock files. Specifically intended to act on SIGTERM or during system(d) shutdown, when time and disk I/O may be limited.
# TODO Use a tmpfs mount to track reboots (with appropriate BSD/Linux/Solaris checking) in the first place.
#"$1" == sessionid (optional override for cleaning up stale systemd files)
_closeChRoot_emergency() {
	
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
	#[[ "$1" == "" ]] && find "$scriptAbsoluteFolder"/v_* -maxdepth 1 -type d > /dev/null && return 0
	
	#Not called by systemd, do not globally halt all.
	[[ "$1" == "" ]] && return 0
	
	! _readLocked "$lock_open" && ! find "$scriptAbsoluteFolder"/v_*/fs -maxdepth 1 -type d && return 0
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
