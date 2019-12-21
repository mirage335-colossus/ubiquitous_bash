# Also depends on '_labVBoxManage' .
_test_vboxconvert() {
	_getDep VBoxManage
}

_vdi_to_img() {
	_labVBoxManage clonehd "$scriptLocal"/vm.vdi "$scriptLocal"/vm.img --format RAW
}

#No production use. Not recommended except to accommodate MSW hosts.
_img_to_vdi() {
	_labVBoxManage convertdd "$scriptLocal"/vm.img "$scriptLocal"/vm.vdi --format VDI
}


#No production use. Dependency of functions which also have no production use.
#https://unix.stackexchange.com/questions/33508/check-which-network-block-devices-are-in-use
_nbd-available_vbox() {
	nbd-client -c "$1";
	[ 1 = $? ] &&
	python -c 'import os,sys; os.open(sys.argv[1], os.O_EXCL)' "$1" 2>/dev/null;
}

#No production use. Dependency of functions which also have no production use.
_check_nbd_vbox() {
	! _wantSudo && _messagePlain_bad 'fail: _wantSudo' && _messageFAIL
	
	sudo -n ! type nbd-client > /dev/null 2>&1 && _messagePlain_bad 'fail: missing: nbd-client' && _messageFAIL
	! type qemu-nbd > /dev/null 2>&1 && _messagePlain_bad 'fail: missing: qemu nbd' && _messageFAIL
	
	! sudo -n modprobe nbd && _messagePlain_bad 'fail: modprobe nbd' && _messageFAIL
	
	if ! sudo -n "$scriptAbsoluteLocation" _nbd-available_vbox "$@"
	then
		_messagePlain_bad 'fail: _nbd-available: '"$@"
		_messageFAIL
	fi
}

#No production use.
# DANGER: Take care to ensure neither "vm.vdi" nor "/dev/nbd7" are not in use.
# WARNING: Not recommended. Convert to raw img and use dd/gparted as needed.
# DANGER: Not tested.
_vdi_gparted() {
	! _check_nbd_vbox /dev/nbd7 && _messageFAIL
	
	sudo -n qemu-nbd -c /dev/nbd7 "$scriptLocal"/vm.vdi
	
	sudo -n partprobe
	
	sudo -n gparted /dev/nbd7
	
	sudo -n qemu-nbd -d /dev/nbd7
}

#No production use.
# DANGER: Take care to ensure neither "vm.vdi", "/dev/nbd6", nor "/dev/nbd7" are not in use.
# WARNING: Not recommended. Convert to raw img and use dd/gparted as needed.
# DANGER: Not tested.
_vdi_resize() {
	! _check_nbd_vbox /dev/nbd7 && _messageFAIL
	! _check_nbd_vbox /dev/nbd6 && _messageFAIL
	
	mv "$scriptLocal"/vm.vdi "$scriptLocal"/vm-big.vdi
	
	#Accommodates 8024MiB.
	VBoxManage createhd --filename "$scriptLocal"/vm-small.vdi --size 8512
	
	sudo -n modprobe nbd max_part=15
	sudo -n qemu-nbd -c /dev/nbd7 "$scriptLocal"/vm-big.vdi
	sudo -n qemu-nbd -c /dev/nbd6 "$scriptLocal"/vm-small.vdi
	sudo -n partprobe
	
	#sudo -n dd if=/dev/nbd7 of=/dev/nbd6 bs=446 count=1
	sudo -n dd if=/dev/nbd7 of=/dev/nbd6 bs=1M count=8512
	sudo -n partprobe
	
	
	
	
	
	
	
	sudo -n gparted /dev/nbd7 /dev/nbd6
	
	sudo -n qemu-nbd -d /dev/nbd7
	sudo -n qemu-nbd -d /dev/nbd6
	
	mv "$scriptLocal"/vm-small.vdi "$scriptLocal"/vm.vdi
	
	#qemu-img convert -f vdi -O qcow2 vm.vdi vm.qcow2
	#qemu-img resize vm.qcow2 8512M
	
	#VBoxManage clonehd "$scriptLocal"/vm.vdi "$scriptLocal"/vm-small.vdi --existing
	#VBoxManage modifyhd "$scriptLocal"/vm-small.vdi --resize 8512
}
