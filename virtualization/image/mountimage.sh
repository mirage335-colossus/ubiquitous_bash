_test_image() {
	_mustGetSudo
	
	_getDep losetup
	#_getDep partprobe
}


# ATTENTION: WARNING: TODO: UNCOMMENT SAFE/EMPTY CONFIGURATION VARIABLES HERE IF NEEDED TO RESET ENVIRONMENT!


###

# ATTENTION: Override with 'ops', env, or similar.
# DANGER: NOT respected (and possibly not needed) by some virtualization backends.
# DANGER: Root image/device/partiton must be correct!
# WARNING: Root/Image/Device override implies 'true' "ubVirtImageLocal" .

# WARNING: Implies blank "ubVirtImagePartition" .
#export ubVirtImageIsRootPartition='true'

#export ubVirtImageIsDevice='true'
#export ubVirtImageOverride='/dev/disk/by-id/identifier-part'

# ATTENTION: Path pointing to full disk device or image, including partition table, for full booting.
# Will take precedence over "ubVirtImageOverride" with virtualization backends capable of full booting.
# vbox , qemu
#export ubVirtDiskOverride='/dev/disk/by-id/identifier'


# ATTENTION: Explicitly override platform. Not all backends support all platforms.
# chroot , qemu
# x64-bios , raspbian , x64-efi
#export ubVirtPlatformOverride='x64-bios'

###



###

# ATTENTION: Override with 'ops' or similar.
# WARNING: Do not override unnecessarily. Default rules are expected to accommodate typical requirements.

# WARNING: Only applies to imagedev (text) loopback device.
# x64 bios , raspbian , x64 efi (respectively)
#export ubVirtImagePartition='p1'
#export ubVirtImagePartition='p2'
#export ubVirtImagePartition='p3'

###



# ATTENTION: Override with 'ops' or similar.
# WARNING: Prefer to avoid override in favor of overriding other relevant variables or functions.
# DANGER: Required for safety mechanisms which may also be used by some other virtualization backends!
# WARNING: Dependency: Should run _loopImage_imagefilename .
# "$1" == imagedev
# "$2" == default (if any)
_determine_rawFileRootPartition() {
	# DANGER: REQUIRES image/device including ONLY root partition!
	if [[ "$ubVirtImageIsRootPartition" == 'true' ]]
	then
		export ubVirtImagePartition=''
		echo "$1"
		return 0
	fi
	
	if [[ "$ubVirtImagePartition" != "" ]]
	then
		echo "$1""$ubVirtImagePartition"
		return 0
	fi
	
	if [[ "$2" != "" ]]
	then
		export ubVirtImagePartition="$2"
		echo "$1""$2"
		return 0
	fi
	
	#Platform defaults.
	export ubVirtImageEFI=""
	export ubVirtImagePartition=""
	[[ "$ubVirtPlatform" == "x64-bios" ]] && export ubVirtImagePartition=p1
	[[ "$ubVirtPlatform" == "x64-efi" ]] && export ubVirtImagePartition=p3 && export ubVirtImageEFI=p2
	[[ "$ubVirtPlatform" == "raspbian" ]] && export ubVirtImagePartition=p2
	
	
	#Default.
	# DANGER: Do NOT set blank.
	[[ "$ubVirtImagePartition" == "" ]] && export ubVirtImagePartition=p1
	
	echo "$1""$ubVirtImagePartition"
	
	return 0
}



