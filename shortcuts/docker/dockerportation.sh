#Docker Portation.
#https://english.stackexchange.com/questions/141717/hypernym-for-import-and-export
#https://stackoverflow.com/questions/23935141/how-to-copy-docker-images-from-one-host-to-another-without-via-repository
#http://mr.gy/blog/build-vm-image-with-docker.html
#These import/export functions had no production use in DockerApp. However, they produce bootable images, so are used for translation in ubiquitous_bash. Prefer _docker_save and _docker_load 

#Import filesystem as Docker image.
#"$1" == containerObjectName
#Import filesystem as Docker image.
#"$1" == containerObjectName
_dockerImport() {
	if [[ -e "$scriptLocal"/"dockerImageFS".tar ]]
	then
		_permitDocker docker import "$scriptLocal"/"dockerImageFS".tar "$dockerImageObjectName" --change 'ENTRYPOINT ["/usr/local/bin/ubiquitous_bash.sh", "_drop_docker"]' > /dev/null 2>&1
	fi
	
	# WARNING Untested. Not recommended.
	[[ -e "$scriptLocal"/"dockerContainerFS".tar ]] && _permitDocker docker import "$scriptLocal"/"dockerContainerFS".tar "$dockerImageObjectName" > /dev/null 2>&1
}

_dockerExportContainer_named() {
	local dockerNamedID
	dockerNamedID=$(_permitDocker docker ps -a -q --filter name='^/'"$1"'$')
	
	 _permitDocker docker export "$dockerNamedID" > "$2"
}

_dockerExportContainer_sequence() {
	_start
	_prepare_docker
	
	_messageProcess "Exporting ""$dockerContainerObjectName"
	
	rm -f "$scriptLocal"/"dockerContainerFS".tar > /dev/null 2>&1
	[[ -e "$scriptLocal"/"dockerContainerFS".tar ]] && _messageFAIL && _stop 1
	
	_dockerExportContainer_named "$dockerContainerObjectName" "$scriptLocal"/"dockerContainerFS".tar
	
	! [[ -s "$scriptLocal"/"dockerContainerFS".tar ]] && _messageFAIL && _stop 1
	 _messagePASS
	 _stop 0
}

_dockerExportImage_sequence() {
	_start
	_prepare_docker
	
	if ! _create_docker_container_sequence_partial "$dockerContainerObjectNameInstanced"
	then
		_stop 1
	fi
	
	_messageProcess "Exporting ""$dockerContainerObjectNameInstanced"
	
	rm -f "$scriptLocal"/"dockerImageFS".tar > /dev/null 2>&1
	[[ -e "$scriptLocal"/"dockerImageFS".tar ]] && _messageFAIL && _stop 1
	
	_dockerExportContainer_named "$dockerContainerObjectNameInstanced" "$scriptLocal"/"dockerImageFS".tar
	
	! [[ -s "$scriptLocal"/"dockerImageFS".tar ]] && _messageFAIL && _stop 1
	 _messagePASS
	 _stop 0
}

# WARNING Recommend preforming commit operations first, then either _dockerExport or preferably _docker_save .
#Export Docker Container Filesystem. Will be restored as an image, NOT a container, resulting in operations equivalent to commit/import.
_dockerExportContainer() {
	_messageProcess "Searching conflicts"
	#[[ -e "$scriptLocal"/"dockerContainerFS".tar ]] && _messageFAIL && return 1
	[[ -e "$scriptLocal"/"dockerImageFS".tar ]] && _messageFAIL && return 1
	[[ -e "$scriptLocal"/"dockerImageAll".tar ]] && _messageFAIL && return 1
	_messagePASS
	
	_create_docker_container || return 1
	
	"$scriptAbsoluteLocation" _dockerExportContainer_sequence "$@"
}

# WARNING Recommend _docker_save instead for images built within docker, not needed by other virtualization platforms, and not subject to path locking.
#Export Docker Image Filesystem (by exporting instanced container).
#"$1" == containerObjectName
_dockerExport() {
	[[ "$recursionGuard" == "true" ]] && return 0
	export recursionGuard="true"
	
	_messageProcess "Searching conflicts"
	[[ -e "$scriptLocal"/"dockerContainerFS".tar ]] && _messageFAIL && return 1
	#[[ -e "$scriptLocal"/"dockerImageFS".tar ]] && _messageFAIL && return 1
	[[ -e "$scriptLocal"/"dockerImageAll".tar ]] && _messageFAIL && return 1
	_messagePASS
	
	if ! _create_docker_image "$@"
	then
		return 1
	fi
	
	"$scriptAbsoluteLocation" _dockerExportImage_sequence "$@"
}


