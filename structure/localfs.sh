#####Local Environment Management (Resources)

_extra() {
	true
}


_prepare() {
	
	mkdir -p "$safeTmp"
	
	mkdir -p "$shortTmp"
	
	mkdir -p "$logTmp"
	
	mkdir -p "$scriptLocal"
	
	mkdir -p "$bootTmp"
	
	_extra
}
