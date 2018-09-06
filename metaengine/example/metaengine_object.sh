# TODO: WIP intended to illustrate the basic logic flow. Uses global variables for some arguments - resetting these is MANDATORY .
_example_processor_name() {
	_assign_me_objname "_example_processor_name"
	
	_me_command "_example_me_processor_name"
	
	#Optional. Usually correctly orders diagnostic output.
	sleep 3
}

_example_me_processor_name() {
	_messageNormal 'launch: '"$metaObjName"
	
	_wait_metaengine
	_start_metaengine
	
	#Do something.
	#> cat >
	while true
	do
		sleep 10
	done
	
	#optional
	_stop
}
