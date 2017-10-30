##VBox Boxing
_prepare_instance_vbox() {
	_prepare_vbox "$instancedVirtDir"
}


_wait_instance_vbox() {
	_prepare_instance_vbox || return 1
	
	VBoxXPCOMIPCD_PID=$(cat "$VBoxXPCOMIPCD_PIDfile" 2> /dev/null)
	#echo -e '\E[1;32;46mWaiting for VBoxXPCOMIPCD to finish... \E[0m'
	while kill -0 "$VBoxXPCOMIPCD_PID" > /dev/null 2>&1
	do
		sleep 0.2
	done
}

#Not routine.
_remove_instance_vbox() {
	_prepare_instance_vbox || return 1
}


_edit_instance_vbox_sequence() {
	_start
	
	_prepare_instance_vbox || return 1
	
	env HOME="$VBOX_USER_HOME_short" VirtualBox "$@"
	
	_wait_lab_vbox
	
	_stop
}

_edit_instance_vbox() {	
	"$scriptAbsoluteLocation" _edit_instance_vbox_sequence "$@"
}

_editVBox() {
	_edit_instance_vbox "$@"
}

_userVBox() {
	true "$@"
}

_vboxlabSSH() {
	ssh -q -F "$scriptLocal"/vblssh -i "$scriptLocal"/id_rsa "$1"
}
