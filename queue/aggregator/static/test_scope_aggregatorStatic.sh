
_aggregatorStatic_test_scope-konsole_tab-service() {
	_demand_broadcastPipe_aggregatorStatic "$inputBufferDir" "$outputBufferDir"
	while true
	do
		sleep 3
	done
}

_aggregatorStatic_test_scope-konsole_tab-dirLoop() {
	while true
	do
		echo '----------'
		clear
		ls -R
		sleep 0.1
	done
}



# ATTENTION: Experimental use intended. Provides a command line environment with temporary directories , functions , services , examples , etc .
# Requires 'scope' which is NOT usually pulled in as a dependency of 'queue' .
_aggregatorStatic_test_scope() {
	_start
	
	export inputBufferDir="$safeTmp"/_i
	export outputBufferDir="$safeTmp"/_o
	
	dd if=/dev/urandom of="$safeTmp"/testfill bs=1k count=2048 > /dev/null 2>&1
	
	
	
	
	# ATTENTION: EXAMPLE. Consider experimenting with these commands.
	
	#_aggregatorStatic_read "$outputBufferDir" "$inputBufferDir"
	
	#_aggregatorStatic_converse "$outputBufferDir" "$inputBufferDir"
 	
 	#echo test | _aggregatorStatic_write "$inputBufferDir" "$outputBufferDir"
 	
 	
 	#_terminate_broadcastPipe_aggregatorStatic "$inputBufferDir"
	
	
	
	
	cat << CZXWXcRMTo8EmM8i4d > "$safeTmp"/konsole_tabs
#title: true;; command:  "$scriptAbsoluteLocation" --devenv _true
title: _demand_broadcastPipe_aggregatorStatic;; command:  "$scriptAbsoluteLocation" --devenv _aggregatorStatic_test_scope-konsole_tab-service
title: dirLoop;; command:  "$scriptAbsoluteLocation" --devenv _aggregatorStatic_test_scope-konsole_tab-dirLoop
CZXWXcRMTo8EmM8i4d
	
	_scope_konsole "$safeTmp" --tabs-from-file "$safeTmp"/konsole_tabs
	
	#(
	#cd "$safeTmp"
	#du -sh ./testfill ./rewrite ./rewrite_converse ./rewrite_converse_subprocess
	#md5sum ./testfill ./rewrite ./rewrite_converse ./rewrite_converse_subprocess
	#)
	
	_stop
}
