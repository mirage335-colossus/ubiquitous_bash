# WARNING Deletes specified docker IMAGE.
_dockerDeleteImage() {
	_permitDocker docker rmi "$@"
}

_dockerDeleteContainer() {
	_permitDocker docker rm "$@"
}

# WARNING Deletes all docker containers.
_dockerDeleteContainersAll() {
	_dockerDeleteContainer $(_dockerContainers -q)
}

# DANGER Deletes all docker images!
_dockerDeleteImagesAll() {
	_dockerDeleteImage --force $(_dockerImages -q)
}

# DANGER Deletes all docker assets not clearly in use!
_dockerPrune() {
	echo y | _permitDocker docker system prune
}

_dockerDeleteAll() {
	_dockerDeleteContainersAll
	_dockerDeleteImagesAll
	_dockerPrune
}

_docker_deleteContainerInstance_sequence() {
	_start
	_prepare_docker
	
	[[ "$dockerContainerObjectNameInstanced" != "" ]] && _dockerDeleteContainer "$dockerContainerObjectNameInstanced"
	
	_stop
}

_docker_deleteContainerInstance() {
	"$scriptAbsoluteLocation" _docker_deleteContainerInstance_sequence "$@"
}

_docker_deleteLocal_sequence() {
	_start
	_prepare_docker
	
	[[ "$dockerContainerObjectName" != "" ]] && _dockerDeleteContainer "$dockerContainerObjectName"
	[[ "$dockerImageObjectName" != "" ]] && _dockerDeleteImage "$dockerImageObjectName"
	
	_stop
}

_docker_deleteLocal() {
	"$scriptAbsoluteLocation" _docker_deleteLocal_sequence "$@"
}

_docker_deleteLocalBase_sequence() {
	_start
	_prepare_docker
	
	[[ "$dockerBaseObjectName" != "" ]] && _dockerDeleteImage "$dockerBaseObjectName"
	
	_stop
}

_docker_deleteLocalAll() {
	"$scriptAbsoluteLocation" _docker_deleteLocal_sequence "$@"
	"$scriptAbsoluteLocation" _docker_deleteLocalBase_sequence "$@"
}

