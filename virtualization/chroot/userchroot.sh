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



_ubvrtusrChRoot_report_failure() {
	
	echo -n "ubvrtusr     ""$1"
	echo -e -n '\t'
	shift
	
	echo -n "$1"
	echo -e -n '\t'
	shift
	
	shift
	echo "$@"
	
	return 0
	
}

_ubvrtusrChRoot_check() {
	#Diagnostics.
	echo '#####ubvrtusr     checks'
	
	local internalFailure
	internalFailure=false
	
	! [[ -e "$globalVirtFS"/"$virtGuestHomeRef" ]] && _ubvrtusrChRoot_report_failure "nohome" "$virtGuestHomeRef" '[[ -e "$virtGuestHomeRef" ]]' && internalFailure=true
	
	! _chroot id -u "$virtGuestUser" > /dev/null 2>&1 && _ubvrtusrChRoot_report_failure "no guest user" "$virtGuestUser" '_chroot id -u "$virtGuestUser"' && internalFailure=true
	
	! [[ $(_chroot id -u "$virtGuestUser") == "$HOST_USER_ID" ]] && _ubvrtusrChRoot_report_failure "bad uid" $(_chroot id -u "$virtGuestUser") '[[ $(_chroot id -u "$virtGuestUser") == "$HOST_USER_ID" ]]' && internalFailure=true
	
	! [[ $(_chroot id -g "$virtGuestUser") == "$HOST_GROUP_ID" ]] && _ubvrtusrChRoot_report_failure "bad gid" $(_chroot id -g "$virtGuestUser") '[[ $(_chroot id -g "$virtGuestUser") == "$HOST_GROUP_ID" ]]' && internalFailure=true
	
	echo '#####ubvrtusr     checks'
	
	 [[ "$internalFailure" == "true" ]] && return 1
	 return 0
}

_ubvrtusrChRoot() {
	
	#If root, discontinue.
	[[ $(id -u) == 0 ]] && return 0
	
	#If user correctly setup, discontinue. Check multiple times before recreating user.
	local iterationCount
	iterationCount=0
	while [[ "$iterationCount" -lt "3" ]]
	do
		_ubvrtusrChRoot_check && return 0
		
		let iterationCount="$iterationCount"+1
		sleep 0.3
	done
	
	## Lock file. Not done with _waitFileCommands because there is nither an obvious means, nor an obviously catastrophically critical requirement, to independently check for completion of related useradd/mod/del operations.
	_waitFile "$globalVirtDir"/_ubvrtusr || return 1
	echo > "$globalVirtDir"/quicktmp
	mv -n "$globalVirtDir"/quicktmp "$globalVirtDir"/_ubvrtusr > /dev/null 2>&1 || return 1
	
	_chroot userdel -r "$virtGuestUser"
	_rm_ubvrtusrChRoot
	
	_chroot groupadd -g "$HOST_GROUP_ID" -o "$virtGuestUser"
	_chroot useradd --shell /bin/bash -u "$HOST_USER_ID" -g "$HOST_GROUP_ID" -o -c "" -m "$virtGuestUser" || return 1
	
	_chroot usermod -a -G video "$virtGuestUser" > /dev/null 2>&1 || return 1
	
	_chroot chown "$virtGuestUser":"$virtGuestUser" "$virtGuestHome" > /dev/null 2>&1
	
	_chroot /bin/bash /usr/local/bin/ubiquitous_bash.sh _dropChRoot /bin/bash /usr/local/bin/ubiquitous_bash.sh _setupUbiquitous_nonet
	
	sudo -n mkdir -p "$globalVirtFS""$virtGuestHome"
	sudo -n mkdir -p "$globalVirtFS""$virtGuestHomeRef"
	sudo -n cp -a "$globalVirtFS""$virtGuestHome"/. "$globalVirtFS""$virtGuestHomeRef"/
	echo sudo -n cp -a "$globalVirtFS""$virtGuestHome"/. "$globalVirtFS""$virtGuestHomeRef"/
	_chroot chown "$virtGuestUser":"$virtGuestUser" "$virtGuestHomeRef" > /dev/null 2>&1
	
	rm -f "$globalVirtDir"/_ubvrtusr > /dev/null 2>&1 || return 1
	
	return 0
}