# ATTENTION: Override with 'ops' or similar.
# WARNING: Uncommenting will cause losetup not to be used for 'vm.img' and similar even if symlinked to '/dev'. This will break 'ubVirtImagePartition' .
# DANGER: Unnecessarily linking 'vm.img' or similar to device file strongly discouraged. May allow some virtualization backends to attempt to perform unsupported operations (ie. rm -f) on device file.
_detect_deviceAsVirtImage_symlinks() {
	#[[ -h "$scriptLocal"/vm.img ]] && readlink "$scriptLocal"/vm.img | grep ^\/dev\/\.\* > /dev/null 2>&1 && return 0
	#[[ -h "$scriptLocal"/vm-x64.img ]] && readlink "$scriptLocal"/vm-x64.img | grep ^\/dev\/\.\* > /dev/null 2>&1 && return 0
	#[[ -h "$scriptLocal"/vm-raspbian.img ]] && readlink "$scriptLocal"/vm-raspbian.img | grep ^\/dev\/\.\* > /dev/null 2>&1 && return 0
	
	# WARNING: Symlinks to locations outside a home subfolder (including relative symlinks) will be presumed to be device files if uncommented.
	#[[ -h "$scriptLocal"/vm.img ]] && ! readlink "$scriptLocal"/vm.img | grep ^\/home\/\.\* > /dev/null 2>&1 && return 0
	#[[ -h "$scriptLocal"/vm-x64.img ]] && ! readlink "$scriptLocal"/vm-x64.img | grep ^\/home\/\.\* > /dev/null 2>&1 && return 0
	#[[ -h "$scriptLocal"/vm-raspbian.img ]] && ! readlink "$scriptLocal"/vm-raspbian.img | grep ^\/home\/\.\* > /dev/null 2>&1 && return 0
	
	return 1
}


# DANGER: Required for safety mechanisms which may also be used by some other virtualization backends!
# DANGER: Multiple 'vm.img' variants (eg. 'vm-x64.img') available simultaneously is NOT deliberately supported and NOT safe!
# DANGER: Multiple symlinks or other conditions may confuse this safety mechanism. Only intended to prevent casual misuse.
# image
# chroot
# vbox
# qemu
# "$1" == imagefilename
_detect_deviceAsVirtImage() {
	[[ "$ubVirtImageIsDevice" != "" ]] && return 0
	[[ "$ubVirtImageOverride" == '/dev/'* ]] && return 0
	
	[[ "$1" == '/dev/'* ]] && return 0
	
	
	[[ "$1" != "" ]] && [[ -h "$1" ]] && ! readlink "$1" | grep ^\/dev\/\.\* > /dev/null 2>&1 && return 1
	[[ "$1" != "" ]] && [[ -e "$1" ]] && return 1
	_detect_deviceAsVirtImage_symlinks "$1" && return 0
	
	return 1
}

# ATTENTION: Override with 'ops' or similar.
# WARNING: Prefer to avoid override in favor of overriding other relevant variables or functions.
# DANGER: Required for safety mechanisms which may also be used by some other virtualization backends!
# "$1" == imagedev
# "$2" == imagepart
_determine_rawIsRootPartition() {
	[[ "$ubVirtImageIsRootPartition" == 'true' ]] && return 0
	[[ "$1" == "$2" ]] && return 0
	return 1
}


# DANGER: Required for safety mechanisms which may also be used by some other virtualization backends!
# DANGER: Exact values of 'ubVirtPlatform' and other variables may be required by other virtualization backends!
_loopImage_imagefilename() {
	local current_imagefilename
	[[ -e "$scriptLocal"/vm-raspbian.img ]] && current_imagefilename="$scriptLocal"/vm-raspbian.img && export ubVirtPlatform=raspbian
	[[ -e "$scriptLocal"/vm-x64.img ]] && current_imagefilename="$scriptLocal"/vm-x64.img && export ubVirtPlatform=x64-bios
	[[ -e "$scriptLocal"/vm.img ]] && current_imagefilename="$scriptLocal"/vm.img && export ubVirtPlatform=x64-bios
	[[ "$ubVirtImageOverride" != "" ]] && current_imagefilename="$ubVirtImageOverride"
	
	
	[[ "$ubVirtPlatform" == "" ]] && export ubVirtPlatform=x64-bios
	[[ "$ubVirtPlatformOverride" != "" ]] && export ubVirtPlatform="$ubVirtPlatformOverride"
	
	echo "$current_imagefilename"
}


