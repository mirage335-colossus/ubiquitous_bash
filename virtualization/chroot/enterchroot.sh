_chroot() {
	
	[[ ! -e "$chrootDir"/bin/bash ]] && return 1
	
	_mustGetSudo
	
	#cd "$chrootDir"
	
	local chrootExitStatus
	
	sudo -n env -i HOME="/root" TERM="${TERM}" SHELL="/bin/bash" PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" DISPLAY="$DISPLAY" XSOCK="$XSOCK" XAUTH="$XAUTH" localPWD="$localPWD" hostArch=$(uname -m) virtSharedUser="$virtGuestUser" USER="root" chrootName="chrt" devfast="$devfast" nonet="$nonet" GH_TOKEN="$GH_TOKEN" INPUT_GITHUB_TOKEN="$INPUT_GITHUB_TOKEN" TOKEN="$TOKEN" $(sudo -n bash -c "type -p chroot") "$chrootDir" "$@"


	# WARNING: CAUTION: May be untested.
	#export GH_TOKEN="$GH_TOKEN"
	#export INPUT_GITHUB_TOKEN="$INPUT_GITHUB_TOKEN"
	#export TOKEN="$TOKEN"
	##env -i
	#sudo -n -E --preserve-env=GH_TOKEN --preserve-env=INPUT_GITHUB_TOKEN --preserve-env=TOKEN env HOME="/root" TERM="${TERM}" SHELL="/bin/bash" PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" DISPLAY="$DISPLAY" XSOCK="$XSOCK" XAUTH="$XAUTH" localPWD="$localPWD" hostArch=$(uname -m) virtSharedUser="$virtGuestUser" USER="root" chrootName="chrt" devfast="$devfast" nonet="$nonet" $(sudo -n bash -c "type -p chroot") "$chrootDir" "$@"
	
	chrootExitStatus="$?"
	
	return "$chrootExitStatus"
	
}
