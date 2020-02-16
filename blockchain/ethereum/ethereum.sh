_test_ethereum() {

	_getDep xterm
	
	#OpenGL/OpenCL runtime dependency for mining.
	_getDep GL/gl.h
	_getDep GL/glext.h
	_getDep GL/glx.h
	_getDep GL/glxext.h
	_getDep GL/internal/dri_interface.h
	
	if [[ ! -e 'x86_64-linux-gnu/pkgconfig/dri.pc' ]] && [[ ! -e '/usr/lib64/pkgconfig/dri.pc' ]] && [[ ! -e '/usr/lib32/pkgconfig/dri.pc' ]]
	then
		_wantGetDep x86_64-linux-gnu/pkgconfig/dri.pc
		_wantGetDep /usr/lib64/pkgconfig/dri.pc
		[[ ! -e 'x86_64-linux-gnu/pkgconfig/dri.pc' ]] && [[ ! -e '/usr/lib64/pkgconfig/dri.pc' ]] && [[ ! -e '/usr/lib32/pkgconfig/dri.pc' ]] && _stop 1
	fi
	
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
	
	cp build/bin/geth "$scriptBundle"/
	
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

_install_fakeHome_ethereum() {
	_prepare_ethereum_data
	
	_link_fakeHome "$scriptLocal"/blkchain/ethereum .ethereum
	
	_link_fakeHome "$scriptLocal"/blkchain/io.parity.ethereum .local/share/io.parity.ethereum
}

#Similar to editShortHome .
_ethereum_home_sequence() {
	_start
	
	export actualFakeHome="$shortFakeHome"
	export fakeHomeEditLib="true"
	
	_install_fakeHome_ethereum
	
	_fakeHome "$@"
	
	_stop $?
}

_ethereum_home() {
	"$scriptAbsoluteLocation" _ethereum_home_sequence "$@"
}

_geth() {
	mkdir -p "$scriptLocal"/blkchain/ethereum > /dev/null 2>&1
	[[ ! -e "$scriptLocal"/blkchain/ethereum ]] && return 1
	geth --datadir "$scriptLocal"/blkchain/ethereum "$@"
}
