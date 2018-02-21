_terminateAll() {
	local processListFile
	processListFile="$scriptAbsoluteFolder"/.pidlist_$(_uid)
	
	local currentPID
	
	cat ./w_*/.pid > "$processListFile"
	
	while read -r currentPID
	do
		pkill -P "$currentPID"
		pkill "$currentPID"
	done < "$processListFile"
	
	rm "$processListFile"
}
