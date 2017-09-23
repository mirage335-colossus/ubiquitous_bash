#"$1" == ChRoot Dir
_mountChRoot() {
	_mustGetSudo
	
	[[ ! -e "$1" ]] && return 1
	
	ChRootDir=$(_getAbsoluteLocation "$1")
	
	_bindMountManager "/dev" "$ChRootDir"/dev
	_bindMountManager "/dev" "$ChRootDir"/proc
	_bindMountManager "/dev" "$ChRootDir"/sys
	
	_bindMountManager "/dev" "$ChRootDir"/dev/pts
	
	_bindMountManager "/dev" "$ChRootDir"/tmp
	
	#Provide an shm filesystem at /dev/shm.
	sudo -n mount -t tmpfs -o size=4G tmpfs "$ChRootDir"/dev/shm
	
}

#"$1" == ChRoot Dir
_umountChRoot() {
	_mustGetSudo
	
	[[ ! -e "$1" ]] && return 1
	
	ChRootDir=$(_getAbsoluteLocation "$1")
	
	sudo -n umount "$ChRootDir"/proc
	sudo -n umount "$ChRootDir"/sys
	sudo -n umount "$ChRootDir"/dev/pts
	sudo -n umount "$ChRootDir"/tmp
	sudo -n umount "$ChRootDir"/dev/shm
	sudo -n umount "$ChRootDir"/dev
	
	sudo -n umount "$ChRootDir" >/dev/null 2>&1
	
}
