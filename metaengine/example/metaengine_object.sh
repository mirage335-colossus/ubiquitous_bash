# TODO: WIP intended to illustrate the basic logic flow. Uses global variables for some arguments - resetting these is MANDATORY .
_processor_name() {
	_assign_me_objname "_processor_name"
	
	"$scriptAbsoluteLocation" _me_processor_name &
	
	#Optional. Usually correctly orders diagnostic output.
	sleep 10
}

_me_processor_name() {
	_start_metaengine
	_wait_metaengine
	
	#Do something.
	#> cat >
	sleep 10
	
	_stop
}
