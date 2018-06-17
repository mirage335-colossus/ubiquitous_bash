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

_terminateAll() {
	local processListFile
	processListFile="$scriptAbsoluteFolder"/.pidlist_$(_uid)
	
	local currentPID
	
	cat ./w_*/.pid >> "$processListFile" 2> /dev/null
	cat ./.s_*/.pid >> "$processListFile" 2> /dev/null
	
	while read -r currentPID
	do
		pkill -P "$currentPID"
		kill "$currentPID"
	done < "$processListFile"
	
	rm "$processListFile"
}
