_test_image() {
	_mustGetSudo
	
	_getDep losetup
	#_getDep partprobe
}

_loopImage_sequence() {
	_mustGetSudo
	
	_start
	
	mkdir -p "$globalVirtFS"
	
	"$scriptAbsoluteLocation" _checkForMounts "$globalVirtFS" && _stop 1
	
	local imagefilename
	#[[ -e "$scriptLocal"/vm-x64.img ]] && imagefilename="$scriptLocal"/vm-x64.img
	[[ -e "$scriptLocal"/vm.img ]] && imagefilename="$scriptLocal"/vm.img
	
	sudo -n losetup -f -P --show "$imagefilename" > "$safeTmp"/imagedev 2> /dev/null || _stop 1
	sudo -n partprobe > /dev/null 2>&1
	
	cp -n "$safeTmp"/imagedev "$scriptLocal"/imagedev > /dev/null 2>&1 || _stop 1
	
	_stop 0
}

_loopImage() {
	"$scriptAbsoluteLocation" _loopImage_sequence
}

_mountImageFS_sequence() {
	_mustGetSudo
	
	_start
	
	mkdir -p "$globalVirtFS"
	
	"$scriptAbsoluteLocation" _checkForMounts "$globalVirtFS" && _stop 1
	
	local imagedev
	imagedev=$(cat "$scriptLocal"/imagedev)
	
	local imagepart
	#imagepart="$imagedev"p2
	imagepart="$imagedev"p1
	
	local loopdevfs
	loopdevfs=$(eval $(sudo -n blkid "$imagepart" | awk ' { print $3 } '); echo $TYPE)
	
	! [[ "$loopdevfs" == "ext4" ]] && _stop 1
	
	sudo -n mount "$imagepart" "$globalVirtFS" || _stop 1
	
	mountpoint "$globalVirtFS" > /dev/null 2>&1 || _stop 1
	
	_stop 0
}

_mountImageFS() {
	"$scriptAbsoluteLocation" _mountImageFS_sequence
}

_mountImage() {
	"$scriptAbsoluteLocation" _loopImage_sequence 
	"$scriptAbsoluteLocation" _mountImageFS_sequence
}

_umountImage() {
	_mustGetSudo || return 1
	
	sudo -n umount "$globalVirtFS" > /dev/null 2>&1
	
	#Uniquely, it is desirable to allow unmounting to proceed a little further if the filesystem was not mounted to begin with. Enables manual intervention.
	_readyImage "$globalVirtFS" && return 1
	
	local imagedev
	imagedev=$(cat "$scriptLocal"/imagedev)
	
	sudo -n losetup -d "$imagedev" > /dev/null 2>&1 || return 1
	sudo -n partprobe > /dev/null 2>&1
	
	rm -f "$scriptLocal"/imagedev || return 1
	
	rm -f "$lock_quicktmp" > /dev/null 2>&1
	
	return 0
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
