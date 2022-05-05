#cloud


_sshnokey_sequence() {
	local functionEntryPWD
	functionEntryPWD="$PWD"
	_start
	
	mkdir -p "$bootTmp"/.sshnokey_"$sessionid"
	chmod 0700 "$bootTmp"/.sshnokey_"$sessionid"
	
	cd "$bootTmp"/.sshnokey_"$sessionid"/
	ssh-keygen -b 4096 -t rsa -N "" -f "$bootTmp"/.sshnokey_"$sessionid"/id_rsa_nologin_bogus -C nologin@bogus
	rm -f "$bootTmp"/.sshnokey_"$sessionid"/id_rsa_nologin_bogus
	cat "$bootTmp"/.sshnokey_"$sessionid"/id_rsa_nologin_bogus.pub
	
	_safeRMR "$bootTmp"/.sshnokey_"$sessionid"
	
	
	cd "$functionEntryPWD"
	_stop
}

_sshnokey() {
	_sshnokey_sequence "$@"
}
sshnokey() {
	_sshnokey "$@"
}


# SSH, Force. Forcibly deletes old host key. Useful after 'rebuilding' a VPS using the same IP address, etc.
# DANGER: Obiously, this is for brief cloud experiments with newly constructed computers for which security is either unimportant or all relavant other conditions are known.
_sshf() {
	local currentUser
	local currentHostname
	
	local currentArg
	for currentArg in "$@"
	do
		if [[ "$currentArg" == *"@"* ]]
		then
			currentUser=$(_safeEcho_newline "$currentArg" | cut -f 1 -d\@)
			currentHostname=$(_safeEcho_newline "$currentArg" | cut -f 2 -d\@)
			break
		fi
	done
	if [[ "$currentHostname" == "" ]]
	then
		for currentArg in "$@"
		do
			if [[ "$currentArg" != "-"* ]]
			then
				currentHostname=$(_safeEcho_newline "$currentArg" | cut -f 2 -d\@)
				break
			fi
		done
	fi
	
	
	[[ "$currentHostname" != "" ]] && ssh-keygen -R "$currentHostname" > /dev/null 2>&1
	ssh -o "StrictHostKeyChecking no" "$@"
}
sshf() {
	_sshf "$@"
}

# VNC, through SSH, usually to server's actual display output, force. Expect this to work with Debian Buster x64, Raspbian, etc, as of 2022 .
# May not be tested with Wayland (x11vnc equivalent may be necessary).
_vncf() {
	local currentScript
	currentScript="$scriptAbsoluteFolder"/ubiquitous_bash.sh
	[[ ! -e "$currentScript" ]] && currentScript="$scriptAbsoluteLocation"
	[[ ! -e "$currentScript" ]] && exit 1
	
	# 'root' user default
	# Purpose is to access the GUI console (usually available through display manager as 'root' or through desktop session as 'user').
	if [[ "$1" != *"@"* ]] && [[ "$2" == "" ]] && [[ "$3" == "" ]] && [[ "$4" == "" ]] && [[ "$5" == "" ]]
	then
		"$currentScript" _sshf root@"$1" echo true
		"$currentScript" _vnc root@"$1"
	else
		"$currentScript" _sshf "$@" echo true
		"$currentScript" _vnc "$@"
	fi
}
vncf() {
	_vncf "$@"
}


