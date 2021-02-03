

# "$1" == 'tickFile'
_read_single() {
	measureTickA=$(head -n 1 "$1" 2>/dev/null)
	[[ "$measureTickA" != '0' ]] && [[ "$measureTickA" != '1' ]] && [[ "$measureTickA" != '2' ]] && return 0
	
	measureTickB=$(head -n 1  "$1"-prev-$sessionid 2>/dev/null)
	
	[[ "$measureTickB" == '' ]] && measureTickB='doNotMatch'
	[[ "$measureTickA" == "$measureTickB" ]] && return 0
	
	currentExitStatus='0'
	
	cat ${1/-tick/}-"$measureTickA" 2>/dev/null
	[[ "$?" != '0' ]] && currentExitStatus='1'
	
	cp "$1" "$1"-prev-$sessionid 2>/dev/null
	[[ "$?" != '0' ]] && currentExitStatus='1'
	
	if [[ "$currentExitStatus" != '0' ]]
	then
		rm -f "$1" > /dev/null 2>&1
		return "$currentExitStatus"
	fi
	
	return 0
}



