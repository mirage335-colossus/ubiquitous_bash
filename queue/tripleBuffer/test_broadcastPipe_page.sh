

# WARNING: Not a valid example of intended or otherwise correct usage.
# WARNING: Bus parameters are chosen to attempt synchronyous operation, which is usually highly undesirable!
# System latency and bandwidth indirectly measured by this test. Inability to triple buffer through the "$safeTmp" filesystem at expected rate (ie. ~15KiB/s) will return failure.
_test_broadcastPipe_page-stream_sequence() {
	_start
	
	#Benchmarked at >15KiB/s .
	export ub_force_limit_page_rate='true'
	local current_Service_MaxTime=975
	local current_Read_MaxTime=575
	local current_Write_MaxTime=4475
	local current_Write_MaxBytes=86400
	
	_demand_broadcastPipe_page "$safeTmp"/inputBufferDir "$safeTmp"/outputBufferDir "$current_Service_MaxTime"
	
	#>&2 echo "read"
	"$scriptAbsoluteLocation" _page_read "$safeTmp"/outputBufferDir 'out-' "$current_Read_MaxTime" > "$safeTmp"/rewrite &
	
	dd if=/dev/urandom of="$safeTmp"/testfill bs=1k count=288 > /dev/null 2>&1
	
	#>&2 echo "write"
	#_timeout 150 cat "$safeTmp"/testfill | pv | _timeout 30 "$scriptAbsoluteLocation" _page_write "$safeTmp"/inputBufferDir 'testfill-' "$current_Write_MaxTime" "$current_Write_MaxBytes"
	_timeout 150 cat "$safeTmp"/testfill | _timeout 30 "$scriptAbsoluteLocation" _page_write "$safeTmp"/inputBufferDir 'testfill-' "$current_Write_MaxTime" "$current_Write_MaxBytes"
	
	#cat "$safeTmp"/testfill | _page_write_single "$safeTmp"/inputBufferDir 'testfill-' "$current_Write_MaxTime" "$current_Write_MaxBytes"
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
	
	#Benchmarked at >15KiB/s .
	export ub_force_limit_page_rate='true'
	local current_Service_MaxTime=975
	local current_Read_MaxTime=575
	local current_Write_MaxTime=4475
	local current_Write_MaxBytes=86400
	
	_demand_broadcastPipe_page "$safeTmp"/inputBufferDir "$safeTmp"/outputBufferDir "$current_Service_MaxTime"
	
	#>&2 echo "read"
	"$scriptAbsoluteLocation" _page_read "$safeTmp"/outputBufferDir 'out-' "$current_Read_MaxTime" > "$safeTmp"/rewrite &
	
	dd if=/dev/urandom of="$safeTmp"/testfill bs=1k count=288 > /dev/null 2>&1
	
	#>&2 echo "write"
	#_timeout 150 cat "$safeTmp"/testfill | pv | _timeout 30 "$scriptAbsoluteLocation" _page_write "$safeTmp"/inputBufferDir 'testfill-' "$current_Write_MaxTime" "$current_Write_MaxBytes"
	#_timeout 150 cat "$safeTmp"/testfill | _timeout 30 "$scriptAbsoluteLocation" _page_write "$safeTmp"/inputBufferDir 'testfill-' "$current_Write_MaxTime" "$current_Write_MaxBytes"
	
	cat "$safeTmp"/testfill | _page_write_single "$safeTmp"/inputBufferDir 'testfill-' "$current_Write_MaxTime" "$current_Write_MaxBytes"
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



