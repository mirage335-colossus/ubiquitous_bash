_testChRoot() {
	_mustGetSudo
	
	_testGosu || _stop 1
	
	_checkDep gosu-armel
	_checkDep gosu-amd64
	_checkDep gosu-i386
	
	_getDep id
	
	_getDep mount
	_getDep umount
	_getDep mountpoint
	
	_getDep unionfs-fuse
	
}
