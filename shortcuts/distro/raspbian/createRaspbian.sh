_fetch_raspbian_sequence() {
	_start
	
	export functionEntryPWD="$PWD"
	
	export storageLocation="$scriptAbsoluteFolder"/_lib/os/
	[[ "$1" != "" ]] && export storageLocation=$(_getAbsoluteLocation "$1")
	
	cd "$safeTmp"
	
	[[ -e "$storageLocation"/2018-10-09-raspbian-stretch.zip ]] && cp "$storageLocation"/2018-10-09-raspbian-stretch.zip ./2018-10-09-raspbian-stretch.zip > /dev/null 2>&1
	[[ -e ./2018-10-09-raspbian-stretch.zip ]] || _fetch 'https://downloads.raspberrypi.org/raspbian/images/raspbian-2018-10-11/2018-10-09-raspbian-stretch.zip'
	
	wget 'https://downloads.raspberrypi.org/raspbian/images/raspbian-2018-10-11/2018-10-09-raspbian-stretch.zip.sha256'
	
	if ! cat '2018-10-09-raspbian-stretch.zip.sha256' | grep '2018-10-09-raspbian-stretch.zip' | sha256sum -c - > /dev/null 2>&1
	then
		echo 'invalid'
		_stop 1
	fi
	
	#Raspbian signature is difficult to authenticate. Including hash here allows some trust to be established from a Git/SSH server, as well HTTPS generally.
	if [[ "$(cat 2018-10-09-raspbian-stretch.zip.sha256 | cut -f1 -d\  )" != "6e3aa76e21473ef316c0bfc9efa5c27a27fe46bd698f71de3e06e66b64a55500" ]]
	then
		echo 'invalid'
		_stop 1
	fi
	
	mkdir -p "$storageLocation"
	
	cd "$functionEntryPWD"
	mv "$safeTmp"/2018-10-09-raspbian-stretch.zip "$storageLocation"
	
	
	
	_stop
}

_fetch_raspbian() {
	
	"$scriptAbsoluteLocation" _fetch_raspbian_sequence "$@"
	
}

_create_raspbian_sequence() {
	_start
	
	export functionEntryPWD="$PWD"
	
	_fetch_raspbian || _stop 1
	
	export storageLocation="$scriptAbsoluteFolder"/_lib/os/
	
	cd "$storageLocation"
	
	unzip "$scriptAbsoluteFolder"/_lib/os/2018-10-09-raspbian-stretch.zip
	
	export raspbianImageFile="$scriptLocal"/vm-raspbian.img
	
	[[ ! -e "$raspbianImageFile" ]] && mv "$scriptAbsoluteFolder"/_lib/os/2018-10-09-raspbian-stretch.img "$raspbianImageFile"
	
	cd "$functionEntryPWD"
	
	_stop
}

_create_raspbian() {
	
	"$scriptAbsoluteLocation" _create_raspbian_sequence "$@"
	
}
