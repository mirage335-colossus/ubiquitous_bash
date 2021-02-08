_test_broadcastPipe_aggregatorStatic_sequence() {
	_start
	
	_start
	
	
	export inputBufferDir="$safeTmp"/_i
	export outputBufferDir="$safeTmp"/_o
	
	
	_demand_broadcastPipe_aggregatorStatic "$inputBufferDir" "$outputBufferDir"
	
	
	
	
	
	
	
	dd if=/dev/urandom of="$safeTmp"/testfill bs=1k count=2048 > /dev/null 2>&1
	
	_aggregator_read "$outputBufferDir" > "$safeTmp"/rewrite &
	#_reset_broadcastPipe_aggregatorStatic
	
	# WARNING: May be incompatible with '_timeout' .
	cat "$safeTmp"/testfill | _aggregator_write "$inputBufferDir"
	#_reset_broadcastPipe_aggregatorStatic
	
	_skip_broadcastPipe_aggregatorStatic "$inputBufferDir"
	
	
	_terminate_broadcastPipe_aggregatorStatic "$inputBufferDir"
	
	(
	cd "$safeTmp"
	du -sh ./testfill ./rewrite
	md5sum ./testfill ./rewrite
	)
	
	! [[ -s "$safeTmp"/testfill ]] && _stop 1
	! [[ -s "$safeTmp"/rewrite ]] && _stop 1
	! diff "$safeTmp"/testfill "$safeTmp"/rewrite && _stop 1
	
	_stop
}

_test_broadcastPipe_aggregatorStatic() {
	if ! "$scriptAbsoluteLocation" _test_broadcastPipe_aggregatorStatic_sequence "$@" 2> /dev/null
	#if ! "$scriptAbsoluteLocation" _test_broadcastPipe_aggregatorStatic_sequence "$@"
	then
		return 1
	fi
	return 0
}

