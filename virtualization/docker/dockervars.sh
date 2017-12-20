##### DockerVars
#Only include variables and functions here that might need to be used globally.

_unset_docker() {
	export docker_image=""
	
	export dockerInstanceDir=""
	
	export dockerubidfile=""
	
	export dockerImageFilename=""
	
	export DOCKERUBID=""
	
	export dockerObjectName=""
	export dockerBaseObjectName=""
	export dockerImageObjectName=""
	export dockerImageObjectNameSane=""
	export dockerContainerObjectName=""
	export dockerContainerObjectNameInstanced=""
	
	export dockerBaseObjectExists=""
	export dockerImageObjectExists=""
	export dockerContainerObjectExists=""
	export dockerContainerObjectNameInstancedExists=""
	
	export dockerContainerID=""
	export dockerContainerInstancedID=""
	
	export dockerMkimageDistro=""
	export dockerMkimageVersion=""
	
	export dockerMkimageAbsoluteLocaton=""
	export dockerMkimageAbsoluteDirectory=""
	
	export dockerdirectivefile=""
	export dockerentrypoint=""
	
	
}

_reset_dockerID() {
	[[ "$dockerubidfile" == "" ]] && return 1
	
	rm -f "$dockerubidfile" > /dev/null 2>&1
	 
	[[ -e "$dockerubidfile" ]] && return 1
	
	return 0
}

_prepare_docker_directives() {
	# https://denibertovic.com/posts/handling-permissions-with-docker-volumes/
	_here_dockerfile > "$dockerdirectivefile"
	
	cp "$scriptAbsoluteLocation" "$dockerentrypoint" > /dev/null 2>&1
	chmod 0755 "$dockerentrypoint" > /dev/null 2>&1
}

_pull_docker_guest() {
	cp "$dockerdirectivefile" ./ > /dev/null 2>&1
	cp "$dockerentrypoint" ./ > /dev/null 2>&1
	
	cp "$scriptBin"/gosu* ./ > /dev/null 2>&1
	cp "$scriptBin"/hello ./ > /dev/null 2>&1
	
	mkdir -p ./ubbin
	cp -a "$scriptBin"/. ./ubbin/
}

#Separated for diagnostic purposes.
_prepare_docker_default() {
	export dockerObjectName
	export dockerBaseObjectName
	export dockerImageObjectName
	export dockerContainerObjectName
	
	[[ "$dockerBaseObjectName" == "" ]] && [[ "$1" != "" ]] && dockerBaseObjectName="$1"
	[[ "$dockerImageObjectName" == "" ]] && [[ "$2" != "" ]] && dockerImageObjectName="$2"
	
	#Default
	if [[ "$dockerObjectName" == "" ]] && [[ "$dockerBaseObjectName" == "" ]] && [[ "$dockerImageObjectName" == "" ]] && [[ "$dockerContainerObjectName" == "" ]]
	then
		#dockerObjectName="unimportant-local/app:app-local/debian:jessie"
		#dockerObjectName="unimportant-hello-scratch"
		#dockerObjectName="ubvrt-ubvrt-scratch"
		#dockerObjectName="ubvrt-ubvrt-ubvrt/debian:jessie"
		dockerObjectName="ubvrt-ubvrt-unknown/unknown:unknown"
	fi
	
	#Allow specification of just the base name.
	[[ "$dockerObjectName" == "" ]] && [[ "$dockerBaseObjectName" != "" ]] && [[ "$dockerImageObjectName" == "" ]] && [[ "$dockerContainerObjectName" == "" ]] && dockerObjectName="ubvrt-ubvrt-""$dockerBaseObjectName"
	
	export dockerObjectName
	export dockerBaseObjectName
	export dockerImageObjectName
	export dockerContainerObjectName
}

