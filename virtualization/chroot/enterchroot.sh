



_chroot() {
	
	[[ ! -e "$chrootDir"/bin/bash ]] && return 1
	
	_mustGetSudo
	
	#cd "$chrootDir"
	
	local chrootExitStatus
	
	sudo -n env -i HOME="/root" TERM="${TERM}" SHELL="/bin/bash" PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" DISPLAY="$DISPLAY" localPWD="$localPWD" hostArch=$(uname -m) $(sudo -n which chroot) "$chrootDir" "$@"
	
	chrootExitStatus="$?"
	
	
	
	
	return "$chrootExitStatus"
	
}

_ubvrtusrChRoot() {
	#If root, discontinue.
	[[ $(id -u) == 0 ]] && return 0
	
	#If user correctly setup, discontinue.
	[[ -e "$instancedVirtDir"/home/"$virtGuestUser".ref ]] && _chroot id -u "$virtGuestUser" > /dev/null 2>&1 && [[ $(_chroot id -u "$virtGuestUser") == $(id -u) ]] && return 0
	
	_chroot userdel -r "$virtGuestUser" > /dev/null 2>&1
	rmdir "$chrootDir"/home/"$virtGuestUser"/project > /dev/null 2>&1
	rmdir "$chrootDir"/home/"$virtGuestUser" > /dev/null 2>&1
	rmdir "$chrootDir"/home/"$virtGuestUser".ref/project > /dev/null 2>&1
	rmdir "$chrootDir"/home/"$virtGuestUser".ref > /dev/null 2>&1
	
	_chroot groupadd -g "$HOST_GROUP_ID" -o "$virtGuestUser" > /dev/null 2>&1
	_chroot useradd --shell /bin/bash -u "$HOST_USER_ID" -g "$HOST_GROUP_ID" -o -c "" -m "$virtGuestUser" > /dev/null 2>&1 || return 1
	
	_chroot usermod -a -G video "$virtGuestUser" > "$logTmp"/userchroot 2>&1 || return 1
	
	_chroot chown "$virtGuestUser":"$virtGuestUser" /home/"$virtGuestUser"
	
	sudo -n cp -a "$instancedVirtDir"/home/"$virtGuestUser" "$instancedVirtDir"/home/"$virtGuestUser".ref
	
	
	return 0
}

_userChRoot() {
	_start
	
	_openChRoot > "$logTmp"/userchroot 2>&1 || _stop 1
	
	# DANGER Do NOT use typical safeTmp dir, as any recursive cleanup may be catastrophic.
	export chrootDir="$instancedVirtDir"
	export HOST_USER_ID=$(id -u)
	export HOST_GROUP_ID=$(id -g)
	
	sudo -n mkdir -p "$instancedVirtDir" > "$logTmp"/userchroot 2>&1 || _stop 1
	sudo -n mkdir -p "$instancedVirtDir"/home/"$virtGuestUser" > "$logTmp"/userchroot 2>&1 || _stop 1
	sudo -n mkdir -p "$instancedVirtDir"/home/"$virtGuestUser".ref > "$logTmp"/userchroot 2>&1 || _stop 1
	
	_checkDep mountpoint > "$logTmp"/userchroot 2>&1 || _stop 1
	mountpoint "$instancedVirtDir"/home/"$virtGuestUser" > /dev/null 2>&1 && _stop 1
	
	_mountChRoot_user > "$logTmp"/userchroot 2>&1 || _stop 1
	
	## Wait for lock file. Not done with _waitFileCommands because there is nither an obvious means, nor an obviously catastrophically critical requirement, to independently check for completion of related useradd/mod/del operations.
	[[ -e "$scriptLocal"/_instancing ]] && sleep 1
	[[ -e "$scriptLocal"/_instancing ]] && sleep 9
	[[ -e "$scriptLocal"/_instancing ]] && sleep 27
	[[ -e "$scriptLocal"/_instancing ]] && sleep 81
	[[ -e "$scriptLocal"/_instancing ]] && _stop 1
	
	## Lock file.
	echo > "$scriptLocal"/quicktmp
	mv -n "$scriptLocal"/quicktmp "$scriptLocal"/_instancing > /dev/null 2>&1 || _stop 1
	
	#If guest/host user/group id does not match, recreate guest user. Do nothing for root user.
	_ubvrtusrChRoot > "$logTmp"/userchroot 2>&1 || _stop 1
	
	_mountChRoot_user_home > "$logTmp"/userchroot 2>&1 || _stop 1
	_chroot /bin/bash /usr/bin/ubiquitous_bash.sh _prepareChRootUser
	
	## Lock file.
	rm "$scriptLocal"/_instancing > /dev/null 2>&1 || _stop 1
	
	export checkBaseDirRemote=_checkBaseDirRemote_chroot
	_virtUser "$@" > "$logTmp"/userchroot 2>&1
	
	_mountChRoot_project > "$logTmp"/userchroot 2>&1 || _stop 1
	
	_chroot chown "$virtGuestUser":"$virtGuestUser" "$sharedGuestProjectDir" > "$logTmp"/userchroot 2>&1
	
	_chroot /bin/bash /usr/bin/ubiquitous_bash.sh _dropChRoot "${processedArgs[@]}"
	local userChRootExitStatus="$?"	
	
	_stopChRoot "$chrootDir" > "$logTmp"/userchroot 2>&1
	
	_umountChRoot_project > "$logTmp"/userchroot 2>&1
	_umountChRoot_user_home > "$logTmp"/userchroot 2>&1 || _stop 1
	_umountChRoot_user > "$logTmp"/userchroot 2>&1 || _stop 1
	
	"$scriptAbsoluteLocation" _checkForMounts "$chrootDir" > "$logTmp"/userchroot 2>&1 && _stop 1
	
	sudo -n rmdir "$instancedVirtDir"/home/"$virtGuestUser" > "$logTmp"/userchroot 2>&1
	sudo -n rmdir "$instancedVirtDir"/home/"$virtGuestUser".ref > "$logTmp"/userchroot 2>&1
	sudo -n rmdir "$instancedVirtDir"/home > "$logTmp"/userchroot 2>&1
	sudo -n rmdir "$instancedVirtDir" > "$logTmp"/userchroot 2>&1
	
	#cat "$logTmp"/userchroot
	
	_stop "$userChRootExitStatus"
	
}


_removeUserChRoot() {
	_openChRoot
	
	_chroot userdel -r "$virtGuestUser" > /dev/null 2>&1
	rmdir "$chrootDir"/home/"$virtGuestUser"/project > /dev/null 2>&1
	rmdir "$chrootDir"/home/"$virtGuestUser" > /dev/null 2>&1
	rmdir "$chrootDir"/home/"$virtGuestUser".ref/project > /dev/null 2>&1
	rmdir "$chrootDir"/home/"$virtGuestUser".ref > /dev/null 2>&1
	
	_removeChRoot
}





