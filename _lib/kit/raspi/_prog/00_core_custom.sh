# ATTENTION: Configure/Override .



# ATTENTION: Override .
_custom_set() {
	_messagePlain_nominal 'init: _custom_set'
	
	export custom_netName="$netName"
	export custom_hostname='hostname'
	
	export custom_user="user"
	[[ -e "$scriptLocal"/vm-raspbian.img ]] && export custom_user="pi"
	#export custom_user="username"
	
	export safeToDeleteGit="true"
}

# ATTENTION: Override (if necessary) .
_custom_prepare() {
	_messagePlain_nominal 'init: _custom_prepare'
	
	mkdir -p "$scriptLocal"/_custom
	
	rm -f "$scriptLocal"/_custom/* > /dev/null 2>&1
	
	
	! _openChRoot && _messageError 'FAIL: _openChRoot' && _stop 1
}

_custom_safety() {
	_messagePlain_nominal 'init: _custom_safety'
	
	export safeToDeleteGit="true"
	
	_messagePlain_probe 'custom_user= '"$custom_user"
	
	! _safePath "$scriptLib" && _messageError 'FAIL: _safePath: scriptLib' && _stop 1
	! _safePath "$scriptLocal" && _messageError 'FAIL: _safePath: scriptLocal' && _stop 1
	
	! _safePath "$globalVirtFS" && _messageError 'FAIL: _safePath: globalVirtFS' && _stop 1
	! _safePath "$globalVirtFS"/home/"$custom_user"/core/ && _messageError 'FAIL: _safePath: user' && _stop 1
}

# ATTENTION: Override (if necessary) .
# User-specific SSH identity will be taken from "$scriptLocal"/ssh_pub_[user]/*.pub (if available) .
_custom_users() {
	_custom_construct_user root
	echo 'root:password' | _chroot chpasswd
	
	_custom_construct_user "$custom_user"
	echo "$custom_user"':password' | _chroot chpasswd
	
	_custom_construct_user user1
	echo 'user1:password' | _chroot chpasswd
	_chroot usermod -s /bin/false user1
	
	_custom_construct_user user2
	echo 'user2:password' | _chroot chpasswd
	_chroot usermod -s /bin/false user2
}

# ATTENTION: Override (if necessary) .
_custom_users_ssh() {
	_custom_construct_user_ssh root
	_custom_construct_user_ssh "$custom_user"
	
	_custom_construct_user_ssh user1
	_custom_construct_user_ssh user2
}

# ATTENTION: Override (if necessary) .
_custom_packages() {
	_chroot apt-get update
	
	# DANGER: Requires expanded image!
	#_chroot apt-get upgrade -y
	
	_chroot apt-get install -y bc nmap autossh socat sshfs tor bup
	
	_chroot apt-get install -y tigervnc-viewer
	_chroot apt-get install -y x11vnc
	_chroot apt-get install -y tigervnc-standalone-server
}

# ATTENTION: Override (if necessary) .
_custom_copy_directory() {
	true
	#_custom_rsync "$scriptLib"/'directory'/ "$globalVirtFS"/home/pi/core/'directory'/
}

# ATTENTION: Override (if necessary) .
_custom_prog() {
	true
	
	_custom_cautossh
	
	_tryExec _custom_cautossh-limited
}

# ATTENTION: REVISE AS NECESSARY .
_custom() {
	_messageNormal '_custom: SET , PREPARE, SAFETY'
	_custom_set
	_custom_prepare
	_custom_safety
	
	_messageNormal '_custom: ...'
	
	_custom_users
	_custom_users_ssh
	
	
	_custom_packages
	
	_custom_copy_directory
	_custom_prog
	
	_custom_construct_crontab
	_custom_write_fs
	
	# Guarantee permissions, inclusions, etc.
	_custom_users
	_custom_users_ssh
	
	 _messageNormal '_custom: END'
}




