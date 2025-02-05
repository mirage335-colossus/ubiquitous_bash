_stopwatch() {
	local currentExitStatus_bin
	local currentExitStatus_self
	
	local measureDateA
	local measureDateB
	
	measureDateA=$(date +%s%N | cut -b1-13)

	"$@"
	currentExitStatus_bin="$?"

	measureDateB=$(date +%s%N | cut -b1-13)

	bc <<< "$measureDateB - $measureDateA"
	currentExitStatus_self="$?"

	[[ "$currentExitStatus_bin" != "0" ]] && return "$currentExitStatus_bin"
	[[ "$currentExitStatus_self" != "0" ]] && return "$currentExitStatus_self"
	return 0
}
