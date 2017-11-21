_userDocker_sequence() {
	_start
	_prepare_docker
	
	export checkBaseDirRemote=_checkBaseDirRemote_docker
	_virtUser "$@" >> "$logTmp"/usrchrt.log 2>&1
	
	#"$sharedHostProjectDir"
	#"${processedArgs[@]}"
	
	#_permitDocker docker run -it --name "$dockerContainerObjectNameInstanced" -e virtSharedUser="$virtGuestUser" --rm "$dockerImageObjectName" /bin/bash /usr/local/bin/ubiquitous_bash.sh _drop_docker "${processedArgs[@]}"
	_permitDocker docker run -it --name "$dockerContainerObjectNameInstanced" --rm "$dockerImageObjectName" /bin/bash /usr/local/bin/ubiquitous_bash.sh _drop_docker "${processedArgs[@]}"
	local userDockerExitStatus="$?"
	
	_stop "$userDockerExitStatus"
}

_userDocker() {
	local dockerImageNeeded
	"$scriptAbsoluteLocation" _create_docker_image_needed_sequence > /dev/null 2>&1
	dockerImageNeeded="$?"
	[[ "$dockerImageNeeded" == "0" ]] && return 1
	[[ "$dockerImageNeeded" == "1" ]] && return 1
	
	"$scriptAbsoluteLocation" _userDocker_sequence "$@"
	return "$?"
}
