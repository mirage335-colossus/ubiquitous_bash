



_chroot() {

	[[ ! -e "$chrootDir"/bin/bash ]] && return 1
	
	_mustGetSudo
	
	#cd "$chrootDir"
	
	local chrootExitStatus
	
	sudo -n env -i HOME="/root" TERM="${TERM}" SHELL="/bin/bash" PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" DISPLAY="$DISPLAY" $(sudo -n which chroot) "$chrootDir" "$@"
	
	chrootExitStatus="$?"
	
	
	
	
	return "$chrootExitStatus"
	
}

_userChRoot() {
	
	# DANGER Do NOT use typical safeTmp dir, as any recursive cleanup may be catastrophic.
	export globalChRootDir="$chrootDir"
	export instancedChrootDir="$scriptAbsoluteFolder"/v_"$sessionid"/chroot
	export chrootDir="$instancedChrootDir"
	export HOST_USER_ID=$(id -u "$USER")
	
	mkdir -p "$instancedChrootDir" || return 1
	mkdir -p "$instancedChrootDir"/home/ubvrtusr || return 1
	
	_checkDep mountpoint || return 1
	mountpoint "$instancedChrootDir"/home/ubvrtusr > /dev/null 2>&1 && return 1
	# TODO Check if home folder contents are not empty.
	
	_mountChRoot_user || return 1
	
	_chroot userdel -r ubvrtusr > /dev/null 2>&1
	
	mkdir -p "$instancedChrootDir"/home/ubvrtusr || return 1
	_mountChRoot_user_home || return 1
	
	_chroot useradd --shell /bin/bash -u "$HOST_USER_ID" -o -c "" -m ubvrtusr > /dev/null 2>&1 || return 1
	_chroot usermod -a -G video ubvrtusr || return 1
	
	
	_mountChRoot_project || return 1
	
	_chroot /usr/bin/ubiquitous_bash.sh _dropChRoot "$@"
	local userChRootExitStatus="$?"
	
	
	
	
	
	_stopChRoot "$chrootDir"
		
	_umountChRoot_user_home || return 1
	_umountChRoot_user || return 1
	
	mountpoint "$chrootDir" > /dev/null 2>&1 || return 1
	sudo -n umount "$chrootDir" || return 1
	
	
	"$scriptAbsoluteLocation" _checkForMounts "$chrootDir" && return 1
	
	return "$userChRootExitStatus"
	
}
