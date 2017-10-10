



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
	
	_openChRoot || _stop 1
	
	# DANGER Do NOT use typical safeTmp dir, as any recursive cleanup may be catastrophic.
	export chrootDir="$instancedVirtDir"
	export HOST_USER_ID=$(id -u "$USER")
	
	sudo -n mkdir -p "$instancedVirtDir" || _stop 1
	sudo -n mkdir -p "$instancedVirtDir"/home/"$virtGuestUser" || _stop 1
	
	_checkDep mountpoint || _stop 1
	mountpoint "$instancedVirtDir"/home/"$virtGuestUser" > /dev/null 2>&1 && _stop 1
	# TODO Check if home folder contents are not empty.
	
	_mountChRoot_user || _stop 1
	
	## Wait for lock file. Not done with _waitFileCommands because there is nither an obvious means, nor an obviously catastrophically critical requirement, to independently check for completion of related useradd/mod/del operations.
	while [[ -e "$scriptLocal"/_instancing ]]
	do
		sleep 1
	done
	
	## Lock file.
	echo > "$scriptLocal"/quicktmp
	mv -n "$scriptLocal"/quicktmp "$scriptLocal"/_instancing > /dev/null 2>&1 || _stop 1
	
	_chroot userdel -r "$virtGuestUser" > /dev/null 2>&1
	
	_mountChRoot_user_home || _stop 1
	
	_chroot useradd --shell /bin/bash -u "$HOST_USER_ID" -o -c "" -m "$virtGuestUser" > /dev/null 2>&1 || _stop 1
	_chroot usermod -a -G video "$virtGuestUser" || _stop 1
	
	
	## Lock file.
	rm "$scriptLocal"/_instancing > /dev/null 2>&1 || _stop 1
	
	_virtUser "$@"
	
	_mountChRoot_project || _stop 1
	
	_chroot chown "$virtGuestUser":"$virtGuestUser" "$sharedGuestProjectDir"
	
	_chroot /bin/bash /usr/bin/ubiquitous_bash.sh _dropChRoot "${processedArgs[@]}"
	local userChRootExitStatus="$?"	
	
	_stopChRoot "$chrootDir"
	
	_umountChRoot_project
	_umountChRoot_user_home || _stop 1
	_umountChRoot_user || _stop 1
	
	"$scriptAbsoluteLocation" _checkForMounts "$chrootDir" && _stop 1
	
	sudo -n rmdir "$instancedVirtDir"/home/"$virtGuestUser"
	sudo -n rmdir "$instancedVirtDir"/home
	sudo -n rmdir "$instancedVirtDir"
	
	_stop "$userChRootExitStatus"
	
}
