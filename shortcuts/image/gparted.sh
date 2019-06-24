_test_gparted() {
	_getDep gparted
}

_gparted_sequence() {
	_messageNormal 'launch gparted'
	
	_start
	
	_mustGetSudo
	
	_messagePlain_nominal 'Attempt: _openLoop'
	! _openLoop && _messageFAIL
	
	
	_messagePlain_nominal 'Launch: gparted'
	
	local imagedev
	imagedev=$(cat "$scriptLocal"/imagedev)
	
	_messagePlain_probe 'blkid'
	sudo -n blkid "$imagedev"
	local orig_ptuuid
	orig_ptuuid=$(sudo blkid -s PTUUID -o value /dev/loop0)
	
	sudo -n gparted "$imagedev"
	
	_messagePlain_probe 'blkid'
	sudo -n blkid "$imagedev"
	local modified_ptuuid
	modified_ptuuid=$(sudo blkid -s PTUUID -o value /dev/loop0)
	
	
	_messagePlain_nominal 'Attempt: _closeLoop'
	! _closeLoop && _messageFAIL
	
	
	if [[ -e "$scriptLocal"/vm-raspbian.img ]]
	then
		_messageNormal 'Config: raspbian'
		_messagePlain_probe_var orig_ptuuid
		_messagePlain_probe_var modified_ptuuid
		
		_messagePlain_nominal 'Attempt: _openChRoot'
		! _openChRoot && _messageFAIL
		
		
		_messagePlain_nominal 'Replace: /boot/cmdline.txt'
		_messagePlain_probe "$globalVirtFS"/../boot/cmdline.txt
		sudo -n sed -i 's/'"$orig_ptuuid"'/'"$modified_ptuuid"'/g' "$globalVirtFS"/../boot/cmdline.txt
		
		_messagePlain_nominal 'Replace: /etc/fstab'
		_messagePlain_probe "$globalVirtFS"/../fs/etc/fstab
		sudo -n sed -i 's/'"$orig_ptuuid"'/'"$modified_ptuuid"'/g' "$globalVirtFS"/../fs/etc/fstab
		
		
		_messagePlain_nominal 'Attempt: _closeChRoot'
		! _closeChRoot && _messageFAIL
	fi
	
	_stop
}

_gparted() {
	"$scriptAbsoluteLocation" _gparted_sequence
}
