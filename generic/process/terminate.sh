_terminate() {
	local processListFile
	processListFile="$scriptAbsoluteFolder"/.pidlist_$(_uid)
	
	local currentPID
	
	cat "$safeTmp"/.pid >> "$processListFile" 2> /dev/null
	
	while read -r currentPID
	do
		pkill -P "$currentPID"
		kill "$currentPID"
	done < "$processListFile"
	
	rm "$processListFile"
}

_terminateMetaHostAll() {
	! ls -d -1 ./.m_*/.pid > dev/null 2>&1 && return 0
	
	local processListFile
	processListFile="$scriptAbsoluteFolder"/.pidlist_$(_uid)
	
	local currentPID
	
	cat ./.m_*/.pid >> "$processListFile" 2> /dev/null
	
	while read -r currentPID
	do
		pkill -P "$currentPID"
		kill "$currentPID"
	done < "$processListFile"
	
	rm "$processListFile"
	
	! ls -d -1 ./.m_*/.pid > dev/null 2>&1 && return 0
	sleep 0.3
	! ls -d -1 ./.m_*/.pid > dev/null 2>&1 && return 0
	sleep 1
	! ls -d -1 ./.m_*/.pid > dev/null 2>&1 && return 0
	sleep 3
	! ls -d -1 ./.m_*/.pid > dev/null 2>&1 && return 0
	sleep 10
	! ls -d -1 ./.m_*/.pid > dev/null 2>&1 && return 0
	sleep 20
	! ls -d -1 ./.m_*/.pid > dev/null 2>&1 && return 0
	sleep 20
	! ls -d -1 ./.m_*/.pid > dev/null 2>&1 && return 0
	sleep 20
	! ls -d -1 ./.m_*/.pid > dev/null 2>&1 && return 0
	
	return 1
}

_terminateAll() {
	_terminateMetaHostAll
	
	local processListFile
	processListFile="$scriptAbsoluteFolder"/.pidlist_$(_uid)
	
	local currentPID
	
	
	cat ./.s_*/.pid >> "$processListFile" 2> /dev/null
	
	cat ./.e_*/.pid >> "$processListFile" 2> /dev/null
	cat ./.m_*/.pid >> "$processListFile" 2> /dev/null
	
	cat ./w_*/.pid >> "$processListFile" 2> /dev/null
	
	while read -r currentPID
	do
		pkill -P "$currentPID"
		kill "$currentPID"
	done < "$processListFile"
	
	rm "$processListFile"
}