# "$1" == imagefilename
# "$2" == imagedev (text)
_loopImage_procedure_losetup() {
	if _detect_deviceAsVirtImage "$1"
	then
		! [[ -e "$1" ]] || _stop 1
		echo "$1" > "$safeTmp"/imagedev
		sudo -n partprobe > /dev/null 2>&1
		
		cp -n "$safeTmp"/imagedev "$2" > /dev/null 2>&1 || _stop 1
		return 0
	fi
	
	sleep 1
	sudo -n losetup -f -P --show "$1" > "$safeTmp"/imagedev 2> /dev/null || _stop 1
	sudo -n partprobe > /dev/null 2>&1
	sleep 1
	
	cp -n "$safeTmp"/imagedev "$2" > /dev/null 2>&1 || _stop 1
	return 0
}

# DANGER: Optional parameter intended only for virtualization backends using only loopback devices without filesystem mounting (vbox) .
# "$1" == imagedev (text)
_loopImage_sequence() {
	_mustGetSudo
	
	_start
	
	mkdir -p "$globalVirtFS"
	
	local current_imagedev_text
	current_imagedev_text="$1"
	[[ "$current_imagedev_text" == "" ]] && current_imagedev_text="$scriptLocal"/imagedev
	
	[[ -e "$current_imagedev_text" ]] && _stop 1
	
	local current_imagefilename
	current_imagefilename=$(_loopImage_imagefilename)
	
	_loopImage_procedure_losetup "$current_imagefilename" "$current_imagedev_text"
	
	_stop 0
}

_loopImage() {
	if "$scriptAbsoluteLocation" _loopImage_sequence "$@"
	then
		return 0
	fi
	return 1
}

# DANGER: Only use with backends supporting full disk booting!
# "$1" == imagedev (text)
_loopFull_procedure() {
	if [[ "$ubVirtDiskOverride" == "" ]]
	then
		! _loopImage "$1" && _stop 1
	else
		! _loopImage_procedure_losetup "$ubVirtDiskOverride" "$1" && _stop 1
	fi
	return 0
}

# "$1" == imagedev (text)
_loopFull_sequence() {
	_start
	
	if ! _loopFull_procedure "$@"
	then
		_stop 1
	fi
	
	_stop 0
}

# "$1" == imagedev (text)
_loopFull() {
	if "$scriptAbsoluteLocation" _loopFull_sequence "$@"
	then
		return 0
	fi
	
	# Typically requires "_stop 1" .
	return 1
}


# ATTENTION: Override with 'ops' or similar.
# DANGER: Allowing types other than 'ext4' (eg. fat), may allow mounting of filesystems other than an UNIX-like userspace root.
_mountImageFS_procedure_blkid_fstype() {
	! [[ "$1" == "ext4" ]] && _stop 1
	return 0
}

# "$1" == imagedev
# "$2" == imagepart
# "$3" == dirVirtFS (RESERVED)
_mountImageFS_procedure_blkid() {
	local loopdevfs
	
	# DANGER: Must ignore/reject 'PTTYPE' field if given.
	#if _determine_rawIsRootPartition "$1" "$2"
	#then
		#loopdevfs=$(eval $(sudo -n blkid "$2" | tr -dc 'a-zA-Z0-9\=\"\ \:\/\-' | awk ' { print $4 } '); echo $TYPE)
	#else
		#loopdevfs=$(eval $(sudo -n blkid "$2" | tr -dc 'a-zA-Z0-9\=\"\ \:\/\-' | awk ' { print $3 } '); echo $TYPE)
	#fi
	loopdevfs=$(sudo -n blkid -s TYPE -o value "$2" | tr -dc 'a-zA-Z0-9')
	
	! _mountImageFS_procedure_blkid_fstype "$loopdevfs" && _stop 1
	
	return 0
}

