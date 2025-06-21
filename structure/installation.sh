#####Installation

_installation_nonet_default() {
	if [[ "$nonet" != 'false' ]]
	then
		[[ "$scriptAbsoluteFolder" == /media/"$USER"* ]] && [[ -e /media/"$USER" ]] && export nonet='true'
		[[ "$scriptAbsoluteFolder" == /mnt/"$USER"* ]] && [[ -e /mnt/"$USER" ]] && export nonet='true'
		[[ "$scriptAbsoluteFolder" == /var/run/media/"$USER"* ]] && [[ -e /var/run/media/"$USER" ]] && export nonet='true'
		[[ "$scriptAbsoluteFolder" == /run/"$USER"* ]] && [[ -e /run/"$USER" ]] && currentParameter=/run/"$USER" && export nonet='true'
		[[ "$scriptAbsoluteFolder" == "/cygdrive"* ]] && [[ -e /cygdrive ]] && export nonet='true'
	fi
	
	return 0
}

_vector_line_cksum() {
	[[ $(echo test | env CMD_ENV=xpg4 cksum | cut -f1 -d\  | tr -dc '0-9') != '935282863' ]] && echo 'broken cksum' && _messageFAIL && _stop 1
	
	[[ $(echo -e '1\n2\n3\n4\n5\n6\n7\n8\n9\n0' | tail -n +2 | env CMD_ENV=xpg4 cksum | cut -f1 -d\  | tr -dc '0-9') != '2409981071' ]] && _messageFAIL && _stop 1
	[[ $(echo -e '1\n2\n3\n4\n5\n6\n7\n8\n9\n0' | tail -n +2 | wc -l | cut -f1 -d\  | tr -dc '0-9') != '9' ]] && _messageFAIL && _stop 1
	
	[[ $(echo -e '1\n2\n3\n4\n5\n6\n7\n8\n9\n0' | tail -n 2 | env CMD_ENV=xpg4 cksum | cut -f1 -d\  | tr -dc '0-9') != '763220757' ]] && _messageFAIL && _stop 1
	[[ $(echo -e '1\n2\n3\n4\n5\n6\n7\n8\n9\n0' | tail -n 2 | wc -l | cut -f1 -d\  | tr -dc '0-9') != '2' ]] && _messageFAIL && _stop 1
	
	[[ $(echo -e '1\n2\n3\n4\n5\n6\n7\n8\n9\n0' | head -n 2 | env CMD_ENV=xpg4 cksum | cut -f1 -d\  | tr -dc '0-9') != '1864731933' ]] && _messageFAIL && _stop 1
	[[ $(echo -e '1\n2\n3\n4\n5\n6\n7\n8\n9\n0' | head -n 2 | wc -l | cut -f1 -d\  | tr -dc '0-9') != '2' ]] && _messageFAIL && _stop 1
	
	[[ $(echo -e '1\n2\n3\n4\n5\n6\n7\n8\n9\n0' | head -n -2 | env CMD_ENV=xpg4 cksum | cut -f1 -d\  | tr -dc '0-9') != '3336706933' ]] && _messageFAIL && _stop 1
	[[ $(echo -e '1\n2\n3\n4\n5\n6\n7\n8\n9\n0' | head -n -2 | wc -l | cut -f1 -d\  | tr -dc '0-9') != '8' ]] && _messageFAIL && _stop 1
	
	return 0
}

_vector() {
	_tryExec "_vector_line_cksum"
	
	
	_tryExec "_vector_virtUser"


	_tryExec "_vector_wget_githubRelease-URL-gh"
	
	
	_tryExec "_vector_ollama"
}




#Verifies the timeout and sleep commands work properly, with subsecond specifications.
_timetest() {
	local iterations
	local dateA
	local dateB
	local dateDelta
	
	local nsDateA
	local nsDateB
	local nsDateDelta
	
	iterations=0
	#while false && [[ "$iterations" -lt 3 ]]
	while [[ "$iterations" -lt 3 ]]
	do
		dateA=$(date +%s)
		nsDateA=$(date +%s%N)
		
		sleep 0.1
		sleep 0.1
		sleep 0.1
		sleep 0.1
		sleep 0.1
		sleep 0.1
		
		_timeout 0.1 sleep 10
		_timeout 0.1 sleep 10
		_timeout 0.1 sleep 10
		_timeout 0.1 sleep 10
		_timeout 0.1 sleep 10
		_timeout 0.1 sleep 10
		
		dateB=$(date +%s)
		nsDateB=$(date +%s%N)
		
		dateDelta=$(bc <<< "$dateB - $dateA")
		nsDateDelta=$(bc <<< "$nsDateB - $nsDateA")
		
		if [[ "$dateDelta" -lt "1" ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ "$dateDelta" -gt "5" ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | wc -c) != '10' ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ "$nsDateDelta" -lt '1000000000' ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-4) -lt 1000 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-8) -gt '50000000' ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-4) -gt 5000 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		
		
		
		
		dateA=$(date +%s)
		nsDateA=$(date +%s%N)
		
		sleep 0.123
		sleep 0.123
		sleep 0.123
		sleep 0.123
		sleep 0.123
		sleep 0.123
		
		_timeout 0.123 sleep 10
		_timeout 0.123 sleep 10
		_timeout 0.123 sleep 10
		_timeout 0.123 sleep 10
		_timeout 0.123 sleep 10
		_timeout 0.123 sleep 10
		
		dateB=$(date +%s)
		nsDateB=$(date +%s%N)
		
		dateDelta=$(bc <<< "$dateB - $dateA")
		nsDateDelta=$(bc <<< "$nsDateB - $nsDateA")
		
		if [[ "$dateDelta" -lt "1" ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ "$dateDelta" -gt "5" ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | wc -c) != '10' ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ "$nsDateDelta" -lt '1000000000' ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-4) -lt 1000 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-8) -gt '50000000' ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-4) -gt 5000 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		
		
		
		dateA=$(date +%s)
		nsDateA=$(date +%s%N)
		
		sleep .123
		sleep .123
		sleep .123
		sleep .123
		sleep .123
		sleep .123
		
		_timeout .123 sleep 10
		_timeout .123 sleep 10
		_timeout .123 sleep 10
		_timeout .123 sleep 10
		_timeout .123 sleep 10
		_timeout .123 sleep 10
		
		dateB=$(date +%s)
		nsDateB=$(date +%s%N)
		
		dateDelta=$(bc <<< "$dateB - $dateA")
		nsDateDelta=$(bc <<< "$nsDateB - $nsDateA")
		
		if [[ "$dateDelta" -lt "1" ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ "$dateDelta" -gt "5" ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | wc -c) != '10' ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ "$nsDateDelta" -lt '1000000000' ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-4) -lt 1000 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-8) -gt '50000000' ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-4) -gt 5000 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		
		
		
		let iterations="$iterations + 1"
	done
	
	
	local nsDateC
	local nsDateD
	local nsDateDeltaA
	local nsDateDeltaB
	local msIterations
	
	if uname -a | grep -i 'cygwin' > /dev/null 2>&1
	then
		nsDateA=$(date +%s%N)
		for msIterations in {1..100}
		do
			sleep 0.011
		done
		nsDateB=$(date +%s%N)
		
		#nsDateC=$(date +%s%N)
		nsDateC="$nsDateB"
		for msIterations in {1..100}
		do
			sleep 0.091
		done
		nsDateD=$(date +%s%N)
		
		nsDateDeltaA=$(bc <<< "$nsDateB - $nsDateA")
		nsDateDeltaB=$(bc <<< "$nsDateD - $nsDateC")
		nsDateDelta=$(bc <<< "$nsDateDeltaB - $nsDateDeltaA")
		
		#echo "$nsDateDelta"
		
		
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-8) -lt '10000000' ]]
		then
			_messageFAIL
			_stop 1
		fi
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-8) -gt '640000000' ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-4) -lt '1000' ]]
		then
			_messageFAIL
			_stop 1
		fi
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-4) -gt '64000' ]]
		then
			_messageFAIL
			_stop 1
		fi
	else
		nsDateA=$(date +%s%N)
		for msIterations in {1..100}
		do
			sleep 0.001
		done
		nsDateB=$(date +%s%N)
		
		#nsDateC=$(date +%s%N)
		nsDateC="$nsDateB"
		for msIterations in {1..100}
		do
			sleep 0.009
		done
		nsDateD=$(date +%s%N)
		
		nsDateDeltaA=$(bc <<< "$nsDateB - $nsDateA")
		nsDateDeltaB=$(bc <<< "$nsDateD - $nsDateC")
		nsDateDelta=$(bc <<< "$nsDateDeltaB - $nsDateDeltaA")
		
		#echo "$nsDateDelta"
		
		
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-8) -lt '10000000' ]]
		then
			_messageFAIL
			_stop 1
		fi
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-8) -gt '640000000' ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-4) -lt '1000' ]]
		then
			_messageFAIL
			_stop 1
		fi
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-4) -gt '64000' ]]
		then
			_messageFAIL
			_stop 1
		fi
	fi
	
	
	
	
	_messagePASS
	return 0
}


_testarglength() {
	local testArgLength
	
	! testArgLength=$(getconf ARG_MAX) && _messageFAIL && _stop 1
	
	
	# Typical UNIX.
	# && [[ "$testArgLength" != "" ]]
	if [[ "$testArgLength" -lt 131071 ]] && [[ "$testArgLength" != "-1" ]] && [[ "$testArgLength" != "undefined" ]]
	then

		# Typical Cygwin. Marginal result at best.
		[[ "$testArgLength" -ge 32000 ]] && uname -a | grep -i 'cygwin' > /dev/null 2>&1 && _messagePASS && return 0
		if _if_cygwin
		then
			# Fortunately, as of 2023-09-08 , from questions to the Cygwin mailing list, reportedly the undefined 'ARG_MAX' is a standards compliant delimiter of no limit except system resource limit.
			# Unfortunately, as of 2023-09-07 , apparently Cygwin has removed the 'ARG_MAX' definition from the provided 'getconf' .
			# Due to the narrower use case of Cygwin/MSW (as opposed to GNU/Linux) - not expecting to compile gEDA for Cygwin anytime soon - it will be more of a concern if other binaries in 'ubcp' cease to exist because newer versions of Cygwin packages upstream were failing to compile as a result. Hopefully, Cygwin itself has adequate testing to prevent release of such breakage.
			#echo "$testArgLength"
			return 0
		fi
		
		_messageFAIL && _stop 1
	fi
	
	_messagePASS
}



_variableLocalTestA_procedure() {
	local currentLocalA
	currentLocalA='false'
	[[ "$currentGlobalA" != 'true' ]] && _stop 1
	[[ "$currentLocalA" == '' ]] && _stop 1
	[[ "$currentLocalA" != 'false' ]] && _stop 1
	
	local currentLocalB
	currentLocalB='true'
	
	currentNotLocalA='true'
	
	
	return 0
}

_variableLocalTestB_procedure() {
	[[ "$currentGlobalA" != 'true' ]] && return 1
	[[ "$currentLocalA" != '' ]] && return 1
	[[ "$currentLocalA" == 'true' ]] && return 1
	
	return 0
}

