_importShortcuts() {
	_tryExec "_resetFakeHomeEnv"
	
	if ! [[ "$PATH" == *":""$HOME""/bin"* ]] && ! [[ "$PATH" == "$HOME""/bin"* ]] && [[ -e "$HOME"/bin ]] && [[ -d "$HOME"/bin ]]
	then
		#export PATH="$PATH":"$HOME"/bin
		
		# CAUTION: Dubious workaround to prevent '/usr/local/bin/ubiquitous_bash.sh' , or '/usr/local/bin' , from overriding later program versions in '~/bin' .
		if [[ $( ( export PATH="$PATH":"$HOME"/bin ; type -p ubiquitous_bash.sh ) ) == "/usr/local/bin/ubiquitous_bash.sh" ]]
		then
			export PATH="$HOME"/bin:"$PATH"
		else
			export PATH="$PATH":"$HOME"/bin
		fi
	fi
	
	_tryExec "_visualPrompt"
	
	_tryExec "_scopePrompt"
	
	return 0
}
