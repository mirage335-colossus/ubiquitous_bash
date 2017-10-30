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
	
	rm -v /tmp/\.vbox-"$VBOX_IPC_SOCKETID"-ipc/ipcd > /dev/null 2>&1
	rm -v /tmp/\.vbox-"$VBOX_IPC_SOCKETID"-ipc/lock > /dev/null 2>&1
	rmdir -v /tmp/\.vbox-"$VBOX_IPC_SOCKETID"-ipc > /dev/null 2>&1
	
	rm -v "$VBOX_USER_HOME_short" > /dev/null 2>&1
}


_launch_lab_vbox_sequence() {
	_start
	
	_prepare_lab_vbox || return 1
	
	env HOME="$VBOX_USER_HOME_short" VirtualBox "$@"
	
	_wait_lab_vbox
	
	_stop
}

_launch_lab_vbox() {	
	"$scriptAbsoluteLocation" _launch_lab_vbox_sequence "$@"
}

_labVBox() {
	_launch_lab_vbox "$@"
}

_vboxlabSSH() {
	ssh -q -F "$scriptLocal"/vblssh -i "$scriptLocal"/id_rsa "$1"
}
