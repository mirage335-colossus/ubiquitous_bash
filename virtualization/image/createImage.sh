_testCreateFS() {
	_mustGetSudo
	
	_getDep mkfs
	_getDep mkfs.ext4
}

_testCreatePartition() {
	_mustGetSudo
	
	_getDep parted
	#_getDep partprobe
}

_createRawImage_sequence() {
	_start
	
	export vmImageFile="$scriptLocal"/vm.img
	
	[[ "$1" != "" ]] && export vmImageFile="$1"
	
	local createRawImageSize
	createRawImageSize=7636
	[[ "$vmSize" != "" ]] && createRawImageSize="$vmSize"
	
	[[ "$vmImageFile" == "" ]] && _stop 1
	[[ -e "$vmImageFile" ]] && _stop 1
	
	dd if=/dev/zero of="$vmImageFile" bs=1M count="$createRawImageSize" > /dev/null 2>&1
	
	_stop
}

_createRawImage() {
	
	"$scriptAbsoluteLocation" _createRawImage_sequence "$@"
	
}

_createPartition() {
	_mustGetSudo
	
	sudo -n parted --script "$scriptLocal"/vm.img mklabel msdos
	sudo -n partprobe > /dev/null 2>&1
	sudo -n parted "$scriptLocal"/vm.img --script -- mkpart primary 0% 100%
	sudo -n partprobe > /dev/null 2>&1
}


_createFS_sequence() {
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
	loopdevfs=$(sudo -n blkid -s TYPE -o value "$imagepart" | tr -dc 'a-zA-Z0-9')
	[[ "$loopdevfs" == "ext4" ]] && _stop 1
	sudo -n mkfs.ext4 "$imagepart" > /dev/null 2>&1 || _stop 1
	
	_stop 0
}

_createFS_shell() {
	"$scriptAbsoluteLocation" _loopImage_sequence || return 1
	"$scriptAbsoluteLocation" _createFS_sequence || return 1
	"$scriptAbsoluteLocation" _umountImage || return 1
	return 0
}

_createFS() {
	local returnCode
	_open true _createFS_shell
	returnCode="$?"
	_close true true
	
	return "$returnCode"
}




