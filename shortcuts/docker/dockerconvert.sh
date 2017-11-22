_docker_img_to_tar() {
	_messageProcess "Searching conflicts"
	[[ -e "$scriptLocal"/"dockerContainerFS".tar ]] && _messageFAIL && _stop 1
	[[ -e "$scriptLocal"/"dockerImageFS".tar ]] && _messageFAIL && return 1
	[[ -e "$scriptLocal"/"dockerImageAll".tar ]] && _messageFAIL && _stop 1
	_messagePASS
	
	false
}

_docker_tar_to_img() {
	false
}

# WARNING In automated use, the load command may not result in an image name matching the path locked docker id.
_docker_load() {
	[[ -e "$scriptLocal"/"dockerImageAll".tar ]] && _permitDocker docker load < "$scriptLocal"/"dockerImageAll".tar
}

_dockerLoad() {
	_docker_load "$@"
}

_docker_save_sequence() {
	_start
	_prepare_docker
	
	_permitDocker docker save "$dockerImageObjectName" > "$scriptLocal"/"dockerImageAll".tar
	
	_stop
}

#https://stackoverflow.com/questions/23935141/how-to-copy-docker-images-from-one-host-to-another-without-via-repository
_docker_save() {
	_messageProcess "Searching conflicts"
	[[ -e "$scriptLocal"/"dockerContainerFS".tar ]] && _messageFAIL && _stop 1
	[[ -e "$scriptLocal"/"dockerImageFS".tar ]] && _messageFAIL && return 1
	#[[ -e "$scriptLocal"/"dockerImageAll".tar ]] && _messageFAIL && _stop 1
	_messagePASS
	
	_messageProcess "Saving ""$dockerImageObjectName"
	
	"$scriptAbsoluteLocation" _docker_save_sequence "$@"
	
	 ! [[ -s "$scriptLocal"/"dockerImageAll".tar ]] && _messageFAIL && return 1
	 _messagePASS
	 return 0
}

_dockerSave() {
	_docker_save "$@"
}
