
_docker_img_enboot_sequence() {
	_messageNormal "#####Disabling docker."
	
	#Debian image, created by mkimage, is bootable without further docker-specific and/or automation suitable modifications as of 11-12-2017 .
	
	_messageProcess "Enabling fstab"
	[[ -e "$chrootDir"/etc/fstab.dsv ]] && sudo -n mv "$chrootDir"/etc/fstab.dsv "$chrootDir"/etc/fstab
	_messagePASS
	
	_messageProcess "Enabling resolv"
	[[ -e "$chrootDir"/etc/resolv.conf.dsv ]] && sudo -n mv "$chrootDir"/etc/resolv.conf.dsv "$chrootDir"/etc/resolv.conf
	_messagePASS
}

#Only use to reverse docker specific boot impediments. Install bootloader as part of ChRoot functionality.
#http://mr.gy/blog/build-vm-image-with-docker.html
#http://www.olafdietsche.de/2016/03/24/debootstrap-bootable-image
_docker_img_enboot() {
	"$scriptAbsoluteLocation" _docker_img_enboot_sequence
}

_docker_img_endocker_sequence() {
	_start
	
	_mustGetSudo
	
	_readLocked "$lock_open_image" && _stop 1
	
	local localFunctionEntryPWD
	localFunctionEntryPWD="$PWD"
	
	cd "$scriptAbsoluteFolder"
	
	_messageNormal "#####Enabling docker."
	
	_messageProcess "Sanity"
	[[ "$chrootDir" == "" ]] && _messageFAIL && _stop 1
	_messagePASS
	
	_messageProcess "Opening"
	if ! _openChRoot > /dev/null 2>&1
	then
		_messageFAIL
		_stop 1
	fi
	_messagePASS
	
	_messageProcess "Removing user"
	if ! _removeUserChRoot_sequence
	then
		_messageFAIL
		_stop 1
	fi
	_messagePASS
	
	_messageProcess "Disabling fstab"
	[[ -s "$chrootDir"/etc/fstab ]] && sudo -n mv "$chrootDir"/etc/fstab "$chrootDir"/etc/fstab.dsv > /dev/null 2>&1
	echo | sudo -n tee > /dev/null "$chrootDir"/etc/fstab
	_messagePASS
	
	_messageProcess "Disabling resolv"
	[[ -s "$chrootDir"/etc/resolv.conf ]] &&  sudo -n mv "$chrootDir"/etc/resolv.conf "$chrootDir"/etc/resolv.conf.dsv > /dev/null 2>&1
	echo | sudo -n tee > /dev/null "$chrootDir"/etc/resolv.conf
	_messagePASS
	
	_messageProcess "Closing"
	if ! _closeChRoot > /dev/null 2>&1
	then
		_messageFAIL
		_stop 1
	fi
	_messagePASS
	
	#rm "$logTmp"/log.log
	cd "$localFunctionEntryPWD"
	_stop
}

#Reverse operations performed by _docker_img_enboot .
_docker_img_endocker() {
	"$scriptAbsoluteLocation" _docker_img_endocker_sequence
}

_docker_img_to_tar_sequence() {
	_mustGetSudo
	
	_start
	
	local localFunctionEntryPWD
	localFunctionEntryPWD="$PWD"
	
	_openImage
	
	
	
	cd "$globalVirtFS"
	
	sudo -n tar --selinux --acls --xattrs -cpf "$scriptLocal"/"dockerImageFS".tar ./ --exclude '/lost+found'
	
	cd "$localFunctionEntryPWD"
	
	#
	
	cd "$localFunctionEntryPWD"
	_closeImage
	
	_stop
}


