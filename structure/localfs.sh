#####Local Environment Management (Resources)

_prepare_prog() {
	true
}

_extra() {
	true
}


_prepare() {
	
	! mkdir -p "$safeTmp" && exit 1
	
	! mkdir -p "$shortTmp" && exit 1
	
	! mkdir -p "$logTmp" && exit 1
	
	! mkdir -p "$scriptLocal" && exit 1
	
	! mkdir -p "$bootTmp" && exit 1
	
	_extra
	_prepare_prog
}
