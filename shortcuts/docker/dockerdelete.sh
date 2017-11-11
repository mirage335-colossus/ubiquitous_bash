# WARNING Deletes specified docker IMAGE.
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
	echo y | _permitDocker docker system prune
}
 
