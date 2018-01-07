_ethereum_new() {
	_geth account new
}

_ethereum_sync() {
	_geth --rpc --fast --cache=4096
}

_ethereum_status() {
	echo 'eth.syncing' | _geth attach
}

_ethereum_mine() {
	_ethereum_home "$scriptBin"/ethminer -G --farm-recheck 200 -S eu1.ethermine.org:4444 -FS us1.ethermine.org:4444 -O "$ethaddr"."$rigname"
}

_ethereum_mine_status() {
	xdg-open "https://ethermine.org/miners/""$ethaddr"
}

# TODO Dynamically chosen port.
_parity_ui() {
	#xdg-open 'http://127.0.0.1:'"$parity_ui_port"'/#/'
	
	#egrep -o 'https?://[^ ]+'
	parity_browser_url=$(_parity signer new-token | grep 'http' | cut -f 2- -d\  | _nocolor)
	
	xdg-open "$parity_browser_url"
}

_parity_import() {
	_parity --import-geth-keys
}
