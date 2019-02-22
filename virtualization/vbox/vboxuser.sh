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
	
	#_closeVBoxRaw || return 1
	
	return 0
}

#Not routine.
_remove_instance_vbox() {
	_prepare_instance_vbox || return 1
}

#https://www.virtualbox.org/ticket/18257
_workaround_VirtualBoxVM() {
	if type VirtualBoxVM > /dev/null 2>&1
	then
		VirtualBoxVM "$@"
		return
	fi
	if ! type VirtualBoxVM > /dev/null 2>&1 && type /usr/lib/virtualbox/VirtualBoxVM > /dev/null 2>&1
	then
		/usr/lib/virtualbox/VirtualBoxVM "$@"
		return
	fi
	if ! type VirtualBoxVM > /dev/null 2>&1 && type /usr/local/lib/virtualbox/VirtualBoxVM > /dev/null 2>&1
	then
		/usr/local/lib/virtualbox/VirtualBoxVM "$@"
		return
	fi
	if ! type VirtualBoxVM > /dev/null 2>&1
	then
		VirtualBox "$@"
		return
	fi
}

_vboxGUI() {
	#_workaround_VirtualBoxVM "$@"
	
	#VirtualBoxVM "$@"
	#VirtualBox "$@"
	VBoxSDL "$@"
}


_set_instance_vbox_type() {
	#[[ "$vboxOStype" == "" ]] && export vboxOStype=Debian_64
	#[[ "$vboxOStype" == "" ]] && export vboxOStype=Gentoo
	#[[ "$vboxOStype" == "" ]] && export vboxOStype=Windows2003
	#[[ "$vboxOStype" == "" ]] && export vboxOStype=WindowsXP
	
	[[ "$vboxOStype" == "" ]] && _readLocked "$lock_open" && export vboxOStype=Debian_64
	[[ "$vboxOStype" == "" ]] && export vboxOStype=WindowsXP
	
	_messagePlain_probe 'vboxOStype= '"$vboxOStype"
	
	if VBoxManage createvm --name "$sessionid" --ostype "$vboxOStype" --register --basefolder "$VBOX_USER_HOME_short"
	then
		_messagePlain_probe VBoxManage createvm --name "$sessionid" --ostype "$vboxOStype" --register --basefolder "$VBOX_USER_HOME_short"
		return 0
	fi
	_messagePlain_bad 'fail: 'VBoxManage createvm --name "$sessionid" --ostype "$vboxOStype" --register --basefolder "$VBOX_USER_HOME_short"
	return 1
}

_set_instance_vbox_features() {
	#VBoxManage modifyvm "$sessionid" --boot1 disk --biosbootmenu disabled --bioslogofadein off --bioslogofadeout off --bioslogodisplaytime 5 --vram 128 --memory 1512 --nic1 nat --nictype1 "82543GC" --clipboard bidirectional --accelerate3d off --accelerate2dvideo off --vrde off --audio pulse --usb on --cpus 1 --ioapic off --acpi on --pae off --chipset piix3
	
	[[ "$vboxNic" == "" ]] && vboxNic="nat"
	_messagePlain_probe 'vboxNic= '"$vboxNic"
	
	local vboxChipset
	vboxChipset="ich9"
	#[[ "$vboxOStype" == *"Win"*"XP"* ]] && vboxChipset="piix3"
	_messagePlain_probe 'vboxChipset= '"$vboxChipset"
	
	local vboxNictype
	vboxNictype="82543GC"
	[[ "$vboxOStype" == *"Win"*"7"* ]] && vboxNictype="82540EM"
	[[ "$vboxOStype" == *"Win"*"10"* ]] && vboxNictype="82540EM"
	_messagePlain_probe 'vboxNictype= '"$vboxNictype"
	
	local vboxAudioController
	vboxAudioController="ac97"
	[[ "$vboxOStype" == *"Win"*"7"* ]] && vboxAudioController="hda"
	[[ "$vboxOStype" == *"Win"*"10"* ]] && vboxAudioController="hda"
	_messagePlain_probe 'vboxAudioController= '"$vboxAudioController"
	
	[[ "$vmMemoryAllocation" == "" ]] && vmMemoryAllocation="$vmMemoryAllocationDefault"
	_messagePlain_probe 'vmMemoryAllocation= '"$vmMemoryAllocation"
	
	_messagePlain_nominal "Setting VBox VM features."
	if ! VBoxManage modifyvm "$sessionid" --biosbootmenu disabled --bioslogofadein off --bioslogofadeout off --bioslogodisplaytime 1 --vram 128 --memory "$vmMemoryAllocation" --nic1 "$vboxNic" --nictype1 "$vboxNictype" --clipboard bidirectional --accelerate3d off --accelerate2dvideo off --vrde off --audio pulse --usb on --cpus 4 --ioapic on --acpi on --pae on --chipset "$vboxChipset" --audiocontroller="$vboxAudioController"
	then
		_messagePlain_probe VBoxManage modifyvm "$sessionid" --biosbootmenu disabled --bioslogofadein off --bioslogofadeout off --bioslogodisplaytime 1 --vram 128 --memory "$vmMemoryAllocation" --nic1 "$vboxNic" --nictype1 "$vboxNictype" --clipboard bidirectional --accelerate3d off --accelerate2dvideo off --vrde off --audio pulse --usb on --cpus 4 --ioapic on --acpi on --pae on --chipset "$vboxChipset" --audiocontroller="$vboxAudioController"
		_messagePlain_bad 'fail: VBoxManage'
		return 1
	fi
	return 0
	
}

