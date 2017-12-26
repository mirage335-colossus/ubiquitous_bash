_test_docker_mkimage() {
	_getDep "debootstrap"
}

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
	#Commands here were tested with "mkimage.sh" script from "moby" git repository, URL "https://github.com/moby/moby.git", commit a4bdb304e29f21661e8ef398dbaeb8188aa0f46a .
	
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
	
	[[ "$dockerBaseObjectName" == "" ]] && _messageError "BLANK" && return 0
	
	[[ "$dockerBaseObjectName" == "scratch:latest" ]] && _messagePASS && _create_docker_scratch && return 0
	
	#[[ "$dockerBaseObjectName" == "ubvrt/debian:squeeze" ]] && _messagePASS && _create_docker_debiansqueeze && return
	[[ "$dockerBaseObjectName" == "ubvrt/debian:jessie" ]] && _messagePASS && _create_docker_debianjessie && return 0
	
	if [[ "$dockerBaseObjectName" == *"ubvrt"* ]]
	then
		[[ "$(_permitDocker docker images -q "$dockerBaseObjectName" 2> /dev/null)" == "" ]] && _messageFAIL && return 1
		_messagePASS
		return 0
	fi
	
	_messageWARN "No local build instructons operating, will rely on upstream provider."
	return 0
}

_create_docker_image_needed_sequence() {
	_start
	_prepare_docker
	
	_messageNormal "#####PreImage."
	_messageProcess "Validating ""$dockerImageObjectName"
	[[ "$dockerImageObjectName" == "" ]] && _messageError "BLANK" && _stop 1
	_messagePASS
	
	_messageProcess "Searching ""$dockerImageObjectName"
	[[ "$(_permitDocker docker images -q "$dockerImageObjectName" 2> /dev/null)" != "" ]] && export dockerImageObjectExists="true"
	[[ "$dockerImageObjectExists" == "true" ]]  && _messageHAVE && _stop 2
	_messageNEED
	
	_messageProcess "Loading ""$dockerImageObjectName"
	"$scriptAbsoluteLocation" _dockerLoad
	_messagePASS
	
	_messageProcess "Searching ""$dockerImageObjectName"
	[[ "$(_permitDocker docker images -q "$dockerImageObjectName" 2> /dev/null)" != "" ]] && export dockerImageObjectExists="true"
	[[ "$dockerImageObjectExists" == "true" ]]  && _messageHAVE && _stop 2
	_messageNEED
	
	_messageProcess "Importing ""$dockerImageObjectName"
	"$scriptAbsoluteLocation" _dockerImport
	_messagePASS
	
	_messageProcess "Searching ""$dockerImageObjectName"
	[[ "$(_permitDocker docker images -q "$dockerImageObjectName" 2> /dev/null)" != "" ]] && export dockerImageObjectExists="true"
	[[ "$dockerImageObjectExists" == "true" ]]  && _messageHAVE && _stop 2
	_messageNEED
	
	_stop
}

_create_docker_image_sequence() {
	_start
	_prepare_docker
	
	_create_docker_base || _stop 1
	
	_messageNormal "#####Image."
	mkdir -p "$safeTmp"/dockerimage
	cd "$safeTmp"/dockerimage
	
	_prepare_docker_directives
	_pull_docker_guest
	
	_messageProcess "Checking context "
	[[ ! -e "$dockerdirectivefile" ]] && _messageFAIL && _stop 1
	[[ ! -e "$dockerentrypoint" ]] && _messageFAIL && _stop 1
	_messagePASS
	
	_messageProcess "Building ""$dockerImageObjectName"
	
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
	
	local dockerImageNeeded
	"$scriptAbsoluteLocation" _create_docker_image_needed_sequence
	dockerImageNeeded="$?"
	[[ "$dockerImageNeeded" == "2" ]] && return 0
	[[ "$dockerImageNeeded" == "1" ]] && return 1
	
	if ! "$scriptAbsoluteLocation" _create_docker_image_sequence
	then
		return 1
	fi
	
	if ! "$scriptAbsoluteLocation" _dockerExport
	then
		return 1
	fi
	
	return 0
}

