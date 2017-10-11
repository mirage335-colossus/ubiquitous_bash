
_mountChRoot_userAndHome() {
	
	sudo -n mount -t tmpfs -o size=4G,uid="$HOST_USER_ID",gid="$HOST_GROUP_ID" tmpfs "$instancedVirtTmp"
	
	#_bindMountManager "$globalVirtFS" "$instancedVirtFS" || return 1
	
	#_bindMountManager "$instancedVirtTmp" "$instancedVirtHome" || return 1
	
	
	
	
	sudo /bin/mount -t unionfs -o dirs="$instancedVirtTmp":"$globalVirtFS"=ro unionfs "$instancedVirtFS"
	
	return 0
}

_mountChRoot_project() {
	#if [[ ! -e "$0" ]]
	#then
	#	return 1
	#fi
	
	if [[ "$sharedHostProjectDir" == "" ]]
	then
		return 1
	fi
	
	if [[ "$sharedHostProjectDir" == "/" ]]
	then
		return 1
	fi
	
	#Blacklist.
	[[ "$sharedHostProjectDir" == "/home" ]] && return 1
	[[ "$sharedHostProjectDir" == "/home/" ]] && return 1
	[[ "$sharedHostProjectDir" == "/home/$USER" ]] && return 1
	[[ "$sharedHostProjectDir" == "/home/$USER/" ]] && return 1
	[[ $(id -u) != 0 ]] && [[ "$sharedHostProjectDir" == "/$USER" ]] && return 1
	[[ $(id -u) != 0 ]] && [[ "$sharedHostProjectDir" == "/$USER/" ]] && return 1
	
	[[ "$sharedHostProjectDir" == "/tmp" ]] && return 1
	[[ "$sharedHostProjectDir" == "/tmp/" ]] && return 1
	
	[[ $(id -u) != 0 ]] && [[ "$sharedHostProjectDir" == "$HOME" ]] && return 1
	[[ $(id -u) != 0 ]] && [[ "$sharedHostProjectDir" == "$HOME/" ]] && return 1
	
	#Whitelist.
	local safeToMount=false
	
	local safeScriptAbsoluteFolder="$_getScriptAbsoluteFolder"
	
	[[ "$sharedHostProjectDir" == "./"* ]] && [[ "$PWD" == "$safeScriptAbsoluteFolder"* ]] && safeToMount="true"
	
	[[ "$sharedHostProjectDir" == "$safeScriptAbsoluteFolder"* ]] && safeToMount="true"
	
	[[ "$sharedHostProjectDir" == "/home/$USER"* ]] && safeToMount="true"
	[[ "$sharedHostProjectDir" == "/root"* ]] && safeToMount="true"
	
	[[ "$sharedHostProjectDir" == "/tmp/"* ]] && safeToMount="true"
	
	[[ "$safeToMount" == "false" ]] && return 1
	
	#Safeguards/
	#[[ -d "$sharedHostProjectDir" ]] && find "$sharedHostProjectDir" | grep -i '\.git$' >/dev/null 2>&1 && return 1
	
	#Validate necessary tools were available for path building and checks.
	_checkDep realpath
	_checkDep readlink
	_checkDep dirname
	_checkDep basename
	
	
	_bindMountManager "$sharedHostProjectDir" "$instancedProjectDir" || return 1
	
}

_umountChRoot_project() {
	
	_wait_umount "$instancedProjectDir"
	
}


_umountChRoot_user() {
	
	mountpoint "$instancedVirtFS" > /dev/null 2>&1 || return 1
	#_umountChRoot "$instancedVirtFS"
	_wait_umount "$instancedVirtFS"
	
}

_umountChRoot_user_home() {
	
	_wait_umount "$instancedVirtHome" || return 1
	mountpoint "$instancedVirtHome" > /dev/null 2>&1 && return 1
	
	return 0
	
}

_checkBaseDirRemote_chroot() {
	
	[[ -e "$chrootDir"/"$1" ]] || return 1
	return 0
	
}