# ATTENTION: Highly irregular means of keeping temporary data from cloud replies to API queries, due to the expected high probability of failures.
_start_cloud_tmp() {
	export ub_cloudTmp_id=$(_uid)
	export ub_cloudTmp="$scriptLocal"/cloud/cloudTmp/"$cloudTmp_id"
	
	#mkdir -p "$scriptLocal"/cloud/cloudTmp
	#! [[ -e "$scriptLocal"/cloud/cloudTmp ]] && _messageFAIL && _stop 1
	#! [[ -d "$scriptLocal"/cloud/cloudTmp ]] && _messageFAIL && _stop 1
	
	mkdir -p "$ub_cloudTmp"
	! [[ -e "$ub_cloudTmp" ]] && _messageFAIL && _stop 1
	! [[ -d "$ub_cloudTmp" ]] && _messageFAIL && _stop 1
	
	echo '*' > "$scriptLocal"/cloud/cloudTmp/.gitignore
	
	return 0
}
# WARNING: Do NOT call from '_stop' !
# WARNING: *Requires* variable "$ub_cloudTmp" to have been exported/set by '_start_cloud_tmp' !
_stop_cloud_tmp() {
	[[ "$cloudTmp" == "" ]] && return 1
	! [[ -e "$cloudTmp" ]] && return 1
	! [[ -d "$cloudTmp" ]] && return 1
	
	_safeRMR "$ub_cloudTmp" > /dev/null 2>&1
	
	return 0
}




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
	
	_tryExec '_aws_hook'
	_tryExec '_google_hook'
	return 0
}

# WARNING: End user function. Do NOT call within scripts.
# ATTENTION: TODO: Needs to be written out with 'declare -f' to '~/bin' and/or similar during '_setup_ssh' '_index' shortcut '_setup' and/or similar.
_cloud_unhook() {
	_messageNormal "init: _cloud_unhook"
	local ubHome
	ubHome="$HOME"
	[[ "$1" != "" ]] && ubHome="$1"
	
	export ubcoreDir="$ubHome"/.ubcore
	
	rm -f "$ubcoreDir"/cloudrc
	
	_tryExec '_google_unhook'
}

_cloud_shell() {
	#_cloudPrompt
	
	# https://unix.stackexchange.com/questions/428175/how-to-export-all-bash-functions-in-a-file-in-one-line
	#set -a
	##. "$scriptAbsoluteLocation" --parent _importShortcuts
	#. "$scriptAbsoluteLocation" --profile _importShortcuts
	#_cloud_set
	#_cloudPrompt
	#set +a
	
	# https://serverfault.com/questions/368054/run-an-interactive-bash-subshell-with-initial-commands-without-returning-to-the
	#/usr/bin/env bash --init-file <(_safeEcho ". "\"$scriptAbsoluteLocation\"" --profile _importShortcuts ; _cloud_set ; _cloudPrompt")
	/usr/bin/env bash --init-file <(_cloud_hook_here)
}



_cloudPrompt() {
	export prompt_cloudNetName='(cloud-'"$netName"')-'
	
	_visualPrompt
	
	#cloud-$netName
	#export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-(cloud-$netName)-(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$PS1_lineNumberText\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '
}


_cloud_set() {
	_rclone_set "$@"
	
	_aws_set "$@"
	_aws_eb_set "$@"
	
	_gcloud_set
	
	
	
	_cloudPrompt "$@"
}


_cloud_reset() {
	_rclone_reset "$@"
	
	_aws_reset "$@"
	_aws_eb_reset "$@"
	
	_gcloud_reset
	
	
	
	_visualPrompt
}







# ATTENTION: Override with 'core.sh', 'ops', or similar!
# Software which specifically may rely upon a recent feature of cloud services software (eg. aws, gcloud) should force this to instead always return 'true' .
_test_cloud_updateInterval() {
	! find "$HOME"/.ubcore/.retest-cloud"$1" -type f -mtime -9 2>/dev/null | grep '.retest-cloud' > /dev/null 2>&1
	
	#return 0
	return
}

_test_cloud() {
	_tryExec '_test_digitalocean_cloud'
	_tryExec '_test_linode_cloud'
	
	
	if _test_cloud_updateInterval
	then
		rm -f "$HOME"/.ubcore/.retest-cloud > /dev/null 2>&1
		touch "$HOME"/.ubcore/.retest-cloud
		date +%s > "$HOME"/.ubcore/.retest-cloud
		_tryExec '_test_aws'
		_tryExec '_test_gcloud'
	fi
	
	_tryExec '_test_ubVirt'
	_tryExec '_test_phpvirtualbox_self'
	_tryExec '_test_virtualbox_self'
	
	
	return 0
}
