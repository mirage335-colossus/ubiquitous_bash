

# "$1" == 'tickFile'
_page_read_single() {
	local inputBufferDir="$1"
	if [[ "$inputBufferDir" == "" ]]
	then
		local current_demand_dir
		current_demand_dir=$(_demand_dir_broadcastPipe_page)
		[[ "$current_demand_dir" == "" ]] && _stop 1
		
		inputBufferDir="$current_demand_dir"/outputBufferDir
	fi
	
	measureTickA=$(head -n 1 "$inputBufferDir" 2>/dev/null)
	[[ "$measureTickA" != '0' ]] && [[ "$measureTickA" != '1' ]] && [[ "$measureTickA" != '2' ]] && return 0
	
	measureTickB=$(head -n 1  "$inputBufferDir"-prev-$sessionid 2>/dev/null)
	
	[[ "$measureTickB" == '' ]] && measureTickB='doNotMatch'
	[[ "$measureTickA" == "$measureTickB" ]] && return 0
	
	currentExitStatus='0'
	
	cat ${1/-tick/}-"$measureTickA" 2>/dev/null
	[[ "$?" != '0' ]] && currentExitStatus='1'
	
	cp "$inputBufferDir" "$inputBufferDir"-prev-$sessionid 2>/dev/null
	[[ "$?" != '0' ]] && currentExitStatus='1'
	
	if [[ "$currentExitStatus" != '0' ]]
	then
		rm -f "$inputBufferDir" > /dev/null 2>&1
		return "$currentExitStatus"
	fi
	
	return 0
}



