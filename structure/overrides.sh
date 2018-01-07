#####Overrides

[[ "$isDaemon" == "true" ]] && echo "$$" >> "$daemonPidFile"

#Traps, if script is not imported into existing shell, or bypass requested.
if ! [[ "${BASH_SOURCE[0]}" != "${0}" ]] || ! [[ "$1" != "--bypass" ]]
then
	trap 'excode=$?; _stop $excode; trap - EXIT; echo $excode' EXIT HUP QUIT PIPE 	# reset
	trap 'excode=$?; trap "" EXIT; _stop $excode; echo $excode' EXIT HUP QUIT PIPE 	# ignore
	
	trap 'excode=$?; _stop_emergency $excode; trap - EXIT; echo $excode' INT TERM	# reset
	trap 'excode=$?; trap "" EXIT; _stop_emergency $excode; echo $excode' INT TERM	# ignore
fi

#Override functions with external definitions from a separate file if available.
#if [[ -e "./ops" ]]
#then
#	. ./ops
#fi

#Override functions with external definitions from a separate file if available.
if [[ -e "$objectDir"/ops ]]
then
	. "$objectDir"/ops
fi
if [[ -e "$scriptLocal"/ops ]]
then
	. "$scriptLocal"/ops
fi

#WILL BE OVERWRITTEN FREQUENTLY.
#Intended for automatically generated shell code identifying usable resources, such as unused network ports. Do NOT use for serialization of internal variables (use $varStore for that).
if [[ -e "$objectDir"/opsauto ]]
then
	. "$objectDir"/opsauto
fi
if [[ -e "$scriptLocal"/opsauto ]]
then
	. "$scriptLocal"/opsauto
fi

#Launch internal functions as commands.
#Wrapper function to launch arbitrary commands within the ubiquitous_bash environment, including its PATH with scriptBin.
_bin() {
	"$@"
}

_true() {
	true
}
_false() {
	false
}
_echo() {
	echo "$@"
}
#if [[ "$1" != "" ]] && [[ "$1" != "-"* ]] && [[ ! -e "$1" ]]
#if [[ "$1" == '_'* ]] || [[ "$1" == "true" ]] || [[ "$1" == "false" ]]
if [[ "$1" == '_'* ]]
then
	"$@"
	internalFunctionExitStatus="$?"
	#Exit if not imported into existing shell, or bypass requested, else fall through to subsequent return.
	if ! [[ "${BASH_SOURCE[0]}" != "${0}" ]] || ! [[ "$1" != "--bypass" ]]
	then
		#export noEmergency=true
		exit "$internalFunctionExitStatus"
	fi
	#_stop "$?"
fi

#Stop if script is imported into an existing shell and bypass not requested.
if [[ "${BASH_SOURCE[0]}" != "${0}" ]] && [[ "$1" != "--bypass" ]]
then
	return
fi

if ! [[ "$1" != "--bypass" ]]
then
	shift
fi

#Do not continue script execution through program code if critical global variables are not sane.
[[ ! -e "$scriptAbsoluteLocation" ]] && exit 1
[[ ! -e "$scriptAbsoluteFolder" ]] && exit 1
_failExec || exit 1
