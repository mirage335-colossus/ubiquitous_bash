_test_broadcastPipe_aggregatorStatic_sequence() {
	_start
	
	
	export inputBufferDir="$safeTmp"/_i
	export outputBufferDir="$safeTmp"/_o
	
	
	# > /dev/null 2>&1
	_demand_broadcastPipe_aggregatorStatic "$inputBufferDir" "$outputBufferDir" > "$safeTmp"/log/demand.log
	
	
	
	
	
	
	
	dd if=/dev/urandom of="$safeTmp"/testfill bs=1k count=2048 > /dev/null 2>&1
	
	"$scriptAbsoluteLocation" _aggregator_read_procedure "$outputBufferDir" > "$safeTmp"/rewrite &
	#_reset_broadcastPipe_aggregatorStatic
	
	# WARNING: May be incompatible with '_timeout' .
	cat "$safeTmp"/testfill | "$scriptAbsoluteLocation" _aggregator_write_procedure "$inputBufferDir" &
	#_reset_broadcastPipe_aggregatorStatic
	
	
	_sleep_spinlock
	_skip_broadcastPipe_aggregatorStatic "$inputBufferDir"
	
	sleep 24
	_sleep_spinlock
	_terminate_broadcastPipe_aggregatorStatic "$inputBufferDir"
	
	#(
	#cd "$safeTmp"
	#du -sh ./testfill ./rewrite
	#md5sum ./testfill ./rewrite
	#)
	
	! [[ -s "$safeTmp"/testfill ]] && _stop 1
	! [[ -s "$safeTmp"/rewrite ]] && _stop 1
	! diff "$safeTmp"/testfill "$safeTmp"/rewrite && _stop 1
	
	_stop
}


_test_broadcastPipe_aggregatorStatic_delayIPC__aggregatorStatic_converse() {
	true | _aggregatorStatic_converse "$1" "$2" > "$3"
}


_test_broadcastPipe_aggregatorStatic_delayIPC_sequence() {
	_start
	
	
	export inputBufferDir="$safeTmp"/_i
	export outputBufferDir="$safeTmp"/_o
	
	
	# > /dev/null 2>&1
	_demand_broadcastPipe_aggregatorStatic "$inputBufferDir" "$outputBufferDir" > "$safeTmp"/log/demand.log
	_sleep_spinlock
	
	
	
	
	
	
	dd if=/dev/urandom of="$safeTmp"/testfill bs=1k count=2048 > /dev/null 2>&1
	
	"$scriptAbsoluteLocation" _aggregatorStatic_read "$outputBufferDir" "$inputBufferDir" > "$safeTmp"/rewrite &
	
	"$scriptAbsoluteLocation" _aggregatorStatic_converse "$outputBufferDir" "$inputBufferDir" > "$safeTmp"/rewrite_converse &
 	"$scriptAbsoluteLocation" _test_broadcastPipe_aggregatorStatic_delayIPC__aggregatorStatic_converse "$outputBufferDir" "$inputBufferDir" "$safeTmp"/rewrite_converse_subprocess &
	
	#_reset_broadcastPipe_aggregatorStatic
	
	# WARNING: May be incompatible with '_timeout' .
	cat "$safeTmp"/testfill | "$scriptAbsoluteLocation" _aggregatorStatic_write "$inputBufferDir" "$outputBufferDir"
	#_reset_broadcastPipe_aggregatorStatic
	
	
	#_sleep_spinlock
	#_skip_broadcastPipe_aggregatorStatic "$inputBufferDir"
	
	sleep 18
	_sleep_spinlock
	
	sleep 24
	_sleep_spinlock
	
	_terminate_broadcastPipe_aggregatorStatic "$inputBufferDir"
	
	#(
	#cd "$safeTmp"
	#du -sh ./testfill ./rewrite ./rewrite_converse ./rewrite_converse_subprocess
	#md5sum ./testfill ./rewrite ./rewrite_converse ./rewrite_converse_subprocess
	#)
	
	! [[ -s "$safeTmp"/testfill ]] && _stop 1
	! [[ -s "$safeTmp"/rewrite ]] && _stop 1
	! [[ -s "$safeTmp"/rewrite_converse ]] && _stop 1
	! diff "$safeTmp"/testfill "$safeTmp"/rewrite && _stop 1
	! diff "$safeTmp"/testfill "$safeTmp"/rewrite_converse && _stop 1
	
	_stop
}


_test_broadcastPipe_aggregatorStatic() {
	if ! "$scriptAbsoluteLocation" _test_broadcastPipe_aggregatorStatic_sequence "$@" 2> /dev/null
	#if ! "$scriptAbsoluteLocation" _test_broadcastPipe_aggregatorStatic_sequence "$@"
	then
		return 1
	fi
	if ! "$scriptAbsoluteLocation" _test_broadcastPipe_aggregatorStatic_delayIPC_sequence "$@" 2> /dev/null
	#if ! "$scriptAbsoluteLocation" _test_broadcastPipe_aggregatorStatic_sequence "$@"
	then
		return 1
	fi
	return 0
}

