#####Installation

#Verifies the timeout and sleep commands work properly, with subsecond specifications.
_timetest() {
	
	iterations=0
	while [[ "$iterations" -lt 10 ]]
	do
		dateA=$(date +%s)
		
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
		
		dateDelta=$(bc <<< "$dateB - $dateA")
		
		if [[ "$dateDelta" -lt "1" ]]
		then
			echo "FAIL"
			_stop 1
		fi
		
		if [[ "$dateDelta" -lt "5" ]]
		then
			echo "PASS"
			return 0
		fi
		
		let iterations="$iterations + 1"
	done
	echo "FAIL"
	_stop 1
}

_test() {
	_start
	
	echo -e -n '\E[1;32;46m Dependency checking...	\E[0m'
	
	# Check dependencies
	_checkDep wget
	_checkDep grep
	_checkDep fgrep
	_checkDep sed
	_checkDep awk
	_checkDep cut
	_checkDep head
	_checkDep tail
	
	
	_checkDep realpath
	_checkDep readlink
	_checkDep dirname
	
	_checkDep sleep
	_checkDep wait
	_checkDep kill
	_checkDep jobs
	_checkDep ps
	_checkDep exit
	
	_checkDep env
	_checkDep bash
	_checkDep echo
	_checkDep cat
	_checkDep type
	_checkDep mkdir
	_checkDep trap
	_checkDep return
	_checkDep set
	
	_checkDep dd
	
	_checkDep rm
	
	_checkDep find
	_checkDep ln
	_checkDep ls
	
	_checkDep id
	
	_tryExec "_testMountChecks"
	_tryExec "_testBindMountManager"
	_tryExec "_testDistro"
	
	_tryExec "_testChRoot"
	_tryExec "_testQEMU"
	_tryExec "_testQEMU_x64-x64"
	_tryExec "_testQEMU_x64-raspi"
	_tryExec "_testQEMU_raspi-raspi"
	
	_tryExec "_testExtra"
	
	[[ -e /dev/urandom ]] || echo /dev/urandom missing _stop
	
	echo "PASS"
	
	echo -n -e '\E[1;32;46m Timing...		\E[0m'
	_timetest
	
	_stop
	
}

_testBuilt() {
	_start
	
	echo -e -n '\E[1;32;46m Binary checking...	\E[0m'
	
	_tryExec "_testBuiltIdle"
	_tryExec "_testBuiltChRoot"
	_tryExec "_testBuiltQEMU"
	
	_tryExec "_testBuiltExtra"
	
	echo "PASS"
	
	_stop
}

#Creates symlink in ~/bin, to the executable at "$1", named according to its residing directory and file name.
_setupCommand() {
	local clientScriptLocation
	clientScriptLocation=$(_getAbsoluteLocation "$1")
	
	local clientScriptFolder
	clientScriptFolder=$(_getAbsoluteFolder "$1")
	
	local commandName
	commandName=$(basename "$1")
	
	local clientName
	clientName=$(basename "$clientScriptFolder")
	
	ln -s -r "$clientScriptLocation" ~/bin/"$commandName""-""$clientName"
	
	
}

_setupCommands() {
	#find . -name '_command' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
	true
}

_setup() {
	_start
	
	"$scriptAbsoluteLocation" _test || _stop 1
	
	"$scriptAbsoluteLocation" _build "$@" || _stop 1
	
	"$scriptAbsoluteLocation" _testBuilt || _stop 1
	
	_setupCommands
	
	_stop
}
