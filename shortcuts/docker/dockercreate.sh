_create_docker_mkimage_sequence() {
	_start
	_prepare_docker
	
	_messageProcess "Searching ""$dockerBaseObjectName"
	[[ "$dockerBaseObjectExists" == "true" ]] && _messageHAVE && _stop
	_messageNEED
	
	_messageProcess "Locating mkimage"
	cd "$dockerMkimageAbsoluteDirectory"
	[[ ! -e "./mkimage.sh" ]] && _messageFAIL && _stop 1
	_messagePASS
	
	_messageProcess "Checking sudo"
	! _wantSudo && _messageFAIL && _stop 1
	_messagePASS
	
	_messageProcess "Building ""$dockerBaseObjectName"
	
	#Script "mkimage.sh" from "moby" repository is "not part of the core docker distribution". Frequent updates to code requesting operations from such a script may be expected.
	#Commands here were tested with "mkimage.sh" scrip from "moby" git repository, URL "https://github.com/moby/moby.git", commit a4bdb304e29f21661e8ef398dbaeb8188aa0f46a .
	
	[[ $dockerMkimageDistro == "debian" ]] ; sudo -n ./mkimage.sh -t "$dockerBaseObjectName" debootstrap --variant=minbase --components=main --include=inetutils-ping,iproute "$dockerMkimageVersion" 2>> "$logTmp"/mkimageErr > "$logTmp"/mkimageOut
	
	cd "$scriptAbsoluteFolder"
	
	
	
	[[ "$(_permitDocker docker images -q "$dockerBaseObjectName" 2> /dev/null)" == "" ]] && _messageFAIL && _preserveLog && _stop 1
	_messagePASS
	
	_stop
}

_create_docker_scratch_sequence() {
	_start
	_prepare_docker
	
	_messageProcess "Searching ""$dockerBaseObjectName"
	[[ "$dockerBaseObjectExists" == "true" ]] && _messageHAVE && _stop
	_messageNEED
	
	cd "$dockerInstanceDir"
	
	_messageProcess "Building ""$dockerBaseObjectName"
	tar cv --files-from /dev/null | _permitDocker docker import - "$dockerBaseObjectName" 2> /dev/null > "$logTmp"/buildBase
	
	cd "$scriptAbsoluteFolder"
	
	[[ "$(_permitDocker docker images -q "$dockerBaseObjectName" 2> /dev/null)" == "" ]] && _messageFAIL && _stop 1
	_messagePASS
	
	_stop
}

_create_docker_scratch() {
	"$scriptAbsoluteLocation" _create_docker_scratch_sequence "$@"
}

_create_docker_debiansqueeze() {
	"$scriptAbsoluteLocation" _create_docker_mkimage_sequence "$@"
}

_create_docker_debianjessie() {
	"$scriptAbsoluteLocation" _create_docker_mkimage_sequence "$@"
}


_create_docker_base() {
	[[ "$dockerBaseObjectName" == "" ]] && [[ "$1" != "" ]] && export dockerBaseObjectName="$1"
	
	_messageProcess "Evaluating ""$dockerBaseObjectName"
	
	[[ "$dockerBaseObjectName" == "" ]] && _messageError "BLANK" && return 1
	
	[[ "$dockerBaseObjectName" == "scratch:latest" ]] && _messagePASS && _create_docker_scratch && return
	
	#[[ "$dockerBaseObjectName" == "local/debian:squeeze" ]] && _messagePASS && _create_docker_debiansqueeze && return
	[[ "$dockerBaseObjectName" == "local/debian:jessie" ]] && _messagePASS && _create_docker_debianjessie && return
	
	
	_messageWARN "No local build instructons operating, will rely on upstream provider."
	return 1
	
}
