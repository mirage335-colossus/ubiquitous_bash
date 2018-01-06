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

# TODO Dynamically chosen port.
_parity_browser() {
	./ubiquitous_bash.sh _parity signer new-token
	
	#xdg-open 'http://127.0.0.1:'"$parity_ui_port"'/#/'
	
	parity_browser_url=$(grep 'http' | cut -f 2- -d\  )
	
	xdg-open "$parity_browser_url"
}

_parity_import() {
	_parity --import-geth-keys
}
