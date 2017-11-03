_dockerImages() {
	_permitDocker docker images "$@"
}

_dockerContainers() {
	_permitDocker docker ps -a "$@"
}

_dockerRunning() {
	_permitDocker docker ps "$@"
}

_dockerDeleteImage() {
	_permitDocker docker rmi "$1"
}

# WARNING Deletes all docker containers.
_dockerDeleteContainersAll() {
	_permitDocker docker rm $(_dockerContainers -q)
}

# DANGER Deletes all docker images!
_dockerDeleteImagesAll() {
	_permitDocker docker rmi --force $(_dockerImages -q)
}

# DANGER Deletes all docker assets not clearly in use!
_dockerPrune() {
	_permitDocker docker system prune
}
