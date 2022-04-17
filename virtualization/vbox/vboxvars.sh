##### VBoxVars
#Only include variables and functions here that might need to be used globally.
_unset_vbox() {
	export vBox_vdi=""
	
	export vBoxInstanceDir=""
	
	export VBOX_ID_FILE=""
	
	export VBOX_USER_HOME=""
	export VBOX_USER_HOME_local=""
	export VBOX_USER_HOME_short=""
	
	export VBOX_IPC_SOCKETID=""
	export VBoxXPCOMIPCD_PIDfile=""
	
	_messagePlain_nominal 'clear: _unset_vbox'
}

_reset_vboxLabID() {
	[[ "$VBOX_ID_FILE" == "" ]] && _messagePlain_bad 'blank: VBOX_ID_FILE' && return 1
	
	if [[ "$ub_VBoxLab_prepare" == "true" ]]
	then
		_messagePlain_warn 'warn: path has changed and lock not reset'
		_messagePlain_warn 'user: recommend: _labVBox_migrate'
		return 0
	fi
	
	rm -f "$VBOX_ID_FILE" > /dev/null 2>&1
	
	[[ -e "$VBOX_ID_FILE" ]] && _messagePlain_bad 'fail: VBOX_ID_FILE exists' && return 1
	
	return 0
}

#"$1" == virtualbox instance directory (optional)
_prepare_vbox() {
	_messagePlain_nominal 'init: _prepare_vbox'
	
	_unset_vbox
	
	export vBox_vdi="$scriptLocal/_vboxvdi"
	
	export vBoxInstanceDir="$scriptLocal"
	[[ "$1" != "" ]] && export vBoxInstanceDir="$1"
	_messagePlain_probe 'vBoxInstanceDir= '"$vBoxInstanceDir"
	
	mkdir -p "$vBoxInstanceDir" > /dev/null 2>&1 || return 1
	mkdir -p "$scriptLocal" > /dev/null 2>&1 || return 1
	mkdir -p "$globalVirtDir" > /dev/null 2>&1 || return 1
	mkdir -p "$globalVirtFS" > /dev/null 2>&1 || return 1
	mkdir -p "$globalVirtTmp" > /dev/null 2>&1 || return 1
	
	export VBOX_ID_FILE
	VBOX_ID_FILE="$vBoxInstanceDir"/vbox.id
	
	! _pathLocked _reset_vboxLabID && _messagePlain_bad 'fail: path has changed and lock not reset' && return 1
	
	[[ ! -e "$VBOX_ID_FILE" ]] && sleep 0.1 && [[ ! -e "$VBOX_ID_FILE" ]] && echo -e -n "$sessionid" > "$VBOX_ID_FILE" 2> /dev/null
	[[ -e "$VBOX_ID_FILE" ]] && export VBOXID=$(cat "$VBOX_ID_FILE" 2> /dev/null)
	
	
	export VBOX_USER_HOME="$vBoxInstanceDir"/vBoxCfg
	export VBOX_USER_HOME_local="$vBoxInstanceDir"/vBoxHome
	#export VBOX_USER_HOME_short="$HOME"/.vbl"$VBOXID"
	#export VBOX_USER_HOME_short=/tmp/.vbl"$VBOXID"
	export VBOX_USER_HOME_short="$bootTmp"/.vbl"$VBOXID"
	
	export VBOX_IPC_SOCKETID="$VBOXID"
	export VBoxXPCOMIPCD_PIDfile="/tmp/.vbox-""$VBOX_IPC_SOCKETID""-ipc/lock"
	
	
	
	[[ "$VBOXID" == "" ]] && _messagePlain_bad 'blank: VBOXID' && return 1
	[[ ! -e "$VBOX_ID_FILE" ]] && _messagePlain_bad 'missing: VBOX_ID_FILE= '"$VBOX_ID_FILE" && return 1
	
	
	mkdir -p "$VBOX_USER_HOME" > /dev/null 2>&1 || return 1
	mkdir -p "$VBOX_USER_HOME_local" > /dev/null 2>&1 || return 1
	
	
	#Atomically ensure symlink between full and short home directory paths is up to date.
	local oldLinkPath
	oldLinkPath=$(readlink "$VBOX_USER_HOME_short")
	[[ "$oldLinkPath" != "$VBOX_USER_HOME_local" ]] && ln -sf -n "$VBOX_USER_HOME_local" "$VBOX_USER_HOME_short" > /dev/null 2>&1
	oldLinkPath=$(readlink "$VBOX_USER_HOME_short")
	[[ "$oldLinkPath" != "$VBOX_USER_HOME_local" ]] && _messagePlain_bad 'fail: symlink VBOX_USER_HOME_local to VBOX_USER_HOME_short' && return 1
	
	
	_override_bin_vbox "$@"
	
	return 0
}

_prepare_lab_vbox() {
	export ub_VBoxLab_prepare='true'
	local currentExitStatus
	_prepare_vbox "$scriptLocal"
	currentExitStatus="$?"
	export ub_VBoxLab_prepare='false'
	
	return "$currentExitStatus"
}
#_prepare_lab_vbox




_override_bin_vbox() {
	if ! _if_cygwin
	then
		return 0
	fi
	
	_at_userMSW_probeCmd_discoverResource-cygwinNative-ProgramFiles VirtualBox Oracle/VirtualBox false
	_at_userMSW_probeCmd_discoverResource-cygwinNative-ProgramFiles VBoxManage Oracle/VirtualBox false
	
	_at_userMSW_probeCmd_discoverResource-cygwinNative-ProgramFiles VBoxHeadless Oracle/VirtualBox false
	_at_userMSW_probeCmd_discoverResource-cygwinNative-ProgramFiles VBoxSDL Oracle/VirtualBox false
	
	_at_userMSW_probeCmd_discoverResource-cygwinNative-ProgramFiles VirtualBoxVM Oracle/VirtualBox false
}



_VirtualBox_env_VBOX_USER_HOME_short_sequence() {
	export functionEntry_HOME="$HOME"
	
	local currentExitStatus
	
	export HOME="$VBOX_USER_HOME_short"
	VirtualBox "$@"
	currentExitStatus="$?"
	
	export HOME="$functionEntry_HOME"
	return "$currentExitStatus"
}
_VirtualBox_env_VBOX_USER_HOME_short() {
	if _if_cygwin
	then
		_VirtualBox_env_VBOX_USER_HOME_short_sequence "$@"
		return
	fi
	
	"$scriptAbsoluteLocation" _VirtualBox_env_VBOX_USER_HOME_short_sequence "$@"
	return
}

_VBoxManage_env_VBOX_USER_HOME_short_sequence() {
	export functionEntry_HOME="$HOME"
	
	local currentExitStatus
	
	export HOME="$VBOX_USER_HOME_short"
	VBoxManage "$@"
	currentExitStatus="$?"
	
	export HOME="$functionEntry_HOME"
	return "$currentExitStatus"
}
_VBoxManage_env_VBOX_USER_HOME_short() {
	if _if_cygwin
	then
		_VBoxManage_env_VBOX_USER_HOME_short_sequence "$@"
		return
	fi
	
	"$scriptAbsoluteLocation" _VBoxManage_env_VBOX_USER_HOME_short_sequence "$@"
	return
}


