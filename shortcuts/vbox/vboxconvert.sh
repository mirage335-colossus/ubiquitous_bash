# Also depends on '_labVBoxManage' .
_test_vboxconvert() {
	_getDep VBoxManage
}

#No production use.
_vdi_get_UUID() {
	_labVBoxManage showhdinfo "$scriptLocal"/vm.vdi | grep ^UUID | cut -f2- -d\  | tr -dc 'a-zA-Z0-9\-'
}

#No production use.
_vdi_write_UUID() {
	_vdi_get_UUID > "$scriptLocal"/vm.vdi.uuid.quicktmp
	
	if [[ -e "$scriptLocal"/vm.vdi.uuid ]] && ! diff "$scriptLocal"/vm.vdi.uuid.quicktmp "$scriptLocal"/vm.vdi.uuid > /dev/null 2>&1
	then
		_messagePlain_bad 'conflict: mismatch: existing vdi uuid'
		_messagePlain_request 'request: rm '"$scriptLocal"/vm.vdi.uuid
		return 1
	fi
	
	mv "$scriptLocal"/vm.vdi.uuid.quicktmp "$scriptLocal"/vm.vdi.uuid
	return
}

#No production use.
_vdi_read_UUID() {
	local current_UUID
	current_UUID=$(cat "$scriptLocal"/vm.vdi.uuid 2>/dev/null | tr -dc 'a-zA-Z0-9\-')
	
	[[ "$current_UUID" == "" ]] && return 1
	echo "$current_UUID"
	return 0
}


_vdi_to_img() {
	_messageNormal '_vdi_to_img: init'
	! [[ -e "$scriptLocal"/vm.vdi ]] && _messagePlain_bad 'fail: missing: in file' && return 1
	[[ -e "$scriptLocal"/vm.img ]] && _messagePlain_request 'request: rm '"$scriptLocal"/vm.img && return 1
	
	_messageNormal '_vdi_to_img: _vdi_write_UUID'
	# No production use. Only required by other functions, also no production use.
	if ! _vdi_write_UUID
	then
		_messagePlain_bad 'fail: _vdi_write_UUID'
		return 1
	fi
	
	_messageNormal '_vdi_to_img: clonehd'
	if _labVBoxManage clonehd "$scriptLocal"/vm.vdi "$scriptLocal"/vm.img --format RAW
	then
		_messageNormal '_vdi_to_img: closemedium'
		_labVBoxManage closemedium "$scriptLocal"/vm.img
		_messagePlain_request 'request: rm '"$scriptLocal"/vm.vdi
		_messagePlain_good 'End.'
		return 0
	fi
	_labVBoxManage closemedium "$scriptLocal"/vm.img
	return 1
}

#No production use. Not recommended except to accommodate MSW hosts.
_img_to_vdi() {
	_messageNormal '_img_to_vdi: init'
	! [[ -e "$scriptLocal"/vm.img ]] && _messagePlain_bad 'fail: missing: in file' && return 1
	[[ -e "$scriptLocal"/vm.vdi ]] && _messagePlain_request 'request: rm '"$scriptLocal"/vm.vdi && return 1
	
	_messageNormal '_img_to_vdi: convertdd'
	if _labVBoxManage convertdd "$scriptLocal"/vm.img "$scriptLocal"/vm-c.vdi --format VDI
	then
		_messageNormal '_img_to_vdi: closemedium'
		_labVBoxManage closemedium "$scriptLocal"/vm-c.vdi
		mv -n "$scriptLocal"/vm-c.vdi "$scriptLocal"/vm.vdi
		_messageNormal '_img_to_vdi: setuuid'
		VBoxManage internalcommands sethduuid "$scriptLocal"/vm.vdi $(_vdi_read_UUID)
		_messagePlain_request 'request: rm '"$scriptLocal"/vm.img
		_messagePlain_good 'End.'
		return 0
	fi
	
	_messageFAIL
	return 1
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
