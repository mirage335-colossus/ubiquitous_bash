# Under ideal conditions, small quantities of data may be continiously copied completely or identically (<10M).
_benchmark_broadcastPipe_page() {
	_start
	
	#Benchmarked at >100KiB/s .
# 	export ub_force_limit_page_rate='true'
# 	local current_Service_MaxTime=100
# 	local current_Service_MaxBytes=86400
# 	local current_Service_Write_MaxTime=725
# 	local current_Read_MaxTime=175
# 	local current_Write_MaxTime=725
# 	local current_Write_MaxBytes=86400
	
	#Benchmarked at >2.0MiB/s .
	export ub_force_limit_page_rate='false'
	local current_Service_MaxTime=100
	local current_Service_MaxBytes=86400
	local current_Service_Write_MaxTime=725
	local current_Read_MaxTime=175
	local current_Write_MaxTime=725
	local current_Write_MaxBytes=86400
	
	
	
	_demand_broadcastPipe_page "$safeTmp"/inputBufferDir "$safeTmp"/outputBufferDir "$current_Service_MaxTime" "$current_Service_MaxBytes" "$current_Service_Write_MaxTime"
	
	#>&2 echo "read"
	"$scriptAbsoluteLocation" _page_read "$safeTmp"/outputBufferDir 'out-' "$current_Read_MaxTime" > "$safeTmp"/rewrite &
	
	dd if=/dev/urandom of="$safeTmp"/testfill bs=1M count=24 > /dev/null 2>&1
	
	#>&2 echo "write"
	_timeout 150 cat "$safeTmp"/testfill | pv | _timeout 30 "$scriptAbsoluteLocation" _page_write "$safeTmp"/inputBufferDir 'testfill-' "$current_Write_MaxTime" "$current_Write_MaxBytes"
	#_timeout 150 cat "$safeTmp"/testfill | _timeout 30 "$scriptAbsoluteLocation" _page_write "$safeTmp"/inputBufferDir 'testfill-' '725' '86400'
	
	#cat "$safeTmp"/testfill | _page_write_single "$safeTmp"/inputBufferDir 'testfill-' '725' '86400'
	#_sleep_spinlock
	
	_terminate_broadcastPipe_page "$safeTmp"/inputBufferDir
	
	(
	cd "$safeTmp"
	du -sh ./testfill ./rewrite
	md5sum ./testfill ./rewrite
	)
	
	#! [[ -s "$safeTmp"/testfill ]] && _stop 1
	#! [[ -s "$safeTmp"/rewrite ]] && _stop 1
	#! diff "$safeTmp"/testfill "$safeTmp"/rewrite && _stop 1
	
	_stop
}