_variableLocalTestC_procedure() {
	[[ "$currentGlobalA" != '' ]] && _stop 1
	[[ "$currentGlobalA" == 'true' ]] && _stop 1
	
	return 0
}

_variableLocalTest_sequence() {
	_start scriptLocal_mkdir_disable
	
	variableLocalTest_currentSubFunction() {
		if ! [[ "$currentSubFunctionTest" == "true" ]] || ! [[ $(echo "$currentSubFunctionTest") == "true" ]]
		then
			_stop 1
			return 1
		fi
		return 0
	}
	local currentSubFunctionTest
	currentSubFunctionTest='true'
	! variableLocalTest_currentSubFunction && _stop 1
	
	
	local currentSubshellTest1=$(
		echo x
	)
	[[ "$currentSubshellTest1" != 'x' ]] && _stop 1
	
	local currentSubshellTest2
	currentSubshellTest2=$(
		echo x
	)
	[[ "$currentSubshellTest2" != 'x' ]] && _stop 1
	
	
	echo $(
		echo 1
		echo 2
	) | grep '1 2' > /dev/null || _stop 1
	
	! echo $(
		echo 1
		echo 2
	) | grep '1 2' > /dev/null && _stop 1
	
	
	export currentGlobalA='true'
	
	local currentLocalA
	currentLocalA='true'
	
	( export currentSubshellTestA='true' )
	[[ ! -z "$currentSubshellTestA" ]] && _stop 1
	[[ "$currentSubshellTestA" != "" ]] && _stop 1
	[[ "$currentSubshellTestA" != '' ]] && _stop 1
	[[ "$currentSubshellTestA" == 'true' ]] && _stop 1
	
	( currentSubshellTestB='true' )
	[[ "$currentSubshellTestB" != "" ]] && _stop 1
	[[ "$currentSubshellTestB" == 'true' ]] && _stop 1
	
	( local currentSubshellTestC='true' )
	[[ "$currentSubshellTestC" != "" ]] && _stop 1
	[[ "$currentSubshellTestC" == 'true' ]] && _stop 1
	
	
	export currentGlobalSubshellTest="true"
	if [[ $( ( echo "$currentGlobalSubshellTest" ) ) != "true" ]]
	then
		_stop 1
	fi
	if [[ $( ( export currentGlobalSubshellTest="false" ; echo "$currentGlobalSubshellTest" ) ) != "false" ]]
	then
		_stop 1
	else
		true
	fi
	if [[ $( ( echo "$currentGlobalSubshellTest" ) ) != "true" ]]
	then
		_stop 1
	fi
	if [[ "$currentGlobalSubshellTest" != "true" ]]
	then
		_stop 1
	fi
	
	
	! ( echo true ) | grep 'true' > /dev/null && _stop 1
	! ( echo "$currentGlobalA" ) | grep 'true' > /dev/null && _stop 1
	! ( echo "$currentLocalA" ) | grep 'true' > /dev/null && _stop 1
	( echo "$currentLocalB" ) | grep 'true' > /dev/null && _stop 1
	
	[[ "$currentLocalA" != 'true' ]] && _stop 1
	! _variableLocalTestA_procedure && _stop 1
	[[ "$currentLocalA" != 'true' ]] && _stop 1
	[[ "$currentLocalB" != '' ]] && _stop 1
	[[ "$currentLocalB" == 'true' ]] && _stop 1
	[[ "$currentNotLocalA" != 'true' ]] && _stop 1
	
	_variableLocalTestB_procedure && _stop 1
	! "$scriptAbsoluteLocation" _variableLocalTestB_procedure && _stop 1
	
	local currentGlobalA
	! _variableLocalTestC_procedure && _stop 1
	
	export currentGlobalB='false'
	local currentGlobalB='true'
	[[ "$currentGlobalB" != 'true' ]] && _stop 1
	
	local currentLocalB='true'
	! ( echo "$currentLocalB" ) | grep 'true' > /dev/null && _stop 1
	[[ "$currentLocalB" != 'true' ]] && _stop 1
	
	local currentLocalC='true'
	[[ "$currentLocalC" != 'true' ]] && _stop 1
	
	! env -i  HOME="$HOME" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" PWD="$PWD" scriptAbsoluteLocation="$scriptAbsoluteLocation" scriptAbsoluteFolder="$scriptAbsoluteFolder" sessionid="$sessionid" LD_PRELOAD="$LD_PRELOAD" USER="$USER" "bash" -c '[[ "$sessionid" != "" ]]' && _stop 1
	env -i  HOME="$HOME" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" PWD="$PWD" scriptAbsoluteLocation="$scriptAbsoluteLocation" scriptAbsoluteFolder="$scriptAbsoluteFolder" sessionid="" LD_PRELOAD="$LD_PRELOAD" USER="$USER" "bash" -c '[[ "$sessionid" != "" ]]' && _stop 1
	env -i HOME="$HOME" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" PWD="$PWD" scriptAbsoluteLocation="$scriptAbsoluteLocation" scriptAbsoluteFolder="$scriptAbsoluteFolder" LD_PRELOAD="$LD_PRELOAD" USER="$USER" "bash" -c '[[ "$sessionid" != "" ]]' && _stop 1
	
	local currentBashBinLocation
	currentBashBinLocation=$(type -p bash)
	[[ "$sessionid" == '' ]] &&  _stop 1
	! env -i sessionid="$sessionid" "$currentBashBinLocation" -c '[[ "$sessionid" != "" ]]' && _stop 1
	env -i sessionid="" "$currentBashBinLocation" --norc -c '[[ "$sessionid" != "" ]]' && _stop 1
	env -i "$currentBashBinLocation" --norc -c '[[ "$sessionid" != "" ]]' && _stop 1
	
	
	
	local currentVariableFunctionText
	
	export UB_TEST_VARIABLE_FUNCTION_COMMAND='_variableFunction_variableLocalTest() { echo true; }'' ; _variableFunction_variableLocalTest'
	currentVariableFunctionText=$(bash -c "$UB_TEST_VARIABLE_FUNCTION_COMMAND")
	#currentVariableFunctionText=$($UB_TEST_VARIABLE_FUNCTION_COMMAND)
	[[ "$currentVariableFunctionText" != "true" ]] && _messageFAIL && _stop 1
	export UB_TEST_VARIABLE_FUNCTION_COMMAND=
	unset UB_TEST_VARIABLE_FUNCTION_COMMAND
	
	_exportFunction_variableLocalTest() {
		echo true
	}
	currentVariableFunctionText=$(bash -c '_exportFunction_variableLocalTest' 2>/dev/null)
	[[ "$currentVariableFunctionText" != "" ]] && _messageFAIL && _stop 1
	export -f _exportFunction_variableLocalTest
	currentVariableFunctionText=$(bash -c '_exportFunction_variableLocalTest' 2>/dev/null)
	[[ "$currentVariableFunctionText" != "true" ]] && _messageFAIL && _stop 1
	unset _exportFunction_variableLocalTest
	
	
	_currentFunctionDefinitionTest() { echo false; }
	true && _currentFunctionDefinitionTest() { echo true; }
	false && _currentFunctionDefinitionTest() { echo false; }
	[[ $(_currentFunctionDefinitionTest) != "true" ]] && _messageFAIL && _stop 1
	unset _currentFunctionDefinitionTest
	
	
	local doubleLocalDefinitionA
	doubleLocalDefinitionA=1
	local doubleLocalDefinitionA
	doubleLocalDefinitionA=2
	[[ "$doubleLocalDefinitionA" != "2" ]] && _messageFAIL && _stop 1
	local doubleLocalDefinitionA=3
	[[ "$doubleLocalDefinitionA" != "3" ]] && _messageFAIL && _stop 1
	local doubleLocalDefinitionA
	doubleLocalDefinitionA=4
	[[ "$doubleLocalDefinitionA" != "4" ]] && _messageFAIL && _stop 1
	export doubleLocalDefinitionA=5
	[[ "$doubleLocalDefinitionA" != "5" ]] && _messageFAIL && _stop 1
	local doubleLocalDefinitionA=6
	[[ "$doubleLocalDefinitionA" != "6" ]] && _messageFAIL && _stop 1
	doubleLocalDefinitionA=7
	[[ "$doubleLocalDefinitionA" != "7" ]] && _messageFAIL && _stop 1
	local doubleLocalDefinitionA=8
	[[ "$doubleLocalDefinitionA" != "8" ]] && _messageFAIL && _stop 1
	unset doubleLocalDefinitionA
	[[ "$doubleLocalDefinitionA" != "" ]] && _messageFAIL && _stop 1
	

	variableLocalTest_evalTest() { local currentVariableNum=1 ; eval local currentVariable_${currentVariableNum}_currentData=PASS ; ( eval "[[ \$currentVariable_${currentVariableNum}_currentData == PASS ]]" && eval "[[ \$currentVariable_${currentVariableNum}_currentData != '' ]]" && eval "echo \$currentVariable_${currentVariableNum}_currentData" ) ;} ; variableLocalTest_evalTest > /dev/null ; [[ $(variableLocalTest_evalTest) != "PASS" ]] && _messageFAIL && _stop 1


	! [[ $(currentVariable=currentValue /bin/bash --norc -c 'echoVariableTest() { echo $currentVariable ; } ; echoVariableTest') == "currentValue" ]] && _messageFAIL && _stop 1
	! [[ $(currentVariable=currentValue currentVariable=currentValue /bin/bash --norc -c 'echoVariableTest() { echo $currentVariable ; } ; echoVariableTest') == "currentValue" ]] && _messageFAIL && _stop 1
	! [[ $(currentVariable=currentValueA currentVariable=currentValueB /bin/bash --norc -c 'echoVariableTest() { echo $currentVariable ; } ; echoVariableTest') == "currentValueB" ]] && _messageFAIL && _stop 1

	_stop
}


_variableLocalTest() {
	if "$scriptAbsoluteLocation" _variableLocalTest_sequence "$@"
	then
		return 0
	fi
	return 1
}


_uid_test() {
	local current_uid_1
	local current_uid_2
	local current_uid_3
	
	current_uid_1=$(_uid)
	current_uid_2=$(_uid)
	current_uid_3_char=$(_uid 8 | wc -c)
	
	if [[ "$current_uid_1" == "" ]]
	then
		_messageFAIL
		_stop 1
	fi
	
	if [[ "$current_uid_2" == "" ]]
	then
		_messageFAIL
		_stop 1
	fi
	
	if [[ "$current_uid_1" == "$current_uid_2" ]]
	then
		_messageFAIL
		_stop 1
	fi
	
	if [[ "$current_uid_3_char" != "8" ]]
	then
		_messageFAIL
		_stop 1
	fi
	
	return 0
}


