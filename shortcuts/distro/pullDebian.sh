#"$1" == storageLocation (optional)
_fetchDebianLiteISOsequence() {
	_start
	
	export functionEntryPWD="$PWD"
	
	if ! ls /usr/share/keyrings/debian-role-keys.gpg > /dev/null 2>&1
	then
		echo 'Debian Keyring missing.'
		echo 'apt-get install debian-keyring'
	fi
	
	cd "$safeTmp"
	
	
	axel 'https://cdimage.debian.org/debian-cd/9.1.0/amd64/iso-cd/debian-9.1.0-amd64-netinst.iso'
	
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
	
	storageLocation="$scriptAbsoluteFolder"/_lib/os/
	[[ "$1" != "" ]] && storageLocation="$1"
	
	mkdir -p "$storageLocation"
	
	cd "$functionEntryPWD"
	mv "$safeTmp"/debian-9.1.0-amd64-netinst.iso "$storageLocation"
	
	_stop
}

_fetchDebianLiteISO() {
	
	"$scriptAbsoluteLocation" _fetchDebianLiteISOsequence
	
}
