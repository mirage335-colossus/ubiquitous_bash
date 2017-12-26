_testChRoot() {
	_testGosu
	
	_typeDep gosu-armel
	_typeDep gosu-amd64
	_typeDep gosu-i386
	
	_mustGetSudo
	
	_getDep id
	
	_getDep mount
	_getDep umount
	_getDep mountpoint
	
	_getDep unionfs-fuse
	
}