# Creating a function from within a function may be relied upon for some overrides.
# Enumerating a function's text with 'declare -f' may be relied upon by some 'here document' functions.
_define_function_test() {
	local current_uid_1
	current_uid_1=$(_uid)
	
	local current_uid_2
	current_uid_2=$(_uid)
	
	# https://stackoverflow.com/questions/7145337/bash-how-do-i-create-function-from-variable
	eval "__$current_uid_1() { __$current_uid_2() { echo $ubiquitousBashID; }; }"
	
	if [[ $(declare -f __$current_uid_1 | wc -c) -lt 50 ]]
	then
		_messageFAIL
		_stop 1
	fi
	
	if [[ $(declare -f __$current_uid_2 | wc -c) -gt 0 ]]
	then
		_messageFAIL
		_stop 1
	fi
	
	__$current_uid_1
	
	if [[ $(declare -f __$current_uid_2 | wc -c) -lt 15 ]]
	then
		_messageFAIL
		_stop 1
	fi
	
	# https://superuser.com/questions/154332/how-do-i-unset-or-get-rid-of-a-bash-function
	unset -f __$current_uid_2
	
	if [[ $(declare -f __$current_uid_2 | wc -c) -gt 0 ]]
	then
		_messageFAIL
		_stop 1
	fi
	
	if [[ $(declare -f __$current_uid_1 | wc -c) -lt 50 ]]
	then
		_messageFAIL
		_stop 1
	fi
	
	unset -f __$current_uid_1
	
	if [[ $(declare -f __$current_uid_1 | wc -c) -gt 0 ]]
	then
		_messageFAIL
		_stop 1
	fi
	
	
	return 0
}

#_test_prog() {
#	true
#}

_test_embed_procedure-embed() {
	#echo $ub_import
	#echo $ub_import_param
	
	[[ "$ub_import" != 'true' ]] && return 1
	[[ "$ub_import" == '' ]] && return 1
	[[ "$ub_import_param" != '--embed' ]] && return 1
	
	#_stop 0
	#return 0
	true
}

_test_embed_sequence() {
	_start scriptLocal_mkdir_disable
	
	#echo $ub_import
	#echo $ub_import_param
	
	# CAUTION: Profoundly unexpected to have called '_test' or similar functions after importing into a current shell in any way.
	if ( [[ "$current_internal_CompressedScript" == "" ]] && [[ "$current_internal_CompressedScript_cksum" == "" ]] && [[ "$current_internal_CompressedScript_bytes" == "" ]] ) || ( ( [[ "$ub_import_param" != "--embed" ]] ) && [[ "$ub_import_param" != "--bypass" ]] && [[ "$ub_import_param" != "--call" ]] && [[ "$ub_import_param" != "--script" ]] && [[ "$ub_import_param" != "--compressed" ]] )
	then
		[[ "$ub_import" == 'true' ]] && _messageFAIL && _stop 1
		[[ "$ub_import" != '' ]] && _messageFAIL && _stop 1
		[[ "$ub_import_param" != '' ]] && _messageFAIL && _stop 1
	fi
	
	! "$safeTmp"/.embed.sh _true && _stop 1
	
	"$safeTmp"/.embed.sh _false && _stop 1
	
	! "$safeTmp"/.embed.sh _test_embed_procedure-embed && _stop 1
	
	! . "$safeTmp"/.embed.sh _test_embed_procedure-embed && _stop 1
	
	_stop
}

_test_embed() {
	"$scriptAbsoluteLocation" _test_embed_sequence "$@"
}

_test_parallelFifo_procedure() {
	mkfifo "$safeTmp"/parallel_fifo
	cat "$safeTmp"/parallel_fifo > "$safeTmp"/parallel_fifo_out &
	
	local currentIterationsA
	currentIterationsA=0
	local currentIterationsB
	currentIterationsB=0
	
	while [[ "$currentIterationsA" -lt "2" ]]
	do
		echo a
		sleep 1
		let currentIterationsA="$currentIterationsA"" + 1"
	done | cat > "$safeTmp"/parallel_fifo &
	
	sleep 0.4
	
	while [[ "$currentIterationsB" -lt "2" ]]
	do
		echo b
		sleep 1
		let currentIterationsB="$currentIterationsB"" + 1"
	done | cat > "$safeTmp"/parallel_fifo
	
	sleep 1
	sleep 7
	
	
	#echo $(cat "$safeTmp"/parallel_fifo_out | tr -dc 'a-zA-Z0-9' 2> /dev/null)
	
	# WARNING: Strongly discouraged! Strict test highly dependent on unpredictable InterProcess-Communication timing requiring >7s latency margins at each 'step'!
	if _if_cygwin
	then
		[[ $(cat "$safeTmp"/parallel_fifo_out | tr -dc 'a-zA-Z0-9' 2> /dev/null) != "abab" ]] && _messageFAIL && return 1
	fi
	
	[[ $(cat "$safeTmp"/parallel_fifo_out | tr -dc 'a-zA-Z0-9' | wc -c) != "4" ]] && _messageFAIL && return 1
	
	
	rm -f "$safeTmp"/parallel_fifo
	rm -f "$safeTmp"/parallel_fifo_out
}

# No production use.
_test_parallelFifo_sequence() {
	_start scriptLocal_mkdir_disable
	
	_test_parallelFifo_procedure "$@"
	
	_stop
}

_test_pipe_true() {
	true | tee /dev/null 2>&1
}

# Apparently, shell script functions and conditions default to pipefail or pipestatus, although "$scriptAbsoluteLocation" is able to use the exit status instead.
_test_pipe_false() {
	false | tee /dev/null 2>&1
}
_test_pipe_false_condition() {
	#false | tee /dev/null 2>&1 && return 0
	false | echo stuff | grep stuff > /dev/null 2>&1 && return 0
	return 1
}
_test_pipe_false_condition_special() {
	false | tee /dev/null
	[[ "$?" == "0" ]] && return 0
	return 1
}

# Expect return true (ie. 0).
_test_pipefail_forcePlus_true_sequence() {
	set +o pipefail
	true | tee /dev/null 2>&1
}
_test_pipefail_forcePlus_true() {
	"$scriptAbsoluteLocation" _test_pipefail_forcePlus_true_sequence "$@"
}

# Expect return true (ie. 0).
_test_pipefail_forcePlus_false_sequence() {
	set +o pipefail
	false | tee /dev/null 2>&1
}
_test_pipefail_forcePlus_false() {
	"$scriptAbsoluteLocation" _test_pipefail_forcePlus_false_sequence "$@"
}

# Expect return true (ie. 0).
_test_pipefail_forceMinus_true_sequence() {
	set -o pipefail
	true | tee /dev/null 2>&1
}
_test_pipefail_forceMinus_true() {
	"$scriptAbsoluteLocation" _test_pipefail_forceMinus_true_sequence "$@"
}

# Expect return false (ie. 1).
_test_pipefail_forceMinus_false_sequence() {
	set -o pipefail
	false | tee /dev/null 2>&1
}
_test_pipefail_forceMinus_false() {
	"$scriptAbsoluteLocation" _test_pipefail_forceMinus_false_sequence "$@"
}

# https://stackoverflow.com/questions/6871859/piping-command-output-to-tee-but-also-save-exit-code-of-command
_test_pipestatus_true() {
	true | tee /dev/null 2>&1
	return ${PIPESTATUS[0]}
}

_test_pipestatus_false() {
	false | tee /dev/null 2>&1
	return ${PIPESTATUS[0]}
}

# ATTENTION: NOTICE: Regard this as a relatively definitive specification of known bash pipe 'exit status', 'pipestatus', 'pipefail', defaults and inheritance.
# WARNING: If 'bash' software interpreter uses same code paths (eg. for shell functions and subshells) do not assume this will always remain the case. Test and consider specifically and explicitly.
_test_pipefail_sequence_sequence() {
	if ! _test_pipefail_forcePlus_true || ! _test_pipefail_forcePlus_false || ! _test_pipefail_forceMinus_true_sequence || _test_pipefail_forceMinus_false_sequence
	then
		echo 'fail: pipefail'
		_stop 1
		return 1
	fi
	
	# NOTICE: Will FAIL if 'set -o pipefail' applies to script commands !
	if ! _test_pipestatus_true || _test_pipestatus_false || ! "$scriptAbsoluteLocation" _test_pipestatus_true || "$scriptAbsoluteLocation" _test_pipestatus_false
	then
		echo 'fail: pipestatus'
		_stop 1
		return 1
	fi
	
	
	
	# ATTENTION: Apparently, "$scriptAbsoluteLocation" is able to correctly retrieve the expected (ie. 0, true) exit status of both '_test_pipe_true' and '_test_pipe_false', although calling these functions directly results in the unexpected use of pipestatus, pipefail, or similar, etc.
	# CAUTION: While such defaults may seem slightly undesirable for shell scripts, there may be some benefit to command prompt use (especailly when functions are called from an interactive shell through such as ubiquitous_bash.sh _true , etc), UNIX pipe input programs (eg. cat /file) rarely if ever fail when a grep match would occur, and best practice of using a condition (ie. [[ -e /file ]]) before such pipes already avoids severe issues in shell script usage.
	# CAUTION: Ensure all pipe exit status, pipe status, and pipe fail, default behavior remains *strictly* as-is.
	
	
	
	# ATTENTION: ! _test_pipe_false ... would return true if consistent with behavior when called by "$scriptAbsoluteLocation"
	_test_pipe_false
	[[ "$?" == "0" ]] && echo 'fail: _test_pipe_false' && _stop 1 && return 1
	if _test_pipe_false
	then
		echo 'fail: _test_pipe_false'
		_stop 1
		return 1
	fi
	
	# ATTENTION: ! _test_pipe_false ... does return true if called by "$scriptAbsoluteLocation"
	! "$scriptAbsoluteLocation" _test_pipe_false
	[[ "$?" == "0" ]] && echo 'fail: ! "$scriptAbsoluteLocation" _test_pipe_false' && _stop 1 && return 1
	if ! "$scriptAbsoluteLocation" _test_pipe_false
	then
		echo 'fail: if: ! "$scriptAbsoluteLocation" _test_pipe_false'
		_stop 1
		return 1
	fi
	
	_test_pipe_false_condition
	[[ "$?" == "0" ]] && echo 'fail: _test_pipe_false_condition' && _stop 1 && return 1
	if _test_pipe_false_condition
	then
		echo 'fail: if: _test_pipe_false_condition'
		_stop 1
		return 1
	fi
	
	! "$scriptAbsoluteLocation" _test_pipe_false_condition
	[[ "$?" == "0" ]] && echo 'fail: ! "$scriptAbsoluteLocation" _test_pipe_false_condition' && _stop 1 && return 1
	if _test_pipe_false_condition
	then
		echo 'fail: if: ! "$scriptAbsoluteLocation" _test_pipe_false_condition'
		_stop 1
		return 1
	fi
	
	
	_test_pipe_false_condition_special
	[[ "$?" == "0" ]] && echo 'fail: _test_pipe_false_condition_special' && _stop 1 && return 1
	if _test_pipe_false_condition_special
	then
		echo 'fail: if: _test_pipe_false_condition_special'
		_stop 1
		return 1
	fi
	
	! "$scriptAbsoluteLocation" _test_pipe_false_condition_special
	[[ "$?" == "0" ]] && echo 'fail: ! "$scriptAbsoluteLocation" _test_pipe_false_condition_special' && _stop 1 && return 1
	if ! "$scriptAbsoluteLocation" _test_pipe_false_condition_special
	then
		echo 'fail: if: ! "$scriptAbsoluteLocation" _test_pipe_false_condition_special'
		_stop 1
		return 1
	fi
	
	"$scriptAbsoluteLocation" _test_pipe_false_condition_special
	[[ "$?" != "0" ]] && echo 'fail: "$scriptAbsoluteLocation" _test_pipe_false_condition_special' && _stop 1 && return 1
	if "$scriptAbsoluteLocation" _test_pipe_false_condition_special
	then
		true
	else
		echo 'fail: if: "$scriptAbsoluteLocation" _test_pipe_false_condition_special'
		_stop 1
		return 1
	fi
	
	
	#! _test_pipe_true || ! _test_pipe_false || ! "$scriptAbsoluteLocation" _test_pipe_true || ! "$scriptAbsoluteLocation" _test_pipe_false
	#! _test_pipe_false
	if ! _test_pipe_true || ! "$scriptAbsoluteLocation" _test_pipe_true || ! "$scriptAbsoluteLocation" _test_pipe_false
	then
		echo 'fail: if: pipe: value'
		_stop 1
		return 1
	fi
	
	set +o pipefail
	# NOTICE: Will FAIL if 'set -o pipefail' applies to script commands !
	if ! _test_pipestatus_true || _test_pipestatus_false || ! "$scriptAbsoluteLocation" _test_pipestatus_true || "$scriptAbsoluteLocation" _test_pipestatus_false
	then
		echo 'fail: pipestatus'
		_stop 1
		return 1
	fi
	if ( true | tee /dev/null 2>&1 )
	then
		true
	else
		echo 'fail: if: pipe: pipefail: plus: subshell: true'
		_stop 1
		return 1
	fi
	if ( false | tee /dev/null 2>&1 )
	then
		true
	else
		echo 'fail: if: pipe: pipefail: plus: subshell: false'
		_stop 1
		return 1
	fi
	if ! "$scriptAbsoluteLocation" _test_pipe_true || ! "$scriptAbsoluteLocation" _test_pipe_false
	then
		echo 'fail: if: pipe: pipefail: plus'
		_stop 1
		return 1
	fi
	
	set -o pipefail
	# NOTICE: Will FAIL if 'set -o pipefail' applies to script commands !
	if ! _test_pipestatus_true || _test_pipestatus_false || ! "$scriptAbsoluteLocation" _test_pipestatus_true || "$scriptAbsoluteLocation" _test_pipestatus_false
	then
		echo 'fail: pipestatus'
		_stop 1
		return 1
	fi
	if ( true | tee /dev/null 2>&1 )
	then
		true
	else
		echo 'fail: if: pipe: pipefail: minus: subshell: true'
		_stop 1
		return 1
	fi
	# ATTENTION: Seems this actually is sensitive to 'set -o pipefail' .
	if ( false | tee /dev/null 2>&1 )
	then
		echo 'fail: if: pipe: pipefail: minus: subshell: false'
		_stop 1
		return 1
	else
		true
	fi
	if ! "$scriptAbsoluteLocation" _test_pipe_true || ! "$scriptAbsoluteLocation" _test_pipe_false
	then
		echo 'fail: if: pipe: pipefail: minus'
		_stop 1
		return 1
	fi
	return 0
}
_test_pipefail_sequence() {
	! "$scriptAbsoluteLocation" _test_pipefail_sequence_sequence "$@" && return 1
	
	set +o pipefail
	! "$scriptAbsoluteLocation" _test_pipefail_sequence_sequence "$@" && return 1
	
	set -o pipefail
	! "$scriptAbsoluteLocation" _test_pipefail_sequence_sequence "$@" && return 1
	
	return 0
}
_test_pipefail() {
	if ! "$scriptAbsoluteLocation" _test_pipefail_sequence "$@"
	then
		_messageFAIL
		_stop 1
		return 1
	fi
	"$scriptAbsoluteLocation" _test_pipefail_sequence "$@"
	if [[ "$?" != "0" ]]
	then
		_messageFAIL
		_stop 1
		return 1
	fi
}

