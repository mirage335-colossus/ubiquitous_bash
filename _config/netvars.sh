#####Network Specific Variables
#Statically embedded into monolithic ubiquitous_bash.sh/cautossh script by compile .

# WARNING Must use unique netName!
export netName=default
export gatewayName="$netName"-gw
export LOCALSSHPORT=22

#Set to the desktop user most commonly logged in.
#[[ "$SSHUSER" == "" ]] && export SSHUSER=
#[[ "$X11USER" == "" ]] && export X11USER=

#Example ONLY. Modify port asignments.
_get_reversePorts() {
	export matchingReversePorts
	matchingReversePorts=()
	export matchingEMBEDDED=false
	
	local matched
	
	local testHostname
	testHostname="$1"
	[[ "$testHostname" == "" ]] && testHostname=$(hostname -s)
	
	if [[ "$testHostname" == "alpha" ]] || [[ "$testHostname" == '*' ]]
	then
		matchingReversePorts+=( "20000" )
		
		matched=true
	fi
	
	if [[ "$testHostname" == "beta" ]] || [[ "$testHostname" == '*' ]]
	then
		matchingReversePorts+=( "20001" )
		export matchingEMBEDDED=true
		
		matched=true
	fi
	
	if ! [[ "$matched" == "true" ]] || [[ "$testHostname" == '*' ]]
	then
		matchingReversePorts+=( "20008" )
		matchingReversePorts+=( "20009" )
	fi
	
	export matchingReversePorts
}

_get_reversePorts
export reversePorts=("${matchingReversePorts[@]}")
export EMBEDDED="$matchingEMBEDDED"

export keepKeys=true
