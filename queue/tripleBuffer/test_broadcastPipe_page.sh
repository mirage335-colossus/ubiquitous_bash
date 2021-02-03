

# WARNING: Not a valid example of intended or otherwise correct usage.
# WARNING: Bus parameters are chosen to attempt synchronyous operation, which is usually highly undesirable!
# System latency and bandwidth indirectly measured by this test. Inability to triple buffer through the "$safeTmp" filesystem at ~100KiB/s will return failure.
_test_broadcastPipe_page-stream_sequence() {
	_start
	
	export ub_force_limit_page_rate='true'
	
	_demand_broadcastPipe_page "$safeTmp"/inputBufferDir "$safeTmp"/outputBufferDir '100'
	
	#>&2 echo "read"
	"$scriptAbsoluteLocation" _page_read "$safeTmp"/outputBufferDir 'out-' '175' > "$safeTmp"/rewrite &
	
	dd if=/dev/urandom of="$safeTmp"/testfill bs=1k count=2048 > /dev/null 2>&1
	
	#>&2 echo "write"
	#_timeout 150 cat "$safeTmp"/testfill | pv | _timeout 30 "$scriptAbsoluteLocation" _page_write "$safeTmp"/inputBufferDir 'testfill-' '725' '86400'
	_timeout 150 cat "$safeTmp"/testfill | _timeout 30 "$scriptAbsoluteLocation" _page_write "$safeTmp"/inputBufferDir 'testfill-' '725' '86400'
	
	#cat "$safeTmp"/testfill | _page_write_single "$safeTmp"/inputBufferDir 'testfill-' '725' '86400'
	#_sleep_spinlock
	
	_terminate_broadcastPipe_page "$safeTmp"/inputBufferDir
	
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

# WARNING: Not a valid example of intended or otherwise correct usage.
# WARNING: Bus parameters are chosen to attempt synchronyous operation, which is usually highly undesirable!
_test_broadcastPipe_page-single_sequence() {
	_start
	
	export ub_force_limit_page_rate='true'
	
	_demand_broadcastPipe_page "$safeTmp"/inputBufferDir "$safeTmp"/outputBufferDir '100'
	
	#>&2 echo "read"
	"$scriptAbsoluteLocation" _page_read "$safeTmp"/outputBufferDir 'out-' '175' > "$safeTmp"/rewrite &
	
	dd if=/dev/urandom of="$safeTmp"/testfill bs=1k count=512 > /dev/null 2>&1
	
	#>&2 echo "write"
	#_timeout 150 cat "$safeTmp"/testfill | pv | _timeout 30 "$scriptAbsoluteLocation" _page_write "$safeTmp"/inputBufferDir 'testfill-' '725' '86400'
	#_timeout 150 cat "$safeTmp"/testfill | _timeout 30 "$scriptAbsoluteLocation" _page_write "$safeTmp"/inputBufferDir 'testfill-' '725' '86400'
	
	cat "$safeTmp"/testfill | _page_write_single "$safeTmp"/inputBufferDir 'testfill-' '725' '86400'
	_sleep_spinlock
	
	_terminate_broadcastPipe_page "$safeTmp"/inputBufferDir
	
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

_test_broadcastPipe_page() {
	#_getDep pv
	
	if ! "$scriptAbsoluteLocation" _test_broadcastPipe_page-stream_sequence "$@" 2> /dev/null
	then
		return 1
	fi
	if ! "$scriptAbsoluteLocation" _test_broadcastPipe_page-single_sequence "$@" 2> /dev/null
	then
		return 1
	fi
	return 0
}