# WARNING: Not necessarily tested by default, due to lack of use except where faults are tolerable, and slim possibility of useful embedded systems not able to pass.
_test_grep() {
	# If not known distribution/OS, do NOT test. Some embedded systems not able to pass may be nevertheless useful.
	! ( [[ -e /etc/issue ]] && cat /etc/issue | grep 'Debian\|Raspbian\|Ubuntu' > /dev/null 2>&1 ) && ! _if_cygwin && return 0
	
	
	
	! echo \$123 | grep -E '^\$[0-9]|^\.[0-9]' > /dev/null 2>&1 && _messageFAIL && return 1
	! echo \.123 | grep -E '^\$[0-9]|^\.[0-9]' > /dev/null 2>&1 && _messageFAIL && return 1
	echo 123 | grep -E '^\$[0-9]|^\.[0-9]' > /dev/null 2>&1 && _messageFAIL && return 1
	
	
	
	! echo 'qwerty.*123' | grep -xF 'qwerty.*123' > /dev/null 2>&1 && _messageFAIL && return 1
	! echo 'qwerty.*123' | grep -F 'qwerty.*123' > /dev/null 2>&1 && _messageFAIL && return 1
	! echo 'qwerty123' | grep -x 'q.*3' > /dev/null 2>&1 && _messageFAIL && return 1
	
	echo 'qwerty123' | grep -xF 'qwerty.*123' > /dev/null 2>&1 && _messageFAIL && return 1
	echo 'qwerty.*123' | grep -xF 'qwerty123' > /dev/null 2>&1 && _messageFAIL && return 1
	
	echo 'qwerty123' | grep -xF 'qwerty' > /dev/null 2>&1 && _messageFAIL && return 1
	echo 'qwerty123' | grep -xF '123' > /dev/null 2>&1 && _messageFAIL && return 1
	echo 'qwerty123' | grep -xF 'werty12' > /dev/null 2>&1 && _messageFAIL && return 1
	
	
	! echo 'qwerty123' | grep -x 'qwerty.*123' > /dev/null 2>&1 && _messageFAIL && return 1
	echo 'qwerty.*123' | grep -x 'qwerty123' > /dev/null 2>&1 && _messageFAIL && return 1
	
	echo 'qwerty123' | grep -x 'qwerty' > /dev/null 2>&1 && _messageFAIL && return 1
	echo 'qwerty123' | grep -x '123' > /dev/null 2>&1 && _messageFAIL && return 1
	echo 'qwerty123' | grep -x 'werty12' > /dev/null 2>&1 && _messageFAIL && return 1
	
	
	echo 'qwerty123' | grep -F 'qwerty.*123' > /dev/null 2>&1 && _messageFAIL && return 1
	echo 'qwerty.*123' | grep -F 'qwerty123' > /dev/null 2>&1 && _messageFAIL && return 1
	
	! echo 'qwerty123' | grep -F 'qwerty' > /dev/null 2>&1 && _messageFAIL && return 1
	! echo 'qwerty123' | grep -F '123' > /dev/null 2>&1 && _messageFAIL && return 1
	! echo 'qwerty123' | grep -F 'werty12' > /dev/null 2>&1 && _messageFAIL && return 1
	
	
	
	return 0
}

