_test_queue() {
	_getDep md5sum
	_getDep sha512sum
	
	_getDep socat
}



# https://stackoverflow.com/questions/4774358/get-mtime-of-specific-file-using-bash
_test_selfTime_sequence() {
	_start
	
	local iterations
	
	local dateA
	local dateB
	local dateDelta
	
	
	iterations=0
	while [[ "$iterations" -lt 3 ]]
	do
		dateA=$(date +%s)
		! "$scriptAbsoluteLocation" _true && _messageFAIL && _stop 1
		"$scriptAbsoluteLocation" _false && _messageFAIL && _stop 1
		dateB=$(date +%s)
		
		dateDelta=$(bc <<< "$dateB - $dateA")
		#echo "$dateDelta"
		
		if [[ "$dateDelta" -lt 0 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ "$dateDelta" -gt 14 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		let iterations="$iterations + 1"
	done
	
	_stop 0
}

_test_selfTime() {
	"$scriptAbsoluteLocation" _test_selfTime_sequence "$@"
}


_test_bashTime_sequence() {
	_start
	
	local iterations
	
	local dateA
	local dateB
	local dateDelta
	
	
	iterations=0
	while [[ "$iterations" -lt 3 ]]
	do
		dateA=$(date +%s)
		! echo 'echo fake interactive' | bash -i > /dev/null 2>&1 && _messageFAIL && _stop 1
		echo 'false' | bash -i > /dev/null 2>&1 && _messageFAIL && _stop 1
		! echo 'echo fake interactive' | dash -i > /dev/null 2>&1 && _messageFAIL && _stop 1
		echo 'false' | dash -i > /dev/null 2>&1 && _messageFAIL && _stop 1
		dateB=$(date +%s)
		
		dateDelta=$(bc <<< "$dateB - $dateA")
		#echo "$dateDelta"
		
		if [[ "$dateDelta" -lt 0 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ "$dateDelta" -gt 14 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		let iterations="$iterations + 1"
	done
	
	_stop 0
}

_test_bashTime() {
	"$scriptAbsoluteLocation" _test_bashTime_sequence "$@"
}


# https://stackoverflow.com/questions/4774358/get-mtime-of-specific-file-using-bash
_test_filemtime_sequence() {
	_start
	
	local iterations
	
	local currentFileMtimeA
	local currentFileMtimeB
	local currentFileMtimeDelta
	
	
	iterations=0
	while [[ "$iterations" -lt 3 ]]
	do
		echo > "$safeTmp"/test_filemtime
		currentFileMtimeA=$(stat -c %Y "$safeTmp"/test_filemtime)
		sleep 2
		touch "$safeTmp"/test_filemtime
		currentFileMtimeB=$(stat -c %Y "$safeTmp"/test_filemtime)
		
		currentFileMtimeDelta=$(bc <<< "$currentFileMtimeB - $currentFileMtimeA")
		#echo "$currentFileMtimeDelta"
		
		if [[ "$currentFileMtimeDelta" -lt 1 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ "$currentFileMtimeDelta" -gt 12 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		let iterations="$iterations + 1"
	done
	
	
	iterations=0
	while [[ "$iterations" -lt 3 ]]
	do
		echo > "$safeTmp"/test_filemtime
		currentFileMtimeA=$(stat -c %Y "$safeTmp"/test_filemtime)
		sleep 2
		echo 'x' >> "$safeTmp"/test_filemtime
		currentFileMtimeB=$(stat -c %Y "$safeTmp"/test_filemtime)
		
		currentFileMtimeDelta=$(bc <<< "$currentFileMtimeB - $currentFileMtimeA")
		#echo "$currentFileMtimeDelta"
		
		if [[ "$currentFileMtimeDelta" -lt 1 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ "$currentFileMtimeDelta" -gt 12 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		let iterations="$iterations + 1"
	done
	
	
	iterations=0
	while [[ "$iterations" -lt 3 ]]
	do
		if ! rm -f "$safeTmp"/test_filemtime
		then
			_messageFAIL
			_stop 1
		fi
		echo > "$safeTmp"/test_filemtime
		if ! find "$safeTmp"/ -type f -mmin 0.19 | grep test_filemtime > /dev/null 2>&1
		then
			_messageFAIL
			_stop 1
		fi
		if ! find "$safeTmp"/ -type f -mmin -0.19 | grep test_filemtime > /dev/null 2>&1
		then
			_messageFAIL
			_stop 1
		fi
		
		sleep 16
		if find "$safeTmp"/ -type f -mmin 0.19 | grep test_filemtime > /dev/null 2>&1
		then
			_messageFAIL
			_stop 1
		fi
		if find "$safeTmp"/ -type f -mmin -0.19 | grep test_filemtime > /dev/null 2>&1
		then
			_messageFAIL
			_stop 1
		fi
		
		if ! find "$safeTmp"/ -type f -mmin 1 | grep test_filemtime > /dev/null 2>&1
		then
			_messageFAIL
			_stop 1
		fi
		if find "$safeTmp"/ -type f -mmin 2 | grep test_filemtime > /dev/null 2>&1
		then
			_messageFAIL
			_stop 1
		fi
		
		if ! find "$safeTmp"/ -type f -mmin -1 | grep test_filemtime > /dev/null 2>&1
		then
			_messageFAIL
			_stop 1
		fi
		if ! find "$safeTmp"/ -type f -mmin -2700 | grep test_filemtime > /dev/null 2>&1
		then
			_messageFAIL
			_stop 1
		fi
		
		let iterations="$iterations + 1"
	done
	
	
	_stop 0
}

_test_filemtime() {
	"$scriptAbsoluteLocation" _test_filemtime_sequence "$@"
}


_test_timeoutRead_slowByteRead() {
	while head --bytes=1
	do
		sleep 9
		#sleep 2
	done
}

_test_timeoutRead_multiByteRead() {
	#while head --bytes=3
	while dd bs="3" count=1 2>/dev/null
	do
		true
	done
}

_test_timeoutRead_bashRead() {
	# Inaccurate. Tests with random data ('/dev/urandom') seem to show errors.
	local currentString
	export IFS=
	export LANG=C
	export LC_ALL=C
	#LANG=C IFS= read -r -d '' -n 1 currentString
	while read -r -d '' -n 1 currentString
	do
		#[ "$currentString" ] && echo -n "$currentString" || echo
		[ "$currentString" ] && printf '%b' "$currentString" || echo
	done
}

_test_timeoutRead_read() {
	local currentIterations
	currentIterations=0
	while _timeout 0.1 cat 2>/dev/null && true | ( [[ "$currentIterations" -lt "$1" ]] )
	do
		true | (sleep 6 ; echo -n x)
		#true | (sleep 1 ; echo -n x)
		let currentIterations="$currentIterations"' + 1'
	done
}

_test_timeoutRead_procedure() {
	
	# Applying 'timeout' to 'echo' may have no effect (presumably due to immediately filling pipe buffer).
	# Applying 'timeout' to 'slowByteRead' should be able to limit the number of input characters. A 8s timeout at 3s/b read rate should apparently interrupt '12345' at '123'.
	# Applying timeout to '_test_timeoutRead_read' should immediately terminate all processes in the processing chain (presumably due to pipe close).
	
	#_timeout 75 echo '12345' | _timeout 26 _test_timeoutRead_slowByteRead | _timeout 75 _test_timeoutRead_multiByteRead | _timeout 75 _test_timeoutRead_bashRead | _timeout 75 _test_timeoutRead_read 6
	
	_timeout 75 echo '12345' | _timeout 75 _test_timeoutRead_multiByteRead | _timeout 26 _test_timeoutRead_slowByteRead | _timeout 75 _test_timeoutRead_bashRead | _timeout 75 _test_timeoutRead_read 6
	
	
	true
}

_test_timeoutRead() {
	#true | "$scriptAbsoluteLocation" _test_timeoutRead_procedure "$@" | cat
	#return 0
	
	local currentString
	currentString=$(true | "$scriptAbsoluteLocation" _test_timeoutRead_procedure "$@" | cat)
	#echo "$currentString"
	
	[[ "$currentString" == "" ]] && _stop 1
	[[ "$currentString" != "1xx2x3xxx" ]] && _stop 1
	[[ $(echo -n "$currentString" | wc -c) != '9' ]] && _stop 1
	
	return 0
}