_prepare_docker() {
	
	export dockerInstanceDir="$scriptLocal"
	[[ "$1" != "" ]] && export dockerInstanceDir="$1"
	
	export docker_image="$scriptLocal/_dockimg"
	
	export dockerubidfile
	dockerubidfile="$scriptLocal"/docker.id
	
	_pathLocked _reset_dockerID || return 1
	
	[[ ! -e "$dockerubidfile" ]] && sleep 0.1 && [[ ! -e "$dockerubidfile" ]] && echo -e -n "$lowsessionid" > "$dockerubidfile" 2> /dev/null
	[[ -e "$dockerubidfile" ]] && export DOCKERUBID=$(cat "$dockerubidfile" 2> /dev/null)
	
	export dockerImageFilename="$scriptLocal"/docker.dai
	
	##Sub-object Names
	#Overload by setting either "$dockerObjectName", or any of "$dockerBaseObjectName", "$dockerImageObjectName", and "$dockerContainerObjectName" .
	
	#container-image-base
	#Unique names NOT requires.
	#Path locked ID from ubiquitous_bash will be prepended to image name.
	_prepare_docker_default
	
	[[ "$dockerBaseObjectName" == "" ]] && export dockerBaseObjectName=$(echo "$dockerObjectName" | cut -s -d\- -f3)
	[[ "$dockerImageObjectName" == "" ]] && export dockerImageObjectName=$(echo "$dockerObjectName" | cut -s -d\- -f2)
	[[ "$dockerContainerObjectName" == "" ]] && export dockerContainerObjectName=$(echo "$dockerObjectName" | cut -d\- -f1)
	
	if ! echo "$dockerBaseObjectName" | grep ':' >/dev/null 2>&1
	then
		export dockerBaseObjectName="$dockerBaseObjectName"":latest"
	fi
	
	export dockerImageObjectName="$DOCKERUBID"_"$dockerImageObjectName"
	
	if ! echo "$dockerImageObjectName" | grep ':' >/dev/null 2>&1
	then
		export dockerImageObjectName="$dockerImageObjectName"":latest"
	fi
	
	export dockerImageObjectNameSane=$(echo "$dockerImageObjectName" | tr ':/' '__' | tr -dc 'a-zA-Z0-9_')
	
	export dockerContainerObjectName="$dockerContainerObjectName""_""$dockerImageObjectNameSane"
	
	export dockerContainerObjectNameInstanced="$lowsessionid"_"$dockerContainerObjectName"
	
	##Specialized, redundant in some cases.
	export dockerBaseObjectExists="false"
	[[ "$(_permitDocker docker images -q "$dockerBaseObjectName" 2> /dev/null)" != "" ]] && export dockerBaseObjectExists="true"
	
	export dockerImageObjectExists="false"
	[[ "$(_permitDocker docker images -q "$dockerImageObjectName" 2> /dev/null)" != "" ]] && export dockerImageObjectExists="true"
	
	export dockerContainerObjectExists="false"
	export dockerContainerID=$(_permitDocker docker ps -a -q --filter name='^/'"$dockerContainerObjectName"'$')
	[[ "$dockerContainerID" != "" ]] && export dockerContainerObjectExists="true"
	
	export dockerContainerObjectNameInstancedExists="false"
	export dockerContainerInstancedID=$(_permitDocker docker ps -a -q --filter name='^/'"$dockerContainerObjectNameInstanced"'$')
	[[ "$dockerContainerInstancedID" != "" ]] && export dockerContainerObjectNameInstancedExists="true"
	
	
	export dockerMkimageDistro=$(echo "$dockerBaseObjectName" | cut -d \/ -f 2 | cut -d \: -f 1)
	export dockerMkimageVersion=$(echo "$dockerBaseObjectName" | cut -d \/ -f 2 | cut -d \: -f 2)
	
	##Binaries
	[[ "$dockerMkimageAbsoluteLocaton" == "" ]] && export dockerMkimageAbsoluteLocaton=$(_discoverResource moby/contrib/mkimage.sh)
	[[ "$dockerMkimageAbsoluteLocaton" == "" ]] && export dockerMkimageAbsoluteLocaton=$(_discoverResource docker/contrib/mkimage.sh)
	[[ "$dockerMkimageAbsoluteDirectory" == "" ]] && export dockerMkimageAbsoluteDirectory=$(_getAbsoluteFolder "$dockerMkimageAbsoluteLocaton")
	
	##Directives
	export dockerdirectivefile
	dockerdirectivefile="$safeTmp"/Dockerfile
	export dockerentrypoint
	dockerentrypoint="$safeTmp"/ubiquitous_bash.sh
	#_prepare_docker_directives
	
}
#_prepare_docker

