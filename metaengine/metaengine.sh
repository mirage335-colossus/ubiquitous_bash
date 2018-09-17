_test_metaengine_sequence() {
	! _start_metaengine_host && _stop 1
	! _stop_metaengine_allow && _stop 1
	
	! _reset_me_name && _stop 1
	! _assign_me_coordinates "" "" "" "" "" "" 0 1 0 1 1 0 && _stop 1
	! _set_me_null_in && _stop 1
	
	
	! _reset_me_name && _stop 1
	! _set_me_null_in && _stop 1
	! _set_me_rand_out && _stop 1
	! _cycle_me && _stop 1
	! _set_me_null_out && _stop 1
	
	! _reset_me_name && _stop 1
	! _set_me_null_in && _stop 1
	! _assign_me_name_out "1" && _stop 1
	! _cycle_me && _stop 1
	! _assign_me_name_out "2" && _stop 1
	! _cycle_me && _stop 1
	! _assign_me_name_out "3" && _stop 1
	! _cycle_me && _stop 1
	! _set_me_null_out && _stop 1
	
	! _stop_metaengine_allow && _stop 1
	_stop
}

_test_metaengine() {
	_getDep mkfifo
	
	if ! "$scriptAbsoluteLocation" _test_metaengine_sequence > /dev/null 2>&1
	then
		echo 'fail: metaengine: internal'
		_stop 1
	fi
}
