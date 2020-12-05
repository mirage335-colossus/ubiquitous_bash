
_test_export() {
	_getDep pigz
}

# Creates an image which may be written over a previously copied root filesystem. Convenient means to update an 'operating system' and installed applications.
# gunzip --decompress --stdout "$scriptLocal"/vm-rootpart.img.gz | dd of=/dev/deviceFileHereNumberPart9 bs=8M
_export() {
	_mustGetSudo || return 1
	
	
	
	_messagePlain_nominal 'Attempt: _openChRoot'
	! _openChRoot && _messageFAIL && _stop 1
	
	_messagePlain_nominal 'Compression: zero blanking'
	
	sudo -n dd if=/dev/zero of="$globalVirtFS"/zero.del bs=8M
	sudo -n rm -f "$globalVirtFS"/zero.del
	
	_messagePlain_nominal 'Attempt: _closeChRoot'
	! _closeChRoot && _messageFAIL && _stop 1
	
	
	
	
	_messagePlain_nominal 'Attempt: _openLoop'
	! _openLoop && _messageFAIL && _stop 1
	
	
	local current_imagedev
	current_imagedev=$(cat "$scriptLocal"/imagedev)
	
	local current_imagepart
	current_imagepart=$(_determine_rawFileRootPartition "$current_imagedev")
	
	
	
	
	_messagePlain_nominal 'Safety: fs'
	local loopdevfs
	loopdevfs=$(sudo -n blkid -s TYPE -o value "$current_imagepart" | tr -dc 'a-zA-Z0-9')
	! _mountImageFS_procedure_blkid_fstype "$loopdevfs" && _messageFAIL && _stop 1
	
	
	_messagePlain_nominal 'Attempt: export: '"$current_imagepart"
	
	rm -f vm-rootpart.img.gz > /dev/null 2>&1
	#dd if="$current_imagepart" bs=1M | gzip --fast > "$scriptLocal"/vm-rootpart.img.gz
	dd if="$current_imagepart" bs=1M | pigz --fast > "$scriptLocal"/vm-rootpart.img.gz
	
	
	_messagePlain_nominal 'Attempt: _closeLoop'
	! _closeLoop && _messageFAIL && _stop 1
	
	return 0
}
