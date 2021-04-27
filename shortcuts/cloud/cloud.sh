
_cloud_hook_here() {
	cat << CZXWXcRMTo8EmM8i4d
	. "$scriptAbsoluteLocation" --profile _importShortcuts
	_cloud_set
	_cloudPrompt
CZXWXcRMTo8EmM8i4d
}


_cloud_hook() {
	_messageNormal "init: _cloud_hook"
	local ubHome
	ubHome="$HOME"
	[[ "$1" != "" ]] && ubHome="$1"
	
	export ubcoreDir="$ubHome"/.ubcore
	
	_cloud_hook_here > "$ubcoreDir"/cloudrc
}

# WARNING: End user function. Do NOT call within scripts.
# ATTENTION: TODO: Needs to be written out with 'declare -f' to '~/bin' and/or similar during '_setup_ssh' '_index' shortcut '_setup' and/or similar.
_cloud_unhook() {
	_messageNormal "init: _cloud_hook"
	local ubHome
	ubHome="$HOME"
	[[ "$1" != "" ]] && ubHome="$1"
	
	export ubcoreDir="$ubHome"/.ubcore
	
	rm -f "$ubcoreDir"/cloudrc
}




_cloudPrompt() {
	_visualPrompt
	
	#cloud-$netName
	export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-(cloud-$netName)-(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$PS1_lineNumberText\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '
}


_cloud_set() {
	_rclone_set "$@"
	
	_cloudPrompt "$@"
}


_cloud_reset() {
	_rclone_reset "$@"
	
	_visualPrompt
}










_cloud_shell() {
	#_cloudPrompt
	
	# https://unix.stackexchange.com/questions/428175/how-to-export-all-bash-functions-in-a-file-in-one-line
	#set -a
	##. "$scriptAbsoluteLocation" --parent _importShortcuts
	#. "$scriptAbsoluteLocation" --profile _importShortcuts
	#_cloudPrompt
	#set +a
	
	# https://serverfault.com/questions/368054/run-an-interactive-bash-subshell-with-initial-commands-without-returning-to-the
	/usr/bin/env bash --init-file <(_safeEcho ". "\"$scriptAbsoluteLocation\"" --profile _importShortcuts ; _cloud_set ; _cloudPrompt")
}








