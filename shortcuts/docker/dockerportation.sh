#Docker Portation.
#https://english.stackexchange.com/questions/141717/hypernym-for-import-and-export
#https://stackoverflow.com/questions/23935141/how-to-copy-docker-images-from-one-host-to-another-without-via-repository
#http://mr.gy/blog/build-vm-image-with-docker.html
#These import/export functions had no production use in DockerApp. However, they produce bootable images, so are used for translation in ubiquitous_bash. Prefer _docker_save and _docker_load 

#Import filesystem as Docker image.
#"$1" == containerObjectName
_dockerImport() {
	
	_permitDocker docker import "$1" > "$safeTmp"/dockerimport.log 2>&1
	rm -f "$safeTmp"/dockerimport.log > /dev/null 2>&1
	
}

_dockerExportContainer_named() {
	 _permitDocker docker export $(_permitDocker docker ps -a -q --filter name='^/'"$1"'$') > "$2"
}

_dockerExportContainer_sequence() {
	_start
	_prepare_docker
	
	_dockerExportContainer_named "$dockerContainerObjectName" "$dockerContainerFS".tar
	
	_stop
}

_dockerExportImage_sequence() {
	_start
	_prepare_docker
	
	_dockerExportContainer_named "$dockerContainerObjectNameInstanced" "$dockerImageFS".tar
	
	_stop
}

#Export Docker Container Filesystem. Will be restored as an image, NOT a container, resulting in operations equivalent to commit/import.
_dockerExportContainer() {
	"$scriptAbsoluteLocation" _dockerExportContainer_sequence "$@"
}

# WARNING Recommend _docker_save instead for images built within docker.
#Export Docker Image Filesystem (by exporting instanced container).
#"$1" == containerObjectName
_dockerExport() {
	"$scriptAbsoluteLocation" _dockerExportImage_sequence "$@"
}


