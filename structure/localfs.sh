#####Local Environment Management (Resources)

_prepare_prog() {
	true
}

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
	_prepare_prog
}
