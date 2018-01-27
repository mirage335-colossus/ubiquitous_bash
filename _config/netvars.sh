#####Network Specific Variables
#Statically embedded into monolithic cautossh script by compile script .

export netName=default
export gatewayName="$netName"-gw
export LOCALSSHPORT=22

#Set to the desktop user most commonly logged in.
#[[ "$SSHUSER" == "" ]] && export SSHUSER=
#[[ "$X11USER" == "" ]] && export X11USER=


#Example ONLY. Modify port asignments.
if [[ "$reversePort" == "" ]]
then
	export reversePort=20009
	case $(hostname -s) in
		alpha)
			export reversePort=20000
			;;
		beta)
			export reversePort=20001
			export EMBEDDED=true
			;;
	esac
fi

export keepKeys=true