_create_docker_container_sequence_partial() {
	local dockerContainerToCreate
	dockerContainerToCreate="$dockerContainerObjectName"
	[[ "$1" != "" ]] && dockerContainerToCreate="$1"
	
	_messageNormal "#####Container."
	_messageProcess "Validating ""$dockerContainerToCreate"
	[[ "$dockerContainerToCreate" == "" ]] && _messageError "BLANK" && return 1
	_messagePASS
	
	_messageProcess "Searching ""$dockerContainerToCreate"
	
	local dockerContainerToCreateExists
	dockerContainerToCreateExists="false"
	local dockerContainerToCreateID
	dockerContainerToCreateID=$(_permitDocker docker ps -a -q --filter name='^/'"$dockerContainerToCreate"'$')
	[[ "$dockerContainerToCreateID" != "" ]] && dockerContainerToCreateExists="$true"
	
	[[ "$dockerContainerToCreateExists" == "true" ]]  && _messageHAVE && return
	_messageNEED
	
	_messageProcess "Building ""$dockerContainerToCreate"
	
	mkdir -p "$safeTmp"
	cd "$safeTmp"
	
	#_prepare_docker_directives
	
	_permitDocker docker create -t -i --name "$dockerContainerToCreate" "$dockerImageObjectName" 2> "$logTmp"/buildContainer.log > "$logTmp"/buildContainer.log
	
	cd "$scriptAbsoluteFolder"
	
	local dockerIDcheck
	dockerIDcheck=$(_permitDocker docker ps -a -q --filter name='^/'"$dockerContainerToCreate"'$')
	[[ "$dockerIDcheck" == "" ]]  && _messageFAIL && return 1
	
	_messagePASS
	rm -f "$logTmp"/buildContainer.log > /dev/null 2>&1
}

_create_docker_container_sequence() {
	_start
	_prepare_docker
	
	if ! _create_docker_container_sequence_partial "$@"
	then
		_stop 1
	fi
	
	_stop
}

_create_docker_container() {
	if ! "$scriptAbsoluteLocation" _create_docker_image "$@"
	then
		return 1
	fi
	
	if "$scriptAbsoluteLocation" _create_docker_container_sequence "$@"
	then
		return 0
	fi
	return 1
}

#Will not attempt to create image/base from scratch.
_create_docker_container_quick() {
	local dockerImageNeeded
	"$scriptAbsoluteLocation" _create_docker_image_needed_sequence
	dockerImageNeeded="$?"
	[[ "$dockerImageNeeded" == "0" ]] && return 1
	[[ "$dockerImageNeeded" == "1" ]] && return 1
	
	
	if "$scriptAbsoluteLocation" _create_docker_container_sequence "$@"
	then
		return 0
	fi
	return 1
}

# WARNING Serves as an example. Most use cases for instanced containers REQUIRE the container creation command to share session with other operations. See _dockerExport .
_create_docker_container_sequence_instanced() {
	_start
	_prepare_docker
	
	if ! _create_docker_container_sequence_partial "$dockerContainerObjectNameInstanced"
	then
		_stop 1
	fi
	
	_stop
}

# WARNING Serves as an example. Most use cases for instanced containers REQUIRE the image creation command to run in a fresh instance. See _dockerExport .
_create_docker_container_instanced() {
	if ! _create_docker_image "$@"
	then
		return 1
	fi
	
	#Alternative, quicker, check for image, will not create image/base from scratch.
	local dockerImageNeeded
	"$scriptAbsoluteLocation" _create_docker_image_needed_sequence
	dockerImageNeeded="$?"
	[[ "$dockerImageNeeded" == "0" ]] && return 1
	[[ "$dockerImageNeeded" == "1" ]] && return 1
	
	_create_docker_container_sequence_instanced || return 1
	
	return 0
}
