_findPort_opsauto_blockchain() {
	if ! _findPort 63800 63850 "$@" >> "$scriptLocal"/opsauto
	then
		_stop 1
	fi
}

_opsauto_blockchain_sequence() {
	_start
	
	export opsautoGenerationMode="true"
	
	echo "" > "$scriptLocal"/opsauto
	
	echo -n 'export parity_ui_port=' >> "$scriptLocal"/opsauto
	_findPort_opsauto_blockchain
	
	echo -n 'export parity_port=' >> "$scriptLocal"/opsauto
	_findPort_opsauto_blockchain
	
	echo -n 'export parity_jasonrpc_port=' >> "$scriptLocal"/opsauto
	_findPort_opsauto_blockchain
	
	echo -n 'export parity_ws_port=' >> "$scriptLocal"/opsauto
	_findPort_opsauto_blockchain
	
	echo -n 'export parity_ifs_api_port=' >> "$scriptLocal"/opsauto
	_findPort_opsauto_blockchain
	
	echo -n 'export parity_secretstore_port=' >> "$scriptLocal"/opsauto
	_findPort_opsauto_blockchain
	
	echo -n 'export parity_secretstore_http_port=' >> "$scriptLocal"/opsauto
	_findPort_opsauto_blockchain
	
	echo -n 'export parity_stratum_port=' >> "$scriptLocal"/opsauto
	_findPort_opsauto_blockchain
	
	echo -n 'export parity_dapps_port=' >> "$scriptLocal"/opsauto
	_findPort_opsauto_blockchain
	
	_stop 0
} 
