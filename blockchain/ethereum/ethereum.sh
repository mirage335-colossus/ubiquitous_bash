_test_ethereum() {
	_getDep GL/gl.h
	_getDep GL/glext.h
	_getDep GL/glx.h
	_getDep GL/glxext.h
	_getDep GL/internal/dri_interface.h
	_getDep x86_64-linux-gnu/pkgconfig/dri.pc
	
}

_test_ethereum_built() {
	_checkDep geth
	
	_checkDep ethminer
}

_test_ethereum_build() {
	_getDep go
}


_build_geth_sequence() {
	_start
	
	cd "$safeTmp"
	
	git clone https://github.com/ethereum/go-ethereum.git
	cd go-ethereum
	make geth
	
	cp build/bin/geth "$scriptBin"/
	
	_stop
}

_build_geth() {
	"$scriptAbsoluteLocation" _build_geth_sequence
}

