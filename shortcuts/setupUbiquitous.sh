_configureLocal() {
	_configureFile "$1" "_local"
}

_configureFile() {
	cp "$scriptAbsoluteFolder"/"$1" "$scriptAbsoluteFolder"/"$2"
}

_configureOps() {
	echo "$@" >> "$scriptAbsoluteFolder"/ops
}

_resetOps() {
	rm "$scriptAbsoluteFolder"/ops
}

_importShortcuts() {
	_tryExec "_resetFakeHomeEnv"
	
	_visualPrompt
}

_setupUbiquitous() {
	local ubHome
	ubHome="$HOME"
	[[ "$1" != "" ]] && ubHome="$1"
	
	local ubcoreDir
	ubcoreDir="$ubHome"/.ubcore
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
		"$scriptBin"/.ubrgbin.sh _ubrgbin_cpA "$scriptBin" "$ubcoreUBdir"/
		cp -a "$scriptAbsoluteLocation" "$ubcoreUBdir"/ubiquitous_bash.sh
	fi
	
	mkdir -p "$ubHome"/_bin/
	ln -sf "$ubcoreUBdir"/ubiquitous_bash.sh "$ubHome"/_bin/ubiquitous_bash.sh
	
	echo -e -n > "$ubcoreFile"
	echo 'export profileScriptLocation='"$ubcoreUBdir"/ubiquitous_bash.sh >> "$ubcoreFile"
	echo 'export profileScriptFolder='"$ubcoreUBdir" >> "$ubcoreFile"
	echo '. '"$ubcoreUBdir"/ubiquitous_bash.sh' _importShortcuts' >> "$ubcoreFile"
	
	if ! grep ubcore "$ubHome"/.bashrc > /dev/null 2>&1
	then
		#echo "$ubHome"/.bashrc > /dev/tty
		#ls -l "$ubHome"/.bashrc > /dev/tty
		echo ". ""$ubcoreFile" >> "$ubHome"/.bashrc
	fi
	
	cd "$outerPWD"
}

_setupUbiquitous_nonet() {
	local oldNoNet
	oldNoNet="$nonet"
	export nonet="true"
	_setupUbiquitous "$@"
	[[ "$oldNoNet" != "true" ]] && export nonet="$oldNoNet"
}