# "$1" == destinationDir (default: "$globalVirtFS")
_mountImageFS_sequence() {
	_mustGetSudo
	
	_start
	
	local currentDestinationDir
	currentDestinationDir="$1"
	[[ "$currentDestinationDir" == "" ]] && currentDestinationDir="$globalVirtFS"
	
	mkdir -p "$globalVirtFS"
	
	"$scriptAbsoluteLocation" _checkForMounts "$currentDestinationDir" && _stop 1
	
	# Include platform determination code for correct determination of partition and mounts.
	_loopImage_imagefilename > /dev/null 2>&1
	
	local current_imagedev
	current_imagedev=$(cat "$scriptLocal"/imagedev)
	
	local current_imagepart
	current_imagepart=$(_determine_rawFileRootPartition "$current_imagedev")
	#current_imagepart=$(_determine_rawFileRootPartition "$current_imagedev" "x64-bios")
	
	
	_mountImageFS_procedure_blkid "$current_imagedev" "$current_imagepart" "$currentDestinationDir" || _stop 1
	
	
	sudo -n mount "$current_imagepart" "$currentDestinationDir" || _stop 1
	sleep 1
	
	! mountpoint "$currentDestinationDir" > /dev/null 2>&1 && sleep 3
	! mountpoint "$currentDestinationDir" > /dev/null 2>&1 && sleep 6
	! mountpoint "$currentDestinationDir" > /dev/null 2>&1 && sleep 9
	mountpoint "$currentDestinationDir" > /dev/null 2>&1 || _stop 1
	
	_stop 0
}

_mountImageFS() {
	if "$scriptAbsoluteLocation" _mountImageFS_sequence
	then
		return 0
	fi
	return 1
}

_mountImage() {
	# Include platform determination code for correct determination of partition and mounts.
	_loopImage_imagefilename > /dev/null 2>&1
	
	! _loopImage && _stop 1
	! _mountImageFS "$1" && _stop 1
	
	return 0
}

# "$1" == imagedev
# "$2" == imagedev (text)
# "$3" == imagefilename
_unmountLoop_losetup() {
	#if _detect_deviceAsVirtImage "$3" || [[ "$1" == '/dev/loop'* ]]
	if _detect_deviceAsVirtImage "$3"
	then
		! [[ -e "$1" ]] || return 1
		! [[ -e "$2" ]] || return 1
		! [[ -e "$3" ]] || return 1
		sudo -n partprobe > /dev/null 2>&1
		
		rm -f "$2" || return 1
		return 0
	fi
	
	# DANGER: Should never happen.
	[[ "$1" == '/dev/loop'* ]] || return 1
	
	# WARNING: Should never happen.
	[[ -e "$3" ]] || return 1
	
	sudo -n losetup -d "$1" > /dev/null 2>&1 || return 1
	sudo -n partprobe > /dev/null 2>&1
	
	rm -f "$2" || return 1
	return 0
}

# DANGER: Optional parameter intended only for virtualization backends using only loopback devices without filesystem mounting (vbox) .
# "$1" == imagedev (text)
_umountLoop() {
	_mustGetSudo || return 1
	
	local current_imagedev_text
	current_imagedev_text="$1"
	[[ "$current_imagedev_text" == "" ]] && current_imagedev_text="$scriptLocal"/imagedev
	
	[[ -e "$current_imagedev_text" ]] || return 1
	local current_imagedev
	current_imagedev=$(cat "$current_imagedev_text" 2>/dev/null)
	
	
	# WARNING: Consistent rules required to select correct imagefilename for both _umountLoop and _loopImage regardless of VM backend or 'ops' overrides.
	local current_imagefilename
	current_imagefilename=$(_loopImage_imagefilename)
	
	_unmountLoop_losetup "$current_imagedev" "$current_imagedev_text" "$current_imagefilename" || return 1
	
	rm -f "$lock_quicktmp" > /dev/null 2>&1
	
	return 0
}

# DANGER: Only use with backends supporting full disk booting!
# "$1" == imagedev (text)
_umountFull_procedure() {
	if [[ "$ubVirtDiskOverride" == "" ]]
	then
		! _umountLoop "$1" && _stop 1
	else
		! _unmountLoop_losetup "$ubVirtDiskOverride" "$1" "$ubVirtDiskOverride" && _stop 1
	fi
	return 0
}

_umountFull_sequence() {
	_start
	
	if ! _umountFull_procedure "$@"
	then
		_stop 1
	fi
	
	_stop 0
}

