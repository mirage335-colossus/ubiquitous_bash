# WARNING Stability of this function's API is important for compatibility with existing docker images.
_drop_docker() {
	# Change to localPWD or home.
	cd "$localPWD"
	
	# Drop to user ubvrtusr or remain root, using gosu.
	
	##Example alternative code for future reference.
	#export INPUTRC='~/.inputrc'
	#export profileScriptLocation=/usr/local/bin/entrypoint.sh
	#export profileScriptFolder=/usr/local/bin/
	
	#bash -c ". ./etc/profile > /dev/null 2>&1 ; set -o allexport ; . ~/.bash_profile > /dev/null 2>&1 ; . ~/.bashrc > /dev/null 2>&1 ; . ./ubiquitous_bash.sh _importShortcuts > /dev/null 2>&1 ; set +o allexport ; bash --noprofile --norc -i ; . ~/.bash_logout > /dev/null 2>&1"

	#bash --init-file <(echo ". ~/.bashrc ; . ./ubiquitous_bash.sh _importShortcuts")
	
	#_gosuExecVirt bash --init-file <(echo ". ~/.bashrc ; . /usr/local/bin/entrypoint.sh _importShortcuts" "$@")
	
	##Setup and launch.
	
	oldNoNet="$nonet"
	export nonet="true"
	"$scriptAbsoluteLocation" _setupUbiquitous
	[[ "$oldNoNet" != "true" ]] && export nonet="$oldNoNet"
	
	_gosuExecVirt "$@"
	
}
