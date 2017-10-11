



_chroot() {
	
	[[ ! -e "$chrootDir"/bin/bash ]] && return 1
	
	_mustGetSudo
	
	#cd "$chrootDir"
	
	local chrootExitStatus
	
	sudo -n env -i HOME="/root" TERM="${TERM}" SHELL="/bin/bash" PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" DISPLAY="$DISPLAY" localPWD="$localPWD" hostArch=$(uname -m) $(sudo -n which chroot) "$chrootDir" "$@"
	
	chrootExitStatus="$?"
	
	return "$chrootExitStatus"
	
}

_rm_ubvrtusrChRoot() {
	
	sudo -n rmdir "$sharedGuestProjectDir" > /dev/null 2>&1
	sudo -n rmdir "$instancedVirtHome"/"$virtGuestUser"/project > /dev/null 2>&1
	sudo -n rmdir "$instancedVirtHome"/"$virtGuestUser" > /dev/null 2>&1
	sudo -n rmdir "$instancedVirtHome" > /dev/null 2>&1
	sudo -n rmdir "$instancedVirtHomeRef"/project > /dev/null 2>&1
	sudo -n rmdir "$instancedVirtHomeRef"/"$virtGuestUser"/project > /dev/null 2>&1
	sudo -n rmdir "$instancedVirtHomeRef"/"$virtGuestUser" > /dev/null 2>&1
	sudo -n rmdir "$instancedVirtHomeRef" > /dev/null 2>&1
	
}

_ubvrtusrChRoot() {
	## Lock file. Not done with _waitFileCommands because there is nither an obvious means, nor an obviously catastrophically critical requirement, to independently check for completion of related useradd/mod/del operations.
	_waitFile "$globalVirtDir"/_ubvrtusr || return 1
	echo > "$globalVirtDir"/quicktmp
	mv -n "$globalVirtDir"/quicktmp "$globalVirtDir"/_ubvrtusr > /dev/null 2>&1 || return 1
	
	
	#If root, discontinue.
	[[ $(id -u) == 0 ]] && return 0
	
	#If user correctly setup, discontinue.
	[[ -e "$instancedVirtHomeRef" ]] && _chroot id -u "$virtGuestUser" > /dev/null 2>&1 && [[ $(_chroot id -u "$virtGuestUser") == "$HOST_USER_ID" ]] && [[ $(_chroot id -g "$virtGuestUser") == "$HOST_GROUP_ID" ]] && return 0
	
	_chroot userdel -r "$virtGuestUser" > /dev/null 2>&1
	_rm_ubvrtusrChRoot
	
	_chroot groupadd -g "$HOST_GROUP_ID" -o "$virtGuestUser" > /dev/null 2>&1
	_chroot useradd --shell /bin/bash -u "$HOST_USER_ID" -g "$HOST_GROUP_ID" -o -c "" -m "$virtGuestUser" > /dev/null 2>&1 || return 1
	
	_chroot usermod -a -G video "$virtGuestUser"  > /dev/null 2>&1 || return 1
	
	_chroot chown "$virtGuestUser":"$virtGuestUser" "$instancedVirtHome" > /dev/null 2>&1
	
	sudo -n cp -a "$instancedVirtHome" "$instancedVirtHomeRef" > /dev/null 2>&1
	
	_chroot chown "$virtGuestUser":"$virtGuestUser" "$instancedVirtHomeRef" > /dev/null 2>&1
	
	rm "$globalVirtDir"/_ubvrtusr > /dev/null 2>&1 || _stop 1
	
	return 0
}

_userChRoot() {
	_start
	_start_virt_all
	export chrootDir="$globalVirtFS"
	
	_mustGetSudo || _stop 1
	
	_checkDep mountpoint > "$logTmp"/userchroot 2>&1 || _stop 1
	mountpoint "$instancedVirtDir" > /dev/null 2>&1 && _stop 1
	mountpoint "$instancedVirtFS" > /dev/null 2>&1 && _stop 1
	mountpoint "$instancedVirtTmp" > /dev/null 2>&1 && _stop 1
	mountpoint "$instancedVirtHome" > /dev/null 2>&1 && _stop 1
	
	_openChRoot > "$logTmp"/userchroot 2>&1 || _stop 1
	
	
	_ubvrtusrChRoot  > "$logTmp"/userchroot 2>&1 || _stop 1
	
	
	_mountChRoot_user > "$logTmp"/userchroot 2>&1 || _stop 1
	_mountChRoot_user_home > "$logTmp"/userchroot 2>&1 || _stop 1
	[[ $(id -u) == 0 ]] && cp -a "$instancedVirtHomeRef"/. "$instancedVirtHome"/ > "$logTmp"/userchroot 2>&1
	export chrootDir="$instancedVirtFS"
	
	
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
	
	_rm_ubvrtusrChRoot
	
	"$scriptAbsoluteLocation" _checkForMounts "$chrootDir" > "$logTmp"/userchroot 2>&1 && _stop 1
	
	
	_stop_virt_instance
	_preserveLog
	_stop "$userChRootExitStatus"
	
}


_removeUserChRoot() {
	_openChRoot
	
	_chroot userdel -r "$virtGuestUser" > /dev/null 2>&1
	_rm_ubvrtusrChRoot
	
	_removeChRoot
}





