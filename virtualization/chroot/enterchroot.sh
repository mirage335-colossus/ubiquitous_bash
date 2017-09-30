_chroot_raspi() {
	[[ ! -e "$chrootDir"/bin/bash ]] && return 1
	
	_mustGetSudo
	
	#cd "$chrootDir"
	
	sudo -n env -i HOME="/root" TERM="${TERM}" SHELL="/bin/bash" PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" DISPLAY="$DISPLAY" $(sudo -n which chroot) "$chrootDir"
} 


_chroot() {
	if [[ -e "$scriptLocal"/vm-raspbian.img ]]
	then
		"$scriptAbsoluteLocation" _chroot_raspi
		return "$?"
	fi
	
	if [[ -e "$scriptLocal"/vm-x64.img ]]
	then
		"$scriptAbsoluteLocation" _chroot_x64
		return "$?"
	fi
	
	
}
