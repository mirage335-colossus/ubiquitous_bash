#Show all images in repository.
_dockerImages() {
	_permitDocker docker images "$@"
}

#Show all containers in repository.
_dockerContainers() {
	_permitDocker docker ps -a "$@"
}

#Show all running containers.
_dockerRunning() {
	_permitDocker docker ps "$@"
}

_dockerLocal_sequence() {
	_start
	_prepare_docker
	_prepare_docker_directives
	
	_messageNormal '$dockerObjectName'
	echo "$dockerObjectName"
	_messageNormal '$dockerBaseObjectName'
	echo "$dockerBaseObjectName"
	_messageNormal '$dockerImageObjectName'
	echo "$dockerImageObjectName"
	_messageNormal '$dockerContainerObjectName'
	echo "$dockerContainerObjectName"
	
	_stop
}

#Show local docker container, image, and base name.
_dockerLocal() {
	"$scriptAbsoluteLocation" _dockerLocal_sequence "$@"
}
