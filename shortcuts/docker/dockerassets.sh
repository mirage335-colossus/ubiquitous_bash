_dockerImages() {
	_permitDocker docker images "$@"
}

_dockerContainers() {
	_permitDocker docker ps -a "$@"
}

_dockerRunning() {
	_permitDocker docker ps "$@"
}
