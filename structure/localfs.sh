#####Local Environment Management (Resources)

_prepare_prog() {
	true
}

_extra() {
	true
}

_prepare_abstract() {
	! mkdir -p "$abstractfs_root" && exit 1
	chmod 0700 "$abstractfs_root" > /dev/null 2>&1
	! chmod 700 "$abstractfs_root" && exit 1
	if ! chown "$USER":"$USER" "$abstractfs_root"
	then
		! /sbin/chown "$USER" "$abstractfs_root" && exit 1
	fi
	
	
	! mkdir -p "$abstractfs_lock" && exit 1
	chmod 0700 "$abstractfs_lock" > /dev/null 2>&1
	! chmod 700 "$abstractfs_lock" && exit 1
	if ! chown "$USER":"$USER" "$abstractfs_lock"
	then
		! /sbin/chown "$USER" "$abstractfs_root" && exit 1
	fi
}

_prepare() {
	
	! mkdir -p "$safeTmp" && exit 1
	
	! mkdir -p "$shortTmp" && exit 1
	
	! mkdir -p "$logTmp" && exit 1
	
	! mkdir -p "$scriptLocal" && exit 1
	
	! mkdir -p "$bootTmp" && exit 1
	
	#_prepare_abstract
	
	_extra
	_prepare_prog
}