_set_instance_vbox_features_app() {
	true
	#[[ "$vboxOStype" == *"Win"*"XP"* ]] && vboxChipset="piix3"
	#VBoxManage modifyvm "$sessionid" --usbxhci on
}

_set_instance_vbox_share() {
	#VBoxManage sharedfolder add "$sessionid" --name "root" --hostpath "/"
	if [[ "$sharedHostProjectDir" != "" ]]
	then
		_messagePlain_probe VBoxManage sharedfolder add "$sessionid" --name "appFolder" --hostpath "$sharedHostProjectDir"
		
		! VBoxManage sharedfolder add "$sessionid" --name "appFolder" --hostpath "$sharedHostProjectDir" && _messagePlain_warn 'fail: mount sharedHostProjectDir= '"$sharedHostProjectDir"
	fi
	
	if [[ -e "$HOME"/Downloads ]]
	then
		_messagePlain_probe VBoxManage sharedfolder add "$sessionid" --name "Downloads" --hostpath "$HOME"/Downloads
		
		! VBoxManage sharedfolder add "$sessionid" --name "Downloads" --hostpath "$HOME"/Downloads && _messagePlain_warn 'fail: mount (shared) Downloads= '"$HOME"/Downloads
	fi
}

_set_instance_vbox_command() {
	_messagePlain_nominal 'Creating BootDisc.'
	! _commandBootdisc "$@" && _messagePlain_bad 'fail: _commandBootdisc' && return 1
	return 0
}

