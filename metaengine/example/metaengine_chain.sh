# Intended to illustrate the basic logic flow. Uses global variables for some arguments - resetting these is MANDATORY .
_example_process_rand() {
	_start_metaengine_host
	
	_set_me_null_in
	_set_me_rand_out
	_example_processor_name
	
	_cycle_me
	_example_processor_name
	
	_cycle_me
	_example_processor_name
	
	_cycle_me
	_set_me_null_out
	_example_processor_name
	
	_reset_me
	
	_stop_metaengine_wait
}

# Intended to illustrate the basic logic flow. Uses global variables for some arguments - resetting these is MANDATORY .
_example_process_name() {
	_start_metaengine_host
	
	_set_me_null_in
	_assign_me_name_out "1"
	_example_processor_name
	
	_cycle_me
	_assign_me_name_out "2"
	_example_processor_name
	
	_cycle_me
	_assign_me_name_out "3"
	_example_processor_name
	
	_cycle_me
	_set_me_null_out
	_example_processor_name
	
	_reset_me
	
	_stop_metaengine_wait
}

# Intended to illustrate the basic logic flow. Uses global variables for some arguments - resetting these is MANDATORY .
_example_process_coordinates() {
	_start_metaengine_host
	
	#_assign_me_coordinates aiX aiY aiZ biX biY biZ aoX aoY aoZ boX boY boZ
	#"$metaReg"/grid/"$z"/"$x"/"$y"
	
	_reset_me_name
	_assign_me_coordinates "" "" "" "" "" "" 0 1 0 1 1 0
	_set_me_null_in
	_example_processor_name
	
	_reset_me_name
	_assign_me_coordinates 0 1 0 1 1 0 0 2 0 1 2 0
	_example_processor_name
	
	_reset_me_name
	_assign_me_coordinates 0 2 0 1 2 0 0 3 0 1 3 0
	_example_processor_name
	
	_reset_me_name
	_assign_me_coordinates 0 3 0 1 3 0 0 4 0 1 4 0
	_example_processor_name
	
	_reset_me
	
	_stop_metaengine_wait
}

