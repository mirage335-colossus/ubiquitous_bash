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
