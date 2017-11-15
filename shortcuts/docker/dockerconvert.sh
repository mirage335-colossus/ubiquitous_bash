_docker_img_to_dai() {
	false
}

_docker_dai_to_img() {
	false
}

_docker_load() {
	false
}

_docker_save_sequence() {
	_start
	_prepare_docker
	
	_permitDocker docker save "$dockerImageObjectName" > "$scriptLocal"/dockerImageAll.tar
	
	_stop
}

#https://stackoverflow.com/questions/23935141/how-to-copy-docker-images-from-one-host-to-another-without-via-repository
_docker_save() {
	"$scriptAbsoluteLocation" _docker_save_sequence "$@"
}
