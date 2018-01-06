_ethereum_new() {
	_geth account new
}

_ethereum_sync() {
	_geth --rpc --fast --cache=4096
}

_ethereum_status() {
	echo 'eth.syncing' | _geth attach
}

#Untested.
_ethereum_mine() {
	"$scriptBin"/ethminer -G
}

# TODO Dynamically chosen port.
_parity_browser() {
	xdg-open 'http://127.0.0.1:8180/#/'
}
