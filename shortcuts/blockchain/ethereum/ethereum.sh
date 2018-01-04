_ethereum_init() {
	_geth account new
	_geth --rpc --fast --cache=1024
}
