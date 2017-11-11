_messageNormal() {
	echo -e -n '\E[1;32;46m '
	echo -n "$@"
	echo -e -n ' \E[0m'
	echo
}

_messageError() {
	echo -e -n '\E[1;33;41m '
	echo -n "$@"
	echo -e -n ' \E[0m'
	echo
}

_messageNEED() {
	_messageNormal "NEED"
	#echo " NEED "
}

_messageHAVE() {
	_messageNormal "HAVE"
	#echo " HAVE "
}

_messageWANT() {
	_messageNormal "WANT"
	#echo " WANT "
}

_messagePASS() {
	_messageNormal "PASS"
	#echo " PASS "
}

_messageFAIL() {
	_messageError "FAIL"
	#echo " FAIL "
	_stop 1
}

_messageWARN() {
	echo
	echo "$@"
}


_messageProcess() {
	local processString
	processString="$1""..."
	
	local processStringLength
	processStringLength=${#processString}
	
	local currentIteration
	currentIteration=0
	
	local padLength
	let padLength=40-"$processStringLength"
	
	[[ "$processStringLength" -gt "38" ]] && _messageNormal "$processString" && return
	
	echo -e -n '\E[1;32;46m '
	
	echo -n "$processString"
	
	echo -e -n '\E[0m'
	
	while [[ "$currentIteration" -lt "$padLength" ]]
	do
		echo -e -n ' '
		let currentIteration="$currentIteration"+1
	done
	
}