_umountFull() {
	if "$scriptAbsoluteLocation" _umountFull_sequence "$@"
	then
		return 0
	fi
	
	# Typically requires "_stop 1" .
	return 1
}

# "$1" == destinationDir (default: "$globalVirtFS")
_umountImage() {
	_mustGetSudo || return 1
	
	local currentDestinationDir
	currentDestinationDir="$1"
	[[ "$currentDestinationDir" == "" ]] && currentDestinationDir="$globalVirtFS"
	
	sudo -n umount "$currentDestinationDir" > /dev/null 2>&1
	
	#Uniquely, it is desirable to allow unmounting to proceed a little further if the filesystem was not mounted to begin with. Enables manual intervention.
	
	#Filesystem must be unmounted before proceeding.
	_readyImage "$currentDestinationDir" && return 1
	
	! _umountLoop && return 1
	
	return 0
}

_waitLoop_opening() {
	[[ -e "$scriptLocal"/imagedev ]] && return 0
	sleep 0.1
	[[ -e "$scriptLocal"/imagedev ]] && return 0
	sleep 0.3
	for iteration in `seq 1 45`;
	do
		[[ -e "$scriptLocal"/imagedev ]] && return 0
		sleep 1
	done
	
	return 1
}

_waitImage_opening() {
	_readyImage "$globalVirtFS" && return 0
	sleep 1
	_readyImage "$globalVirtFS" && return 0
	sleep 3
	_readyImage "$globalVirtFS" && return 0
	sleep 9
	_readyImage "$globalVirtFS" && return 0
	sleep 27
	_readyImage "$globalVirtFS" && return 0
	sleep 81
	_readyImage "$globalVirtFS" && return 0
	
	return 1
}

_waitLoop_closing() {
	! [[ -e "$scriptLocal"/imagedev ]] && return 0
	sleep 0.1
	! [[ -e "$scriptLocal"/imagedev ]] && return 0
	sleep 0.3
	for iteration in `seq 1 45`;
	do
		! [[ -e "$scriptLocal"/imagedev ]] && return 0
		sleep 1
	done
	
	return 1
}

_waitImage_closing() {
	_readyImage "$globalVirtFS" || return 0
	sleep 1
	_readyImage "$globalVirtFS" || return 0
	sleep 3
	_readyImage "$globalVirtFS" || return 0
	sleep 9
	_readyImage "$globalVirtFS" || return 0
	sleep 27
	_readyImage "$globalVirtFS" || return 0
	sleep 81
	_readyImage "$globalVirtFS" || return 0
	
	return 1
}

_readyImage() {
	local absolute1
	absolute1=$(_getAbsoluteLocation "$1")
	
	mountpoint "$absolute1" > /dev/null 2>&1 || return 1
	
	return 0
}

_openImage() {
	local returnStatus
	
	export specialLock="$lock_open_image"
	
	_open _waitImage_opening _mountImage
	returnStatus="$?"
	
	export specialLock=""
	
	return "$returnStatus"
}

_closeImage() {
	local returnStatus
	
	export specialLock="$lock_open_image"
	
	if [[ "$1" == "--force" ]]
	then
		_close --force _waitImage_closing _umountImage
		returnStatus="$?"
		
		export specialLock=""
		
		return "$returnStatus"
	fi
	
	_close _waitImage_closing _umountImage
	returnStatus="$?"
	
	export specialLock=""
	
	return "$returnStatus"
}

_openLoop() {
	local returnStatus
	
	export specialLock="$lock_loop_image"
	
	_open _waitLoop_opening _loopImage
	returnStatus="$?"
	
	export specialLock=""
	
	return "$returnStatus"
}

_closeLoop() {
	local returnStatus
	
	export specialLock="$lock_loop_image"
	
	if [[ "$1" == "--force" ]]
	then
		_close --force _waitLoop_closing _umountLoop
		returnStatus="$?"
		
		export specialLock=""
		
		return "$returnStatus"
	fi
	
	_close _waitLoop_closing _umountLoop
	returnStatus="$?"
	
	export specialLock=""
	
	return "$returnStatus"
}
