#####Installation

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
	
	_checkDep rm
	
	_tryExec "_idleTest"
	
	[[ -e /dev/urandom ]] || echo /dev/urandom missing _stop
	
	echo "PASS"
	
	_stop
	
}

_setup() {
	_start
	
	"$scriptAbsoluteLocation" _test
	
	"$scriptAbsoluteLocation" _build "$@"
	
	
	
	_stop
}
