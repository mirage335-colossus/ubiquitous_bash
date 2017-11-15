_testChRoot() {
	_testGosu
	
	_checkDep gosu-armel
	_checkDep gosu-amd64
	_checkDep gosu-i386
	
	_mustGetSudo
	
	_checkDep id
	
	_checkDep unionfs-fuse
	
}