_test_sanity() {
	if (exit 0)
	then
		true
	else
		_messageFAIL && return 1
	fi
	if ! (exit 0)
	then
		_messageFAIL && return 1
	fi
	if (exit 1)
	then
		_messageFAIL && return 1
	fi
	if (exit 2)
	then
		_messageFAIL && return 1
	fi
	if (exit 3)
	then
		_messageFAIL && return 1
	fi
	if (exit 126)
	then
		_messageFAIL && return 1
	fi
	if (exit 127)
	then
		_messageFAIL && return 1
	fi
	if (exit 128)
	then
		_messageFAIL && return 1
	fi
	if (exit 129)
	then
		_messageFAIL && return 1
	fi
	if (exit 130)
	then
		_messageFAIL && return 1
	fi
	if (exit 131)
	then
		_messageFAIL && return 1
	fi
	if (exit 132)
	then
		_messageFAIL && return 1
	fi
	if (exit 255)
	then
		_messageFAIL && return 1
	fi
	
	local currentSubReturnStatus
	(exit 0)
	currentSubReturnStatus="$?"
	[[ "$currentSubReturnStatus" != '0' ]] && _messageFAIL && return 1
	(exit 1)
	currentSubReturnStatus="$?"
	[[ "$currentSubReturnStatus" != '1' ]] && _messageFAIL && return 1
	(exit 2)
	currentSubReturnStatus="$?"
	[[ "$currentSubReturnStatus" != '2' ]] && _messageFAIL && return 1
	(exit 3)
	currentSubReturnStatus="$?"
	[[ "$currentSubReturnStatus" != '3' ]] && _messageFAIL && return 1
	
	
	# Do NOT allow 'rm' to be a shell function alias to 'rm -i' or similar.
	[[ $(type -p rm) == "" ]] && _messageFAIL && return 1
	
	
	! _test_pipefail && _messageFAIL && return 1
	
	
	
	
	#! [[ -2147483648 -lt 2147483647 ]] && _messageFAIL && return 1
	#! [[ -2000000000 -lt 2000000000 ]] && _messageFAIL && return 1
	
	! [[ -1234567890 -le -1234567890 ]] && _messageFAIL && return 1
	! [[ 1234567890 -le 1234567890 ]] && _messageFAIL && return 1
	! [[ -1234567890 -lt 1234567890 ]] && _messageFAIL && return 1
	! [[ -1234567890 -ge -1234567890 ]] && _messageFAIL && return 1
	! [[ 1234567890 -ge 1234567890 ]] && _messageFAIL && return 1
	! [[ 1234567890 -gt -1234567890 ]] && _messageFAIL && return 1
	! [[ -1234567890 -lt -0 ]] && _messageFAIL && return 1
	! [[ -1234567890 -lt 0 ]] && _messageFAIL && return 1
	! [[ 0 -lt 1234567890 ]] && _messageFAIL && return 1
	! [[ -0 -gt -1234567890 ]] && _messageFAIL && return 1
	! [[ 0 -gt -1234567890 ]] && _messageFAIL && return 1
	! [[ 0 -gt -1234567890 ]] && _messageFAIL && return 1
	
	! [[ -900000000 -le -900000000 ]] && _messageFAIL && return 1
	! [[ 900000000 -le 900000000 ]] && _messageFAIL && return 1
	! [[ -900000000 -lt 900000000 ]] && _messageFAIL && return 1
	! [[ -900000000 -ge -900000000 ]] && _messageFAIL && return 1
	! [[ 900000000 -ge 900000000 ]] && _messageFAIL && return 1
	! [[ 900000000 -gt -900000000 ]] && _messageFAIL && return 1
	! [[ -900000000 -lt -0 ]] && _messageFAIL && return 1
	! [[ -900000000 -lt 0 ]] && _messageFAIL && return 1
	! [[ 0 -lt 900000000 ]] && _messageFAIL && return 1
	! [[ -0 -gt -900000000 ]] && _messageFAIL && return 1
	! [[ 0 -gt -900000000 ]] && _messageFAIL && return 1
	! [[ 0 -gt -900000000 ]] && _messageFAIL && return 1
	! [[ 0 -le -0 ]] && _messageFAIL && return 1
	! [[ -0 -le 0 ]] && _messageFAIL && return 1
	! [[ 0 -ge -0 ]] && _messageFAIL && return 1
	! [[ -0 -ge 0 ]] && _messageFAIL && return 1
	
	
	
	! "$scriptAbsoluteLocation" _true && _messageFAIL && return 1
	"$scriptAbsoluteLocation" _false && _messageFAIL && return 1
	
	# CAUTION: Profoundly unexpected to have called '_test' or similar functions after importing into a current shell in any way.
	if ( [[ "$current_internal_CompressedScript" == "" ]] && [[ "$current_internal_CompressedScript_cksum" == "" ]] && [[ "$current_internal_CompressedScript_bytes" == "" ]] ) || ( ( [[ "$ub_import_param" != "--embed" ]] ) && [[ "$ub_import_param" != "--bypass" ]] && [[ "$ub_import_param" != "--call" ]] && [[ "$ub_import_param" != "--script" ]] && [[ "$ub_import_param" != "--compressed" ]] )
	then
		[[ "$ub_import" == 'true' ]] && _messageFAIL && _stop 1
		[[ "$ub_import" != '' ]] && _messageFAIL && _stop 1
		[[ "$ub_import_param" != '' ]] && _messageFAIL && _stop 1
	fi
	
	local santiySessionID_length
	santiySessionID_length=$(echo -n "$sessionid" | wc -c | tr -dc '0-9')
	
	[[ "$santiySessionID_length" -lt "18" ]] && _messageFAIL && return 1
	[[ "$uidLengthPrefix" != "" ]] && [[ "$santiySessionID_length" -lt "$uidLengthPrefix" ]] && _messageFAIL && return 1
	
	[[ -e "$safeTmp" ]] && _messageFAIL && return 1
	
	_start scriptLocal_mkdir_disable
	
	
	[[ ! -e "$safeTmp" ]] && _messageFAIL && return 1
	
	[[ $( cd "$safeTmp" 2>/dev/null ; ls *doNotMatch* 2>/dev/null | wc -c) != "0" ]] && _messageFAIL && return 1
	[[ $( cd "$safeTmp" 2>/dev/null ; ls -A *doNotMatch* 2>/dev/null | wc -c) != "0" ]] && _messageFAIL && return 1
	
	echo -e -n >> "$safeTmp"/empty
	[[ ! -e "$safeTmp"/empty ]] && _messageFAIL && return 1
	[[ $(cat "$safeTmp"/empty | wc -c) != '0' ]] && _messageFAIL && return 1
	
	[[ $( cd "$safeTmp" 2>/dev/null ; ls *empty* 2>/dev/null | wc -c) == "0" ]] && _messageFAIL && return 1
	[[ $( cd "$safeTmp" 2>/dev/null ; ls -A *empty* 2>/dev/null | wc -c) == "0" ]] && _messageFAIL && return 1
	
	rm -f "$safeTmp"/empty > /dev/null 2>&1
	
	
	! _test_moveconfirm_procedure && _messageFAIL && return 1
	
	
	local currentTestUID=$(_uid 245)
	mkdir -p "$safeTmp"/"$currentTestUID"
	echo > "$safeTmp"/"$currentTestUID"/"$currentTestUID"
	
	[[ ! -e "$safeTmp"/"$currentTestUID"/"$currentTestUID" ]] && _messageFAIL && return 1
	
	rm -f "$safeTmp"/"$currentTestUID"/"$currentTestUID"
	rmdir "$safeTmp"/"$currentTestUID"
	
	[[ -e "$safeTmp"/"$currentTestUID" ]] && _messageFAIL && return 1
	
	echo 'true' > "$safeTmp"/shouldNotOverwrite
	mv "$safeTmp"/doesNotExist "$safeTmp"/shouldNotOverwrite > /dev/null 2>&1 && _messageFAIL && return 1
	echo > "$safeTmp"/replacement
	mv -n "$safeTmp"/replacement "$safeTmp"/shouldNotOverwrite > /dev/null 2>&1
	[[ $(cat "$safeTmp"/shouldNotOverwrite) != "true" ]] && _messageFAIL && return 1
	rm -f "$safeTmp"/replacement > /dev/null 2>&1
	rm -f "$safeTmp"/shouldNotOverwrite > /dev/null 2>&1
	
	
	_uid_test
	
	[[ $(_getUUID | wc -c) != '37' ]] && _messageFAIL && return 1
	
	[[ $(_getUUID | cut -f1 -d\- | wc -c) != '9' ]] &&  _messageFAIL && return 1
	
	
	! env | grep 'PATH' > /dev/null 2>&1 && _messageFAIL && return 1
	! printenv | grep 'PATH' > /dev/null 2>&1 && _messageFAIL && return 1
	
	
	_define_function_test
	
	! _variableLocalTest && _messageFAIL && return 1
	
	
	
	mkdir -p "$safeTmp"/maydeletethisfolder
	[[ ! -d "$safeTmp"/maydeletethisfolder ]] && return 1
	echo > "$safeTmp"/maydeletethisfolder/maydeletethisfile
	[[ ! -e "$safeTmp"/maydeletethisfolder/maydeletethisfile ]] && return 1
	_safeRMR "$safeTmp"/maydeletethisfolder
	[[ -e "$safeTmp"/maydeletethisfolder/maydeletethisfile ]] && return 1
	[[ -e "$safeTmp"/maydeletethisfolder ]] && return 1
	
	
	
	_test_grep
	
	
	local currentJobsList
	currentJobsList=$(jobs -p -r)
	
	[[ "$currentJobsList" != "" ]] && return 1
	
	sleep 7 &
	currentJobsList=$(jobs -p -r)
	[[ "$currentJobsList" == "" ]] && return 1
	
	wait
	currentJobsList=$(jobs -p -r)
	[[ "$currentJobsList" != "" ]] && return 1
	
	
	echo -e -n "b" > "$safeTmp"/a
	[[ $(echo -e -n "c" | cat "$safeTmp"/a -) != "bc" ]] && _messageFAIL && _stop 1
	#[[ $(echo -e -n "c" | cat "$safeTmp"/a /dev/stdin) != "bc" ]] && _messageFAIL && _stop 1
	[[ $(echo -e -n "c" | cat "$safeTmp"/a /proc/self/fd/0) != "bc" ]] && _messageFAIL && _stop 1
	[[ $(echo -e -n "c" | cat - "$safeTmp"/a) != "cb" ]] && _messageFAIL && _stop 1
	#[[ $(echo -e -n "c" | cat /dev/stdin "$safeTmp"/a) != "cb" ]] && _messageFAIL && _stop 1
	[[ $(echo -e -n "c" | cat /proc/self/fd/0 "$safeTmp"/a) != "cb" ]] && _messageFAIL && _stop 1
	rm -f "$safeTmp"/a
	
	
	echo -e -n "b" > "$safeTmp"/a
	[[ $(echo -e -n "c" | _messagePlain_probe_cmd cat "$safeTmp"/a - | tail -c 2) != "bc" ]] && _messageFAIL && _stop 1
	#[[ $(echo -e -n "c" | _messagePlain_probe_cmd cat "$safeTmp"/a /dev/stdin | tail -c 2) != "bc" ]] && _messageFAIL && _stop 1
	[[ $(echo -e -n "c" | _messagePlain_probe_cmd cat "$safeTmp"/a /proc/self/fd/0 | tail -c 2) != "bc" ]] && _messageFAIL && _stop 1
	[[ $(echo -e -n "c" | _messagePlain_probe_cmd cat - "$safeTmp"/a | tail -c 2) != "cb" ]] && _messageFAIL && _stop 1
	#[[ $(echo -e -n "c" | _messagePlain_probe_cmd cat /dev/stdin "$safeTmp"/a | tail -c 2) != "cb" ]] && _messageFAIL && _stop 1
	[[ $(echo -e -n "c" | _messagePlain_probe_cmd cat /proc/self/fd/0 "$safeTmp"/a | tail -c 2) != "cb" ]] && _messageFAIL && _stop 1
	rm -f "$safeTmp"/a




	! (set -o pipefail; true | echo x | cat) > /dev/null 2>&1 && _messageFAIL && return 1
	(set -o pipefail; false | echo x | cat) > /dev/null 2>&1 && _messageFAIL && return 1

	[[ $(set -o pipefail; true | echo x | cat) != "x" ]] && _messageFAIL && return 1
	[[ $(set -o pipefail; false | echo x | cat) != "x" ]] && _messageFAIL && return 1

	! false | true && _messageFAIL && return 1
	false | true || _messageFAIL
	false | true || return 1
	true | false && _messageFAIL && return 1
	
	
	
	
	if ! _test_embed
	then
		_messageFAIL && _stop 1
		#! uname -a | grep -i cygwin > /dev/null 2>&1 && _messageFAIL && _stop 1
		#echo 'warn: broken (cygwin): _test_embed - cygwin detected'
	fi
	
	
	
	
	_getDep flock
	
	( flock 200; echo > "$safeTmp"/ready ; sleep 3 ) 200>"$safeTmp"/flock &
	sleep 1
	if ( flock 200; ! [[ -e "$safeTmp"/ready ]] ) 200>"$safeTmp"/flock
	then
		! uname -a | grep -i cygwin > /dev/null 2>&1 && _messageFAIL && _stop 1
		echo 'warn: broken (cygwin): flock - cygwin may not be able to use flock through MSW network drive'
		return 1
	fi
	rm -f "$safeTmp"/flock > /dev/null 2>&1
	rm -f "$safeTmp"/ready > /dev/null 2>&1
	
	ln -s /dev/null "$safeTmp"/working
	ln -s /dev/null/broken "$safeTmp"/broken
	if ! [[ -h "$safeTmp"/broken ]] || ! [[ -h "$safeTmp"/working ]] || [[ -e "$safeTmp"/broken ]] || ! [[ -e "$safeTmp"/working ]]
	then
		! uname -a | grep -i cygwin > /dev/null 2>&1 && _messageFAIL && _stop 1
		echo 'warn: broken (cygwin): flock - cygwin may not be able to use flock through MSW network drive'
		return 1
	fi
	rm -f "$safeTmp"/working
	rm -f "$safeTmp"/broken
	
	
	
	_tryExec _test_parallelFifo_procedure
	
	
	return 0
}



