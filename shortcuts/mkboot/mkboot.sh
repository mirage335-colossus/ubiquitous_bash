#http://nairobi-embedded.org/making_a_qemu_disk_image_bootable_with_grub.html
_mkboot_sequence() {
	_start
	
	_readLocked "$lock_open_image" && _stop 1
	
	local localFunctionEntryPWD
	localFunctionEntryPWD="$PWD"
	
	cd "$scriptAbsoluteFolder"
	
	_messageNormal "#####Enabling boot."
	
	
	_messageProcess "Opening"
	if ! _openChRoot > /dev/null 2>&1
	then
		_messageFAIL
		_stop 1
	fi
	_messagePASS
	
	_messageProcess "Testing grub-install"
	#if ! sudo -n bash -c "type grub-install" > /dev/null 2>&1
	if ! _chroot bash -c "type grub-install" > /dev/null 2>&1
	then
		_messageFAIL
		_stop 1
	fi
	_messagePASS
	
	_messageProcess "Testing grub-mkconfig"
	if ! _chroot bash -c "type grub-mkconfig" > /dev/null 2>&1
	then
		_messageFAIL
		_stop 1
	fi
	_messagePASS
	
	_messageProcess "Installing GRUB"
	
	local imagedev
	imagedev=$(cat "$scriptLocal"/imagedev)
	
	#if ! sudo -n grub-install --root-directory="$chrootDir" --boot-directory="$chrootDir"/boot --modules=part_msdos "$imagedev" >> "$logTmp"/grub.log 2>&1
	if ! _chroot grub-install --boot-directory=/boot --root-directory=/ --modules=part_msdos "$imagedev" >> "$logTmp"/grub.log 2>&1
	then
		_messageFAIL
		_stop 1
	fi
	
	_messagePASS
	
	
	_messageProcess "Configuring GRUB"
	
	_here_mkboot_grubcfg | sudo -n tee "$chrootDir"/boot/grub/grub.cfg > /dev/null 2>&1
	
	#if ! _chroot grub-mkconfig -o /boot/grub/grub.cfg >> "$logTmp"/grub.log 2>&1
	#then
	#	_messageFAIL
	#	_stop 1
	#fi
	
	_messagePASS
		
	_messageProcess "Closing"
	if ! _closeChRoot > /dev/null 2>&1
	then
		_messageFAIL
		_stop 1
	fi
	_messagePASS
	
	#rm "$logTmp"/grub.log
	cd "$localFunctionEntryPWD"
	_stop
}

_mkboot() {
	"$scriptAbsoluteLocation" _mkboot_sequence "$@"
}


_test_mkboot() {
	_mustGetSudo
	
	#sudo -n "$scriptAbsoluteLocation" _checkDep grub-install
}
