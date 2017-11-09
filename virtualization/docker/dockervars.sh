##### DockerVars
#Only include variables and functions here that might need to be used globally.

_unset_docker() {
	export docker_image=""
	
	export dockerInstanceDir=""
	
	export dockerubidfile=""
	
	export dockerObjectName=""
	export dockerBaseObjectName=""
	export dockerImageObjectName=""
	export dockerContainerObjectName=""
	export dockerImageObjectNameSane=""
	
	
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
	#Overload by setting either "$dockerObjectName", or all of "$dockerBaseObjectName", "$dockerImageObjectName", and "$dockerContainerObjectName" .
	
	#container-image-base
	#[[ "$dockerObjectName" == "" ]] && export dockerObjectName="unimportant-""$DOCKERUBID"_"local/app:app-local/debian:jessie"
	[[ "$dockerObjectName" == "" ]] && export dockerObjectName="unimportant-""$DOCKERUBID"_"hello-scratch"
	
	
	if [[ "$dockerBaseObjectName" == "" ]] || [[ "$dockerImageObjectName" == "" ]] || [[ "$dockerContainerObjectName" == "" ]]
	then
		export dockerBaseObjectName=$(echo "$dockerObjectName" | cut -s -d\- -f3)
		export dockerImageObjectName=$(echo "$dockerObjectName" | cut -s -d\- -f2)
		export dockerContainerObjectName=$(echo "$dockerObjectName" | cut -d\- -f1)
	fi
	
	if ! echo "$dockerBaseObjectName" | grep ':' >/dev/null 2>&1
	then
		dockerBaseObjectName="$dockerBaseObjectName"":latest"
	fi
	
	if ! echo "$dockerImageObjectName" | grep ':' >/dev/null 2>&1
	then
		dockerImageObjectName="$dockerImageObjectName"":latest"
	fi
	
	dockerImageObjectNameSane=$(echo "$imageObjectName" | tr ':/' '__' | tr -dc 'a-zA-Z0-9_')
	
	dockerContainerObjectName="$dockerContainerObjectName""_""$dockerImageObjectNameSane"
	
	##Specialized.
	export dockerBaseObjectExists=false
	[[ "$(docker images -q "$baseObjectName" 2> /dev/null)" != "" ]] && export baseObjectExists=true
	
	export dockerContainerObjectExists=false
	export dockerContainerID=$(docker ps -a -q --filter name='^/'"$containerObjectName"'$')
	[[ "$dockerContainerID" != "" ]] && export dockerContainerObjectExists=true
	
	export dockerImageObjectExists=false
	[[ "$(docker images -q "$imageObjectName" 2> /dev/null)" != "" ]] && export dockerImageObjectExists=true
	
	
	export mkimageDistro=$(echo "$baseObjectName" | cut -d \/ -f 2 | cut -d \: -f 1)
	export mkimageVersion=$(echo "$baseObjectName" | cut -d \/ -f 2 | cut -d \: -f 2)
	
	##Binaries
	export mkimageAbsoluteLocaton=$(_discoverResource docker/contrib/mkimage.sh)
	export mkimageAbsoluteDirectory=$(_getAbsoluteFolder "$mkimageAbsoluteLocaton")
	
	##Directives
	export dockerdirectivefile
	dockerdirectivefile="$safeTmp"/dockerfile
	export dockerentrypoint
	dockerentrypoint="$safeTmp"/entrypoint.sh
	#_prepare_docker_directives
	
}
#_prepare_docker

