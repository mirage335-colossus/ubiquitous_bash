# WARNING Must use unique netName!
export netName=default
export gatewayName=gw-"$netName"
export LOCALSSHPORT=22

#Network Defaults
export AUTOSSH_FIRST_POLL=45
export AUTOSSH_POLL=45
#export AUTOSSH_GATETIME=0
export AUTOSSH_GATETIME=15

#export AUTOSSH_PORT=0

#export AUTOSSH_DEBUG=1
#export AUTOSSH_LOGLEVEL=7

#Example ONLY. Modify port asignments. Overriding with "netvars.sh" instead of "ops" recommended, especially for embedded systems relying on autossh.
_get_reversePorts() {
	export matchingReversePorts
	matchingReversePorts=()
	export matchingEMBEDDED=false
	
	local matched
	
	local testHostname
	testHostname="$1"
	[[ "$testHostname" == "" ]] && testHostname=$(hostname -s)
	
	if [[ "$testHostname" == "alpha" ]]
	then
		matchingReversePorts+=( "20000" )
		
		matched=true
	fi
	
	if [[ "$testHostname" == "beta" ]]
	then
		matchingReversePorts+=( "20001" )
		export matchingEMBEDDED=true
		
		matched=true
	fi
	
	if ! [[ "$matched" == "true" ]] || [[ "$testHostname" == '*' ]]
	then
		matchingReversePorts+=( "20009" )
		matchingReversePorts+=( "20008" )
	fi
	
	export matchingReversePorts
}

_get_reversePorts
export reversePorts=("${matchingReversePorts[@]}")
export EMBEDDED="$matchingEMBEDDED"

export keepKeys_SSH=true

_prepare_ssh() {
	[[ "$sshHomeBase" == "" ]] && export sshHomeBase="$HOME"/.ssh
	[[ "$sshBase" == "" ]] && export sshBase="$sshHomeBase"
	export sshUbiquitous="$sshBase"/"$ubiquitiousBashID"
	export sshDir="$sshUbiquitous"/"$netName"
	export sshLocal="$sshDir"/_local
	export sshLocalSSH="$sshLocal"/ssh
}
