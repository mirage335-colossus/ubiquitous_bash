_testTor() {
	_getDep tor
}

_torServer_SSH_writeCfg() {
	mkdir -p "$scriptLocal"/tor/sshd/dd
	
	rm "$scriptLocal"/tor/sshd/dd/torrc > /dev/null 2>&1
	
	echo "RunAsDaemon 0" >> "$scriptLocal"/tor/sshd/dd/torrc
	echo "DataDirectory "'"'"$scriptLocal"/tor/sshd/dd'"' >> "$scriptLocal"/tor/sshd/dd/torrc
	echo  >> "$scriptLocal"/tor/sshd/dd/torrc
	
	echo "SocksPort 0" >> "$scriptLocal"/tor/sshd/dd/torrc
	echo  >> "$scriptLocal"/tor/sshd/dd/torrc
	
	local currentReversePort
	for currentReversePort in "${matchingReversePorts[@]}"
	do
		
		mkdir -p "$scriptLocal"/tor/sshd/"$currentReversePort"
		chmod 700 "$scriptLocal"/tor/sshd/"$currentReversePort"
		
		echo "HiddenServiceDir "'"'"$scriptLocal"/tor/sshd/"$currentReversePort"/'"' >> "$scriptLocal"/tor/sshd/dd/torrc
		
		echo "HiddenServicePort ""$currentReversePort"" 127.0.0.1:22" >> "$scriptLocal"/tor/sshd/dd/torrc
		
		echo  >> "$scriptLocal"/tor/sshd/dd/torrc
		
	done
	
}

_get_torServer_SSH_hostnames() {
	local currentHostname
	local currentReversePort
	
	[[ ! -e "$scriptLocal"/tor/sshd/"${matchingReversePorts[0]}"/hostname ]] && sleep 3
	[[ ! -e "$scriptLocal"/tor/sshd/"${matchingReversePorts[0]}"/hostname ]] && sleep 3
	[[ ! -e "$scriptLocal"/tor/sshd/"${matchingReversePorts[0]}"/hostname ]] && sleep 3
	[[ ! -e "$scriptLocal"/tor/sshd/"${matchingReversePorts[0]}"/hostname ]] && sleep 3
	
	
	for currentReversePort in "${matchingReversePorts[@]}"
	do
		[[ ! -e "$scriptLocal"/tor/sshd/"$currentReversePort"/hostname ]] && sleep 3
		[[ ! -e "$scriptLocal"/tor/sshd/"$currentReversePort"/hostname ]] && continue
		
		currentHostname=$(cat "$scriptLocal"/tor/sshd/"$currentReversePort"/hostname)
		torServer_hostnames+=( "$currentHostname":"$currentReversePort" )
	done
	
	export torServer_hostnames
}

_show_torServer_SSH_hostnames() {
	_get_torServer_SSH_hostnames
	
	echo
	local currentHostname
	for currentHostname in "${torServer_hostnames[@]}"
	do
		echo "$currentHostname"
	done
}

#Typically used to create onion addresses for an entire network of machines.
_torServer_SSH_all_launch() {
	_get_reversePorts '*'
	
	_torServer_SSH_writeCfg
	
	tor -f "$scriptLocal"/tor/sshd/dd/torrc
	
	_show_torServer_SSH_hostnames
	
}

#Especially intended for IPv4 NAT punching.
_torServer_SSH_launch() {
	_get_reversePorts
	
	_torServer_SSH_writeCfg
	
	tor -f "$scriptLocal"/tor/sshd/dd/torrc
	
	_show_torServer_SSH_hostnames
	
}

_torServer_SSH() {
	"$scriptAbsoluteLocation" _cmdDaemon _torServer_SSH_launch
}