_create_instance_vbox() {
	
	#Use existing VDI image if available.
	if ! [[ -e "$scriptLocal"/vm.vdi ]]
	then
		_messagePlain_nominal 'Missing VDI. Attempting to create from IMG.'
		! _openVBoxRaw && _messageError 'FAIL' && return 1
	fi
	
	_messagePlain_nominal 'Checking VDI file.'
	export vboxInstanceDiskImage="$scriptLocal"/vm.vdi
	_readLocked "$lock_open" && vboxInstanceDiskImage="$vboxRaw"
	! [[ -e "$vboxInstanceDiskImage" ]] && _messagePlain_bad 'missing: vboxInstanceDiskImage= '"$vboxInstanceDiskImage" && return 1
	
	_messagePlain_nominal 'Determining OS type.'
	_set_instance_vbox_type
	
	! _set_instance_vbox_features && _messageError 'FAIL' && return 1
	
	! _set_instance_vbox_features_app && _messageError 'FAIL: unknown app failure' && return 1
	
	_set_instance_vbox_command "$@"
	
	_messagePlain_nominal 'Mounting shared filesystems.'
	_set_instance_vbox_share
	
	_messagePlain_nominal 'Attaching local filesystems.'
	! VBoxManage storagectl "$sessionid" --name "IDE Controller" --add ide --controller PIIX4 && _messagePlain_bad 'fail: VBoxManage... attach ide controller'
	
	#export vboxDiskMtype="normal"
	#[[ "$vboxDiskMtype" == "" ]] && export vboxDiskMtype="multiattach"
	[[ "$vboxDiskMtype" == "" ]] && export vboxDiskMtype="immutable"
	_messagePlain_probe 'vboxDiskMtype= '"$vboxDiskMtype"
	
	_messagePlain_probe VBoxManage storageattach "$sessionid" --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium "$vboxInstanceDiskImage" --mtype "$vboxDiskMtype"
	! VBoxManage storageattach "$sessionid" --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium "$vboxInstanceDiskImage" --mtype "$vboxDiskMtype" && _messagePlain_bad 'fail: VBoxManage... attach vboxInstanceDiskImage= '"$vboxInstanceDiskImage"
	
	[[ -e "$hostToGuestISO" ]] && ! VBoxManage storageattach "$sessionid" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium "$hostToGuestISO" && _messagePlain_bad 'fail: VBoxManage... attach hostToGuestISO= '"$hostToGuestISO"
	
	#VBoxManage showhdinfo "$scriptLocal"/vm.vdi

	#Suppress annoying warnings.
	! VBoxManage setextradata global GUI/SuppressMessages "remindAboutAutoCapture,remindAboutMouseIntegration,remindAboutMouseIntegrationOn,showRuntimeError.warning.HostAudioNotResponding,remindAboutGoingSeamless,remindAboutInputCapture,remindAboutGoingFullscreen,remindAboutMouseIntegrationOff,confirmGoingSeamless,confirmInputCapture,remindAboutPausedVMInput,confirmVMReset,confirmGoingFullscreen,remindAboutWrongColorDepth" && _messagePlain_warn 'fail: VBoxManage... suppress messages'
	
	
	
	return 0
}

#Create and launch temporary VM around persistent disk image.
_user_instance_vbox_sequence() {
	_messageNormal '_user_instance_vbox_sequence: start'
	_start
	
	_prepare_instance_vbox || _stop 1
	
	_messageNormal '_user_instance_vbox_sequence: Checking lock vBox_vdi= '"$vBox_vdi"
	_readLocked "$vBox_vdi" && _messagePlain_bad 'lock: vBox_vdi= '"$vBox_vdi" && _stop 1
	
	_messageNormal '_user_instance_vbox_sequence: Creating instance. '"$sessionid"
	if ! _create_instance_vbox "$@"
	then
		_stop 1
	fi
	
	_messageNormal '_user_instance_vbox_sequence: Launch: _vboxGUI '"$sessionid"
	 _vboxGUI --startvm "$sessionid"
	
	_messageNormal '_user_instance_vbox_sequence: Removing instance. '"$sessionid"
	_rm_instance_vbox
	
	_messageNormal '_user_instance_vbox_sequence: stop'
	_stop
}

_user_instance_vbox() {
	"$scriptAbsoluteLocation" _user_instance_vbox_sequence "$@"
}

_userVBox() {
	_findInfrastructure_virtImage ${FUNCNAME[0]} "$@"
	[[ "$ubVirtImageLocal" == "false" ]] && return
	
	_messageNormal 'Begin: '"$@"
	_user_instance_vbox "$@"
	_messageNormal 'End: '"$@"
}

_edit_instance_vbox_sequence() {
	_start
	
	_prepare_instance_vbox || return 1
	
	#VBoxManage modifymedium "$scriptLocal"/vm.vdi --type normal
	
	export vboxDiskMtype="normal"
	if ! _create_instance_vbox "$@"
	then
		return 1
	fi
	
	_readLocked "$vBox_vdi" && return 1
	
	_createLocked "$vBox_vdi" || return 1
	
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
	_findInfrastructure_virtImage ${FUNCNAME[0]} "$@"
	[[ "$ubVirtImageLocal" == "false" ]] && return
	
	_messageNormal 'Begin: '"$@"
	_edit_instance_vbox "$@"
	_messageNormal 'End: '"$@"
}

