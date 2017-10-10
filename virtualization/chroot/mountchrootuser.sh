_checkBaseDirRemote_chroot() {
	
	[[ -e "$chrootDir"/"$1" ]] || return 1
	return 0
	
}


# TODO TODO Mount project directory if isolation configuration variable is set. Set directory permissions correctly. Use either root or ubvrtusr home directory as appropriate.
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
	
	
	_bindMountManager "$sharedHostProjectDir" "$chrootDir""$sharedGuestProjectDir" || return 1
	
}

_umountChRoot_project() {
	
	_wait_umount "$chrootDir""$sharedGuestProjectDir"
	
}


_mountChRoot_user() {
	
	_bindMountManager "$globalChRootDir" "$instancedVirtDir" || return 1
	#_mountChRoot "$instancedVirtDir" || return 1
	
	return 0
	
}

_umountChRoot_user() {
	
	mountpoint "$chrootDir" > /dev/null 2>&1 || return 1
	_umountChRoot "$instancedVirtDir"
	
}



_mountChRoot_user_home() {
	
	sudo -n mkdir -p "$instancedVirtHome" || return 1
	sudo -n mount -t tmpfs -o size=4G tmpfs "$instancedVirtHome" || return 1
	
	return 0
	
}

_umountChRoot_user_home() {
	
	_wait_umount "$instancedVirtHome" || return 1
	mountpoint "$instancedVirtHome" > /dev/null 2>&1 && return 1
	
	return 0
	
} 
