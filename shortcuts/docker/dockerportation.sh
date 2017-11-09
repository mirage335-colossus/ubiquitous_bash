#Docker Portation.
#https://english.stackexchange.com/questions/141717/hypernym-for-import-and-export
#These import/export functions have no production use, and have been pulled in from DockerApp for manual use or reference only.

#NOT recommended. NOT well tested. Import filesystem as Docker image.
#"$1" == containerObjectName
_dockerImport() {
	
	_permitDocker docker import "$1".dcf > "$importLog" 2>&1
	
}

#NOT recommended. NOT well tested. Export Docker Container Filesystem. Will be restored as an image, NOT a container, resulting in operations equivalent to commit/import.
#"$1" == containerObjectName
_dockerExport() {
	_permitDocker docker export $(_permitDocker docker ps -a -q --filter name='^/'"$1"'$') > "$1".dcf
} 
