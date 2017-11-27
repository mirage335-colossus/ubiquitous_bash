_userDocker_sequence() {
	_start
	_prepare_docker
	local userDockerExitStatus
	
	export checkBaseDirRemote=_checkBaseDirRemote_docker
	_virtUser "$@" >> "$logTmp"/usrdock.log 2>&1
	
	#"$sharedHostProjectDir"
	#"${processedArgs[@]}"
	
	local dockerRunArgs
	
	#Translation only.
	local LOCAL_USER_ID=$(id -u)
	dockerRunArgs+=(-e virtSharedUser="$virtGuestUser" -e localPWD="$localPWD" -e LOCAL_USER_ID="$LOCAL_USER_ID")
	
	#Directory sharing.
	dockerRunArgs+=(-v "$HOME"/Downloads:"$virtGuestHome"/Downloads:rw -v "$sharedHostProjectDir":"$sharedGuestProjectDir":rw)
	
	#Display
	dockerRunArgs+=(-e DISPLAY=$DISPLAY -v $XSOCK:$XSOCK:rw -v $XAUTH:$XAUTH:rw -e "XAUTHORITY=${XAUTH}")
	
	#FUSE (AppImage)
	dockerRunArgs+=(--cap-add SYS_ADMIN --device /dev/fuse --security-opt apparmor:unconfined)
		
	#OpenGL, Intel HD Graphics.
	dockerRunArgs+=(--device=/dev/dri:/dev/dri)
	
	_permitDocker docker run -it --name "$dockerContainerObjectNameInstanced" --rm "${dockerRunArgs[@]}" "$dockerImageObjectName" "${processedArgs[@]}"
	
	
	userDockerExitStatus="$?"
	
	rm -f "$logTmp"/usrdock.log > /dev/null 2>&1
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
