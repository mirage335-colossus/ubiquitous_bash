#####Local Environment Management (Resources)

_prepare_prog() {
	true
}

_extra() {
	true
}

_prepare_abstract() {
	! mkdir -p "$abstractfs" && exit 1
	chmod 0700 "$abstractfs" > /dev/null 2>&1
	! chmod 700 "$abstractfs" && exit 1
	! chown "$USER":"$USER" "$abstractfs" && exit 1
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
