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
	export dockerContainerObjectName=""
	export dockerImageObjectNameSane=""
	export dockerContainerObjectNameInstanced=""
	
	export dockerBaseObjectExists=""
	export dockerContainerObjectExists=""
	export dockerContainerID=""
	export dockerImageObjectExists=""
	
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
	#Docker directives files should be generated from here documents and a copy of the script iself.
	
	true
}

_prepare_docker() {
	
	export dockerInstanceDir="$scriptLocal"
	[[ "$1" != "" ]] && export dockerInstanceDir="$1"
	
	export docker_image="$scriptLocal/_dockimg"
	
	export dockerubidfile
	dockerubidfile="$scriptLocal"/docker.id
	
	_pathLocked _reset_dockerID || return 1
	
	[[ ! -e "$dockerubidfile" ]] && sleep 0.1 && [[ ! -e "$dockerubidfile" ]] && echo -e -n "$sessionid" > "$dockerubidfile" 2> /dev/null
	[[ -e "$dockerubidfile" ]] && export DOCKERUBID=$(cat "$dockerubidfile" 2> /dev/null)
	
	export dockerImageFilename="$scriptLocal"/docker.dai
	
	##Sub-object Names
	#Overload by setting either "$dockerObjectName", or any of "$dockerBaseObjectName", "$dockerImageObjectName", and "$dockerContainerObjectName" .
	
	#container-image-base
	#Unique names NOT requires.
	#Path locked ID from ubiquitous_bash will be prepended to image name.
	
	#Default
	if [[ "$dockerObjectName" == "" ]] && [[ "$dockerBaseObjectName" == "" ]] && [[ "$dockerImageObjectName" == "" ]] && [[ "$dockerContainerObjectName" == "" ]]
	then
		#export dockerObjectName="unimportant-local/app:app-local/debian:jessie"
		#export dockerObjectName="unimportant-hello-scratch"
		#export dockerObjectName="ubvrt-ub-ubvrt/debian:jessie"
		#export dockerObjectName="ubvrt-ubvrt-scratch"
		export dockerObjectName="ubvrt-ubvrt-scratch"
	fi
	
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
	
	export dockerContainerObjectNameInstanced="$sessionid"_"$dockerContainerObjectName"
	
	##Specialized.
	export dockerBaseObjectExists="false"
	[[ "$(_permitDocker docker images -q "$dockerBaseObjectName" 2> /dev/null)" != "" ]] && export dockerBaseObjectExists="true"
	
	export dockerContainerObjectExists="false"
	export dockerContainerID=$(_permitDocker docker ps -a -q --filter name='^/'"$containerObjectName"'$')
	[[ "$dockerContainerID" != "" ]] && export dockerContainerObjectExists="true"
	
	export dockerImageObjectExists="false"
	[[ "$(_permitDocker docker images -q "$dockerImageObjectName" 2> /dev/null)" != "" ]] && export dockerImageObjectExists="true"
	
	
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
	dockerentrypoint="$safeTmp"/entrypoint.sh
	#_prepare_docker_directives
	
}
#_prepare_docker