_test-shell-cygwin() {
	_messageNormal "Cygwin detected... MSW configuration issues..."
	
	
	local currentScriptTime
	if type _stopwatch > /dev/null 2>&1
	then
		if [[ -e "$scriptAbsoluteFolder"/ubiquitous_bash.sh ]]
		then
			currentScriptTime=$(_timeout 45 _stopwatch "$scriptAbsoluteFolder"/ubiquitous_bash.sh _true 2>/dev/null | tr -dc '0-9')
		else
			currentScriptTime=$(_timeout 45 _stopwatch "$scriptAbsoluteLocation" _true 2>/dev/null | tr -dc '0-9')
		fi
	else
		# If '_stopwatch' is not available, assume this is not an issue.
		currentScriptTime="2000"
	fi
	
	# Unusual, broken, non-desktop, etc user/login/account/etc configuration in MSW, might cause prohibitively long Cygwin delays.
	# MSW has a fragile track record, and cannot be used for combining complex applications (eg. flight sim) with 'enterprise' user/login/account/etc and/or deployment. Unless extensive testing conclusively shows a long track record otherwise, or unless MS has a direct commitment under a valuable contract to specifically ensure compatibility with such a use case, it would be obviously gross negligence to put a business at risk of unacceptable downtime from such a fragile stack. Any 'bonus' compensation so earned should incur liability for the disproportionate risk.
	# Enterprise must either use GNU/Linux, or similar, or maybe swap single-user preinstalled physical laptops/desktops.
	if [[ "$currentScriptTime" == "" ]]
	then
		echo 'fail: blank: currentScriptTime'
		_messageFAIL
	fi
	if ( [[ "$currentScriptTime" -gt '9500' ]] && [[ "$CI" == "" ]] ) || [[ "$currentScriptTime" -gt '20000' ]]
	then
		echo 'fail: slow: currentScriptTime: '"$currentScriptTime"
		_messageFAIL
	fi
	if [[ "$currentScriptTime" -gt '4500' ]]
	then
		echo 'warn: slow: currentScriptTime: '"$currentScriptTime"
		_messagePlain_request 'request: obtain a CPU with better single-thread performance, disable HyperThreading, disable EfficiencyCores, and/or reduce MSW OS installed functionality'
	fi
	
	
	local currentPathCount
	currentPathCount=$(echo "$PATH" | grep -o ':' | wc -l | tr -dc '0-9')
	#if [[ "$currentPathCount" -gt 50 ]]
	#if [[ "$currentPathCount" -gt 66 ]]
	if [[ "$currentPathCount" -gt 99 ]]
	then
		echo 'fail: count: PATH: '"$currentPathCount"
		_messageFAIL
	fi
	#if [[ "$currentPathCount" -gt 66 ]]
	if [[ "$currentPathCount" -gt 80 ]]
	then
		echo 'warn: count: PATH: '"$currentPathCount"
		echo 'warn: MSWEXTPATH may be ignored'
		_messagePlain_request 'request: reduce the length of PATH variable'
	fi
	#if [[ "$currentPathCount" -gt 44 ]]
	if [[ "$currentPathCount" -gt 60 ]]
	then
		echo 'warn: count: PATH: '"$currentPathCount"
		echo 'warn: MSWEXTPATH may be ignored'
		_messagePlain_request 'request: reduce the length of PATH variable'
	fi
	
	if [[ "$currentPathCount" -gt 48 ]]
	then
		echo 'warn: count: PATH: '"$currentPathCount"
		echo 'warn: MSWEXTPATH exceeds preferred 48'
		_messagePlain_request 'request: reduce the length of PATH variable'
	fi
	if [[ "$currentPathCount" -gt 44 ]]
	then
		echo 'warn: count: PATH: '"$currentPathCount"
		echo 'warn: MSWEXTPATH exceeds preferred 44'
		_messagePlain_request 'request: reduce the length of PATH variable'
	fi
	if [[ "$currentPathCount" -gt 32 ]]
	then
		echo 'warn: count: PATH: '"$currentPathCount"
		echo 'warn: MSWEXTPATH exceeds preferred 32'
		_messagePlain_request 'request: reduce the length of PATH variable'
	fi
	if [[ "$currentPathCount" -gt 34 ]]
	then
		echo 'warn: count: PATH: '"$currentPathCount"
		echo 'warn: MSWEXTPATH exceeds preferred 34'
		_messagePlain_request 'request: reduce the length of PATH variable'
	fi
	


	# Discouraged. NOT guaranteed, may be removed if unmaintainable.
	# Inheritance of variables as a means of communicating or passing parameters is not the point. Inheritance is tested to ensure an entirely different 'ubcp' environment, script, '$safeTmp', etc, is NOT used.
	export ub_sanity_special="mustInherit"
	if _if_cygwin
	then
		local currentResult
		currentResult=""

		local current_bin_bash
		current_bin_bash=$(cygpath -w /bin/bash)

		currentResult=$(cmd /C "$current_bin_bash" '-c' 'echo $ub_sanity_special')
		[[ "$currentResult" != "mustInherit" ]] && echo 'fail: cmd /bin/bash: mustInherit' && _messageFAIL && return 1

		currentResult=$(cmd /C "$current_bin_bash" '-c' 'echo "$safeTmp"')
		[[ "$currentResult" != "$safeTmp" ]] && echo 'fail: cmd /bin/bash: inherit: safeTmp' && _messageFAIL && return 1


		current_bin_bash=$(cygpath -w /bin/bash | sed 's/\\/\\\\/g')

		currentResult=$(_powershell -Command "$current_bin_bash"" -c 'echo "'"$ub_sanity_special"'"'")
		[[ "$currentResult" != "mustInherit" ]] && echo 'fail: powershell /bin/bash: mustInherit' && _messageFAIL && return 1

		currentResult=$(_powershell -Command "$current_bin_bash"" -c 'echo "'"$safeTmp"'"'")
		[[ "$currentResult" != "$safeTmp" ]] && echo 'fail: powershell /bin/bash: inherit: safeTmp' && _messageFAIL && return 1
	fi
	unset ub_sanity_special

	
	
	# Although use case specific (eg. flight sim with usual desktop applications installed) test cases may be necessary for MSW, to avoid ambiguity in expectations that every test includes an explicit PASS statement, a call to '_messagePASS' is still given.
	# Self-hosted 'runners' may be able to implement these test cases, with the resulting fragility reduced somewhat by another computer pulling frequent backups and artifacts.
	# Unusually, MSW may have use case specific issues due to a track record for configuration changes to the MSW OS causing prohibitive performance issues (eg. Cygwin being delayed more than tens of seconds possibly due to a program adding some kind of user account, some programs known to drastically increase frame dropping in intense applications, etc).
	_messagePASS
	
	
	return 0
}
_test-shell() {
	_installation_nonet_default
	
	# ATTENTION: As part of sanity test, "$safeTmp" must not exist until '_start scriptLocal_mkdir_disable' is called from within '_test_sanity' .
	#_start scriptLocal_mkdir_disable
	_messageNormal "Sanity..."
	_test_sanity && _messagePASS
	
	
	
	_messageNormal "Permissions..."
	! _test_permissions_ubiquitous && _messageFAIL
	_messagePASS
	
	#Environment generated by ubiquitous bash is typically 10000 characters.
	#echo -n -e '\E[1;32;46m Argument length...	\E[0m'
	_messageNormal 'Argument length...'
	_testarglength
	
	_messageNormal "Absolute pathfinding..."
	#if ! uname -a | grep -i cygwin > /dev/null 2>&1
	#then
		_tryExec "_test_getAbsoluteLocation"
	#fi
	_messagePASS
	
	
	if _if_cygwin
	then
		! _test-shell-cygwin && _messageFAIL
	fi
	
	
	return 0
}

