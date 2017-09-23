#"$1" == storageLocation (optional)
_fetch_x64_debianLiteISO_sequence() {
	_start
	
	export functionEntryPWD="$PWD"
	
	export storageLocation="$scriptAbsoluteFolder"/_lib/os/
	[[ "$1" != "" ]] && export storageLocation=$(_getAbsoluteLocation "$1")
	
	if ! ls /usr/share/keyrings/debian-role-keys.gpg > /dev/null 2>&1
	then
		echo 'Debian Keyring missing.'
		echo 'apt-get install debian-keyring'
	fi
	
	cd "$safeTmp"
	
	[[ -e "$storageLocation"/debian-9.1.0-amd64-netinst.iso ]] && cp "$storageLocation"/debian-9.1.0-amd64-netinst.iso ./debian-9.1.0-amd64-netinst.iso > /dev/null 2>&1
	[[ -e ./debian-9.1.0-amd64-netinst.iso ]] || _fetch 'https://cdimage.debian.org/debian-cd/9.1.0/amd64/iso-cd/debian-9.1.0-amd64-netinst.iso'
	
	wget 'https://cdimage.debian.org/debian-cd/9.1.0/amd64/iso-cd/SHA512SUMS'
	
	wget 'https://cdimage.debian.org/debian-cd/9.1.0/amd64/iso-cd/SHA512SUMS.sign'
	
	if ! cat SHA512SUMS | grep debian-9.1.0-amd64-netinst.iso | sha512sum -c - > /dev/null 2>&1
	then
		echo 'invalid'
		_stop 1
	fi
	
	if ! gpgv --keyring /usr/share/keyrings/debian-role-keys.gpg ./SHA512SUMS.sign ./SHA512SUMS
	then
		echo 'invalid'
		_stop 1
	fi
	
	mkdir -p "$storageLocation"
	
	cd "$functionEntryPWD"
	mv "$safeTmp"/debian-9.1.0-amd64-netinst.iso "$storageLocation"
	
	_stop
}

_fetch_x64_DebianLiteISO() {
	
	"$scriptAbsoluteLocation" _fetch_x64_debianLiteISO_sequence "$@"
	
}

#Installs to a raw disk image using QEMU. Subsequently may be run under a variety of real and virtual platforms.
_create_x64_debianLiteVM_sequence() {
	_start
	
	_fetch_x64_DebianLiteISO || _stop 1
	
	_createRawImage
	
	_checkDep qemu-system-x86_64
	
	qemu-system-x86_64 -hda "$scriptAbsoluteFolder"/vm.img -cdrom "$scriptAbsoluteFolder"/_lib/os/debian-9.1.0-amd64-netinst.iso -boot d -m 1512
	
	_stop
}

_create_x64_debianLiteVM() {
	
	"$scriptAbsoluteLocation" _create_x64_debianLiteVM_sequence "$@"
	
}

_create_arm_debianLiteVM() {
	true
}



#####
