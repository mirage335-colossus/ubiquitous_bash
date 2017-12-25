_fetchDep_debianStretch() {
	! _wantSudo && return 1
	
	[[ "$1" == "readlink" ]] && sudo -n apt-get install -y coreutils && return
	[[ "$1" == "dirname" ]] && sudo -n apt-get install -y coreutils && return
	[[ "$1" == "basename" ]] && sudo -n apt-get install -y coreutils && return
	[[ "$1" == "basename" ]] && sudo -n apt-get install -y coreutils && return
	
	[[ "$1" == "umount" ]] && sudo -n apt-get install -y mount && return
	[[ "$1" == "mountpoint" ]] && sudo -n apt-get install -y util-linux && return
	
	
	sudo -n apt-get install -y "$1"
	
}

_fetchDep_debian() {
	if [[ -e /etc/debian_version ]] && cat /etc/debian_version | head -c 1 | grep 9 > /dev/null 2>&1
	then
		_getDep_debianStretch
		return
	fi
	
	return 1
}
