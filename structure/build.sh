_build_nonet_default() {
	_installation_nonet_default
	
	return 0
}

_test_build_prog() {
	true
}

_test_build() {
	_getDep gcc
	_getDep g++
	_getDep make
	
	
	# libc6-dev
	_getDep 'malloc.h'
	_getDep 'memory.h'
	_getDep 'stdio.h'
	_getDep 'math.h'
	
	
	_getDep cmake
	
	_getDep autoreconf
	_getDep autoconf
	_getDep automake
	
	_getDep libtool
	
	_getDep makeinfo
	
	_getDep pkg-config
	
	_tryExec _test_buildGoSu
	
	_tryExec _test_buildIdle
	
	_tryExec _test_bashdb
	
	_tryExec _test_ethereum_build
	_tryExec _test_ethereum_parity_build
	
	_tryExec _test_build_prog
}
alias _testBuild=_test_build

_buildSequence() {
	_start
	
	echo -e '\E[1;32;46m Binary compiling...	\E[0m'
	
	_tryExec _buildHello
	
	_tryExec _buildIdle
	_tryExec _buildGosu
	
	_tryExec _build_geth
	_tryExec _build_ethereum_parity
	
	_tryExec _buildChRoot
	_tryExec _buildQEMU
	
	_tryExec _buildExtra
	
	echo "     ...DONE"
	
	_stop
}

_build_prog() {
	true
}

_build() {
	_build_nonet_default
	
	"$scriptAbsoluteLocation" _buildSequence
	
	_build_prog
}