_test() {
	_test-shell "$@"
	_installation_nonet_default
	
	if ! _typeDep sudo && [[ "$UID" == "0" ]]
	then
		if _typeDep 'apt-get'
		then
			apt-get -y update
			apt-get -y install sudo
		fi
	fi
	#! _typeDep sudo && _stop 1
	
	if ! _typeDep bc
	then
		if _typeDep 'apt-get'
		then
			sudo -n apt-get -y update
			sudo -n apt-get -y install bc
		fi
	fi
	! _typeDep bc && _stop 1
	
	if type _timetest > /dev/null 2>&1 && [[ "$devfast" != 'true' ]]
	then
		echo -n -e '\E[1;32;46m Timing...		\E[0m'
		echo
		
		# DANGER: Even under MSW/Cygwin, should ONLY fail IF extremely slow storage is attached.
		if type _test_selfTime > /dev/null 2>&1
		then
			echo -e '\E[0;36m Timing: _test_selfTime \E[0m'
			if ! _test_selfTime
			then
				if _if_cygwin
				then
					echo 'warn: accepted: cygwin: _test_selfTime broken'
				else
					echo '_test_selfTime broken'
					_stop 1
				fi
			fi
		fi
		
		if type _test_bashTime > /dev/null 2>&1
		then
			echo -e '\E[0;36m Timing: _test_bashTime \E[0m'
			! _test_bashTime && echo '_test_selfTime broken' && _stop 1
		fi
		
		if type _test_filemtime > /dev/null 2>&1
		then
			echo -e '\E[0;36m Timing: _test_filemtime \E[0m'
			! _test_filemtime && echo '_test_selfTime broken' && _stop 1
		fi
		
		if type _test_timeoutRead > /dev/null 2>&1
		then
			echo -e '\E[0;36m Timing: _test_timeoutRead \E[0m'
			! _test_timeoutRead && echo '_test_timeoutRead broken' && _stop 1
		fi

		echo -e '\E[0;36m Timing: true/false \E[0m'
		! _timeout 10 true && echo '! _timeout 10 true  broken' && _stop 1
		_timeout 10 false && echo '_timeout 10 false  broken' && _stop 1
		if type _stopwatch > /dev/null 2>&1
		then
    		! _stopwatch _timeout 10 true > /dev/null 2>&1 && echo '! _stopwatch _timeout 10 true  broken' && _stop 1
    		_stopwatch _timeout 10 false > /dev/null 2>&1 && echo '_stopwatch _timeout 10 false  broken' && _stop 1
		fi
		
		
		echo -e '\E[0;36m Timing: _timetest \E[0m'
		! _timetest && echo '_timetest broken' && _stop 1
	fi
	
	
	_messageNormal "Dependency checking..."
	
	## Check dependencies
	
	# WARNING: Although '#!/usr/bin/env bash' is used as header when possible, some high-speed 'heredoc' scripts may instead rely on '#!/bin/bash' or '#!/bin/dash' to ensure performance. For these important use cases, the typical '/bin/bash' and '/bin/dash' binary locations are required.
	_getDep /bin/bash
	! [[ -e /bin/bash ]] && echo '/bin/bash missing' && _stop 1
	! [[ -x /bin/bash ]] && echo '/bin/bash nonexecutable' && _stop 1
	_getDep /bin/dash
	! [[ -e /bin/dash ]] && echo '/bin/dash missing' && _stop 1
	! [[ -x /bin/dash ]] && echo '/bin/dash nonexecutable' && _stop 1
	
	#"generic/filesystem"/permissions.sh
	_checkDep stat
	
	_getDep cksum
	
	_getDep wget
	_getDep curl
	_wantGetDep aria2c
	_wantGetDep axel
	_getDep grep
	_getDep fgrep
	_getDep sed
	_getDep awk
	_getDep cut
	_getDep head
	_getDep tail
	
	_getDep seq
	
	_getDep wc
	
	_getDep fold
	
	
	! _compat_realpath && ! _wantGetDep realpath && echo 'realpath missing'
	_getDep readlink
	_getDep dirname
	_getDep basename
	
	_getDep sleep
	_getDep wait
	_getDep kill
	_getDep jobs
	_getDep ps
	_getDep exit
	
	_getDep env
	_getDep printenv
	_getDep bash
	_getDep echo
	_getDep cat
	_getDep tac
	_getDep type
	_getDep mkdir
	_getDep trap
	_getDep return
	_getDep set
	
	# WARNING: Deprecated. Migrate to 'type -p' instead when possible.
	# WARNING: No known production use.
	#https://unix.stackexchange.com/questions/85249/why-not-use-which-what-to-use-then
	_getDep which
	
	_getDep printf
	
	_getDep stat
	_getDep touch
	
	_getDep dd
	_wantGetDep blockdev
	_wantGetDep lsblk
	
	_getDep rm
	
	_getDep find
	_getDep ln
	_getDep ls
	
	_getDep id
	
	_getDep test
	
	_getDep true
	_getDep false
	
	_getDep diff
	
	_getDep uuidgen
	
	_getDep bc
	_getDep xxd
	_getDep od
	
	_getDep yes
	
	
	_getDep xargs
	
	
	
	_getDep perl
	
	
	# WARNING: Avoid if possible.
	# Not needed by 'ubiquitous_bash' itself up to at least commit 51ba42ed50b24a0e6eca749e8db7bee5c52cce47 .
	_wantGetDep expect
	
	
	_tryExec "_test_python"
	_tryExec "_test_haskell"
	
	
	
	_test_readlink_f
	
	_tryExec "_test_package"
	
	_tryExec "_test_daemon"
	
	_tryExec "_testFindPort"
	_tryExec "_test_waitport"
	
	
	_tryExec "_test_gitBest"
	
	_tryExec "_test_fw"
	_tryExec "_test_hosts"
	
	_tryExec "_testProxySSH"
	
	_tryExec "_testAutoSSH"
	
	_tryExec "_testTor"
	
	_tryExec "_testProxyRouter"
	
	#_tryExec "_test_build"
	
	_tryExec "_testGosu"
	
	_tryExec "_testMountChecks"
	_tryExec "_testBindMountManager"
	_tryExec "_testDistro"
	_tryExec "_test_fetchDebian"
	
	_tryExec "_test_image"
	_tryExec "_test_transferimage"
	
	_tryExec "_testCreatePartition"
	_tryExec "_testCreateFS"
	
	_tryExec "_test_mkboot"
	
	_tryExec "_test_abstractfs"
	_tryExec "_test_fakehome"
	_tryExec "_testChRoot"
	_tryExec "_testQEMU"
	_tryExec "_testQEMU_x64-x64"
	_tryExec "_testQEMU_x64-raspi"
	_tryExec "_testQEMU_raspi-raspi"
	_tryExec "_testVBox"
	
	_tryExec "_test_vboxconvert"
	
	_tryExec "_test_dosbox"
	
	_tryExec "_testWINE"
	
	_tryExec "_test_docker"
	
	_tryExec "_test_docker_mkimage"
	
	_tryExec "_testVirtBootdisc"
	
	_tryExec "_test_live"
	
	_tryExec "_testExtra"
	
	_tryExec "_testGit"
	
	_tryExec "_test_bup"
	
	_tryExec "_testX11"
	
	_tryExec "_test_virtLocal_X11"
	
	_tryExec "_test_search"
	
	_tryExec "_test_packetDriveDevice"
	_tryExec "_test_gparted"


	_tryExec "_test_wsl2_internal"

	
	# WARNING: Disabled by default. Newer FLOSS (ie. 'barrier'), seems to have displaced the older 'synergy' software.
	# ATTENTION: Override with 'ops' or similar.
	# More portable computing (ie. better laptops) and hardware (eg. mechanical) USB switches are also displacing the usefulness of such keyboard/mouse sharing software.
	#_tryExec "_test_synergy"
	
	
	
	_tryExec "_test_ollama"
	
	
	
	_tryExec "_test_devqalculate"
	_tryExec "_test_devgnuoctave"
	
	
	
	_tryExec "_test_devatom"
	_tryExec "_test_devemacs"
	_tryExec "_test_deveclipse"
	
	
	_tryExec "_test_h1060p"
	
	
	_tryExec "_test_ethereum"
	_tryExec "_test_ethereum_parity"
	
	
	
	_tryExec "_test_mktorrent"
	
	
	_tryExec "_test_cloud"
	
	_tryExec "_test_rclone"
	_tryExec "_test_croc"
	
	_tryExec "_test_terraform"
	
	
	_tryExec "_test_vagrant_build"
	
	
	
	_tryExec "_test_rclone_limited"
	
	
	
	_tryExec "_test_kernelConfig"
	
	
	_tryExec "_test_clog"
	
	_tryExec "_test_metaengine"
	
	_tryExec "_test_channel"
	
	_tryExec "_test_nix-env"
	
	
	! [[ -e /dev/urandom ]] && echo /dev/urandom missing && _stop 1
	[[ $(_timeout 3 cat /dev/urandom 2> /dev/null | _timeout 3 base64 2> /dev/null | _timeout 3 tr -dc 'a-zA-Z0-9' 2> /dev/null | _timeout 3 head -c 18 2> /dev/null) == "" ]] && echo /dev/urandom fail && _stop 1
	
	_messagePASS
	
	if type _test_queue > /dev/null 2>&1 && [[ "$devfast" != 'true' ]]
	then
		_messageNormal "Queue..."
		
		_tryExec '_test_queue'
		
		# DANGER: Even under MSW/Cygwin, should ONLY fail IF extremely slow storage is attached.
		echo -e '\E[0;36m Queue: _test_broadcastPipe_page \E[0m'
		if ! _test_broadcastPipe_page
		then
			if _if_cygwin
			then
				echo 'warn: accepted: cygwin: _test_broadcastPipe_page broken'
			else
				echo '_test_broadcastPipe_page broken'
				_stop 1
			fi
		fi
		
		# DANGER: Even under MSW/Cygwin, should ONLY fail IF extremely slow storage is attached.
		echo -e '\E[0;36m Queue: _test_broadcastPipe_aggregatorStatic \E[0m'
		if ! _test_broadcastPipe_aggregatorStatic
		then
			if _if_cygwin
			then
				#echo 'warn: accepted: cygwin: _test_broadcastPipe_aggregatorStatic broken'
				echo '_test_broadcastPipe_aggregatorStatic broken'
				_stop 1
			else
				echo '_test_broadcastPipe_aggregatorStatic broken'
				_stop 1
			fi
		fi
		
		_messagePASS
	fi
	
	_messageNormal 'Vector...'
	_vector
	_messagePASS
	
	_tryExec "_test_prog"
	
	
	_stop
}

#_testBuilt_prog() {
#	true
#}

_testBuilt() {
	_start scriptLocal_mkdir_disable
	
	_messageProcess "Binary checking"
	
	_tryExec "_testBuiltIdle"
	_tryExec "_testBuiltGosu"	#Note, requires sudo, not necessary for docker .
	
	_tryExec "_test_ethereum_built"
	_tryExec "_test_ethereum_parity_built"
	
	_tryExec "_testBuiltChRoot"
	_tryExec "_testBuiltQEMU"
	
	_tryExec "_testBuiltExtra"
	
	_tryExec "_testBuilt_prog"
	
	_messagePASS
	
	_stop
}

#Creates symlink in "$HOME"/bin, to the executable at "$1", named according to its residing directory and file name.
_setupCommand() {
	mkdir -p "$HOME"/bin
	! [[ -e "$HOME"/bin ]] && return 1
	
	local clientScriptLocation
	clientScriptLocation=$(_getAbsoluteLocation "$1")
	
	local clientScriptFolder
	clientScriptFolder=$(_getAbsoluteFolder "$1")
	
	local commandName
	commandName=$(basename "$1")
	
	local clientName
	clientName=$(basename "$clientScriptFolder")
	
	_relink_relative "$clientScriptLocation" "$HOME"/bin/"$commandName""-""$clientName"
	
	
}

_setupCommand_meta() {
	mkdir -p "$HOME"/bin
	! [[ -e "$HOME"/bin ]] && return 1
	
	local clientScriptLocation
	clientScriptLocation=$(_getAbsoluteLocation "$1")
	
	local clientScriptFolder
	clientScriptFolder=$(_getAbsoluteFolder "$1")
	
	local clientScriptFolderResidence
	clientScriptFolderResidence=$(_getAbsoluteFolder "$clientScriptFolder")
	
	local commandName
	commandName=$(basename "$1")
	
	local clientName
	clientName=$(basename "$clientScriptFolderResidence")
	
	_relink_relative "$clientScriptLocation" "$HOME"/bin/"$commandName""-""$clientName"
	
	
}

_find_setupCommands() {
	find -L "$scriptAbsoluteFolder" -not \( -path \*_arc\* -prune \) -not \( -path \*__disk\* -prune \) -not \( -path \*/_local/h/\* -prune \) -not \( -path \*/_local/fs/\* -prune \) -not \( -path \*/_local/ubcp/\* -prune \) "$@"
}

#Consider placing files like ' _vnc-machine-"$netName" ' in an "_index" folder for automatic installation.
_setupCommands() {
	#_find_setupCommands -name '_command' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
	
	_tryExec "_setup_ssh_commands"
	_tryExec "_setup_command_commands"
}

#_setup_pre() {
#	true
#}

#_setup_prog() {
#	true
#}


_setup_anchor() {
	if ! _if_cygwin && [[ "$objectName" == "ubiquitous_bash" ]]
	then
		# WARNING: End user file association. Do NOT call within scripts.
		# WARNING: Necessarily relies on a 'deprecated' 'field code' with the 'Exec key' of a 'Desktop Entry' file association.
		# https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
		_messagePlain_request 'association: *.bat'
		echo 'konsole --workdir %d -e /bin/bash %f (open in graphical terminal emulator from file manager)'
		echo 'bash'
	fi
	
	if type "_associate_anchors_request" > /dev/null 2>&1
	then
		_tryExec "_associate_anchors_request"
		return
	fi
}

_setup() {
	_installation_nonet_default
	
	_start scriptLocal_mkdir_disable
	
	"$scriptAbsoluteLocation" _test || _stop 1
	
	#Only attempt build procedures if their functions have been defined from "build.sh" . Pure shell script projects (eg. CoreAutoSSH), and projects using only statically compiled binaries, need NOT include such procedures.
	local buildSupported
	type _build > /dev/null 2>&1 && type _test_build > /dev/null 2>&1 && buildSupported="true"
	
	[[ "$buildSupported" == "true" ]] && ! "$scriptAbsoluteLocation" _test_build && _stop 1
	
	if ! "$scriptAbsoluteLocation" _testBuilt
	then
		! [[ "$buildSupported" == "true" ]] && _stop 1
		[[ "$buildSupported" == "true" ]] && ! "$scriptAbsoluteLocation" _build "$@" && _stop 1
		! "$scriptAbsoluteLocation" _testBuilt && _stop 1
	fi
	
	_setupCommands
	
	_tryExec "_setup_pre"
	
	_tryExec "_setup_ssh"
	
	_tryExec "_setup_prog"
	
	_setup_anchor
	
	_stop
}

# DANGER: Especially not expected to modify system program behavior (eg. not to modify "$HOME"/.ssh ).
# WARNING: Strictly expected to not modify anyting outside the script directory.
_setup_local() {
	export ub_setup_local='true'
	
	_setup
}

_test_package() {
	_getDep tar
	_getDep gzip
	
	_getDep xz
}

_package_prog() {
	true
}


