#####
# ATTENTION: *ENV*
#####
export netName=default
export gatewayName=gw-"$netName"-"$netName"

export sshHomeBase="$HOME"/.ssh


if [[ "$envGuard" != "$scriptAbsoluteLocation" ]]
then
	export netTimeout=18
fi
export envGuard="$scriptAbsoluteLocation"


#####
# ATTENTION: *import*
#####

_here_ssh_config_import() {
	cat << CZXWXcRMTo8EmM8i4d
CZXWXcRMTo8EmM8i4d
}


#####
# ATTENTION: *export*
#####

_here_ssh_config_export() {
	cat << CZXWXcRMTo8EmM8i4d

Host gw-default-$netName
	ProxyCommand "$sshDir/cautossh" _ssh_proxy_server-default
	User gateway
	#IdentityFile "$sshLocalSSH/rev_gate"

	Compression no
	#Aggressively disconnects quickly. Comment if margins insufficient for high-latency.
	ConnectTimeout 18
	ConnectionAttempts 3
	ServerAliveInterval 3
	ServerAliveCountMax 3

CZXWXcRMTo8EmM8i4d
}

_check_LAN_default() {
	ip addr show | grep '192\.168\.x' > /dev/null 2>&1 && return 0
	return 1
}

_check_LAN_simulation() {
	ip addr show | grep '192\.168\.x' > /dev/null 2>&1 && return 0
	return 1
}

_ssh_proxy_server-default() {
	_start

	export netTimeout='3'
	# May prefer port "2022" or similar if domain is shared by NAT.
	_proxy x.x.x.x 22

	_proxy server.domain.tld 22


	_stop
}


#####
# ATTENTION: *guest*
#####

_here_ssh_config_guest() {
	cat << CZXWXcRMTo8EmM8i4d

CZXWXcRMTo8EmM8i4d
}

#####
# ATTENTION: *internal*
#####

_here_ssh_config_internal() {
	cat << CZXWXcRMTo8EmM8i4d

Host server-$netName
	ProxyCommand "$sshDir/cautossh" _ssh_proxy_server-default
	User user
	#IdentityFile "$sshLocalSSH/id_rsa"

Host raspi-$netName
	ProxyCommand "$sshDir/cautossh" _ssh_proxy_raspi-default
	User pi
	#IdentityFile "$sshLocalSSH/id_rsa"

Host lan-$netName
	ProxyCommand "$sshDir/cautossh" _ssh_proxy_lan-default
	User root
	#IdentityFile "$sshLocalSSH/id_rsa"

Host wan-$netName
	ProxyCommand "$sshDir/cautossh" _ssh_proxy_wan-default
	User root
	#IdentityFile "$sshLocalSSH/id_rsa"

Host assetA-$netName
	ProxyCommand "$sshDir/cautossh" _ssh_proxy_assetA-default
	User user
	#IdentityFile "$sshLocalSSH/id_rsa"

CZXWXcRMTo8EmM8i4d
}

_ssh_proxy_raspi-default() {
	_start

	export netTimeout='0.1'
	_proxy localhost 20001

	export netTimeout='18'

	_check_LAN_simulation && _proxy 192.168.x.x 22
	_check_LAN_default && _proxy raspi.lan 20001
	_check_LAN_default && _proxy 192.168.x.x 22
	_proxySSH_reverse raspi gw-default

	_proxyTor_reverse raspi xxxxxxxxxxxxxxxxx.onion


	_stop
}

_ssh_proxy_lan-default() {
	_start

	_check_LAN_simulation && _proxy 192.168.x.x 22
	_check_LAN_default && _proxy defaultl.lan 22
	_check_LAN_default && _proxy 192.168.x.x 22
	if [[ "$proxySSH_loopGuard" != "true" ]]
	then
		export proxySSH_loopGuard="true"
		_proxySSH raspi-default 22 defaultl.lan
	fi

	if [[ "$proxySSH_loopGuard" != "true" ]]
	then
		export proxySSH_loopGuard="true"
		_proxySSH raspi-default 22 192.168.xxx.xxx
	fi


	_stop
}

_ssh_proxy_wan-default() {
	_start

	_check_LAN_simulation && _proxy 192.168.x.x 22
	_check_LAN_default && _proxy defaultw.lan 22
	_check_LAN_default && _proxy 192.168.x.x 22
	if [[ "$proxySSH_loopGuard" != "true" ]]
	then
		export proxySSH_loopGuard="true"
		_proxySSH raspi-default 22 defaultw.lan
	fi

	if [[ "$proxySSH_loopGuard" != "true" ]]
	then
		export proxySSH_loopGuard="true"
		_proxySSH raspi-default 22 192.168.xxx.xxx
	fi


	_stop
}

_ssh_proxy_assetA-default() {
	_start

	export netTimeout='0.1'
	_proxy localhost 20002

	export netTimeout='18'

	_proxy assetA.domain.tld 20002

	_check_LAN_simulation && _proxy 192.168.x.x 22
	_check_LAN_default && _proxy assetA.lan 20002
	_check_LAN_default && _proxy 192.168.x.x 22
	_proxySSH_reverse assetA gw-default

	if [[ "$proxySSH_loopGuard" != "true" ]]
	then
		export proxySSH_loopGuard="true"
		_proxySSH raspi-default 22 192.168.xxx.xxx
	fi

	_proxyTor_reverse assetA xxxxxxxxxxxxxxxxx.onion


	_stop
}


#####
# ATTENTION: *global*
#####

_here_ssh_config() {
	_here_ssh_config_import
	_here_ssh_config_export
	_here_ssh_config_guest
	_here_ssh_config_internal
	
	cat << CZXWXcRMTo8EmM8i4d

Host *-$netName*
	Compression yes
	ExitOnForwardFailure yes
	ConnectTimeout 72
	ConnectionAttempts 3
	ServerAliveInterval 6
	ServerAliveCountMax 9
	#PubkeyAuthentication yes
	#PasswordAuthentication no
	StrictHostKeyChecking no
	UserKnownHostsFile "$sshLocalSSH/known_hosts"
	IdentityFile "$sshLocalSSH/id_rsa"
	#Cipher aes256-gcm@openssh.com
	#Ciphers aes256-gcm@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,arcfour256,arcfour128,aes128-gcm@openssh.com,chacha20-poly1305@openssh.com,aes128-cbc,3des-cbc,blowfish-cbc,cast128-cbc,aes192-cbc,aes256-cbc,arcfour

CZXWXcRMTo8EmM8i4d


}


#Daemon commands. Do not define unless multi-gateway
#redundancy is needed. Tor services redundancy is
#expected to be far more reliable than such fallbacks.
_ssh_autoreverse() {
	_get_reversePorts
	_torServer_SSH
	_autossh

	#_autossh firstGateway
	#_autossh secondGateway

	return '0'

	## Optional - tunnel public web server.
	export autosshPublic="true"

	export overrideLOCALLISTENPORT=443
	_get_reversePorts
	_offset_reversePorts
	export overrideMatchingReversePort="${matchingOffsetPorts[0]}"

	_torServer_SSH
	_autossh
}

#Hooks "_setup_ssh" after other operations complete. Typically
#used to install special files (eg. machine specific keys).
_setup_ssh_extra() {
	true
}

#Hooks "_setup" before "_setup_ssh" .
_setup_pre() {
	true
}

#Hooks "_setup" after "_setup_ssh" .
_setup_prog() {
	true
}










