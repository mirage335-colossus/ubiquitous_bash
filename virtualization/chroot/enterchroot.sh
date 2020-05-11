_chroot() {
	
	[[ ! -e "$chrootDir"/bin/bash ]] && return 1
	
	_mustGetSudo
	
	#cd "$chrootDir"
	
	local chrootExitStatus
	
	sudo -n env -i HOME="/root" TERM="${TERM}" SHELL="/bin/bash" PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" DISPLAY="$DISPLAY" XSOCK="$XSOCK" XAUTH="$XAUTH" localPWD="$localPWD" hostArch=$(uname -m) virtSharedUser="$virtGuestUser" $(sudo -n bash -c "type -p chroot") "$chrootDir" "$@"
	
	chrootExitStatus="$?"
	
	return "$chrootExitStatus"
	
}
