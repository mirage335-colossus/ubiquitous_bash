#Runs command directly if member of "docker" group, or through sudo if not.
#Docker inevitably requires effective root. 
_permitDocker() {
	if groups | grep docker > /dev/null 2>&1
	then
		"$@"
		return 0
	fi
	
	if _wantSudo > /dev/null 2>&1
	then
		sudo -n "$@"
		return 0
	fi
	
	return 1
}

_test_docker() {
	#https://docs.docker.com/engine/installation/linux/docker-ce/debian/#install-using-the-repository
	#https://wiki.archlinux.org/index.php/Docker#Installation
	#sudo usermod -a -G docker "$USER"
	
	#_checkDep /sbin/losetup
	if ! [[ -e "/dev/loop-control" ]] || ! [[ -e "/sbin/losetup" ]]
	then
		echo 'may be missing loopback interface'
		_stop 1
	fi
	
	_checkDep docker
	
	local dockerPermission
	dockerPermission=$(_permitDocker echo true 2> /dev/null)
	if [[ "$dockerPermission" != "true" ]]
	then
		echo 'no permissions to run docker'
		_stop 1
	fi
	
	if ! _permitDocker docker run hello-world 2>&1 | grep 'Hello from Docker' > /dev/null 2>&1
	then
		echo 'failed docker hello world'
		_stop 1
	fi
	
	if ! _discoverResource docker/contrib/mkimage.sh > /dev/null 2>&1
	#if true
	then
		echo
		echo 'base images cannot be created without mkimage'
		#_stop 1
	fi
}

