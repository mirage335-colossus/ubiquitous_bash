#Docker Parse
#These docker file parsing functions have no production use, and have been pulled in from DockerApp for manual use or reference only.

_parseDockerfileElement() {
	local dockerfileElement
	dockerfileElement=$(grep "$1" ./dockerfile | cut -d\  -f2- | tr -d '[]"')
	export dockerfile_"$1"="$dockerfileElement"
}

_parseDockerfile() {
	_parseDockerfileElement ENTRYPOINT
	_parseDockerfileElement CMD
}
