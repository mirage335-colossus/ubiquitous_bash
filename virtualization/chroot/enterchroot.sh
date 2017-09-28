
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

_closeChRoot() {
	[[ -e "$scriptLocal"/_closing ]] || return 1
	
	_start
	
	_mustGetSudo
	
	echo > "$scriptLocal"/_closing
	
	_stopChRoot "$chrootDir"
	_umountChRoot "$chrootDir"
	mountpoint "$chrootDir" > /dev/null 2>&1 && sudo -n umount "$chrootDir"
	
	"$scriptAbsoluteLocation" _checkForMounts "$chrootDir" && _stop 1
	
	rm "$scriptLocal"/_closing
	
	rm "$scriptLocal"/WARNING
	
	_stop
}

imageLoop_raspbian() {
	_mustGetSudo
	
	_start
	
	mkdir -p "$chrootDir"
	
	if sudo -n losetup -f -P --show "$scriptLocal"/vm-raspbian.img > "$safeTmp"/imagedev 2> /dev/null
	then
		local imagedev
		imagedev="$safeTmp"/imagedev
		
		local imagepart
		imagepart="$imagedev"p2
		
		local loopdevfs
		loopdevfs=$(eval $(sudo -n blkid "$imagepart" | awk ' { print $3 } '); echo $TYPE)
		
		if [[ "$loopdevfs" == "ext4" ]]
		then
			
			mount "$imagepart" "$chrootDir"
			
		fi
		
		
		
	fi
	
	
	mountpoint "$chrootDir" > /dev/null 2>&1 || _stop 1
	
	_mountChRoot "$chrootDir"
	
	_readyChRoot "$chrootDir" || _stop 1
	
	_stop 0
}

_imageLoop_Native() {
	_mustGetSudo
	mkdir -p "$chrootDir"
	
	
}

_imageLoop_platforms() {
	_mustGetSudo
	mkdir -p "$chrootDir"
	
	if [[ -e "$scriptLocal"/vm-raspbian.img ]]
	then
		imageLoop_raspbian
		return "$?"
	fi
	
	if [[ -e "$scriptLocal"/vm.img ]]
	then
		_imageLoop_Native
		return "$?"
	fi
}

_imageChRoot() {
	_mustGetSudo
	mkdir -p "$chrootDir"
	
	[[ -e "$scriptLocal"/_closing ]] || return 1
	
	if [[ -e "$scriptLocal"/_opening ]] || "$scriptAbsoluteLocation" _checkForMounts "$chrootDir"
	then
		_waitChRoot_opening || return 1
		_readyChRoot || return 1
	fi
	
	echo > "$scriptLocal"/_opening
	
	
	if ! _imageLoop_platforms
	then
		"$scriptAbsoluteLocation" _closeChRoot
		
		rm "$scriptLocal"/_opening
		
		return 1
	fi
	
	
	rm "$scriptLocal"/_opening
}


_openChRoot() {
	_start
	
	_mustGetSudo
	
	echo "OPEN CHROOT" > "$scriptLocal"/WARNING
	
	mkdir -p "$chrootDir"
	
	_imageChRoot || _stop 1
	
	_stop
}



_chrootRasPi() {
	
	
	#effectively disable /etc/ld.so.preload
	
	
	true
	#chroot
	
	#enable default /etc/ld.so.preload
} 
