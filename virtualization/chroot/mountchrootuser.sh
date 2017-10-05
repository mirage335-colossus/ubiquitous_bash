# TODO TODO Mount project directory if isolation configuration variable is set. Set directory permissions correctly. Use either root or ubvrtusr home directory as appropriate.
_mountChRoot_project() {
	
	_bindMountManager "$sharedHostProjectDir" "$sharedGuestProjectDir" || return 1
	
}

_umountChRoot_project() {
	
	_wait_umount "$chrootDir""$sharedGuestProjectDir"
	
}


_mountChRoot_user() {
	
	_bindMountManager "$globalChRootDir" "$instancedVirtDir" || return 1
	_mountChRoot "$instancedVirtDir" || return 1
	
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
