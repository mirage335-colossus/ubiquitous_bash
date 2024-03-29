##VBox Boxing
_wait_lab_vbox() {
	_prepare_lab_vbox || return 1
	
	VBoxXPCOMIPCD_PID=$(cat "$VBoxXPCOMIPCD_PIDfile" 2> /dev/null)
	#echo -e '\E[1;32;46mWaiting for VBoxXPCOMIPCD to finish... \E[0m'
	while kill -0 "$VBoxXPCOMIPCD_PID" > /dev/null 2>&1
	do
		sleep 0.2
	done
}

#Not routine.
_remove_lab_vbox() {
	_prepare_lab_vbox || return 1
	
	_wait_lab_vbox
	
	#echo -e '\E[1;32;46mRemoving IPC folder and vBoxHome directory symlink from filesystem.\E[0m'
	
	rm -f /tmp/\.vbox-"$VBOX_IPC_SOCKETID"-ipc/ipcd > /dev/null 2>&1
	rm -f /tmp/\.vbox-"$VBOX_IPC_SOCKETID"-ipc/lock > /dev/null 2>&1
	rmdir /tmp/\.vbox-"$VBOX_IPC_SOCKETID"-ipc > /dev/null 2>&1
	
	rm -f "$VBOX_USER_HOME_short" > /dev/null 2>&1
}


_launch_lab_vbox_sequence() {
	_start
	
	_prepare_lab_vbox || return 1
	
	#Directly opening raw images in the VBoxLab environment is not recommended, due to changing VMDK disk identifiers.
	#Better practice may be to instead programmatically construct the raw image virtual machines before opening VBoxLab environment.
	#_openVBoxRaw
	
	_VirtualBox_env_VBOX_USER_HOME_short "$@"
	
	_wait_lab_vbox
	
	_stop
}

_launch_lab_vbox() {	
	"$scriptAbsoluteLocation" _launch_lab_vbox_sequence "$@"
}

_labVBox() {
	_launch_lab_vbox "$@"
}

_launch_lab_vbox_manage_sequence() {
	_start
	
	_prepare_lab_vbox || return 1
	
	#Directly opening raw images in the VBoxLab environment is not recommended, due to changing VMDK disk identifiers.
	#Better practice may be to instead programmatically construct the raw image virtual machines before opening VBoxLab environment.
	#_openVBoxRaw
	
	_VBoxManage_env_VBOX_USER_HOME_short "$@"
	
	_wait_lab_vbox
	
	_stop
}

_launch_lab_vbox_manage() {	
	"$scriptAbsoluteLocation" _launch_lab_vbox_manage_sequence "$@"
}

_labVBoxManage() {
	_launch_lab_vbox_manage "$@"
}


_vboxlabSSH() {
	ssh -q -F "$scriptLocal"/vblssh -i "$scriptLocal"/id_rsa "$1"
}

_labVBox_migrate() {
	_messageNormal 'init: _labVBox_migrate'
	
	! _prepare_lab_vbox && _messagePlain_bad 'fail: _prepare_lab_vbox' && return 1
	
	export ub_new_VBOXID=$(_uid)
	
	find . \( -iname '*.xml' -o -iname '*.xml*' -o -iname '*.xbel' -o -iname '*.conf' -o -iname '*.vbox' -o -iname '*.vbox*' -o -iname '*.id' \) -exec sed -i 's/'$VBOXID'/'"$ub_new_VBOXID"'/g' '{}' \;
	
	_messagePlain_good 'complete: _labVBox_migrate'
}


