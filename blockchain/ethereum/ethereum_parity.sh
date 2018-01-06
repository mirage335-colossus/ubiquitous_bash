_test_ethereum_parity() {
	_getDep gcc
	_getDep g++
	
	_getDep openssl/ssl.h
	
	_getDep libudev.h
	_getDep libudev.so
}

_test_ethereum_parity_built() {
	_checkDep parity
}

_test_ethereum_parity_build() {
	_getDep rustc
	_getDep cargo
}

_build_ethereum_parity_sequence() {
	_start
	
	cd "$safeTmp"
	
	git clone https://github.com/paritytech/parity
	cd parity
	cargo build --release
	
	cp ./target/release/parity "$scriptBin"/
	
	cd "$safeTmp"/..
	_stop
}

_build_ethereum_parity() {
	#Do not rebuild geth unnecessarily, as build is slow.
	_typeDep parity && echo "already have parity" && return 0
	
	"$scriptAbsoluteLocation" _build_ethereum_parity_sequence
}

_parity() {
	./ubiquitous_bash.sh _findPort >> "$scriptLocal"/parity_ui_port
	
	parity_ui_port=8180
	[[ -e "$scriptLocal"/parity_ui_port ]] && parity_ui_port=$(cat "$scriptLocal"/parity_ui_port)
	
	_ethereum_home parity "$@"
}

_parity_attach() {
	_ethereum_home _geth attach ~/.local/share/io.parity.ethereum/jsonrpc.ipc "$@"
}
