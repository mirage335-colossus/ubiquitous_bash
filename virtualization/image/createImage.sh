_createRawImage_sequence() {
	_start
	
	export vmImageFile="$scriptLocal"/vm.img
	
	[[ "$1" != "" ]] && export vmImageFile="$1"
	
	[[ "$vmImageFile" == "" ]] && _stop 1
	[[ -e "$vmImageFile" ]] && _stop 1
	
	dd if=/dev/zero of="$vmImageFile" bs=1G count=6
	
	_stop
}

_createRawImage() {
	
	"$scriptAbsoluteLocation" _createRawImage_sequence "$@"
	
}
