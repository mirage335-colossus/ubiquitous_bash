_opsauto_blockchain() {
	echo "" > "$scriptLocal"/opsauto
	
	echo -n 'export parity_ui_port=' >> "$scriptLocal"/opsauto
	./ubiquitous_bash.sh _findPort >> "$scriptLocal"/opsauto
	
	echo -n 'export parity_port=' >> "$scriptLocal"/opsauto
	./ubiquitous_bash.sh _findPort >> "$scriptLocal"/opsauto
	
	echo -n 'export parity_jasonrpc_port=' >> "$scriptLocal"/opsauto
	./ubiquitous_bash.sh _findPort >> "$scriptLocal"/opsauto
	
	echo -n 'export parity_ws_port=' >> "$scriptLocal"/opsauto
	./ubiquitous_bash.sh _findPort >> "$scriptLocal"/opsauto
	
	echo -n 'export parity_ifs_api_port=' >> "$scriptLocal"/opsauto
	./ubiquitous_bash.sh _findPort >> "$scriptLocal"/opsauto
	
	echo -n 'export parity_secretstore_port=' >> "$scriptLocal"/opsauto
	./ubiquitous_bash.sh _findPort >> "$scriptLocal"/opsauto
	
	echo -n 'export parity_secretstore_http_port=' >> "$scriptLocal"/opsauto
	./ubiquitous_bash.sh _findPort >> "$scriptLocal"/opsauto
	
	echo -n 'export parity_stratum_port=' >> "$scriptLocal"/opsauto
	./ubiquitous_bash.sh _findPort >> "$scriptLocal"/opsauto
	
	echo -n 'export parity_dapps_port=' >> "$scriptLocal"/opsauto
	./ubiquitous_bash.sh _findPort >> "$scriptLocal"/opsauto
	
} 
