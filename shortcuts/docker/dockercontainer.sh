_dockerCommit_sequence() {
	_start
	_prepare_docker
	
	_permitDocker docker commit "$dockerContainerObjectName" "$dockerImageObjectName"
	
	_stop
}

_dockerCommit() {
	if ! "$scriptAbsoluteLocation" _create_docker_container_quick > /dev/null 2>&1
	then
		return 1
	fi
	
	"$scriptAbsoluteLocation" _dockerCommit_sequence "$@"
	return "$?"
}

_dockerLaunch_sequence() {
	_start
	_prepare_docker
	
	#_permitDocker docker start -ia "$dockerContainerObjectName"
	_permitDocker docker start -ia ubvrt_gkzpya8wsrzunppqvh_ubvrt_latest
	
	_stop
}

_dockerLaunch() {
	if ! "$scriptAbsoluteLocation" _create_docker_container_quick > /dev/null 2>&1
	then
		return 1
	fi
	
	"$scriptAbsoluteLocation" _dockerLaunch_sequence "$@"
	return "$?"
}

_dockerAttach_sequence() {
	_start
	_prepare_docker
	
	_permitDocker docker attach "$dockerContainerObjectName"
	
	_stop
}

_dockerAttach() {
	if ! "$scriptAbsoluteLocation" _create_docker_container_quick > /dev/null 2>&1
	then
		return 1
	fi
	
	"$scriptAbsoluteLocation" _dockerAttach_sequence "$@"
	return "$?"
}

_dockerOn_sequence() {
	_start
	_prepare_docker
	
	_permitDocker docker start "$dockerContainerObjectName"
	
	_stop
}


_dockerOn() {
	if ! "$scriptAbsoluteLocation" _create_docker_container_quick > /dev/null 2>&1
	then
		return 1
	fi
	
	"$scriptAbsoluteLocation" _dockerOn_sequence
	return "$?"
}

_dockerOff_sequence() {
	_start
	_prepare_docker
	
	_permitDocker docker stop -t 10 "$dockerContainerObjectName"
	
	_stop
}

_dockerOff() {
	if ! "$scriptAbsoluteLocation" _create_docker_container_quick > /dev/null 2>&1
	then
		return 1
	fi
	
	"$scriptAbsoluteLocation" _dockerOff_sequence
	return "$?"
}

_dockerEnter() {
	_dockerLaunch "$@"
}

dockerRun_command() {
	_permitDocker docker run -it --name "$dockerContainerObjectNameInstanced" --rm "$dockerImageObjectName" "$@"
}

_dockerRun_sequence() {
	_start
	_prepare_docker
	
	dockerRun_command "$@"
	
	_stop "$?"
}

_dockerRun() {
	local dockerImageNeeded
	"$scriptAbsoluteLocation" _create_docker_image_needed_sequence > /dev/null 2>&1
	dockerImageNeeded="$?"
	[[ "$dockerImageNeeded" == "0" ]] && return 1
	[[ "$dockerImageNeeded" == "1" ]] && return 1
	
	"$scriptAbsoluteLocation" _dockerRun_sequence "$@"
	return "$?"
}
