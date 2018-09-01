# TODO: WIP intended to illustrate the basic logic flow. Uses global variables for some arguments - resetting these is MANDATORY .
_processor_name() {
	_assign_me_objname "_processor_name"
	
	"$scriptAbsoluteLocaton" _me_processor_name &
}

_me_processor_name() {
	_start_metaengine
	_wait_metaengine
	
	#Do something.
	#> cat >
	
	_stop
}
