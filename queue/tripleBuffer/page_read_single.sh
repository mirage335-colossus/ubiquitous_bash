

# "$1" == 'tickFile'
_page_read_single() {
	local inputTickFile="$1"
	local inputFilesPrefix="$2"
	if [[ "$inputTickFile" == "" ]]
	then
		local current_demand_dir
		current_demand_dir=$(_demand_dir_broadcastPipe_page)
		[[ "$current_demand_dir" == "" ]] && _stop 1
		
		inputTickFile="$current_demand_dir"/outputBufferDir/out-tick
	fi
	
	measureTickA=$(head -n 1 "$inputTickFile" 2>/dev/null)
	[[ "$measureTickA" != '0' ]] && [[ "$measureTickA" != '1' ]] && [[ "$measureTickA" != '2' ]] && return 0
	
	measureTickB=$(head -n 1  "$inputTickFile"-prev-$sessionid 2>/dev/null)
	
	[[ "$measureTickB" == '' ]] && measureTickB='doNotMatch'
	[[ "$measureTickA" == "$measureTickB" ]] && return 0
	
	currentExitStatus='0'
	
	cat ${1/-tick/}-"$measureTickA" 2>/dev/null
	[[ "$?" != '0' ]] && currentExitStatus='1'
	
	cp "$inputTickFile" "$inputTickFile"-prev-$sessionid 2>/dev/null
	[[ "$?" != '0' ]] && currentExitStatus='1'
	
	if [[ "$currentExitStatus" != '0' ]]
	then
		rm -f "$inputTickFile" > /dev/null 2>&1
		return "$currentExitStatus"
	fi
	
	return 0
}



