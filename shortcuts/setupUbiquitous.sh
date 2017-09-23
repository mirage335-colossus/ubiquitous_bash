_importShortcuts() {
	_visualPrompt
}

_setupUbiquitous() {
	
	mkdir -p "$HOME"/bin/
	
	ln -s "$scriptAbsoluteLocation" "$HOME"/bin/ubiquitous_bash.sh
	
	echo 'export profileScriptLocation='"$scriptAbsoluteLocation" >> "$HOME"/.bashrc
	echo 'export profileScriptFolder='"$scriptAbsoluteFolder" >> "$HOME"/.bashrc
	
	echo '. '"$scriptAbsoluteLocation"' _importShortcuts' >> "$HOME"/.bashrc
	
} 