_package_ubcp_copy_copy() {
	#cp -a "$1" "$2"
	if [[ "$ubPackage_enable_ubcp" != 'true' ]]
	then
		if [[ "$skimfast" != "true" ]]
		then
			rsync -av --progress --exclude "/ubcp/conemu" --exclude "/ubcp/cygwin" --exclude "/ubcp/package_ubcp-cygwinOnly.tar.gz" --exclude "/ubcp/package_ubcp-cygwinOnly.tar.xz" --exclude "/ubcp/package_ubcp-cygwinOnly.tar.flx" "$1" "$2"
		else
			rsync -a --exclude "/ubcp/conemu" --exclude "/ubcp/cygwin" --exclude "/ubcp/package_ubcp-cygwinOnly.tar.gz" --exclude "/ubcp/package_ubcp-cygwinOnly.tar.xz" --exclude "/ubcp/package_ubcp-cygwinOnly.tar.flx" "$1" "$2"
		fi
	else
		if [[ "$skimfast" != "true" ]]
		then
			rsync -av --progress --exclude "/ubcp/package_ubcp-cygwinOnly.tar.gz" --exclude "/ubcp/package_ubcp-cygwinOnly.tar.xz" --exclude "/ubcp/package_ubcp-cygwinOnly.tar.flx" "$1" "$2"
		else
			rsync -a --exclude "/ubcp/package_ubcp-cygwinOnly.tar.gz" --exclude "/ubcp/package_ubcp-cygwinOnly.tar.xz" --exclude "/ubcp/package_ubcp-cygwinOnly.tar.flx" "$1" "$2"
		fi
	fi
	
	
	rm -f "$safeTmp"/package/_local/package_ubcp-cygwinOnly.tar.gz
	rm -f "$safeTmp"/package/_local/package_ubcp-cygwinOnly.tar.xz
	rm -f "$safeTmp"/package/_local/package_ubcp-cygwinOnly.tar.flx
	rm -f "$safeTmp"/package/_local/ubcp/package_ubcp-cygwinOnly.tar.gz
	rm -f "$safeTmp"/package/_local/ubcp/package_ubcp-cygwinOnly.tar.xz
	rm -f "$safeTmp"/package/_local/ubcp/package_ubcp-cygwinOnly.tar.flx
	
	return 0
}

# ATTENTION: Override with 'installation_prog.sh' or similar.
_package_ubcp_copy_prog() {
	false
	
	cd "$outerPWD"
	return 1
	_stop 1
}

_package_ubcp_copy() {
	mkdir -p "$safeTmp"/package/_local
	
	if [[ -e "$scriptLocal"/ubcp ]]
	then
		_package_ubcp_copy_copy "$scriptLocal"/ubcp "$safeTmp"/package/_local/
		return 0
	fi
	if [[ -e "$scriptLib"/ubcp ]]
	then
		_package_ubcp_copy_copy "$scriptLib"/ubcp "$safeTmp"/package/_local/
		rm -f "$safeTmp"/package/_local/ubcp/package_ubcp-cygwinOnly.tar.gz
		return 0
	fi
	if [[ -e "$scriptAbsoluteFolder"/ubcp ]]
	then
		_package_ubcp_copy_copy "$scriptAbsoluteFolder"/ubcp "$safeTmp"/package/_local/
		rm -f "$safeTmp"/package/_local/ubcp/package_ubcp-cygwinOnly.tar.gz
		return 0
	fi
	
	
	if [[ -e "$scriptLib"/ubiquitous_bash/_local/ubcp ]]
	then
		_package_ubcp_copy_copy "$scriptLib"/ubiquitous_bash/_local/ubcp "$safeTmp"/package/_local/
		rm -f "$safeTmp"/package/_local/ubcp/package_ubcp-cygwinOnly.tar.gz
		return 0
	fi
	if [[ -e "$scriptLib"/ubiquitous_bash/_lib/ubcp ]]
	then
		_package_ubcp_copy_copy "$scriptLib"/ubiquitous_bash/_lib/ubcp "$safeTmp"/package/_local/
		rm -f "$safeTmp"/package/_local/ubcp/package_ubcp-cygwinOnly.tar.gz
		return 0
	fi
	if [[ -e "$scriptLib"/ubiquitous_bash/ubcp ]]
	then
		_package_ubcp_copy_copy "$scriptLib"/ubiquitous_bash/ubcp "$safeTmp"/package/_local/
		rm -f "$safeTmp"/package/_local/ubcp/package_ubcp-cygwinOnly.tar.gz
		return 0
	fi
	
	# ATTENTION: Override with 'installation_prog.sh' or similar.
	if _package_ubcp_copy_prog
	then
		return 0
	fi
	
	
	cd "$outerPWD"
	_stop 1
}

# ATTENTION: Override with 'ops' or similar ONLY if necessary.
_package_subdir() {
	#return 0
	
	# ATTENTION: Error message about 'cannot move' ... 'subdirectory of itself' ... is normal .
	mkdir -p "$safeTmp"/package/"$objectName"_tmp/
	( shopt -s dotglob ; mv "$safeTmp"/package/* "$safeTmp"/package/"$objectName"_tmp/ )
	mv "$safeTmp"/package/"$objectName"_tmp "$safeTmp"/package/"$objectName"
}

# WARNING Must define "_package_license" function in ops to include license files in package!
_package_procedure() {
	_start scriptLocal_mkdir_disable
	mkdir -p "$safeTmp"/package
	
	# May not have any effect - Cygwin symlinks should be transparent to 'tar' and similar.
	_force_cygwin_symlinks
	
	# WARNING: Largely due to presence of '.gitignore' files in 'ubcp' .
	export safeToDeleteGit="true"
	
	_package_prog
	
	_tryExec "_package_license"
	
	_tryExec "_package_cautossh"
	
	#cp -a "$scriptAbsoluteFolder"/.git "$safeTmp"/package/ > /dev/null 2>&1
	cp "$scriptAbsoluteFolder"/.gitignore "$safeTmp"/package/ > /dev/null 2>&1
	cp "$scriptAbsoluteFolder"/.gitmodules "$safeTmp"/package/ > /dev/null 2>&1
	
	cp "$scriptAbsoluteFolder"/COPYING "$safeTmp"/package/ > /dev/null 2>&1
	cp "$scriptAbsoluteFolder"/COPYING* "$safeTmp"/package/ > /dev/null 2>&1
	
	cp "$scriptAbsoluteFolder"/gpl.txt "$safeTmp"/package/ > /dev/null 2>&1
	cp "$scriptAbsoluteFolder"/gpl-*.txt "$safeTmp"/package/ > /dev/null 2>&1
	cp "$scriptAbsoluteFolder"/gpl-3.0.txt "$safeTmp"/package/ > /dev/null 2>&1
	
	cp "$scriptAbsoluteFolder"/agpl.txt "$safeTmp"/package/ > /dev/null 2>&1
	cp "$scriptAbsoluteFolder"/agpl-*.txt "$safeTmp"/package/ > /dev/null 2>&1
	cp "$scriptAbsoluteFolder"/agpl-3.0.txt "$safeTmp"/package/ > /dev/null 2>&1
	
	cp "$scriptAbsoluteFolder"/license.txt "$safeTmp"/package/ > /dev/null 2>&1
	cp "$scriptAbsoluteFolder"/license*.txt "$safeTmp"/package/ > /dev/null 2>&1
	
	#scriptBasename=$(basename "$scriptAbsoluteLocation")
	#cp -a "$scriptAbsoluteLocation" "$safeTmp"/package/"$scriptBasename"
	cp -a "$scriptAbsoluteLocation" "$safeTmp"/package/
	cp -a "$scriptAbsoluteFolder"/ops "$safeTmp"/package/
	cp -a "$scriptAbsoluteFolder"/ops.sh "$safeTmp"/package/
	
	cp "$scriptAbsoluteFolder"/_* "$safeTmp"/package/
	cp "$scriptAbsoluteFolder"/*.sh "$safeTmp"/package/
	cp "$scriptAbsoluteFolder"/*.py "$safeTmp"/package/
	
	cp -a "$scriptLocal"/ops "$safeTmp"/package/
	cp -a "$scriptLocal"/ops.sh "$safeTmp"/package/
	
	#cp -a "$scriptAbsoluteFolder"/_bin "$safeTmp"
	#cp -a "$scriptAbsoluteFolder"/_config "$safeTmp"
	#cp -a "$scriptAbsoluteFolder"/_prog "$safeTmp"
	
	#cp -a "$scriptAbsoluteFolder"/_local "$safeTmp"/package/
	
	cp -a "$scriptAbsoluteFolder"/README.md "$safeTmp"/package/
	cp -a "$scriptAbsoluteFolder"/USAGE.html "$safeTmp"/package/
	
	cp -a "$scriptAbsoluteFolder"/README.sh "$safeTmp"/package/
	cp -a "$scriptAbsoluteFolder"/README.html "$safeTmp"/package/
	cp -a "$scriptAbsoluteFolder"/README.pdf "$safeTmp"/package/
	cp -a "$scriptAbsoluteFolder"/README.md "$safeTmp"/package/
	
	
	cp -a "$scriptAbsoluteFolder"/_config "$safeTmp"/package/
	
	
	cp -a "$scriptAbsoluteFolder"/_bin "$safeTmp"/package/
	
	
	cp "$scriptAbsoluteFolder"/fork "$safeTmp"/package/
	
	
	rm -f "$safeTmp"/package/devtask* > /dev/null 2>&1
	rm -f "$safeTmp"/package/__d_* > /dev/null 2>&1
	rm -f "$safeTmp"/package/_d_* > /dev/null 2>&1
	
	
	#if [[ "$ubPackage_enable_ubcp" == 'true' ]]
	#then
		#_package_ubcp_copy "$@"
	#fi
	
	_package_ubcp_copy "$@"
	if [[ "$ubPackage_enable_ubcp" != 'true' ]]
	then
		_safeRMR "$safeTmp"/package/_local/ubcp/conemu
		_safeRMR "$safeTmp"/package/_local/ubcp/cygwin
	fi
	
	cd "$safeTmp"/package/
	_package_subdir
	
	#! [[ "$ubPackage_enable_ubcp" == 'true' ]] && env GZIP=-9 tar -czvf "$scriptAbsoluteFolder"/package.tar.gz .
	! [[ "$ubPackage_enable_ubcp" == 'true' ]] && env XZ_OPT=-e9 tar -cJvf "$scriptAbsoluteFolder"/package.tar.xz .
	#[[ "$ubPackage_enable_ubcp" == 'true' ]] && env GZIP=-9 tar -czvf "$scriptAbsoluteFolder"/package_ubcp.tar.gz .
	#[[ "$ubPackage_enable_ubcp" == 'true' ]] && env XZ_OPT=-e9 tar -cJvf "$scriptAbsoluteFolder"/package_ubcp.tar.xz .
	[[ "$ubPackage_enable_ubcp" == 'true' ]] && env XZ_OPT="-5 -T0" tar -cJvf "$scriptAbsoluteFolder"/package_ubcp.tar.xz .
	
	if [[ "$ubPackage_enable_ubcp" == 'true' ]]
	then
		_messagePlain_request 'request: review contents of _local/ubcp/cygwin/home and similar directories'
	fi
	
	cd "$outerPWD"
	_stop
}

_package() {
	export ubPackage_enable_ubcp='false'
	"$scriptAbsoluteLocation" _package_procedure "$@"
	
	export ubPackage_enable_ubcp='true'
	"$scriptAbsoluteLocation" _package_procedure "$@"
}






