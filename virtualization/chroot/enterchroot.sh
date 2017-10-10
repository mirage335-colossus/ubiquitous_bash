



_chroot() {
	
	[[ ! -e "$chrootDir"/bin/bash ]] && return 1
	
	_mustGetSudo
	
	#cd "$chrootDir"
	
	local chrootExitStatus
	
	sudo -n env -i HOME="/root" TERM="${TERM}" SHELL="/bin/bash" PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" DISPLAY="$DISPLAY" $(sudo -n which chroot) "$chrootDir" "$@"
	
	chrootExitStatus="$?"
	
	
	
	
	return "$chrootExitStatus"
	
}

# TODO Check if ubvrtusr uid actually needs to be changed/recreated.
_userChRoot() {
	_start
	
	_openChRoot > "$logTmp"/userchroot 2>&1 || _stop 1
	
	# DANGER Do NOT use typical safeTmp dir, as any recursive cleanup may be catastrophic.
	export chrootDir="$instancedVirtDir"
	export HOST_USER_ID=$(id -u "$USER")
	
	sudo -n mkdir -p "$instancedVirtDir" > "$logTmp"/userchroot 2>&1 || _stop 1
	sudo -n mkdir -p "$instancedVirtDir"/home/"$virtGuestUser" > "$logTmp"/userchroot 2>&1 || _stop 1
	
	_checkDep mountpoint > "$logTmp"/userchroot 2>&1 || _stop 1
	mountpoint "$instancedVirtDir"/home/"$virtGuestUser" > /dev/null 2>&1 && _stop 1
	# TODO Check if home folder contents are not empty.
	
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
	
	_chroot userdel -r "$virtGuestUser" > /dev/null 2>&1
	
	_mountChRoot_user_home > "$logTmp"/userchroot 2>&1 || _stop 1
	
	_chroot useradd --shell /bin/bash -u "$HOST_USER_ID" -o -c "" -m "$virtGuestUser" > /dev/null 2>&1 || _stop 1
	_chroot usermod -a -G video "$virtGuestUser" > "$logTmp"/userchroot 2>&1 || _stop 1
	
	
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
	sudo -n rmdir "$instancedVirtDir"/home > "$logTmp"/userchroot 2>&1
	sudo -n rmdir "$instancedVirtDir" > "$logTmp"/userchroot 2>&1
	
	_stop "$userChRootExitStatus"
	
}
