# Intended to illustrate the basic logic flow. Uses global variables for some arguments - resetting these is MANDATORY .
#"$1" == _me_processor_name
#"$2" == metaObjName (optional)
_processor_launch() {
	_assign_me_objname "$1"
	[[ "$2" != "" ]] && _assign_me_objname "$2"
	
	_me_command "$1"
	
	#Optional. Usually correctly orders diagnostic output.
	sleep 3
}

_me_processor_noise() {
	_messageNormal 'launch: '"$metaObjName"
	
	_wait_metaengine
	_start_metaengine
	
	_buffer_me_processor_fifo
	
	cat < /dev/urandom > "$metaDir"/ao/fifo
	
	#while true
	#do
	#	sleep 1
	#done
	
	#optional, closes host upon completion
	#_stop
}
