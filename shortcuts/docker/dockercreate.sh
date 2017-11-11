_create_docker_scratch_sequence() {
	_start
	
	# TODO Verify prior dockerObjectName takes effect.
	export dockerObjectName="ubvrt-ubvrt-scratch"
	_prepare_docker
	
	_messageProcess "Searching"
	[[ "$dockerBaseObjectExists" == "true" ]] && _messageHAVE && _stop
	_messageNEED
	
	_messageProcess "Building ""$dockerBaseObjectName"
	cd "$objectDir"
	tar cv --files-from /dev/null | docker import - "$dockerBaseObjectName" 2> /dev/null > "$logTmp"/buildBase
	cd "$scriptAbsoluteFolder"
	
	[[ "$(docker images -q "$dockerBaseObjectName" 2> /dev/null)" == "" ]] && _messageFAIL && _stop 1
	
	_messagePASS
	
	_stop
}

_create_docker_scratch() {
	"$scriptAbsoluteLocation" _create_docker_scratch_sequence "$@"
}


_create_docker_base() {
	[[ "$dockerBaseObjectName" == "" ]] && [[ "$1" != "" ]] && export dockerBaseObjectName="$1"
	
	_messageProcess "Evaluating ""$dockerBaseObjectName"
	
	[[ "$dockerBaseObjectName" == "" ]] && _messageError "BLANK" && return 1
	
	[[ "$dockerBaseObjectName" == "scratch:latest" ]] && _messagePASS && _create_docker_scratch && return
	
	[[ "$dockerBaseObjectName" == "local/debian:jessie" ]] && _messagePASS && _create_docker_debianjessie && return
	
	
	_messageWARN "No local build instructons found, will rely on upstream provider."
	return 1
	
}