_docker_img_to_tar() {
	_messageProcess "Searching conflicts"
	[[ -e "$scriptLocal"/"dockerContainerFS".tar ]] && _messageFAIL && return 1
	[[ -e "$scriptLocal"/"dockerImageFS".tar ]] && _messageFAIL && return 1
	[[ -e "$scriptLocal"/"dockerImageAll".tar ]] && _messageFAIL && return 1
	! [[ -e "$scriptLocal"/vm.img ]] && _messageFAIL && return 1
	_messagePASS
	
	_messageProcess "Copying files"
	"$scriptAbsoluteLocation" _docker_img_to_tar_sequence
	_messagePASS
	
	_messageProcess "Validating readiness"
	_readLocked "$lock_open" && _messageFAIL && return 1
	_readLocked "$lock_opening" && _messageFAIL && return 1
	_readLocked "$lock_closing" && _messageFAIL && return 1
	_readLocked "$lock_emergency" && _messageFAIL && return 1
	_messagePASS
	
	
	return 0
}

_docker_tar_to_img_sequence() {
	_mustGetSudo
	
	_start
	
	local localFunctionEntryPWD
	localFunctionEntryPWD="$PWD"
	
	_openImage
	
	_messageProcess "Copying files"
	cd "$globalVirtFS"
	
	#if ! sudo -n tar --selinux --acls --xattrs xpf "$scriptLocal"/"dockerImageFS".tar
	if ! sudo -n tar xpf "$scriptLocal"/"dockerImageFS".tar
	then
		_messageFAIL
		_stop 1
	fi
	
	#[[ ! -e '/dev' ]] && _messageFAIL && _stop 1
	
	_messagePASS
	cd "$localFunctionEntryPWD"
	
	#
	
	cd "$localFunctionEntryPWD"
	_closeImage
	
	_stop
}

#http://mr.gy/blog/build-vm-image-with-docker.html
_docker_tar_to_img() {
	_messageProcess "Searching conflicts"
	[[ -e "$scriptLocal"/vm.img ]] && _messageFAIL && return 1
	[[ -e "$scriptLocal"/vm*.img ]] && _messageFAIL && return 1
	! [[ -e "$scriptLocal"/"dockerImageFS".tar ]] && _messageFAIL && return 1
	_messagePASS
	
	_messageProcess "Creating raw"
	_createRawImage
	! [[ -e "$scriptLocal"/vm.img ]] && _messageFAIL && return 1
	_messagePASS
	
	
	_messageProcess "Creating partition"
	if ! _createPartition
	then
		_messageFAIL
		return 1
	fi
	_messagePASS
	
	_messageProcess "Creating FS"
	if ! _createFS
	then
		_messageFAIL
		return 1
	fi
	_messagePASS
	
	"$scriptAbsoluteLocation" _docker_tar_to_img_sequence
	
	
	_messageProcess "Validating readiness"
	_readLocked "$lock_open" && _messageFAIL && return 1
	_readLocked "$lock_opening" && _messageFAIL && return 1
	_readLocked "$lock_closing" && _messageFAIL && return 1
	_readLocked "$lock_emergency" && _messageFAIL && return 1
	_messagePASS
	
	
	return 0
}

# WARNING In automated use, the load command may not result in an image name matching the path locked docker id.
_docker_load() {
	[[ -e "$scriptLocal"/"dockerImageAll".tar ]] && _permitDocker docker load < "$scriptLocal"/"dockerImageAll".tar
}

_dockerLoad() {
	_docker_load "$@"
}

_docker_save_sequence() {
	_start
	_prepare_docker
	
	_permitDocker docker save "$dockerImageObjectName" > "$scriptLocal"/"dockerImageAll".tar
	
	_stop
}

#https://stackoverflow.com/questions/23935141/how-to-copy-docker-images-from-one-host-to-another-without-via-repository
_docker_save() {
	_messageProcess "Searching conflicts"
	[[ -e "$scriptLocal"/"dockerContainerFS".tar ]] && _messageFAIL && return 1
	[[ -e "$scriptLocal"/"dockerImageFS".tar ]] && _messageFAIL && return 1
	#[[ -e "$scriptLocal"/"dockerImageAll".tar ]] && _messageFAIL && return 1
	_messagePASS
	
	_messageProcess "Saving ""$dockerImageObjectName"
	
	"$scriptAbsoluteLocation" _docker_save_sequence "$@"
	
	 ! [[ -s "$scriptLocal"/"dockerImageAll".tar ]] && _messageFAIL && return 1
	 _messagePASS
	 return 0
}

_dockerSave() {
	_docker_save "$@"
}
