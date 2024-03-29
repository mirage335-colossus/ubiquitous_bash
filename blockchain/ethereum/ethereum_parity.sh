_test_ethereum_parity() {
	_if_cygwin && return 0
	
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
	
	cp ./target/release/parity "$scriptBundle"/
	
	cd "$safeTmp"/..
	_stop
}

_build_ethereum_parity() {
	#Do not rebuild geth unnecessarily, as build is slow.
	_typeDep parity && echo "already have parity" && return 0
	
	"$scriptAbsoluteLocation" _build_ethereum_parity_sequence
}

_parity() {
	if [[ "$parity_ui_port" != "" ]] && [[ "$parity_port" != "" ]] && [[ "$parity_jasonrpc_port" != "" ]] && [[ "$parity_ws_port" != "" ]] && [[ "$parity_ipfs_api_port" != "" ]] && [[ "$parity_secretstore_port" != "" ]] && [[ "$parity_secretstore_http_port" != "" ]] && [[ "$parity_stratum_port" != "" ]]
	then
		_ethereum_home parity --ui-port="$parity_ui_port" --port="$parity_port" --jsonrpc-port="$parity_jasonrpc_port" --ws-port="$parity_ws_port" --ipfs-api-port="$parity_ipfs_api_port" --secretstore-port="$parity_secretstore_port" --secretstore-http-port="$parity_secretstore_http_port" --stratum-port="$parity_stratum_port" "$@"
	else
		_ethereum_home parity "$@"
	fi
}

_parity_attach() {
	_ethereum_home _geth attach ~/.local/share/io.parity.ethereum/jsonrpc.ipc "$@"
}
