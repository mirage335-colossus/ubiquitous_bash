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
	[[ -e ./debian-9.1.0-amd64-netinst.iso ]] || axel 'https://cdimage.debian.org/debian-cd/9.1.0/amd64/iso-cd/debian-9.1.0-amd64-netinst.iso'
	
	wget 'https://cdimage.debian.org/debian-cd/9.1.0/amd64/iso-cd/SHA512SUMS'
	
	wget 'https://cdimage.debian.org/debian-cd/9.1.0/amd64/iso-cd/SHA512SUMS.sign'
	
	if ! cat SHA512SUMS | grep debian-9.1.0-amd64-netinst.iso | sha512sum -c - > /dev/null 2>&1
	then
		echo 'invalid'
		stop 1
	fi
	
	if ! gpgv --keyring /usr/share/keyrings/debian-role-keys.gpg ./SHA512SUMS.sign ./SHA512SUMS
	then
		echo 'invalid'
		stop 1
	fi
	
	mkdir -p "$storageLocation"
	
	cd "$functionEntryPWD"
	mv "$safeTmp"/debian-9.1.0-amd64-netinst.iso "$storageLocation"
	
	_stop
}

_fetchDebianLiteISO() {
	
	"$scriptAbsoluteLocation" _fetchDebianLiteISOsequence "$@"
	
}

#Installs to a raw disk image using QEMU. Subsequently may be run under a variety of real and virtual platforms.
_create_x64_debianLiteVM_sequence() {
	_start
	
	_fetchDebianLiteISO || _stop 1
	
	_createRawImage || _stop 1
	
	qemu-system-x86_64 -hda "$scriptAbsoluteLocation"/vm.img -cdrom "$scriptAbsoluteFolder"/_lib/os/debian-9.1.0-amd64-netinst.iso -boot d -m 1512
	
	_stop
}

_create_x64_debianLiteVM() {

}

_create_arm_debianLiteVM() {
	
	
	
}



#####
