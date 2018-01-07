_test_ethereum() {

	_getDep xterm
	
	#OpenGL/OpenCL runtime dependency for mining.
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
	
	cd "$safeTmp"/..
	_stop
}

_build_geth() {
	#Do not rebuild geth unnecessarily, as build is slow.
	_typeDep geth && echo "already have geth" && return 0
	
	"$scriptAbsoluteLocation" _build_geth_sequence
}

_prepare_ethereum_data() {
	mkdir -p "$scriptLocal"/blkchain/ethereum
	mkdir -p "$scriptLocal"/blkchain/io.parity.ethereum
}

_prepare_ethereum_fakeHome() {
	_prepare_ethereum_data
	
	export instancedFakeHome="$shortTmp"/h
	mkdir -p "$instancedFakeHome"
	#_relink "$scriptLocal"/blkchain/h "$instancedFakeHome"
	
	_relink "$scriptLocal"/blkchain/ethereum "$instancedFakeHome"/.ethereum
	
	mkdir -p "$instancedFakeHome"/.local/share
	_relink "$scriptLocal"/blkchain/io.parity.ethereum "$instancedFakeHome"/.local/share/io.parity.ethereum
}

_ethereum_home_sequence() {
	_prepare_ethereum_fakeHome
	
	_userFakeHome_sequence "$@"
	
	rmdir "$shortTmp"
}

_ethereum_home() {
	"$scriptAbsoluteLocation" _ethereum_home_sequence "$@"
}

_edit_ethereum_home() {
	_prepare_ethereum_data
	
	_relink ../ethereum "$scriptLocal"/blkchain/h/.ethereum
	mkdir -p "$scriptLocal"/blkchain/h/.local/share
	_relink "$scriptLocal"/blkchain/io.parity.ethereum "$scriptLocal"/blkchain/h/.local/share/io.parity.ethereum
	
	export appGlobalFakeHome="$scriptLocal"/blkchain/h
	mkdir -p "$appGlobalFakeHome" > /dev/null 2>&1
	[[ ! -e "$appGlobalFakeHome" ]] && return 1
	
	_editFakeHome "$@"
	
	#_rmlink "$appGlobalFakeHome"/.ethereum
}

_geth() {
	mkdir -p "$scriptLocal"/blkchain/ethereum > /dev/null 2>&1
	[[ ! -e "$scriptLocal"/blkchain/ethereum ]] && return 1
	geth --datadir "$scriptLocal"/blkchain/ethereum "$@"
}
