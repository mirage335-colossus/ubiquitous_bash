_test_gparted() {
	_wantGetDep gparted
	
	_wantGetDep blkid
	_wantGetDep blockdev
	
	_wantGetDep fdisk
	_wantGetDep gdisk
	_wantGetDep sgdisk
	
	_wantGetDep blkdiscard
	
	_wantGetDep mkfs.ext2
	_wantGetDep mkfs.ext4
	
	_wantGetDep mkfs.nilfs2
	_wantGetDep mkfs.btrfs
	
	
	_wantGetDep mkudffs
	! _wantGetDep genisoimage && _wantGetDep mkisofs
	if ! type mkisofs > /dev/null 2>&1 && ! type genisoimage > /dev/null 2>&1
	then
		echo 'want mkisofs or genisoimage'
	fi
	_wantGetDep dvd+rw-format
	_wantGetDep growisofs
	
	# https://www.kernel.org/doc/html/latest/cdrom/packet-writing.html
	# pktcdvd driver makes the disc appear as a regular block device with a 2KB block size
	_wantGetDep pktsetup
	
	_wantGetDep partprobe
	_wantGetDep kpartx
	
	_wantGetDep dmsetup
}

_gparted_sequence() {
	_messageNormal 'Launch: gparted'
	
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
	orig_ptuuid=$(sudo -n blkid -s PTUUID -o value /dev/loop0)
	
	sudo -n gparted "$imagedev"
	
	_messagePlain_probe 'blkid'
	sudo -n blkid "$imagedev"
	local modified_ptuuid
	modified_ptuuid=$(sudo -n blkid -s PTUUID -o value /dev/loop0)
	
	
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
