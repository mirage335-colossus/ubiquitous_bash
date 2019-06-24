#Runs command directly if member of "docker" group, or through sudo if not.
#Docker inevitably requires effective root. 
_permitDocker() {
	if groups | grep docker > /dev/null 2>&1
	then
		"$@"
		return "$?"
	fi
	
	if _wantSudo > /dev/null 2>&1
	then
		sudo -n "$@"
		return "$?"
	fi
	
	return 1
}

_test_docker() {
	_testGosu || _stop 1
	
	_checkDep gosu-armel
	_checkDep gosu-amd64
	_checkDep gosu-i386
	
	#https://docs.docker.com/engine/installation/linux/docker-ce/debian/#install-using-the-repository
	#https://wiki.archlinux.org/index.php/Docker#Installation
	#sudo -n usermod -a -G docker "$USER"
	
	_getDep /sbin/losetup
	if ! [[ -e "/dev/loop-control" ]] || ! [[ -e "/sbin/losetup" ]]
	then
		echo 'may be missing loopback interface'
		_stop 1
	fi
	
	_getDep docker
	
	local dockerPermission
	dockerPermission=$(_permitDocker echo true 2> /dev/null)
	if [[ "$dockerPermission" != "true" ]]
	then
		echo 'no permissions to run docker'
		_stop 1
	fi
	
	#if ! _permitDocker docker run hello-world 2>&1 | grep 'Hello from Docker' > /dev/null 2>&1
	#then
	#	echo 'failed docker hello world'
	#	_stop 1
	#fi
	
	_permitDocker docker import "$scriptBin"/"dockerHello".tar "ubdockerhello" --change 'CMD ["/hello"]' > /dev/null 2>&1
	if ! _permitDocker docker run "ubdockerhello" 2>&1 | grep 'hello world' > /dev/null 2>&1
	then
		echo 'failed ubdockerhello'
		_stop 1
	fi
	
	if ! _discoverResource moby/contrib/mkimage.sh > /dev/null 2>&1 && ! _discoverResource docker/contrib/mkimage.sh
	#if true
	then
		echo
		echo 'base images cannot be created without mkimage'
		#_stop 1
	fi
	
	if ! [[ -e "$scriptBin"/hello ]]
	then
		echo
		echo 'some base images cannot be created without hello'
	fi
}

