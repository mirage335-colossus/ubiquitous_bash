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
	
	#Usually unnecessary, possibly destructive, may delete VM images.
	#VBoxManage unregistervm "$sessionid" --delete > /dev/null 2>&1
	
	_safeRMR "$instancedVirtDir" || return 1
	
	rm -f /tmp/\.vbox-"$VBOX_IPC_SOCKETID"-ipc/ipcd > /dev/null 2>&1
	rm -f /tmp/\.vbox-"$VBOX_IPC_SOCKETID"-ipc/lock > /dev/null 2>&1
	rmdir /tmp/\.vbox-"$VBOX_IPC_SOCKETID"-ipc > /dev/null 2>&1
	
	rm -f "$VBOX_USER_HOME_short" > /dev/null 2>&1
	
	return 0
}

#Not routine.
_remove_instance_vbox() {
	_prepare_instance_vbox || return 1
}

_vboxGUI() {
	#VirtualBox "$@"
	VBoxSDL "$@"
}


_set_instance_vbox_type() {
	#[[ "$vboxOStype" == "" ]] && export vboxOStype=Gentoo
	#[[ "$vboxOStype" == "" ]] && export vboxOStype=Windows2003
	[[ "$vboxOStype" == "" ]] && export vboxOStype=WindowsXP
	VBoxManage createvm --name "$sessionid" --ostype "$vboxOStype" --register --basefolder "$VBOX_USER_HOME_short"
}

_set_instance_vbox_features() {
	VBoxManage modifyvm "$sessionid" --boot1 disk --biosbootmenu disabled --bioslogofadein off --bioslogofadeout off --bioslogodisplaytime 5 --vram 128 --memory 512 --nic1 nat --nictype1 "82543GC" --vrde off --ioapic off --acpi on --pae off --chipset piix3 --audio pulse --usb on --cpus 1 --accelerate3d off --accelerate2dvideo off --clipboard bidirectional
}

_set_instance_vbox_share() {
	#VBoxManage sharedfolder add "$sessionid" --name "root" --hostpath "/"
	[[ "$sharedHostProjectDir" != "" ]] && VBoxManage sharedfolder add "$sessionid" --name "appFolder" --hostpath "$sharedHostProjectDir"
}

_set_instance_vbox_command() {
	_prepareBootdisc || return 1
	
	_commandBootdisc "$@" || return 1
}

_create_instance_vbox() {
	_set_instance_vbox_type
	
	_set_instance_vbox_features
	
	_set_instance_vbox_command "$@"
	
	_set_instance_vbox_share
	
	VBoxManage storagectl "$sessionid" --name "IDE Controller" --add ide --controller PIIX4
	
	#export vboxDiskMtype="normal"
	[[ "$vboxDiskMtype" == "" ]] && export vboxDiskMtype="multiattach"
	VBoxManage storageattach "$sessionid" --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium "$scriptLocal"/vm.vdi --mtype "$vboxDiskMtype"
	
	[[ -e "$hostToGuestISO" ]] && VBoxManage storageattach "$sessionid" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium "$hostToGuestISO"
	
	#VBoxManage showhdinfo "$scriptLocal"/vm.vdi

	#Suppress annoying warnings.
	VBoxManage setextradata global GUI/SuppressMessages "remindAboutAutoCapture,remindAboutMouseIntegrationOn,showRuntimeError.warning.HostAudioNotResponding,remindAboutGoingSeamless,remindAboutInputCapture,remindAboutGoingFullscreen,remindAboutMouseIntegrationOff,confirmGoingSeamless,confirmInputCapture,remindAboutPausedVMInput,confirmVMReset,confirmGoingFullscreen,remindAboutWrongColorDepth"
	
	return 0
}

#Create and launch temporary VM around persistent disk image.
_user_instance_vbox_sequence() {
	_start
	
	_prepare_instance_vbox || return 1
	
	_readLocked "$vBox_vdi" && return 1
	
	_create_instance_vbox "$@"
	
	 _vboxGUI --startvm "$sessionid"
	
	_rm_instance_vbox
	
	_stop
}

_user_instance_vbox() {
	"$scriptAbsoluteLocation" _user_instance_vbox_sequence "$@"
}

_userVBox() {
	_user_instance_vbox "$@"
}

_edit_instance_vbox_sequence() {
	_start
	
	_prepare_instance_vbox || return 1
	
	_readLocked "$vBox_vdi" && return 1
	
	_createLocked "$vBox_vdi" || return 1
	
	#VBoxManage modifymedium "$scriptLocal"/vm.vdi --type normal
	
	export vboxDiskMtype="normal"
	_create_instance_vbox "$@"
	
	env HOME="$VBOX_USER_HOME_short" VirtualBox
	
	_wait_instance_vbox
	
	#VBoxManage modifymedium "$scriptLocal"/vm.vdi --type multiattach
	
	rm -f "$vBox_vdi" > /dev/null 2>&1
	
	_rm_instance_vbox
	
	_stop
}

_edit_instance_vbox() {	
	"$scriptAbsoluteLocation" _edit_instance_vbox_sequence "$@"
}

_editVBox() {
	_edit_instance_vbox "$@"
}

