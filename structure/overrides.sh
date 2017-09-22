#####Overrides

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


#Launch internal functions as commands.
#if [[ "$1" != "" ]] && [[ "$1" != "-"* ]] && [[ ! -e "$1" ]]
if [[ "$1" == '_'* ]]
then
	"$@"
	#Exit if not imported into existing shell, else fall through to subsequent return.
	if ! [[ "${BASH_SOURCE[0]}" != "${0}" ]] && ! [[ "$1" != "--bypass" ]]
	then
		exit "$?"
	fi
	#_stop "$?"
fi

#Stop if script is imported into an existing shell.
if [[ "${BASH_SOURCE[0]}" != "${0}" ]] && [[ "$1" != "--bypass" ]]
then
	return
fi

if ! [[ "$1" != "--bypass" ]]
then
	shift
fi
