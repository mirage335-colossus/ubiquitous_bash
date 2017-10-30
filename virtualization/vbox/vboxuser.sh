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

_rm_instance_vbox() {
	_prepare_instance_vbox || return 1
	
	VBoxManage unregistervm "$sessionid" --delete > /dev/null 2>&1
	
	_safeRMR "$instancedVirtDir" || return 1
	
	rm -v /tmp/\.vbox-"$VBOX_IPC_SOCKETID"-ipc/ipcd > /dev/null 2>&1
	rm -v /tmp/\.vbox-"$VBOX_IPC_SOCKETID"-ipc/lock > /dev/null 2>&1
	rmdir -v /tmp/\.vbox-"$VBOX_IPC_SOCKETID"-ipc > /dev/null 2>&1
	
	rm -v "$VBOX_USER_HOME_short" > /dev/null 2>&1
	
	return 0
}

#Not routine.
_remove_instance_vbox() {
	_prepare_instance_vbox || return 1
}


_set_instance_vbox_type() {
	#[[ "$vboxOStype" ]] && export vboxOStype=Gentoo
	[[ "$vboxOStype" ]] && export vboxOStype=Windows2003
	VBoxManage createvm --name "$sessionid" --ostype "$vboxOStype" --register --basefolder "$VBOX_USER_HOME_short"
}

_set_instance_vbox_features() {
	VBoxManage modifyvm "$sessionid" --boot1 disk --biosbootmenu disabled --bioslogofadein off --bioslogofadeout off --bioslogodisplaytime 5 --vram 128 --memory 1536 --nic1 nat --nictype1 "82543GC" --vrde off --ioapic on --acpi on --pae on --chipset ich9 --audio null --usb on --cpus 2 --accelerate3d off --accelerate2dvideo off --clipboard bidirectional
}

_set_instance_vbox_share() {
	#VBoxManage sharedfolder add "$sessionid" --name "root" --hostpath "/" --automount
	[[ "$1" != "" ]] && VBoxManage sharedfolder add "$sessionid" --name "appFolder" --hostpath "$1" --automount
}

_set_instance_vbox_command() {
	_prepareBootdisc || return 1
	
	_mkisofs -R -uid 0 -gid 0 -dir-mode 0555 -file-mode 0555 -new-dir-mode 0555 -J -hfs -o "$hostToGuestISO" "$hostToGuestFiles" || return 1
}

_user_instance_vbox() {
	#Create temporary VM around persistent disk image.
	
	_set_instance_vbox_type
	
	_set_instance_vbox_features
	
	_set_instance_vbox_share
	
	_set_instance_vbox_command
	
	VBoxManage storagectl "$sessionid" --name "IDE Controller" --add ide --controller PIIX4
	VBoxManage storageattach "$sessionid" --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium "$scriptLocal"/vm.vdi --mtype multiattach
	
	[[ -e "$hostToGuestISO" ]] && VBoxManage storageattach "$VM_Name" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium "$hostToGuestISO"
	
	#VBoxManage showhdinfo "$scriptLocal"/vm.vdi

	#Suppress annoying warnings.
	VBoxManage setextradata global GUI/SuppressMessages "remindAboutAutoCapture,remindAboutMouseIntegrationOn,showRuntimeError.warning.HostAudioNotResponding,remindAboutGoingSeamless,remindAboutInputCapture,remindAboutGoingFullscreen,remindAboutMouseIntegrationOff,confirmGoingSeamless,confirmInputCapture,remindAboutPausedVMInput,confirmVMReset,confirmGoingFullscreen,remindAboutWrongColorDepth"

}



_edit_instance_vbox_sequence() {
	_start
	
	_prepare_instance_vbox || return 1
	
	_readLocked "$vBox_vdi" && return 1
	
	_createLocked "$vBox_vdi" || return 1
	
	env HOME="$VBOX_USER_HOME_short" VirtualBox "$@"
	
	_wait_instance_vbox
	
	rm "$vBox_vdi" > /dev/null 2>&1
	
	_rm_instance_vbox
	
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
