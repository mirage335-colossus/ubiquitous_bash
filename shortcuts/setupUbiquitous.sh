_importShortcuts() {
	_visualPrompt
}

_setupUbiquitous() {
	
	mkdir -p "$HOME"/bin/
	
	ln -s "$scriptAbsoluteLocation" "$HOME"/bin/ubiquitous_bash.sh
	
	echo '. '"$scriptAbsoluteLocation"' _importShortcuts' >> "$HOME"/.bashrc
	
} 
