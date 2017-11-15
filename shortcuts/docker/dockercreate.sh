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
	cd "$dockerMkimageAbsoluteDirectory"
	
	#Script "mkimage.sh" from "moby" repository is "not part of the core docker distribution". Frequent updates to code requesting operations from such a script may be expected.
	#Commands here were tested with "mkimage.sh" scrip from "moby" git repository, URL "https://github.com/moby/moby.git", commit a4bdb304e29f21661e8ef398dbaeb8188aa0f46a .
	
	[[ $dockerMkimageDistro == "debian" ]] ; sudo -n ./mkimage.sh -t "$dockerBaseObjectName" debootstrap --variant=minbase --components=main --include=inetutils-ping,iproute "$dockerMkimageVersion" 2>> "$logTmp"/mkimageErr > "$logTmp"/mkimageOut
	
	cd "$scriptAbsoluteFolder"
	
	
	
	[[ "$(_permitDocker docker images -q "$dockerBaseObjectName" 2> /dev/null)" == "" ]] && _messageFAIL && _stop 1
	_messagePASS
	
	rm -f "$logTmp"/mkimageErr > /dev/null 2>&1
	rm -f "$logTmp"/mkimageOut > /dev/null 2>&1
	
	_stop
}

_create_docker_scratch_sequence() {
	_start
	_prepare_docker
	
	_messageProcess "Searching ""$dockerBaseObjectName"
	[[ "$dockerBaseObjectExists" == "true" ]] && _messageHAVE && _stop
	_messageNEED
	
	mkdir -p "$safeTmp"/dockerbase
	cd "$safeTmp"/dockerbase
	
	_messageProcess "Building ""$dockerBaseObjectName"
	tar cv --files-from /dev/null | _permitDocker docker import - "$dockerBaseObjectName" 2> /dev/null > "$logTmp"/buildBase.log
	
	cd "$scriptAbsoluteFolder"
	
	[[ "$(_permitDocker docker images -q "$dockerBaseObjectName" 2> /dev/null)" == "" ]] && _messageFAIL && _stop 1
	_messagePASS
	
	rm -f "$logTmp"/buildBase.log > /dev/null 2>&1
	
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
	_messageNormal "#####Base."
	
	[[ "$dockerBaseObjectName" == "" ]] && [[ "$1" != "" ]] && export dockerBaseObjectName="$1"
	
	_messageProcess "Evaluating ""$dockerBaseObjectName"
	
	[[ "$dockerBaseObjectName" == "" ]] && _messageError "BLANK" && return 1
	
	[[ "$dockerBaseObjectName" == "scratch:latest" ]] && _messagePASS && _create_docker_scratch && return 0
	
	#[[ "$dockerBaseObjectName" == "local/debian:squeeze" ]] && _messagePASS && _create_docker_debiansqueeze && return
	[[ "$dockerBaseObjectName" == "local/debian:jessie" ]] && _messagePASS && _create_docker_debianjessie && return
	
	if [[ "$dockerBaseObjectName" == *"ubvrt"* ]]
	then
		[[ "$(_permitDocker docker images -q "$dockerBaseObjectName" 2> /dev/null)" == "" ]] && _messageFAIL && return 1
		_messagePASS
		return 0
	fi
	
	_messageWARN "No local build instructons operating, will rely on upstream provider."
	return 1
}

_create_docker_image_sequence() {
	_start
	_prepare_docker
	_prepare_docker_directives
	
	_create_docker_base
	
	_messageNormal "#####Image."
	_messageProcess "Validating ""$dockerImageObjectName"
	[[ "$dockerImageObjectName" == "" ]] && _messageError "BLANK" && _stop 1
	_messagePASS
	
	_messageProcess "Searching ""$dockerImageObjectName"
	[[ "$dockerImageObjectExists" == "true" ]]  && _messageHAVE && _stop
	_messageNEED
	
	_messageProcess "Loading ""$dockerImageObjectName"
	_docker_load && _messagePASS && _stop
	_messageNEED
	
	_messageProcess "Checking context "
	[[ ! -e "$dockerdirectivefile" ]] && _messageFAIL && _stop 1
	[[ ! -e "$dockerentrypoint" ]] && _messageFAIL && _stop 1
	_messagePASS
	
	mkdir -p "$safeTmp"/dockerimage
	cd "$safeTmp"/dockerimage
	
	_messageProcess "Building ""$dockerImageObjectName"
	
	_pull_docker_guest
	_permitDocker docker build --rm --tag "$dockerImageObjectName" . 2> "$logTmp"/buildImageErr.log > "$logTmp"/buildImageOut.log
	
	cd "$scriptAbsoluteFolder"
	
	[[ "$(_permitDocker docker images -q "$dockerImageObjectName" 2> /dev/null)" == "" ]] && _messageFAIL && _stop 1
	_messagePASS
	
	rm -f "$logTmp"/buildImageErr.log > /dev/null 2>&1
	rm -f "$logTmp"/buildImageOut.log > /dev/null 2>&1
	
	_stop
}

_create_docker_image() {
	[[ "$dockerBaseObjectName" == "" ]] && [[ "$1" != "" ]] && export dockerBaseObjectName="$1"
	[[ "$dockerImageObjectName" == "" ]] && [[ "$2" != "" ]] && export dockerImageObjectName="$2"
	
	"$scriptAbsoluteLocation" _create_docker_image_sequence "$@"
}