_userChRoot() {
	_start
	_start_virt_all
	export chrootDir="$globalVirtFS"
	
	_mustGetSudo || _stop 1
	
	
	_checkDep mountpoint >> "$logTmp"/usrchrt.log 2>&1 || _stop 1
	mountpoint "$instancedVirtDir" > /dev/null 2>&1 && _stop 1
	mountpoint "$instancedVirtFS" > /dev/null 2>&1 && _stop 1
	mountpoint "$instancedVirtTmp" > /dev/null 2>&1 && _stop 1
	mountpoint "$instancedVirtHome" > /dev/null 2>&1 && _stop 1
	
	"$scriptAbsoluteLocation" _openChRoot >> "$logTmp"/usrchrt.log 2>&1 || _stop 1
	
	_tryExecFull _hook_systemd_shutdown_action "_closeChRoot_emergency" "$sessionid"
	
	
	_ubvrtusrChRoot  >> "$logTmp"/usrchrt.log 2>&1 || _stop 1
	
	
	_mountChRoot_userAndHome >> "$logTmp"/usrchrt.log 2>&1 || _stop 1
	[[ $(id -u) != 0 ]] && cp -a "$instancedVirtHomeRef"/. "$instancedVirtHome"/ >> "$logTmp"/usrchrt.log 2>&1
	export chrootDir="$instancedVirtFS"
	
	
	export checkBaseDirRemote=_checkBaseDirRemote_chroot
	_virtUser "$@" >> "$logTmp"/usrchrt.log 2>&1
	
	_mountChRoot_project >> "$logTmp"/usrchrt.log 2>&1 || _stop 1
	_chroot chown "$virtGuestUser":"$virtGuestUser" "$sharedGuestProjectDir" >> "$logTmp"/usrchrt.log 2>&1
	
	
	
	_chroot /bin/bash /usr/local/bin/ubiquitous_bash.sh _dropChRoot "${processedArgs[@]}"
	local userChRootExitStatus="$?"	
	
	
	
	_stopChRoot "$instancedVirtFS" >> "$logTmp"/usrchrt.log 2>&1
	
	_umountChRoot_project >> "$logTmp"/usrchrt.log 2>&1
	_umountChRoot_user_home >> "$logTmp"/usrchrt.log 2>&1 || _stop 1
	_umountChRoot_user >> "$logTmp"/usrchrt.log 2>&1 || _stop 1
	
	_rm_ubvrtusrChRoot
	
	"$scriptAbsoluteLocation" _checkForMounts "$instancedVirtFS" >> "$logTmp"/usrchrt.log 2>&1 && _stop 1
	
	_stop_virt_instance >> "$logTmp"/usrchrt.log 2>&1
	_stop "$userChRootExitStatus"
}

_removeUserChRoot() {
	"$scriptAbsoluteLocation" _openChRoot || _stop 1
	
	## Lock file. Not done with _waitFileCommands because there is nither an obvious means, nor an obviously catastrophically critical requirement, to independently check for completion of related useradd/mod/del operations.
	_waitFile "$globalVirtDir"/_ubvrtusr || return 1
	echo > "$globalVirtDir"/quicktmp
	mv -n "$globalVirtDir"/quicktmp "$globalVirtDir"/_ubvrtusr > /dev/null 2>&1 || return 1
	
	
	_chroot userdel -r "$virtGuestUser" > /dev/null 2>&1
	[[ -d "$chrootDir""$virtGuestHomeRef" ]] && sudo -n "$scriptAbsoluteLocation" _safeRMR "$chrootDir""$virtGuestHomeRef"
	
	_rm_ubvrtusrChRoot
	
	rm -f "$globalVirtDir"/_ubvrtusr > /dev/null 2>&1 || return 1
	
	"$scriptAbsoluteLocation" _closeChRoot || _stop 1
} 
