#Installs to a raw disk image using VirtualBox. Subsequently may be run under a variety of real and virtual platforms.
_create_msw_vbox_sequence() {
	_start
	
	[[ ! -e "$scriptLocal"/msw.iso ]] && _stop 1
	
	[[ ! -e "$scriptLocal"/vm.img ]] && [[ ! -e "$scriptLocal"/vm.vdi ]] && _createRawImage
	
	_checkDep VBoxManage
	
	_prepare_instance_vbox || return 1
	
	_readLocked "$vBox_vdi" && return 1
	
	_createLocked "$vBox_vdi" || return 1
	
	#VBoxManage modifymedium "$scriptLocal"/vm.vdi --type normal
	
	export vboxDiskMtype="normal"
	_create_instance_vbox "$@"
	
	#####Actually mount MSW ISO.
	VBoxManage storageattach "$sessionid" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium "$scriptLocal"/msw.iso
	
	env HOME="$VBOX_USER_HOME_short" VirtualBox
	
	_wait_instance_vbox
	
	#VBoxManage modifymedium "$scriptLocal"/vm.vdi --type multiattach
	
	rm -f "$vBox_vdi" > /dev/null 2>&1
	
	_rm_instance_vbox
	
	_stop
}

_create_msw_vbox() {
	"$scriptAbsoluteLocation" _create_msw_vbox_sequence "$@"
}


#Installs to a raw disk image using QEMU. Subsequently may be run under a variety of real and virtual platforms.
_create_msw_qemu_sequence() {
	_start
	
	[[ ! -e "$scriptLocal"/msw.iso ]] && _stop 1
	
	[[ ! -e "$scriptLocal"/vm.img ]] && _createRawImage
	
	_checkDep qemu-system-x86_64
	
	qemu-system-x86_64 -smp 4 -machine accel=kvm -drive format=raw,file="$scriptLocal"/vm.img -cdrom "$scriptLocal"/msw.iso -boot d -m 1536 -net nic,model=rtl8139 -net user -usbdevice tablet -vga cirrus -show-cursor
	
	_stop
}

_create_msw_qemu() {
	"$scriptAbsoluteLocation" _create_msw_qemu_sequence "$@"
}

_create_msw() {
	_create_msw_vbox "$@"
}
