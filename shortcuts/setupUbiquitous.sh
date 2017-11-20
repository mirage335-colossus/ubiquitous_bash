_importShortcuts() {
	_visualPrompt
}

_setupUbiquitous() {
	local ubcoreDir
	ubcoreDir="$HOME"/.ubcore
	local ubcoreUBdir
	ubcoreUBdir="$ubcoreDir"/ubiquitous_bash
	local ubcoreFile
	ubcoreFile="$ubcoreDir"/.ubcorerc
	
	if [[ -e "$ubcoreUBdir" ]]
	then
		cd "$ubcoreUBdir"
		[[ "$nonet" != "true" ]] && type git > /dev/null 2>&1 && git pull
		cd "$outerPWD"
		return 0
	fi
	
	mkdir -p "$ubcoreDir"
	[[ ! -d "$ubcoreDir" ]] && return 1
	cd "$ubcoreDir"
	
	[[ "$nonet" != "true" ]] && type git > /dev/null 2>&1 && git clone git@github.com:mirage335/ubiquitous_bash.git
	mkdir -p "$ubcoreUBdir"
	
	if [[ ! -e "$ubcoreUBdir"/ubiquitous_bash.sh ]]
	then
		cp -a "$scriptBin" "$ubcoreUBdir"/
		cp -a "$scriptAbsoluteLocation" "$ubcoreUBdir"/ubiquitous_bash.sh
	fi
	
	mkdir -p "$HOME"/bin/
	ln -sf "$ubcoreUBdir"/ubiquitous_bash.sh "$HOME"/bin/ubiquitous_bash.sh
	
	echo -e -n > "$ubcoreFile"
	echo 'export profileScriptLocation='"$ubcoreUBdir"/ubiquitous_bash.sh >> "$ubcoreFile"
	echo 'export profileScriptFolder='"$ubcoreUBdir" >> "$ubcoreFile"
	echo '. '"$ubcoreUBdir"/ubiquitous_bash.sh' _importShortcuts' >> "$ubcoreFile"
	
	if ! grep ubcore ~/.bashrc > /dev/null 2>&1
	then
		echo ". ""$ubcoreFile" >> ~/.bashrc
	fi
	
	cd "$outerPWD"
}
